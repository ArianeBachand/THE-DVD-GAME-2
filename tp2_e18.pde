import processing.sound.*;
import processing.video.*;


//boids--oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
int count = 100;

float boidRadius = 10.0f;

float boidMaxspeed = 2.0f;
float boidMaxforce = 0.03f;

float boidThresholdSeparation = 50.0f;
float boidThresholdCohesion = 50.0f;
float boidThresholdAligment = 50.0f;

float boidWeightSeparation = 1.50f;
float boidWeightCohesion = 1.00f;
float boidWeightAligment = 0.75f;

color colorBack = 0;

// variables
Crowd crowd;
Boid boid;
//boids--oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


float xTv;
float yTv;
float largeurFenetre;
float hauteurFenetre;

int xspeed;
int yspeed;

int sectionActiveAtStartup = 1;
int sectionActive = sectionActiveAtStartup;

PImage imgDvd;
PImage imgOffice;
PImage imgRoasted;
PImage imgVictoire;
PImage imgTitre;
PImage imgRules;
PImage imgFacile;
PImage imgNormal;
PImage imgDifficile;
PImage imgJouer;
PImage imgRetry;
PImage imgAgain;

SoundFile audioTitre;
SoundFile audioJeux;
SoundFile audioDefaite;
SoundFile audioVictoire;
SoundFile audioStrike;
SoundFile soundEasy;
SoundFile soundMedium;
SoundFile soundHard;

boolean b1; //Bouton Facile enfoncé
boolean b2; //Bouton Normal enfoncé
boolean b3; //Bouton Difficile enfoncé

PFont fontGaramond;
PFont fontGoudy;
PFont fontHimalaya;
PFont fontDubai;


float r, g, b; //Variables de couleur

boolean isPlayButtonPressed;
boolean isMouseInsidePlayButton;

float playButtonPositionX;
float playButtonPositionY;
float playButtonWidth;
float playButtonHeight;
float playButtonScaleUp;
float playButtonScaleDown;
float playButtonMinX;
float playButtonMinY;
float playButtonMaxX;
float playButtonMaxY;

color colorPlayButtonNormal = color(68, 255, 0);
color colorPlayButtonInside = color(0, 214, 104);
color colorPlayButtonPressed = color(214, 4, 0);

//boolean isDvdButtonPressed; pas certain qu'on en a de besoin
boolean isMouseInsideDvdButton;
boolean isDvdButtonPressed;

float dvdButtonPositionX;
float dvdButtonPositionY;
float dvdButtonWidth;
float dvdButtonHeight;
float dvdButtonScaleUp;
float dvdButtonScaleDown;
float dvdButtonMinX;
float dvdButtonMinY;
float dvdButtonMaxX;
float dvdButtonMaxY;

int score;
int strikeCount;
int maxStrike = 3;
int scoreGagnant = 30;

//video de god please no-----------------------------------
String file = "godno.mp4";
boolean isPlaying = true;
Movie movie;

//stop-motion-----------------------------------
// paramètres
String filePrefix = "feu";
String fileExtension = ".png";

// nombre d'image dans l'animation
int animationFrameCount = 38;

// variables
PImage[] animation;

String fileName;

int keyframe;

// paramètres

float offsetAmplitude = 0.1f;
float offsetPanning = 0.2f;

// variables

SinOsc oscillator;

float amplitude;
float frequency;
float panning;

int note;
float noteDo;
float noteRe;
float noteMi;
float noteSol;
float noteLa;


void setup()
{
  size(800, 650);
  //frameRate(30);
  
  //boids--oooooooooooooooooooooooooooooooooooooooooooooooo
  frameRate(60);
  noStroke();

  rectMode(CORNER);

  // instanciation du groupe de boids
  crowd = new Crowd();

  // initialisation du groupe de boids
  for (int index = 0; index < count; ++index)
  {
    // instanciation d'un nouveau boid
    boid = new Boid(width / 2.0f, height / 2.0f);

    // configuration du nouveau boid
    configuration(boid);

    // ajouter le nouveau boid au système de boids
    crowd.add(boid);
  }
  //boids--oooooooooooooooooooooooooooooooooooooooooooooooo
  oscillator = new SinOsc(this);

  // volume de la note (intervalle normalisé entre [0, 1])
  amplitude = 0.618f;

  // fréquence de la note (ex. 440 Hertz = le 'LA' du 4e octave)
  frequency = 440.0f;

  // position panoramique de gauche à droite dans l'intervalle [-1, 1]
  panning = 0;
  
  note = 1;
  noteDo = 261.63f;
  noteRe = 293.66f;
  noteMi = 329.63f;
  noteSol = 392.00f;
  noteLa = 440.00f;

  
  b1 = false; //Bouton Facile enfoncé
  b2 = true; //Bouton Normal enfoncé
  b3 = false; //Bouton Difficile enfoncé
  
  fontGaramond = loadFont("Garamond-Bold-48.vlw");
  fontGoudy = loadFont("GoudyStout-48.vlw");
  fontHimalaya = loadFont("Microsoft_Himalaya-200.vlw");
  fontDubai = loadFont("Dubai-Bold-200.vlw");
  
  //video god please no------------------------------------------------
   // chargement du fichier vidéo en mémoire
  movie = new Movie(this, file);

  // jouer le vidéo en boucle
  movie.loop();
  movie.stop();
  //fin video god please no-------------------------------------------
  
  
  imgDvd = loadImage("dvd_logo_fond.png");
  imgOffice = loadImage("logo.png");
  imgRoasted = loadImage("nooo.jpg");
  imgVictoire = loadImage("party.jpg");
  imgTitre = loadImage("titrejeu.jpg");
  imgRules = loadImage("instructions.jpg");
  imgFacile = loadImage("facile.jpg");
  imgNormal = loadImage("normal.jpg");
  imgDifficile = loadImage("difficile.jpg");
  imgJouer = loadImage("jouer.png");
  imgRetry = loadImage("retry.png");
  imgAgain = loadImage("again.png");
  
  
  
  audioTitre = new SoundFile(this, "opening.mp3");
  audioJeux = new SoundFile(this, "medley.mp3");
  audioDefaite = new SoundFile(this, "lose.mp3");
  audioVictoire = new SoundFile(this, "win.mp3");
  audioStrike = new SoundFile(this, "no.mp3");
  soundEasy = new SoundFile(this, "soundeasy.mp3");
  soundMedium = new SoundFile(this, "soundmedium.mp3");
  soundHard = new SoundFile(this, "soundhard.mp3");
  
  audioTitre.loop();
  
  xTv = random(width);
  yTv = random(height);
  xspeed = 4; //Vitesse normale par défaut
  yspeed = 4;
  setRandomColor();
  
  playButtonPositionX = width / 2.0f;
  playButtonPositionY = (height/8.0f) * 7.0f;
  playButtonWidth = (width/9.0f) * 4.0f;
  playButtonHeight = (height/675.0f) * 100.0f;
  playButtonScaleUp = 1.05f;
  playButtonScaleDown = 0.95f;
  playButtonMinX = playButtonPositionX - (playButtonWidth / 2.0f);
  playButtonMinY = playButtonPositionY - (playButtonHeight / 2.0f);
  playButtonMaxX = playButtonPositionX + (playButtonWidth / 2.0f);
  playButtonMaxY = playButtonPositionY + (playButtonHeight / 2.0f);
  isPlayButtonPressed = false;
  isMouseInsidePlayButton = false;
  
  dvdButtonWidth = imgDvd.width;
  dvdButtonHeight = imgDvd.height;
  score = 0;
  strikeCount = 0;
}

void setDifficulty() //Dessine l'intérieur du bouton radio sélectionné
{
  if(b1)//Facile
  {
    fill(0);
    ellipse(width/3.0f, height/12.0f, width/60.0f, width/60.0f);
  }
  if(b2)//Normal
  {
    fill(0);
    ellipse(width/2, height/12.0f, width/60.0f, width/60.0f);
  }
  if(b3)//Difficile
  {
    fill(0);
    ellipse((width/3.0f)*2, height/12.0f, width/60.0f, width/60.0f);
  }
}

void setRandomColor()
{
  r = random(100, 256);
  g = random(100, 256);
  b = random(100, 256);
}

void draw()
{
 switch (sectionActive)
  {
    case 1:
      sectionTitre();
      break;
    case 2:
      sectionJeux();
      break;
    case 3:
      sectionDefaite();
      break;
    case 4:
      sectionVictoire();
      break;
  }
}

void sectionTitre()//------------------------------------------------------------------------------------------------------------------------------------------------------------------
{ 
   
  background(0);
  tint(255);
  imageMode(CENTER);
  image(imgOffice, width/2, height/4);
  fill(255);
  image(imgTitre, width/2, height/2);
  image(imgRules, width/2, (height/9)*6);
  //textAlign(CENTER, CENTER); (VIEILLE VERSION)
  //textFont(fontHimalaya, 125); (VIEILLE VERSION)
  //text("THE DVD GAME", width/2, height/2); (VIEILLE VERSION)
  
  
  textAlign(CENTER, CENTER);
  //textFont(fontGaramond, 35);
  //text("Comment jouer :", width/2, (height/5)*3);
  //text("Clique sur le logo DVD le plus de fois possible", width/2, (height/3)*2);
  //textFont(fontGaramond, 25);
  //text("(Tu as droit à trois erreurs.)", width/2, (((height*1000)/600)*440)/1000);
  
  
  //Bouton "Jouer"
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed == true)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  image(imgJouer, playButtonPositionX, playButtonPositionY);
  //fill(255);
  //textFont(fontHimalaya, 40);
  //text("Jouer!", playButtonPositionX, playButtonPositionY);
  
  
  //Les trois boutons radio------------------------
  image(imgFacile, width/3.0f, height/24.0f);
  //fill(255);
  //textFont(fontGaramond, 30);
  //text("Facile", width/3.0f, height/24.0f);
  
  image(imgNormal, width/2, height/24.0f);
  //fill(255);
  //textFont(fontGaramond, 30);
  //text("Normal", width/2, height/24.0f);
  
  image(imgDifficile, (width/3.0f)*2.0f, height/24.0f);
  //fill(255);
  //textFont(fontGaramond, 30);
  //text("Difficile", (width/3.0f)*2.0f, height/24.0f);
  
  //Bouton radio FACILE
  fill(255);
  ellipse(width/3.0f, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();
  
  //Bouton radio NORMAL
  fill(255);
  ellipse(width/2, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();
  
  //Bouton radio DIFFICILE
  fill(255);
  ellipse((width/3.0f)*2, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();

}

void sectionJeux()//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
  background(0);
  fill(255);
  tint(r, g, b);
  rectMode(CORNER);
  rect(0, (height/13.0f)*12.0f, width, (height/13.0f));
  fill(0);
  textAlign(CENTER, CENTER);
  textFont(fontDubai, 50);
  text("SCORE : " + score + "   STRIKE : " + strikeCount, (width/2.0f), ((height/13.0f)*12.0f)+((height/13.0f)/2.0f));
  imageMode(CORNER);
  tint(r, g, b);
  image(imgDvd, xTv, yTv);

  dvdButtonMaxX = dvdButtonWidth + xTv;
  dvdButtonMaxY = dvdButtonHeight + yTv;
  isMouseInsideDvdButton = false;
  isDvdButtonPressed = false;
  
  //Valide si la souris est à l'interieur de l'image Dvd
  if (mouseX >= xTv && mouseX <= dvdButtonMaxX)
  {
    if (mouseY >= yTv && mouseY <= dvdButtonMaxY)
    {
      isMouseInsideDvdButton = true;
    }

  }
  else
    isMouseInsideDvdButton = false;

  
  xTv = xTv + xspeed;
  yTv = yTv + yspeed;

//Valide si l'image atteint le bord
  if (xTv + imgDvd.width >= width)
  {
    xspeed = -xspeed;
    xTv = width - imgDvd.width;
    setRandomColor();
  } else if (xTv <= 0)
  {
    xspeed = -xspeed;
    xTv = 0;
    setRandomColor();
  }
  
  if (yTv + imgDvd.height >= (height/13.0f)*12.0f)
  {
    yspeed = -yspeed;
    yTv = (height/13.0f)*12.0f - imgDvd.height;
    setRandomColor();
  } else if (yTv <= 0)
  {
    yspeed = -yspeed;
    yTv = 0;
    setRandomColor();
  }
} 
  

void sectionDefaite()//----------------------------------------------------------------------------------------------------------------------------------------------------------------
{
//video god please no--xxxxxxxxxxxxxxxxxxxxx
   // appliquer une teinte
  tint(255, 0, 0);
  
  imageMode(CORNER);
  // dessiner le frame courant du vidéo
  image(movie, 0, 0, 800, 650);
  
  
  
  //background(255);
  //imageMode(CORNER);
  //tint(0, 0 , 255);
  //image(imgRoasted, 0, 0);
  //filter(POSTERIZE, 15);
  
  
  
  fill(255);
  textFont(fontDubai, 60);
  text("ROASTED.", width/2, height/3);
  textFont(fontDubai, 40);
  text("Score = " + score, width/2, (height*3)/4);
  
 
  //Bouton Réessayer
  noStroke();
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  imageMode(CENTER);
  noTint();
  image(imgRetry, playButtonPositionX, playButtonPositionY);
  //fill(255);
  //textFont(fontGoudy, 28);
  //text("Réessayer?", playButtonPositionX, playButtonPositionY);

}
// fonction appelée quand un nouveau frame du vidéo est prêt à être lu
void movieEvent(Movie m)
{
  m.read();
}



void sectionVictoire()//---------------------------------------------------------------------------------------------------------------------------------------------------------------
{
  //background(255);
  //tint(255);
   //imageMode(CORNER);
  //image(imgVictoire, 0, 0);
  
  imageMode(CORNER);
  tint(0, 200, 100, 16);
  image(imgVictoire, 0, 0);
 
  //boids--ooooooooooooooooooooooooooooooooooooooooooo
  //fade(16);

  // mise à jour des contrôles interactifs
  updateMouse();

  // mise à jour du système de boids
  crowd.update();

  // rendu du système de boids
  crowd.render();
  //boids--ooooooooooooooooooooooooooooooooooooooooooo
  if (frameCount % 10 == 0)
    {
      note = int(random(0.1f, 0.5f) * 10);
      if(frameCount % 60 == 0)
      {
        oscillator.stop();
      }
    }
  
  noTint();
  fill(255);
  textFont(fontGaramond, 60);
  text("Victoire!", width/2, height/2);
  textFont(fontGaramond, 40);
  text("Score = " + score, width/2, (height*2)/3);
  
  //Bouton rejouer
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  noTint();
  imageMode(CENTER);
  image(imgAgain, playButtonPositionX, playButtonPositionY);
  //fill(255);
  //textFont(fontGoudy, 35);
  //text("Rejouer?", playButtonPositionX, playButtonPositionY);

//stop-motion___________________________________________________________
 // frameRate(50);
  

  // initialiser le tableau qui contiendra les images de l'animation
 // animation = new PImage[animationFrameCount];

 // for (keyframe = 1; keyframe <= animationFrameCount; ++keyframe)
 // {
    // construire le nom du fichier en fonction du keyframe
    // la fonction nf() permet de formatter un nombre vers une chaîne de 4 caractères
    // afin de correspondre au nom du fichier de chaque image
  //  fileName = filePrefix + nf(keyframe, 4) + fileExtension;

    // importer l'image qui correspond au nom de fichier
   // animation[keyframe - 1] = loadImage(fileName);
 // }

 // keyframe = 0;
  
  
  // déterminer le keyframe courant
 // keyframe = frameCount % animationFrameCount;

  // afficher l'image courante de l'animation
  
 // image(animation[keyframe], 500, 300); //RAJOUTER ICI LE FORMAT DE L'ANIMATION. GROSSIR OU RAPETISSER.
 // image(animation[keyframe], 100, 300);
  //fin du stop-motion____________________________________________________________________________
}


void mousePressed()//------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
   switch (sectionActive)
  {
    case 1:
      if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      if (mouseX >= (width/3.0f)-((width/36.0f)/2.0f) && mouseX <= (width/3.0f)+((width/36.0f)/2.0f))//facile
        {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//facile
          {
            b1 = true;
            b2 = false;
            b3 = false;
            xspeed = 2;
            yspeed = 2;
            soundEasy.play();
          }
        }
      if (mouseX >= (width/2.0f)-((width/36.0f)/2.0f) && mouseX <= (width/2.0f)+((width/36.0f)/2.0f))//Normal
      {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//Normal
        {
          b1 = false;
          b2 = true;
          b3 = false;
          xspeed = 4;
          yspeed = 4;
          soundMedium.play();
        }
      }
      if (mouseX >= ((width/3.0f)*2)-((width/36.0f)/2.0f) && mouseX <= ((width/3.0f)*2)+((width/36.0f)/2.0f))//Normal
      {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//Normal
        {
          b1 = false;
          b2 = false;
          b3 = true;
          xspeed = 7;
          yspeed = 7;
          soundHard.play();
        }
      }
      break;
    case 2:
        if (isMouseInsideDvdButton)
          {
            if (mouseButton == LEFT || mouseButton == RIGHT)
              {
                //Clique réussis;
                score++;
              }
          }
          else
            {
              //Clique raté;
              strikeCount++;
              if(strikeCount < 3)
                audioStrike.play();
            }
              
        if (maxStrike == strikeCount)
        {
          if (score >= scoreGagnant)
            {
              audioJeux.stop();
              movie.stop();
              sectionActive = 4;
              rectMode(CORNER);
              noStroke();
              fill(colorBack);
              rect(0, 0, width, height);
              audioVictoire.play();
            }
            else
              {
              audioJeux.stop();
              oscillator.stop();
              sectionActive = 3;
              movie.loop();
              //audioDefaite.play();
              }
        }
  
      break;
    case 3:
    
    if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      
      break;
    case 4:
      
      if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      
      break;
  }
}

void mouseReleased()
{
  switch (sectionActive)
  {
    case 1:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          sectionActive = 2;
          audioJeux.loop();
          audioDefaite.stop();
          oscillator.stop();
          audioVictoire.stop();
          audioTitre.stop();
          movie.stop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      break;
    case 2:
      
      break;
    case 3:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          score = 0;
          strikeCount = 0;
          sectionActive = 1;
          movie.stop();
          oscillator.stop();
          audioJeux.stop();
          audioVictoire.stop(); 
          audioDefaite.stop();
          audioTitre.loop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      break;
    case 4:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          score = 0;
          strikeCount = 0;
          sectionActive = 1;
          movie.stop();
          oscillator.stop();
          audioJeux.stop();
          audioVictoire.stop(); 
          audioDefaite.stop();
          audioTitre.loop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      
      break;
  }
}


//boids--oooooooooooooooooooooooooooooooooooooooooooooooooooooo
void updateMouse()
{
  if (mousePressed == true)
  {
    // créer un nouveau boid seulement un frame sur deux
    if (frameCount % 2 == 0)
    {
      // faire apparaitre le boid à la position du curseur
      boid = new Boid(mouseX, mouseY);
      configuration(boid);
      crowd.add(boid);
      
      switch (note)
      {
        case 1 :
        {
          playNote(noteDo);
          note = 2;
          break;
        }
        case 2 :
        {
          playNote(noteRe);
          note = 3;
          break;
        }
        case 3 :
        {
          playNote(noteMi);
          note = 4;
          break;
        }
        case 4 :
        {
          playNote(noteSol);
          note = 5;
          break;
        }
        case 5 :
        {
          playNote(noteLa);
          note = 1;
          break;
        }
      }
      
    }
  }
}

void playNote(float f)
{
  frequency = f;

  oscillator.freq(frequency);
  oscillator.amp(amplitude);
  oscillator.pan(panning);

  oscillator.play();
}

// fonction de configuration d'un nouveau boid selon les paramètres du programme
void configuration(Boid b)
{
  // propriétés
  b.radius = boidRadius;
  b.maxspeed = boidMaxspeed;
  b.maxforce = boidMaxforce;

  // valeurs des seuils des différents comportements
  b.thresholdCohesion = boidThresholdCohesion;
  b.thresholdAligment = boidThresholdAligment;
  b.thresholdSeparation = boidThresholdSeparation;

  // valeurs de pondération des différents comportements
  b.weightSeparation = boidWeightSeparation;
  b.weightCohesion = boidWeightCohesion;
  b.weightAligment = boidWeightAligment;
}

//void fade(float intensity)
//{
//  //rectMode(CORNER);
//  //noStroke();
//  //fill(colorBack, intensity);
//  //rect(0, 0, width, height);
//  imageMode(CORNER);
//  tint(0, 255, 0, intensity);
//  image(imgVictoire, 0, 0);
//}
//boids--oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo




//Raccourci pour naviguer dans les sections
void keyReleased()
{
  if (key == '1')
    sectionActive = 1;
    oscillator.stop();
    movie.stop();
    audioJeux.stop();
    audioVictoire.stop(); 
    audioDefaite.stop();
    audioTitre.loop();

  if (key == '2')
    {
    score = 0;
    strikeCount = 0;
    audioJeux.loop();
    audioDefaite.stop();
    audioVictoire.stop();
    audioTitre.stop();
    movie.stop();
    oscillator.stop();
    sectionActive = 2;
    } 

  if (key == '3')
    {
    audioJeux.stop();
    audioVictoire.stop();
    audioTitre.stop();
    //audioDefaite.play();
    movie.loop();
    oscillator.stop();
    sectionActive = 3;
    
    }
    
  if (key == '4')
    {
    audioJeux.stop();
    audioDefaite.stop();
    audioTitre.stop();
    audioVictoire.play(); 
    movie.stop();
    image(imgVictoire, 0, 0);
    rectMode(CORNER);
    noStroke();
    fill(colorBack);
    rect(0, 0, width, height);
    sectionActive = 4;
    }
} 
  
  
  
  
  
  
 
