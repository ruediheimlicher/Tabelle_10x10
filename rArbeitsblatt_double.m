//
//  MyDocument.m
//  Reihen
//
//  Created by Sysadmin on 25.03.08.
//

#import "rArbeitsblatt_double.h"
#import "defines.h"

@implementation rRahmen_double
- (id) initWithFrame:(NSRect)frame
{
	
self =[super initWithFrame:frame];
	return self;
}

- (void)drawRect:(NSRect)rect
{
//dLog("rRahmen drawRect ");
//NSBezierPath p=[Aufgaberahmen path];
NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:tabalpha];
[FeldFarbe set];
[NSBezierPath fillRect:r];
[[NSColor grayColor]set];
[NSBezierPath strokeRect:r];

//dLog("rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);

}



@end


@implementation rAufgabeRahmen_double
- (id)initWithFrame:(NSRect)frame
{
	//dLog("rAufgabeRahmen init");
	self=[super initWithFrame:frame];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(TastenwerteAktion:)
              name:@"DoubleTastenwerte"
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
   if ([[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Tastenwerte"])
   {
      //dLog("TastenwerteAktion double: note: %@",[[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Tastenwerte"]description]);
      NSArray* tempArray=[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Tastenwerte"];
      //dLog("TastenwerteAktion: tempArray: %@",[tempArray description]);
      
      [TastenwertArray setArray:tempArray];
      if ([[note userInfo]objectForKey:@"Mode"])
      {
         mode=[[[note userInfo]objectForKey:@"Mode"]intValue];
      }
      
      [self setNeedsDisplay:YES];
   }
   
}


- (void)drawRect:(NSRect)rect
{
	//dLog("rRahmen drawRect ");
	//NSBezierPath p=[Aufgaberahmen path];
	NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
	[[NSColor grayColor]set];
	[NSBezierPath strokeRect:r];


	//[NSBezierPath strokeRect:rr];
	
	//dLog("rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
	//Tastenwerte=[[[NSArray alloc]init]retain];
	int offsetx=40;
	int offsety=32;
	int durchmesser=22;
	NSRect Tastenfeld=NSMakeRect(0,0,durchmesser,durchmesser);//[self bounds];
															  //Tastenfeld.size.width=20;
															  //Tastenfeld.size.height=20;
															  //Tastenfeld.origin.x=10;
															  //Tastenfeld.origin.y=10;
		
	//dLog("TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
	int i, k;
	int d=26;
	int kar=14;
	int summe=0;
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
			//if ([TastenwertArray count]>(10*k)+i)
			{
				if ([[TastenwertArray objectAtIndex:(10*(i)+(k))]intValue])
				{
					//[[NSColor lightGrayColor]set];
					NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:tabalpha];
					[FeldFarbe set];
					[Kreis fill];
					switch (mode)
					{
						case 0: // Hundertertabelle
							zeilenwert+=(10*(9-i))+(k+1);
							summe +=(10*(9-i))+(k+1);
							//dLog("Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
							break;
						case 1: //Reihentabelle
							zeilenwert+=((10-i))*(k+1);
							summe += ((10-i))*(k+1);
							//dLog("Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
							break;
							
					}//switch mode
					[Kreis setLineWidth:1.6];
					[[NSColor blackColor]set];
					[Kreis stroke];

				}
				//else
				{
					[Kreis setLineWidth:1.0];
					[[NSColor grayColor]set];
					[Kreis stroke];
				}
			}
			/*
			 NSControl * Taste=[[NSControl alloc]initWithFrame:Tastenfeld];
			 //[Taste setControlType:NSRegularControlSize];
			 NSButtonCell* Zelle=[[NSButtonCell alloc]init];
			 [Zelle setTitle:@""];
			 [Taste setTag:k+ 10*(9-i)];
			 [Zelle setBordered:YES];
			 [Zelle setBordered:YES];
			 [Zelle setButtonType:NSOnOffButton];
			 [Zelle setBezelStyle: NSCircularBezelStyle];
			 [Taste setCell:Zelle];
			 [Taste setAction:@selector(Tastenaktion:)];
			 [Taste sizeToFit];
			 [Tastenarray addObject:Taste];
			 [self addSubview:Taste];
			 */
		}//for k
		 //dLog("zeile: %d zeilenwert: %d",i, zeilenwert);
		
		Wertfeld=Tastenfeld;
		Wertfeld.origin.x+=2*d;
		Wertfeld.origin.y+=3;
	//	Wertfeld.size.height-=2;
		Wertfeld.size.width=3*kar;
		[NSBezierPath strokeRect:Wertfeld];
		
		NSPoint oben=Wertfeld.origin;
		oben.y+=Wertfeld.size.height;
		oben.x+=kar;
		NSPoint unten=Wertfeld.origin;;
		unten.x+=kar;
		NSBezierPath* KarPath=[NSBezierPath bezierPath];
		[[NSColor lightGrayColor]set];
		[KarPath moveToPoint:oben];
		[KarPath lineToPoint:unten];
		//
		unten.x+=kar;
		oben.x+=kar;
		[KarPath moveToPoint:oben];
		[KarPath lineToPoint:unten];
		
		[KarPath stroke];

			
			
	}//for i
	 //Wertfeld=Tastenfeld;
	Wertfeld.origin.x=11*d+offsetx+5;
	Wertfeld.origin.y=5;
	//Wertfeld.size.height-=2;
	Wertfeld.size.width=3*kar;
	if (summe >999)
	{
	Wertfeld.origin.x -= kar;
	Wertfeld.size.width +=kar;
	}
	[[NSColor grayColor]set];
	[NSBezierPath strokeRect:Wertfeld];
	
	int delta=10;
	NSPoint links=Wertfeld.origin;
	links.y+=Wertfeld.size.height+4;
	links.x-=delta;
	NSPoint rechts=links;
	rechts.x += 3*kar+delta+delta;
		if (summe >999)
	{
		rechts.x += kar;
	}
	NSBezierPath* StrichPath=[NSBezierPath bezierPath];
	[StrichPath moveToPoint:links];
	[StrichPath lineToPoint:rechts];
	[[NSColor darkGrayColor]set];
	[StrichPath stroke];
	
	
	NSPoint oben=Wertfeld.origin;
	oben.y+=Wertfeld.size.height;
	oben.x+=kar;
	NSPoint unten=Wertfeld.origin;;
	unten.x+=kar;
	NSBezierPath* KarPath=[NSBezierPath bezierPath];
	[[NSColor lightGrayColor]set];
	[KarPath moveToPoint:oben];
	[KarPath lineToPoint:unten];
	
	//
	unten.x+=kar;
	oben.x+=kar;
	[KarPath moveToPoint:oben];
	[KarPath lineToPoint:unten];
	[KarPath stroke];
	if (summe >999)
	{
	unten.x+=kar;
	oben.x+=kar;
	[KarPath moveToPoint:oben];
	[KarPath lineToPoint:unten];
	[KarPath stroke];
		
	}
	
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


@implementation rDruckfeld_double
- (id) initWithFrame:(NSRect)frame
{
	self=[super initWithFrame:frame];
	NSNotificationCenter * nc;
	
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(TastenwerteAktion:)
			   name:@"DoubleTastenwerte"
			 object:nil];
	

	return self;
}
- (void)awakeFromNib
{
	
   NSDateFormatter *datumformat = [[NSDateFormatter alloc] init];
   [datumformat setLocale:[NSLocale currentLocale]];
   [datumformat setDateFormat:@"dd.MM.yyyy"];
   NSDate *heute = [NSDate date];
   NSString *heuteDatumString = [datumformat stringFromDate:heute];
   [Datumfeld setStringValue:heuteDatumString];
   [Datumfeld setToolTip:@"Aktuelles Datum"];
   [Datumfeld2 setStringValue:heuteDatumString];
   [Datumfeld2 setToolTip:@"Aktuelles Datum"];
   
   [ErgebnisDatumfeld setStringValue:heuteDatumString];
	//[ErgebnisDatumfeld2 setStringValue:[heute description]];
	
	NSRect r;
	r=[Titelrahmen frame];
	//dLog("Druckfeld awake Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
	//[self addSubview:Aufgaberahmen];
	//[Titelfeld setStringValue:@"Reihentabelle"];
	//[ErgebnisTitelfeld setStringValue:@"Reihentabelle"];
	//[Gruppefeld setBezeled:YES];
	//[self addSubview:Titelrahmen];
	//[self addSubview:Gruppefeld];
	Grupperahmen=[Gruppefeld frame];
	r=Grupperahmen;
	//dLog("Druckfeld awake drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
	
}


- (void)drawRect:(NSRect)rect
{
//dLog("Arbeitsblatt Druckfeld drawRect ");
//NSBezierPath p=[Aufgaberahmen path];
NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:tabalpha];
[FeldFarbe set];
[[NSColor blackColor]set];
[NSBezierPath strokeRect:[Gruppefeld frame]];
//[NSBezierPath fillRect:Grupperahmen];
//[NSBezierPath strokeRect:r];
NSRect r=[Gruppefeld bounds];
r.size.width -=2;
[NSBezierPath strokeRect:r];
//dLog("Druckfeld drawRect Grupperahmen: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);

}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //dLog("AB Druckfeld_double TastenwerteAktion note: %@",[[note userInfo]description]);
   if ([[[note userInfo]objectForKey:@"druckdatendic"] objectForKey:@"Anzahl"] && [[[[note userInfo]objectForKey:@"druckdatendic"] objectForKey:@"Anzahl"]intValue])
   {
      
      if ([[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Gruppe"])
      {
         [Gruppefeld setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Gruppe"]];
         [Gruppefeld2 setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Gruppe"]];
      }
      if ([[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Nummer"])
      {
         [Nummerfeld setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Nummer"]];
         [Nummerfeld2 setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Nummer"]];
      }
      if ([[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Titel"])
      {
         [Titelfeld setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Titel"]];
         [Titelfeld2 setStringValue:[[[note userInfo]objectForKey:@"druckdatendic"]objectForKey:@"Titel"]];
      }
   }//if Anzahl
   else
   {
      [Gruppefeld setStringValue:@""];
      [Gruppefeld2 setStringValue:@""];
      [Nummerfeld setStringValue:@""];
      [Nummerfeld2 setStringValue:@""];
      [Titelfeld setStringValue:@""];
      [Titelfeld2 setStringValue:@""];
      
      [Datumfeld setStringValue:@""];
      [Datumfeld2 setStringValue:@""];
   }
   //int erfolg=[[self window]makeFirstResponder:[self window]];
}



@end

@implementation rArbeitsblatt_double 

- (id)init
{
    self=[super initWithWindowNibName:@"Arbeitsblatt_double"];
	//dLog("rArbeitsblatt_double ");
	
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    return self;
}

- (void)awakeFromNib
{
//dLog("Arbeitsblatt awake");



}

- (IBAction)reportDrucken :(id)sender
{
   int AnzahlKopien = [moreCopyCheck state];
   //Knopfrahmen.hidden = YES;
   DruckKnopf.hidden = YES;
   [self BlattDruckenMitDic:NULL];
}



- (void)printSerie:(NSDictionary*)druckdaten
{
   DLog(@"Arbeitsblatt_double printSerie druckdaten: %@",druckdaten);
   printDic=[NSDictionary dictionaryWithObject:druckdaten forKey:@"druckdaten"];
   [self BlattDruckenMitDic:printDic];
}

- (IBAction)printDocument:(id)sender
{
//dLog("ArbeitsblattArbeitsblatt_double printDocument");
[self BlattDruckenMitDic:NULL];
//Knopfrahmen.hidden = NO;
DruckKnopf.hidden = NO;
}



- (void)BlattDruckenMitDic:(NSDictionary*)derPrintDic
{
	int AnzahlKopien=1;
	//DLog (@"Arbeitsblatt_double Serie: BlattDruckenMitDic PrintDic: %@",[derPrintDic description]);

	if ([[derPrintDic objectForKey:@"druckdaten"] objectForKey:@"Anzahl"])
      
	{
      AnzahlKopien = [[[derPrintDic objectForKey:@"druckdaten"] objectForKey:@"Anzahl"]intValue];
	}
	//NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
	//DLog (@"Arbeitsblatt double Serie: BlattDruckenMitDic: %@",[derPrintDic description]);
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
	[[PrintInfo dictionary]setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:NSPrintCopies];
	
	int Papierbreite=(int)Papiergroesse.width;
	int Papierhoehe=(int)Papiergroesse.height;
	int obererRand=[PrintInfo topMargin];
	int linkerRand=(int)[PrintInfo leftMargin];
	int rechterRand=[PrintInfo rightMargin];
	
	//dLog("linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
	//NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
	
	//DruckView=[[NSView alloc]initWithFrame:DruckFeld];
	//[DruckView addSubview:Druckfeld];
	//DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];





	//[DruckView setBackgroundColor:[NSColor grayColor]];
	//[DruckView setDrawsBackground:YES];
	NSPrintOperation* DruckOperation;
	DruckOperation=[NSPrintOperation printOperationWithView: Druckfeld_double
												  printInfo:PrintInfo];
   [DruckOperation setShowsPrintPanel:YES];
	//[DruckOperation setShowPanels:NO];
	
	[DruckOperation runOperation];
	
}





@end
