/*
 * First assignment for the Path Planning part of the Robotics practical.
 *
 * You'll be introduced to the problem of planning a path for the 
 * gripper of the robot arm. You will write some functions which are essential
 * for this task.
 *
 * The assignment consists of three parts:
 * - access some data of the board to get acquainted with it
 * - write a class to convert positions ("e3") to locations (column 4, row 2)
 * - write a function convert locations to cartesian coordinates (x,y,z)
 *
 * Just start reading the comments and fill in the ???? stuff. The latter two
 * parts of the assignment and the data are contained in separate class called
 * StudentBoardTrans, check the bottom of this file.
 * A pointer to documentation can be found in
 * /opt/stud/robotics/hints/DOCUMENTATION .
 *
 * You can test your answers yourself, if they are correct ask one of the
 * practical assistents to verify them.
 *
 * This Java introduction was written for the 2001/2002 course.
 * Matthijs Spaan <mtjspaan@science.uva.nl>
 * $Id: Week1.java,v 1.9 2008/06/10 10:21:36 obooij Exp $
 */

import java.io.*;
import java.lang.*;

class BoardTrans
{
  /*
   * BoardTrans takes one optional argument, specifying the position on the field
   * it should use. It defaults to b7.
   */
  public static void main(String[] args)
  {
    String position;

    try { position=args[0]; }
    catch(ArrayIndexOutOfBoundsException e) { position="b7"; }

    StudentBoardTrans boardTrans = new StudentBoardTrans(position);

    // set up the board in starting position
    boardTrans.board.setup();
    
    // draw the board state
    boardTrans.board.print();
    
    /*
     * You are now asked to access some data in the board structure.
     * Please print them and check your answers with the chess_board eitor
     * and the chess_piece editor from SCIL.
     */
    try {  

		System.out.println("The dimensions of the squares on the board are " +
        	String.valueOf(boardTrans.board.delta_x)
        	+ " by " + 
        	String.valueOf(boardTrans.board.delta_y) 
        	+ "mm");
  
		System.out.println("The x,y coordinates of the board are " +
			String.valueOf(boardTrans.board.coords.x)
	        + "," +
    	    String.valueOf(boardTrans.board.coords.y)
        	);
  
     	System.out.println("The height of the piece at " + boardTrans.pos + " is " +
			String.valueOf(boardTrans.board.getHeight(boardTrans.pos)) +
     	   " mm");
    
      System.out.println("The color of the piece at " + boardTrans.pos + " is " +
             String.valueOf(boardTrans.board.getSide(boardTrans.pos))
             );
    } catch (Exception e) {
      System.out.println(e);
      System.exit(1);
    }
    
    /*
     * Next you should write a small class called BoardLocation which
     * converts a position like "a1" to a column and a row.
     * Finish the class BoardLocation in StudentBoardTrans started below.
     */
        
    StudentBoardTrans.BoardLocation location = boardTrans.boardLocation;
    BoardLocation realLocation = new BoardLocation(boardTrans.pos);
	
    System.out.println("You think position " + boardTrans.pos + " is at (" +
                       location.column + "," + location.row +
                       "), the correct answer is (" + realLocation.column +
                       "," + realLocation.row + ")");

    /*
     * In order to be able to plan a path to certain position on the board
     * you have to know where this position is in Cartesian (i.d. real world)
     * coordinates: (x,y,z) in mm relative to the origin.
     * Look at the picture of the chess board in the practical manual.
     * Finish the method toCartesian() in StudentBoardTrans started below.
     */

    Point cartesian = new Point();
    cartesian=boardTrans.toCartesian(location.column, location.row);

    System.out.println("You think " + boardTrans.pos + " is at " + cartesian +
                       ", the correct answer is " +
                       boardTrans.board.toCartesian(boardTrans.pos));

    // Let's turn the board 45 degrees
    boardTrans.board.theta=45;

    // recalculate cartesian
    cartesian=boardTrans.toCartesian(location.column, location.row);

    System.out.println("You think " + boardTrans.pos + " is at " + cartesian +
                       ", the correct answer is " +
                       boardTrans.board.toCartesian(boardTrans.pos));

    // Let's move the position of the board and turn it again
    boardTrans.board.coords.x=100;
    boardTrans.board.coords.y=200;
    boardTrans.board.theta=-60;

    // recalculate cartesian
    cartesian=boardTrans.toCartesian(location.column, location.row);

    System.out.println("You think " + boardTrans.pos + " is at " + cartesian +
                       ", the correct answer is " +
                       boardTrans.board.toCartesian(boardTrans.pos));
  }
}

class StudentBoardTrans
{
  public ChessBoard board; // our board
  public String pos; // the position we're going to examine
  public BoardLocation boardLocation;

  public StudentBoardTrans(String position)
  {
    board = new ChessBoard();
    pos = position;
    boardLocation = new BoardLocation();
  }

  public Point toCartesian(int column, int row)
  {
    /* You can ignore the normal of the board, i.e. we assume the chess
     * board always lies flat on the table.
     */
	System.out.println(row);
	System.out.println(column);
	double x = 0;
	x = (board.coords.x - board.sur_x) - 
		(((7 - column) * board.delta_x) + (board.delta_x / 2));
	double y = 0;
	y = (board.coords.y + board.sur_y) + 
		(((7 - row) * board.delta_y) + (board.delta_y/2));
	double z = board.board_thickness;

	double radangle = Math.toRadians(board.theta);
	double cosAlpha = Math.cos(radangle);
	double sinAlpha = Math.sin(radangle);
	double newx = (cosAlpha * (x - board.coords.x)) + (sinAlpha * (y - board.coords.y)) + board.coords.x;
	double newy = (-sinAlpha * (x - board.coords.x)) + (cosAlpha * (y - board.coords.y)) + board.coords.y;

    Point result = new Point (newx,newy,z);
    return(result);
  }

  class BoardLocation{
    public int row;
    public int column;
    
    
    public BoardLocation()
    {
    	char ch1 = pos.charAt(0);
    	char ch2 = pos.charAt(1);
		row = Character.getNumericValue(ch2) - 1;
		column = Character.getNumericValue(ch1) - 10;
    }
  }
}
