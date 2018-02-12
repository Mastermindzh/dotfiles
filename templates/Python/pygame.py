import sys, pygame 
from pygame.locals import *

# het aantal frames per seconde.
# hoe hoger de waarde hoe sneller het balletje beweegt en hoe beter de animatie er uitziet.
FPS = 200
KLOK = pygame.time.Clock() # de interne pygame klok

# Scherm variabelen
SCHERM_BREEDTE 	= 600 	# De breedte van het scherm
SCHERM_HOOGTE	= 400 	# De hoogte van het scherm
SCHERM = pygame.display # Het pygame venster

# Kleuren
ZWART	= (0,0,0)
WIT		= (255,255,255)


# Main
def main():
	Initialisatie() # Roep de initialisatie methode aan
	while True:		# Start een oneindige loop
		gameLoop()	# Roep onze eigen gameloop aan

# Deze methode initialiseerd het scherm
def Initialisatie():
	pygame.init() #initialiseer pygame
	SCHERM.set_mode((SCHERM_BREEDTE, SCHERM_HOOGTE))
	SCHERM.set_caption('Schermtitel')

# Deze methode wordt de gehele looptijd van het programma uitgevoerd
def gameLoop():
	#hieronder starten we een game loop
	for event in pygame.event.get():
		#als het programma gestopt wil worden dan kan dat.
		if event.type == QUIT:
			pygame.quit()
			sys.exit
		#update het scherm en tik zovaak als het FPS is aangegeven
		pygame.display.update()
		KLOK.tick(FPS)

# start het programma
if __name__=='__main__':
    main()	
