

PImage fighterImg;
PImage hpImg;
PImage treasureImg;
PImage enemyImg;
PImage bg1Img;
PImage bg2Img;
PImage start1Img;
PImage start2Img;
PImage end1Img;
PImage end2Img;
int numframes = 5;
int currentFrame;
int Nowframe;
PImage[] flameImg = new PImage[numframes];
PImage shootImg;

//Other
int hp, B; 

//Treasure
int Treasure_x, Treasure_y;

//Fighter
int Fight_x, Fight_y;
int[] Shoot_x = new int[5];
int[] Shoot_y = new int[5];
boolean[] Shooting = new boolean[5];
int front, rear;
int shoot_speed;

//Enemy
int[] Enemy_x = new int[8];
int[] Enemy_y = new int[8];
int[] Crash_x = new int[8];
int[] Crash_y = new int[8];
boolean[] Crashing = new boolean[8];
boolean Enemy_is_crash[] = new boolean[8];
int restartEnemy;
int speed = 0;

//gamestate
final int GAME_START=1, GAME_RUN=2, GAME_FINISH=3,E1=1,E2=2,E3=3;
int gameState;
int enemyState;

//buttom
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
boolean spacePressed = false;
int value;

void setup () {
  size(640,480);
  //Image
  fighterImg=loadImage("img/fighter.png");
  hpImg=loadImage("img/hp.png");
  treasureImg=loadImage("img/treasure.png");
  enemyImg=loadImage("img/enemy.png");
  bg1Img=loadImage("img/bg1.png");
  bg2Img=loadImage("img/bg2.png");
  start1Img=loadImage("img/start1.png");
  start2Img=loadImage("img/start2.png");
  end1Img=loadImage("img/end1.png");
  end2Img=loadImage("img/end2.png");
  for(int i = 0; i < 5; i++)
  {
    flameImg[i] = loadImage("img/flame" + (i+1) + ".png");
  }
  shootImg = loadImage("img/shoot.png");
  frameRate(60);
  currentFrame = 0;
  Nowframe = 0;
  
  hp=40;
  B=0;
  //Treasure
  Treasure_x=floor(random(20,550));
  Treasure_y=floor(random(30,460));

  //Enemy
  restartEnemy = floor(random(50,300));
  for(int i = 0; i < 8; i++)
  {
    Enemy_x[i] = 0;
    Enemy_y[i] = restartEnemy;
    Enemy_is_crash[i] = false;
    Crash_x[i] = 0;
    Crash_y[i] = 0;
    Crashing[i] = false;
  }
  for(int i = 0; i < 5; i++)
  {
      Shoot_x[i] = 0;
    Shoot_y[i] = 0;
    Shooting[i] = false;
  }

  //Fighter
  Fight_x=580;
  Fight_y=240;
  front = 0;
  rear = 1;
  gameState = GAME_START;
  enemyState=1;
}

void scoreChange (){
  textSize(30);
  fill(255,255,255);
  
  
  
  if (spacePressed)
    {
      int Fullshoot = 0;
      for(int i = 0; i < 5; i++)
      {
        if(Shooting[i]) 
        {
          Fullshoot++;
        }
      }
      if(rear == 1 && Shooting[(rear-1)%5] == false)
      {
        Shoot_x[(rear-1)%5] = Fight_x;
        Shoot_y[(rear-1)%5] = Fight_y + (fighterImg.height)/2 - (shootImg.height)/2;
        Shooting[(rear-1)%5] = true;
        
        
      }
      if(Fullshoot < 5 && Fight_x - Shoot_x[(rear-1)%5] >= 50)
      {
        Shoot_x[rear%5] = Fight_x;
        Shoot_y[rear%5] = Fight_y + (fighterImg.height)/2 - (shootImg.height)/2;
        Shooting[rear%5] = true;
        rear++;
        
      }
    }
    for(int i = 0; i < 5; i++)
    {
      if(Shooting[i])
      {
        image(shootImg, Shoot_x[i], Shoot_y[i]);
        Shoot_x[i]-=5;
        for(int j = 0; j < 8; j++)
        {
          if(Enemy_is_crash[j] == false)
          {
            if(Shoot_x[i] > Enemy_x[j] && Shoot_x[i]<=Enemy_x[j] + enemyImg.width && Shoot_y[i] <= Enemy_y[j] + enemyImg.height && Shoot_y[i] + shootImg.height>=Enemy_y[j])
            {
              Crash_x[j] = Enemy_x[j];
              Crash_y[j] = Enemy_y[j];
              Crashing[j] = true;
              Nowframe = frameCount;
              Enemy_x[j] = width + 1;
              Enemy_y[j] = height + 1;
              Enemy_is_crash[j] = true;
              Shooting[i] = false;
              Shoot_x[i] = 0;
              Shoot_y[i] = 0;
              value +=20;
              if(front <= rear)
              {
                front++;
              }
            }
          }
        }
      }
      if( Shoot_x[i] + shootImg.width < 0 )
      {
        Shoot_x[i] = 0;
        Shoot_y[i] = 0;
        Shooting[i] = false;
        if(front < rear)
        {
          front++;
        }
      }
    }
text("Score:"+ value,10,470); 
  }

  





void draw() 
{
 
  
  switch(gameState)
  {  

  case GAME_START:  
    image(start2Img,0,0);
    if(mouseX>202.3 && mouseX<457.1 && mouseY>373 && mouseY<415){
      if(mousePressed){
        gameState = GAME_RUN;
      }
      else{
        image(start1Img,0,0);
      }
    }
    break;
  
  case GAME_RUN:
    //Boundary Set
    
    image(bg1Img,B,0);
    image(bg2Img,B-640,0);
    image(bg1Img,B-1280,0);
    image(fighterImg,Fight_x,Fight_y);
    fill(255,0,0);
    rect(20,10,hp,20);
    
    image(treasureImg,Treasure_x,Treasure_y);
    image(hpImg,10,10);
  
    //Back ground move  
    B++;
    B%=1280;

    if (upPressed) {
      Fight_y -= 5;
      if(Fight_y<0){
      Fight_y=0;
      }
    }
    if (downPressed) {
      Fight_y += 5;
      if(Fight_y>430){
      Fight_y=430;
      }
    }
    if (leftPressed) {
      Fight_x -= 5;
      if(Fight_x<0){
      Fight_x=0;
      }
    }
    if (rightPressed) {
      Fight_x += 5;
      if(Fight_x>590){
      Fight_x=590;
      }
    }
    
    
   
     //treasure + hp
    if(Fight_x<Treasure_x+41 && Fight_x>=Treasure_x-41 && Fight_y<=Treasure_y+41 && Fight_y>=Treasure_y-41)
    {
      Treasure_x=floor(random(20,550));
      Treasure_y=floor(random(30,430));
      hp+=20;
    }
    if(hp>=195)
    {
      hp=195;
    }
    
    switch(enemyState)
     {
      case E1:
      for(int i = 0; i < 5; i++)
      {
        speed++;
        if( Enemy_is_crash[i] != true)
        {
          Enemy_x[i] = (-enemyImg.width)*i + speed;
          image(enemyImg, Enemy_x[i], restartEnemy);
        }
      }
      if( (speed - 240)>width )
      {
        speed = 0;
        enemyState = E2;
        restartEnemy = floor(random(50,100));
        for(int i = 0; i < 5; i++)
        {
          Enemy_y[i] = restartEnemy;
          Enemy_is_crash[i] = false;
        }
      }
      break;
        
      case E2:  
      for(int i = 0; i < 5; i++)
      {
        speed++;
        if( Enemy_is_crash[i] != true)
        {
          Enemy_x[i] = (-enemyImg.width)*i + speed;
          Enemy_y[i] = restartEnemy + (enemyImg.height)*i;
          image(enemyImg,Enemy_x[i],Enemy_y[i]);
        }
      }
      if((speed - 240)>width)
      {
        speed = 0;
        enemyState = E3;
        restartEnemy = floor(random(40*3, 350));
        for(int i = 0; i < 5; i++)
        {
          Enemy_y[i] = restartEnemy;
          Enemy_is_crash[i] = false;
        }
      }
      break;
     
      case E3:
      for(int i = 0; i < 8; i++)
      {
        if(i < 5)
        {
          speed++;
          if( Enemy_is_crash[i] != true)
          {
            Enemy_x[i] = (-60)*i + speed;
            if(i < 3)
            {
              Enemy_y[i] = restartEnemy - 40*i;
              image(enemyImg,Enemy_x[i],Enemy_y[i]);
            }
            else
            {
              Enemy_y[i] = restartEnemy - 40*(4-i);
              image(enemyImg,Enemy_x[i],Enemy_y[i]);
            }
          }
         }
         else
         {
          if( Enemy_is_crash[i] != true)
          {
            Enemy_x[i] = (-60)*(8-i) + speed;
            if(i < 7)
            {
              Enemy_y[i] = restartEnemy + 40*(i-4);
              image(enemyImg,Enemy_x[i],Enemy_y[i]);
            }
            else
            {
              Enemy_y[i] = restartEnemy + 40*(8-i);
              image(enemyImg,Enemy_x[i],Enemy_y[i]);
            }
          }
         }
      }
      if((speed - 240)>width)
      {
         enemyState = E1;
         speed = 0;
         restartEnemy=floor(random(50,300));      
         for(int i = 0; i < 8; i++)
         {
          Enemy_y[i] = restartEnemy;
          Enemy_is_crash[i] = false;
        }
      }
      break;      
    }
    
    //enemy-hp
    if(enemyState == E3)
    {
      for(int i = 0; i < 8; i++)
      {
        if(Fight_x<=Enemy_x[i]+50 && Fight_x>=Enemy_x[i]-60.8 && Fight_y<=Enemy_y[i]+60.8 && Fight_y>=Enemy_y[i]-60.8)
        {
          Crash_x[i] = Enemy_x[i];
          Crash_y[i] = Enemy_y[i];
          Crashing[i] = true;
          Nowframe = frameCount;
          hp -= 40;
          Enemy_x[i] = width + 10;
          Enemy_y[i] = height + 10;
          Enemy_is_crash[i] = true;
        }
      }
    }
    else
    {
      for(int i = 0; i < 5; i++)
      {  
        if(Fight_x<=Enemy_x[i]+50 && Fight_x>=Enemy_x[i]-60.8 && Fight_y<=Enemy_y[i]+60.8 && Fight_y>=Enemy_y[i]-60.8)
        {
          Crash_x[i] = Enemy_x[i];
          Crash_y[i] = Enemy_y[i];
          Crashing[i] = true;
          Nowframe = frameCount;
          hp -= 40;
          Enemy_x[i] = width + 100;
          Enemy_y[i] = height + 100;
          Enemy_is_crash[i] = true;
        }
      }
    }

    for(int i = 0; i < 8; i++)
    {
      if (Crashing[i]) 
      {
        image(flameImg[currentFrame % numframes], Crash_x[i], Crash_y[i]);
        if((frameCount - Nowframe) % (60/10) == 5)
        {
          currentFrame ++;
        }
        if((frameCount - Nowframe) % 30 == 0 && (frameCount - Nowframe) != 0)
        {
          Crash_x[i] = 0;
          Crash_y[i] = 0;
          Crashing[i] = false;
          Nowframe = 0;
        }
      }
    }


    //Fighter's hp = 0
    if(hp <= 0)
    {
      gameState = GAME_FINISH;
    }
scoreChange();
    break;
   
  case GAME_FINISH:
      
    image(end2Img,0,0);
    if(mouseX>202.3 && mouseX<440 && mouseY>300 && mouseY<355)
    {
      image(end1Img,0,0);
      if(mousePressed)
      {
        speed = 0;
        hp=40;
        Treasure_x=floor(random(20,550));
        Treasure_y=floor(random(30,460));
        for(int i = 0; i < 8; i++)
        {
          Enemy_x[i] = 0;
          Enemy_y[i] = restartEnemy;
          Enemy_is_crash[i] = false;
          Crash_x[i] = 0;
          Crash_y[i] = 0;
          Crashing[i] = false;
        }
        for(int i = 0; i < 5; i++)
        {
            Shoot_x[i] = 0;
          Shoot_y[i] = 0;
          Shooting[i] = false;
        }
        B=0;
        Fight_x=580;
        Fight_y=240;
        gameState = GAME_RUN;
        enemyState = E1;
        value=0;
        break;
      }
    }
  }
  
}


void keyPressed() 
{
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      case ' ':
        spacePressed = true;
        break;
    }
  }
  else if(key == ' ')
  {
    spacePressed = true;
  }
}
void keyReleased() 
{
  if (key == CODED) 
  {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      case ' ':
        spacePressed = false;
        break;
    }
  }
  else if(key == ' ')
  {
    spacePressed = false;
  }
}
