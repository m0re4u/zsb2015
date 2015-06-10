/*
 * PP.java
 * Assignment for the Path planning part of the ZSB lab course.
 *
 * This you will work on writing a function called highPath() to move a
 * chesspiece across the board at a safe height. By raising the gripper 20 cm
 * above the board before moving it over the board you don't risk hitting any
 * other pieces on the board. This means you don't have to do any pathplanning
 * yet.
 *
 * Input of this program is a commandline argument, specifying the computer 
 * (white) move. Your job is to find the correct sequence of GripperPositions
 * (stored in Vector p) to pick up the correct white piece and deposit it at
 * its desired new location. Read file
 * /opt/stud/robotics/hints/HIGHPATH_POSITIONS to see what intermediate
 * positions you should calculate.
 *
 * To run your program, fire up playchess or one of its derviates endgame* and
 * the umirtxsimulator. In the simulator you can see the effect of your path
 * planning although the board itself is not simulated. When you think you've
 * solved this assignment ask one of the lab assistents to verify it and let
 * it run on the real robot arm.
 * 
 * You can also compare your solution with the standard PP solution outside
 * playchess by running in a shell:
 * java PPstandard e2e4
 * cat positions.txt
 * java PP e2e4
 * cat positions.txt
 *
 *
 * 
 * Nikos Massios, Matthijs Spaan <mtjspaan@science.uva.nl>
 * $Id: Week2.java,v a4f44ea5d321 2008/06/16 09:18:44 obooij $
 */

import java.io.*;
import java.lang.*;
import java.util.Vector;

public class PP {
  private static double SAFE_HEIGHT=200;
  private static double LOW_HEIGHT=40;
  private static double OPEN_GRIP=30;
  private static double CLOSED_GRIP=0;

  public static void main(String[] args){
    Vector <GripperPosition> p = new Vector<GripperPosition>();
    ChessBoard b;
    String computerFrom, computerTo;

    System.out.println("**** THIS IS THE STUDENT PP MODULE IN JAVA"); 
    System.out.println("**** The computer move was "+ args[0]); 

    /* Read possibly changed board position */
    if(args.length > 1)
    {
      double x=Double.parseDouble(args[1]),
             y=Double.parseDouble(args[2]),
             theta=Double.parseDouble(args[3]);
      Point boardPosition=new Point(x,y,0);

      System.out.println("**** Chessboard is at (x,y,z,theta): ("
                               + x + ", " + y + ", 0, " + theta + ")");

      b = new ChessBoard(boardPosition, theta);
    }
    else
      b = new ChessBoard();

    /* Read the board state*/
    b.read();
    /* print the board state*/
    System.out.println("**** The board before the move was:");       
    b.print();
    
    computerFrom = args[0].substring(0,2);
    computerTo = args[0].substring(2,4);
    
    /* plan a path for the move */
    highPath(computerFrom, computerTo, b, p);

    /* move the computer piece */
    try {
      b.movePiece(computerFrom, computerTo);
    } catch (ChessBoard.NoPieceAtPositionException e) {
      System.out.println(e);
      System.exit(1);
    }

    System.out.println("**** The board after the move was:");       
    /* print the board state*/
    b.print();
    
    /* after done write the gripper positions */
    GripperPosition.write(p);
  }

  private static void highPath(String from, String to, 
           ChessBoard b, Vector<GripperPosition> p) {

    System.out.println("**** In high path"); 

    double pHeight = 200;

    // Use the boardLocation and toCartesian methods you wrote:
    StudentBoardTrans studentBoardTrans = new StudentBoardTrans(from);
    StudentBoardTrans studentBoardTrans2 = new StudentBoardTrans(to);
    
    try{
    pHeight = b.getHeight(from);
    } catch (Exception e) {
        System.out.println(e);
        System.out.println("something went wrong");
    }

    // FIRST POSITION     
	int fromColumn = studentBoardTrans.boardLocation.column;
    int fromRow = studentBoardTrans.boardLocation.row;
    Point cart1 = studentBoardTrans.toCartesian(fromColumn, fromRow);
    cart1.z = SAFE_HEIGHT;   
	System.out.println(cart1);
	
	GripperPosition position1 = new GripperPosition(cart1, 0, OPEN_GRIP);
	p.add(position1);
	
	// SECOND POSITION 
	Point cart2 = studentBoardTrans.toCartesian(fromColumn, fromRow); 
	cart2.z = LOW_HEIGHT; 
	GripperPosition position2 = new GripperPosition(cart2, 0, OPEN_GRIP);
	p.add(position2);
	
	// THIRD POSITION
	double C_HEIGHT = 0.5 * pHeight; 
	Point cart3 = studentBoardTrans.toCartesian(fromColumn, fromRow);
	cart3.z = C_HEIGHT;
	GripperPosition position3 = new GripperPosition(cart3, 0, OPEN_GRIP);
	p.add(position3);
	
	// FOURTH POSITION
	GripperPosition position4 = new GripperPosition(cart3, 0, CLOSED_GRIP);
	p.add(position4);
	
	// FIFTH POSITION
	Point cart5 = studentBoardTrans.toCartesian(fromColumn, fromRow);
	cart5.z = SAFE_HEIGHT;
	GripperPosition position5 = new GripperPosition(cart5, 0, CLOSED_GRIP);
	p.add(position5);
	
	// SIXT POSITION
	int toColumn = studentBoardTrans2.boardLocation.column;
    int toRow = studentBoardTrans2.boardLocation.row;
	Point cart6 = studentBoardTrans2.toCartesian(toColumn, toRow);
	cart6.z = SAFE_HEIGHT;
	GripperPosition position6 = new GripperPosition(cart6, 0, CLOSED_GRIP);
	p.add(position6);
	
	// SEVENTH POSITION
	double LOW_HALF_P = LOW_HEIGHT + (0.5 * pHeight);
	Point cart7 = studentBoardTrans2.toCartesian(toColumn, toRow);
	cart7.z = LOW_HALF_P;
	GripperPosition position7 = new GripperPosition(cart7, 0, CLOSED_GRIP);
	p.add(position7);
	
	// EIGHTH POSITION
	double HL_HP = (0.5* LOW_HEIGHT) + (0.5 * pHeight);
	Point cart8 = studentBoardTrans2.toCartesian(toColumn, toRow);
	cart8.z = HL_HP;
	GripperPosition position8 = new GripperPosition(cart8, 0, CLOSED_GRIP);
	p.add(position8);
	
	// NINTH POSITION
	double HALF_LOW = 0.5 * LOW_HEIGHT;
	Point cart9 = studentBoardTrans2.toCartesian(toColumn, toRow);
	cart9.z = HALF_LOW;
	GripperPosition position9 = new GripperPosition(cart8, 0, OPEN_GRIP);
	p.add(position9);
	
	// TENTH POSITION
	Point cart10 = studentBoardTrans2.toCartesian(toColumn, toRow);
	cart10.z = SAFE_HEIGHT;
    GripperPosition position10 = new GripperPosition(cart9, 0, OPEN_GRIP);
    p.add(position10);
	
  }

  private static void moveToGarbage(String to, ChessBoard b, Vector<GripperPosition> g) {

	private double piecesMovedToGarbage = 0;
	double pHeight = 200;

    // Use the boardLocation and toCartesian methods you wrote:
    StudentBoardTrans studentBoardTrans = new StudentBoardTrans(to);
    
    try{
    piece_height = b.getHeight(to);
    } catch (Exception e) {
        System.out.println(e);
        System.out.println("Something went wrong");
    }

    // FIRST POSITION     
	int checkedColumn = studentBoardTrans.boardLocation.column;
    int checkedRow = studentBoardTrans.boardLocation.row;
    Point cart1 = studentBoardTrans.toCartesian(checkedColumn, checkedRow);
    cart1.z = SAFE_HEIGHT;   
	System.out.println(cart1);
	
	GripperPosition position1 = new GripperPosition(cart1, 0, OPEN_GRIP);
	p.add(position1);
	
	// SECOND POSITION 
	Point cart2 = studentBoardTrans.toCartesian(checkedColumn, checkedRow); 
	cart2.z = LOW_HEIGHT; 
	GripperPosition position2 = new GripperPosition(cart2, 0, OPEN_GRIP);
	p.add(position2);
	
	// THIRD POSITION
	double C_HEIGHT = 0.5 * pHeight; 
	Point cart3 = studentBoardTrans.toCartesian(checkedColumn, checkedRow);
	cart3.z = C_HEIGHT;
	GripperPosition position3 = new GripperPosition(cart3, 0, OPEN_GRIP);
	p.add(position3);
	
	// FOURTH POSITION
	GripperPosition position4 = new GripperPosition(cart3, 0, CLOSED_GRIP);
	p.add(position4);
	
	// FIFTH POSITION
	Point cart5 = studentBoardTrans.toCartesian(checkedColumn, checkedRow);
	cart5.z = SAFE_HEIGHT;
	GripperPosition position5 = new GripperPosition(cart5, 0, CLOSED_GRIP);
	p.add(position5);
	
	// STARTING TO MOVE OFF THE BOARD ** DANGER DANGER!
	// SIXTH POSITION
	Point cart6 = studentBoardTrans.toCartesian
    
    System.out.println("**** In movoToGarbage"); 

  }
  private static void getGarbagePileCoords(Chessboard b){
	double hor = b.coords.x;
	double dist = b.sur_x;
	
	piecesMovedToGarbage++;
	
	Point garbagePoint;
	garbagepoint.x = hor + 2 * dist;
	if(piecesMovedToGarbage =< 8){
		garbagepoint.x = hor + 2 * dist;
		garbagepoint.y = b.coords.y + piecesMovedToGarbage * b.delta_y;
	} else{
		garbagepoint.x = hor + 2 * dist + b.delta_x;
		garbagepoint.y = b.coords.y + piecesMovedToGarbage - 9 * b.delta_y;
	}
	
	return garbagePoint;
	}
}
