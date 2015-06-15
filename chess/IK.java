/*
 * IK.java
 * Assignment for the Inverse Kinematics part of the ZSB lab course.
 *
 * Until now, you have been building lists of cartesian coordinate positions
 * that you wanted the robot to visit in order to move the chess pieces. The 
 * robot however is not controlled in cartesian coordinates but in joint 
 * values instead. These joint values specify the way in which each individual
 * joint is to be set.
 *
 * The task of the inverse kinematics module is to convert cartesian 
 * coordinates to joint values. By correctly setting the joint values you 
 * effectively move the robot to the right cartesian position.
 *
 * You have to think first how cartesian xyz coordinates map to joint
 * values. So if I want to reach point [x,y,z] in 3D space what should
 * the values be for each of the joints? Remember that we have assumed that 
 * the normal vector of the board is always [0,0,1]. This means that only the 
 * 3 arm joints are of interest and you should be able to just set the right 
 * values for the remaining 3 joints (the hand joints). Do points 1. and 2. of
 * section 3 in the lab manual. Also check the last page of the manual.
 * 
 * You need to know the dimensions of the robot arm, which you can find in 
 * class RobotJoints. It contains a specification of the arm in 
 * Denavit-Hartenberg notation. Look at the code below and replace the 23's. 
 * The total number of lines you have to write for this part does not exceed 
 * 30.
 * 
 * You can always compare your solution with the standard solution given a
 * position.txt file by running in a shell:
 * java IKstandard
 * cat joints.txt
 * java IK
 * cat joints.txt
 *
 * Extra: if you have time and feel like it (and want to make your solution 
 * cooler than ours) work around the problem of configuration switches in
 * lowPath().
 *
 * Nikos Massios, Matthijs Spaan <mtjspaan@science.uva.nl>
 * $Id: Week6.java,v 1.7 2008/06/16 09:18:44 obooij Exp $
 */

import java.lang.*;
import java.util.Vector;

public class IK {

  // Class containing the Denavit-Hartenberg representation of the robot arm
  private static RobotJoints robotJoints;

  /* Calculate roll, pitch, and yaw for the gripper of the robot arm plus
   * the value of the gripper itself.
   */
  private static void handJointCalculation(GripperPosition pos,
                                             JointValues j) {
    double grip = pos.grip;
	Point gripcoord = pos.coords;
	double x = gripcoord.x;
	double y = gripcoord.y;
	double z = gripcoord.z;
	
	j.roll = 0; 
	j.pitch = -90;
	
	// moved yaw to armJoinCalculation, after j.elbow and j.shoulder are 
	// assigned a value.
    j.yaw = 0;
    j.grip = grip; 
  }

  /* Calculate the wrist coordinates from the hand coordinates.
   * If the robot's last link has some length and the tip of the robot grabs
   * the piece. At what height is the start of the robot's last link?
   */
  private static Point wristCoordinatesCalculation(GripperPosition pos) {

    Point c = new Point();
	c.x = pos.coords.x;
	c.y = pos.coords.y;
	RobotJoints.Joint wristR = robotJoints.get("roll");
	c.z = pos.coords.z + wristR.d; // correct wrist height?
	
    return(c);
  }

  /* Calculate the arm joints from the (x,y,z) coordinates of the wrist (the
   * last link).
   */
  private static void armJointCalculation(Point wristCoords,
              JointValues j) {
    
	double x = wristCoords.x;
	double y = wristCoords.y;
	double z = wristCoords.z;
	RobotJoints.Joint shoulderR = robotJoints.get("shoulder");
	double l1 = shoulderR.a;
	RobotJoints.Joint elbowR = robotJoints.get("elbow");
	double l2 = elbowR.a;

	double x2 = Math.pow(x,2);
	double y2 = Math.pow(y,2);
	double l12 = Math.pow(l1,2);
	double l22 = Math.pow(l2,2);
	double x2y2 = x2 + y2;
	double l12l22 = l12 + l22;
	double div = 2 * l1 * l2;
	double cosT2 = (x2y2 - l12l22) / div ;
	double sinT2 = Math.sqrt(1 - Math.pow(cosT2,2));	
	double minSinT2 = -Math.sqrt(1 - Math.pow(cosT2,2));
	double Theta2R = Math.atan2(sinT2, cosT2);
	double minTheta2R = Math.atan2(minSinT2, cosT2);
	
	double Theta1R = Math.atan2(y,x) - Math.atan2(l2 * sinT2, l1 + l2 * cosT2);
	double minTheta1R = Math.atan2(y,x) - Math.atan2(l2 * minSinT2, l1 + l2 * cosT2);
	double Theta2 = Math.toDegrees(Theta2R);
	double minTheta2 = Math.toDegrees(minTheta2R);
	double Theta1 = Math.toDegrees(Theta1R);
	double minTheta1 = Math.toDegrees(minTheta1R);
	
	j.zed = 1000;
    j.shoulder = 90 - Theta1; 
    j.elbow = -Theta2;
    // moved yaw from handCalculation
    j.yaw = -j.shoulder + (0.5 * -j.elbow);
    System.out.println("shoulder = " + j.shoulder);
  }

  /* Calculate the appropriate values for all joints for position pos.
   */
  private static JointValues jointCalculation(GripperPosition pos) {
    JointValues j = new JointValues();
    Point wristCoords;

    handJointCalculation(pos,j);
    wristCoords=wristCoordinatesCalculation(pos);
    armJointCalculation(wristCoords, j);
  
    return(j);
  }

  private static void inverseKinematics(Vector<GripperPosition> p, Vector<JointValues> j) {

    // initialize the Denavit-Hartenberg representation
    robotJoints = new RobotJoints();
  
    for (int i =0; i < p.size(); i++) {
      GripperPosition pos = (GripperPosition) p.elementAt(i);
      /* correct for errors in the arm*/
      // if left on the board then assume left-hand configuration
      // if right on the board then assume right-hand configuration
      if (pos.coords.x < 0)
        RobotJoints.correctCartesian(pos, 0);
      else 
        RobotJoints.correctCartesian(pos, 1);
      j.addElement(jointCalculation(pos));
    }
  }

  public static void main(String[] args) {
    Vector<GripperPosition> p = new Vector<GripperPosition>();
    Vector<JointValues> j = new Vector<JointValues>();

    System.out.println ("**** THIS IS THE STUDENT IK MODULE IN JAVA\n");

    // read the gripper positions as produced by PP.java
    GripperPosition.read(p);

    inverseKinematics(p, j);
    
    for (int i =0; i < j.size(); i++)
              System.out.println((JointValues) j.get(i));

    JointValues.write(j);
  }
}
