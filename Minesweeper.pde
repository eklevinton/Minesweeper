import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private int unmarkedBombs = NUM_BOMBS;
private int unclickedTiles = (NUM_ROWS*NUM_COLS)-(NUM_BOMBS);

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  
  // make the manager
  Interactive.make( this );
  
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int nRows = 0; nRows < NUM_ROWS; nRows++)
    for (int nCols = 0; nCols < NUM_COLS; nCols++)
      buttons[nRows][nCols] = new MSButton(nRows, nCols);
  for (int bomb = 0; bomb < NUM_BOMBS; bomb++)
    setBombs();
}

public void setBombs()
{
  int bRow = (int)(Math.random()*NUM_ROWS);
  int bCol = (int)(Math.random()*NUM_COLS);
  if (!bombs.contains(buttons[bRow][bCol]))
    bombs.add(buttons[bRow][bCol]);
  else
    setBombs();
}


public void draw ()
{
    background(0);
  if (isWon())
    displayWinningMessage();
}

public boolean isWon()
{
  if (unclickedTiles == 0) return true;
  else if (unmarkedBombs != 0) return false;
  else if (unmarkedBombs == 0)
  {
    for (int i = 0; i < bombs.size(); i++)
      if (!bombs.get(i).isMarked())
        return false;
  }
  return true;
}


public void displayLosingMessage()
{
  for (int i = 0; i < bombs.size(); i++)
    if (bombs.get(i).isMarked() == false)
      bombs.get(i).clicked = true;
 buttons[10][7].setLabel("Y");
 buttons[10][8].setLabel("O");
 buttons[10][9].setLabel("U");
 buttons[10][10].setLabel("");
 buttons[10][11].setLabel("L");
 buttons[10][12].setLabel("O");
 buttons[10][13].setLabel("S");
 buttons[10][14].setLabel("T");
  gameOver = true;
}


public void displayWinningMessage()
{
  buttons[10][7].setLabel("Y");
  buttons[10][8].setLabel("O");
  buttons[10][9].setLabel("U");
  buttons[10][10].setLabel("");
  buttons[10][11].setLabel("W");
  buttons[10][12].setLabel("O");
  buttons[10][13].setLabel("N");
  gameOver = true;
}



public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = rr;
    myCol = cc; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  }



  public void mousePressed () 
  {
    if (gameOver == false)
    {
      if (mouseButton == LEFT && flagged == false)
      {
        clicked = true;
        unclickedTiles--;
      }
      if (mouseButton == RIGHT && clicked == false)
      {
        flagged = !flagged;
        if (!isMarked())
          unmarkedBombs++;
        else if (isMarked())
          unmarkedBombs--;
      } 
      else if (bombs.contains( this ) && flagged == false)
        displayLosingMessage();
      else if (countBombs(myRow, myCol)>0)
        setLabel(str(countBombs(myRow, myCol)));
      else
        for (int i = -1; i <= 1; i++)
          for (int j = -1; j <= 1; j++)
            if (isValid(myRow+i, myCol+j) && !buttons[myRow+i][myCol+j].isClicked())
              buttons[myRow+i][myCol+j].mousePressed();
    }
  }

  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    textSize(12);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        if (isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
          numBombs++;
    return numBombs;
  }
}
