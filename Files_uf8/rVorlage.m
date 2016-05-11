
#import "rVorlage.h"


@implementation rVorlagerahmen

- (id)initWithFrame:(NSRect)frame
{
   //dLog("rVorlagerahmen init");
   self=[super initWithFrame:frame];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(TastenwerteAktion:)
              name:@"Tastenwerte"
            object:nil];
   
   
   TastenwertArray=[[NSMutableArray alloc]initWithCapacity:100];
   int i;
   for (i=0;i<100;i++)
   {
      [TastenwertArray addObject:[NSNumber numberWithInt:0]];
   }
   //dLog("rAufgabeRahmen init Tastenwerte: %@",[TastenwertArray description]);
   return self;
   
   /*
    Wertarray=[[[NSMutableArray alloc]initWithCapacity:10]retain];
    for (i=0;i<10;i++)
    {
    [Wertarray addObject:[NSNumber numberWithInt:0]];
    }
    */
   mode=1;
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //dLog("Vorlage TastenwerteAktion");
   if ([[note userInfo]objectForKey:@"Tastenwerte"])
   {
      //dLog("Vorlage TastenwerteAktion: note: %@",[[[note userInfo]objectForKey:@"Tastenwerte"]description]);
      NSArray* tempArray=[[note userInfo]objectForKey:@"Tastenwerte"];
      //dLog("TastenwerteAktion: tempArray: %@",[tempArray description]);
      
      [TastenwertArray setArray:tempArray];
      
      [self setNeedsDisplay:YES];
   }
}

- (void)drawRect:(NSRect)rect
{
   //dLog("rVorlagerahmen drawRect ");
   //NSBezierPath p=[Aufgaberahmen path];
   [[NSColor blackColor]set];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   [NSBezierPath strokeRect:r];
   NSRect rr=NSMakeRect(20,40,20,20);
   //[NSBezierPath strokeRect:rr];
   
   //dLog("rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //Tastenwerte=[[[NSArray alloc]init]retain];
   int offsetx=32;
   int offsety=60;
   int durchmesser=26;
   NSRect Tastenfeld=NSMakeRect(0,0,durchmesser,durchmesser);//[self bounds];
   //Tastenfeld.size.width=20;
   //Tastenfeld.size.height=20;
   //Tastenfeld.origin.x=10;
   //Tastenfeld.origin.y=10;
   
   //dLog("TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
   int i, k;
   /*
    [Wertarray removeAllObjects];
    for (i=0;i<10;i++)
    {
    [Wertarray addObject:[NSNumber numberWithInt:0]];
    }
    */
   int d=30;
   NSRect Wertfeld;
   for(i=0;i<10;i++)//Zeile
   {
      int zeilenwert=0;
      for (k=0;k<10;k++)//Kolonne
      {
         Tastenfeld.origin.x=k*d+offsetx;
         if (k>=5)
            Tastenfeld.origin.x+=5;
         Tastenfeld.origin.y=i*d+offsety;
         if (i>=5)
            Tastenfeld.origin.y+=5;
         NSRect Kreisfeld=Tastenfeld;
         Kreisfeld.origin.x+=2;
         Kreisfeld.origin.y+=2;
         NSBezierPath* Kreis=[NSBezierPath bezierPathWithOvalInRect:Kreisfeld];
         float lw=[Kreis lineWidth];
         [Kreis setLineWidth:2.0];
         //if ([TastenwertArray count]>(10*k)+i)
         {
            if ([[TastenwertArray objectAtIndex:(10*(i)+(k))]intValue])
            {
               [[NSColor lightGrayColor]set];
               [Kreis fill];
               switch (mode)
               {
                  case 0: // Hundertertabelle
                     zeilenwert+=(10*(9-i))+(k+1);
                     //dLog("Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     zeilenwert+=((10-i))*(k+1);
                     //dLog("Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                     
               }//switch mode
               
               
               //dLog("zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
            }
            //else
            {
               [[NSColor darkGrayColor]set];
               [Kreis stroke];
            }
         }
         [Kreis setLineWidth:lw];
      }//for k
      //dLog("zeile: %d zeilenwert: %d",i, zeilenwert);
      
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=2*d;
      Wertfeld.origin.y+=2;
      Wertfeld.size.height-=2;
      Wertfeld.size.width*=1.5;
      [[NSColor lightGrayColor]set];
      [NSBezierPath strokeRect:Wertfeld];
      
   }//for i
   //Wertfeld=Tastenfeld;
   /*
    Wertfeld.origin.x=11*d+offsetx;
    Wertfeld.origin.y=6;
    //Wertfeld.size.height-=2;
    Wertfeld.size.width+=4;
    [NSBezierPath strokeRect:Wertfeld];
    */
   /*
    NSPoint w=[Ergebnisfeld frame].origin;
    w.x =Tastenfeld.origin.x;
    w.x+=3*d;
    [Ergebnisfeld setFrameOrigin:w];
    //[Tastenmatrixfeld addSubview:Tastenmatrix];
    
    [Ergebnisfeld setAlignment:NSRightTextAlignment];
    */
   [[NSColor blackColor]set];
}





@end


@implementation rVorlageDruckfeld
- (id) initWithFrame:(NSRect)frame
{
   self=[super initWithFrame:frame];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(TastenwerteAktion:)
              name:@"Tastenwerte"
            object:nil];
   
   
   return self;
}


- (void)awakeFromNib
{
   heuteDatumString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];//  12.09.2015
   
   //[heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   [Datumfeld setStringValue:heuteDatumString];
   
   NSRect r;
   //r=[Titelrahmen frame];
   //dLog("Druckfeld awake Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //[self addSubview:Aufgaberahmen];
   //[Titelfeld setStringValue:@"Reihentabelle"];
   
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //dLog("VorlageDruckfeld TastenwerteAktion");
   if ([[note userInfo]objectForKey:@"Anzahl"] && [[[note userInfo]objectForKey:@"Anzahl"]intValue])
   {
      if ([[note userInfo]objectForKey:@"Gruppe"])
      {
         [Gruppefeld setStringValue:[[note userInfo]objectForKey:@"Gruppe"]];
      }
      if ([[note userInfo]objectForKey:@"Nummer"])
      {
         [Nummerfeld setStringValue:[[note userInfo]objectForKey:@"Nummer"]];
      }
      
      if ([[note userInfo]objectForKey:@"Titel"])
      {
         [Titelfeld setStringValue:[[note userInfo]objectForKey:@"Titel"]];
         
      }
      
      [Datumfeld setStringValue:heuteDatumString];
      
   }//if Anzahl
   else
   {
      [Datumfeld setStringValue:@""];
      [Titelfeld setStringValue:@""];
      [Gruppefeld setStringValue:@""];
      [Nummerfeld setStringValue:@""];
   }
   int erfolg=[[self window]makeFirstResponder:[self window]];
}

@end


@implementation rVorlage
- (id) init
{
   self=[super initWithWindowNibName:@"Vorlage"];
   return self;
}

- (void)awakeFromNib
{
   //dLog("Vorlage awake");
   
   
}



- (IBAction)printDocument:(id)sender
{
   //dLog("printDocument");
   [self VorlageDrucken];
   
}



- (void)VorlageDrucken
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //DLog (@"Kommentar: BlattDruckenMitDicArray ProjektDicArray: %@",[derProjektDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   
   [PrintInfo setOrientation:NSPortraitOrientation];
   [PrintInfo setHorizontalPagination: NSAutoPagination];
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect bounds=[PrintInfo imageablePageBounds];
   
   int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
   //dLog("Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   NSSize Papiergroesse=[PrintInfo paperSize];
   int leftRand=(Papiergroesse.width-bounds.size.width)/2;
   int topRand=(Papiergroesse.height-bounds.size.height)/2;
   int platzH=(Papiergroesse.width-bounds.size.width);
   
   int freiLinks=60;
   int freiOben=30;
   //int DruckbereichH=bounds.size.width-freiLinks+platzH*0.5;
   int DruckbereichH=Papiergroesse.width-freiLinks-leftRand;
   
   int DruckbereichV=bounds.size.height-freiOben;
   
   int platzV=(Papiergroesse.height-bounds.size.height);
   
   //dLog("platzH: %d  platzV %d",platzH,platzV);
   
   int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
   
   [PrintInfo setLeftMargin:freiLinks];
   [PrintInfo setRightMargin:leftRand];
   [PrintInfo setTopMargin:freiOben];
   [PrintInfo setBottomMargin:botRand];
   
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   int obererRand=[PrintInfo topMargin];
   int linkerRand=(int)[PrintInfo leftMargin];
   int rechterRand=[PrintInfo rightMargin];
   
   //dLog("linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
   NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
   
   //DruckView=[[NSView alloc]initWithFrame:DruckFeld];
   //[DruckView addSubview:Druckfeld];
   //DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];
   
   
   
   
   
   //[DruckView setBackgroundColor:[NSColor grayColor]];
   //[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: VorlageDruckfeld
                                                 printInfo:PrintInfo];
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
   
}
@end


