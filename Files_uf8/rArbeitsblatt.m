//
//  MyDocument.m
//  Reihen
//
//  Created by Sysadmin on 25.03.08.
//


#import "rArbeitsblatt.h"

@implementation rEinstellungenFenster
- (id)init
{
   self = [super initWithWindowNibName:@"Einstellungen"];
   
   return self;
}

- (int)AnzahlKopien
{
   
   return [AnzahlBox intValue];
}

- (IBAction)reportDrucken:(id)sender
{
   NSMutableDictionary* DruckDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [DruckDic setObject:[NSNumber numberWithInt:[AnzahlBox intValue]] forKey:@"Anzahl"];

   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"anzahlkopien" object:self userInfo:DruckDic];

   [NSApp stopModalWithCode:0];
   
   [[self window] orderOut:NULL];
   
}

- (IBAction)reportCancel:(id)sender
{
   [NSApp stopModalWithCode:0];
   [[self window] orderOut:NULL];
   
}

- (void)setAnzahlKopien:(int)dieAnzahl
{
   NSLog(@"setAnzahlKopien: %d",dieAnzahl);
   [AnzahlBox setIntValue:dieAnzahl];
   
}

@end

@implementation rRahmen
- (id) initWithFrame:(NSRect)frame
{
   
   self =[super initWithFrame:frame];
   return self;
}

- (void)drawRect:(NSRect)rect
{
   //NSLog(@"rRahmen drawRect ");
   //NSBezierPath p=[Aufgaberahmen path];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:tabalpha];
   [FeldFarbe set];
   [NSBezierPath fillRect:r];
   [[NSColor grayColor]set];
   [NSBezierPath strokeRect:r];
   
   //NSLog(@"rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   
}



@end


@implementation rAufgabeRahmen
- (id)initWithFrame:(NSRect)frame
{
   //NSLog(@"rAufgabeRahmen init");
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
   //NSLog(@"rAufgabeRahmen init Tastenwerte: %@",[TastenwertArray description]);
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
   if ([[note userInfo]objectForKey:@"Tastenwerte"])
   {
      //NSLog(@"TastenwerteAktion: note: %@",[[[note userInfo]objectForKey:@"Tastenwerte"]description]);
      NSArray* tempArray=[[note userInfo]objectForKey:@"Tastenwerte"];
      //NSLog(@"TastenwerteAktion: tempArray: %@",[tempArray description]);
      
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
   //NSLog(@"rRahmen drawRect ");
   //NSBezierPath p=[Aufgaberahmen path];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   [[NSColor grayColor]set];
   [NSBezierPath strokeRect:r];
   
   
   //[NSBezierPath strokeRect:rr];
   
   //NSLog(@"rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //Tastenwerte=[[[NSArray alloc]init]retain];
   int offsetx=40;
   int offsety=32;
   int durchmesser=22;
   NSRect Tastenfeld=NSMakeRect(0,0,durchmesser,durchmesser);//[self bounds];
   //Tastenfeld.size.width=20;
   //Tastenfeld.size.height=20;
   //Tastenfeld.origin.x=10;
   //Tastenfeld.origin.y=10;
   
   //NSLog(@"TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
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
                     //NSLog(@"Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     zeilenwert+=((10-i))*(k+1);
                     summe += ((10-i))*(k+1);
                     //NSLog(@"Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
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
      //NSLog(@"zeile: %d zeilenwert: %d",i, zeilenwert);
      
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


@implementation rErgebnisRahmen
- (id)initWithFrame:(NSRect)frame
{
   //NSLog(@"rAufgabeRahmen init");
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
   //NSLog(@"rAufgabeRahmen init Tastenwerte: %@",[TastenwertArray description]);
   return self;
   
   Wertarray=[[NSMutableArray alloc]initWithCapacity:10];
   for (i=0;i<10;i++)
   {
      [Wertarray addObject:[NSNumber numberWithInt:0]];
   }
   
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   if ([[note userInfo]objectForKey:@"Tastenwerte"])
   {
      //NSLog(@"TastenwerteAktion: note: %@",[[[note userInfo]objectForKey:@"Tastenwerte"]description]);
      NSArray* tempArray=[[note userInfo]objectForKey:@"Tastenwerte"];
      //NSLog(@"TastenwerteAktion: tempArray: %@",[tempArray description]);
      
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
   //NSLog(@"rRahmen drawRect ");
   //NSBezierPath p=[Aufgaberahmen path];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   [[NSColor grayColor]set];
   [NSBezierPath strokeRect:r];
   
   //NSLog(@"rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //Tastenwerte=[[[NSArray alloc]init]retain];
   int offsetx=40;
   int offsety=28;
   int durchmesser=22;
   NSRect Tastenfeld=NSMakeRect(0,0,durchmesser,durchmesser);//[self bounds];
   //Tastenfeld.size.width=20;
   //Tastenfeld.size.height=20;
   //Tastenfeld.origin.x=10;
   //Tastenfeld.origin.y=10;
   
   //NSLog(@"TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
   int i, k;
   int summe=0;
   [Wertarray removeAllObjects];
   for (i=0;i<10;i++)
   {
      [Wertarray addObject:[NSNumber numberWithInt:0]];
   }
   
   int d=26;
   
   NSRect Wertfeld;
   for(i=0;i<10;i++)//Zeile
   {
      int zeilenwert=0;
      int feldwert=0;
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
               NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:tabalpha];
               [FeldFarbe set];
               [Kreis fill];
               switch (mode)
               {
                  case 0: // Hundertertabelle
                     feldwert=(10*(9-i))+(k+1);
                     zeilenwert+=(10*(9-i))+(k+1);
                     
                     //NSLog(@"Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     feldwert=((10-i))*(k+1);
                     zeilenwert+=((10-i))*(k+1);
                     //NSLog(@"Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                     
               }//switch mode
               NSPoint zahlpunkt=Kreisfeld.origin;;
               zahlpunkt.y+=d/5.0;
               zahlpunkt.x+=d/8.0;
               //NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 9];
               //NSDictionary* ZahlAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
               NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 10];
               NSDictionary* ZahlAttrs=[NSDictionary dictionaryWithObject:ZahlFont forKey:NSFontAttributeName];
               int offset=0;
               NSString* ZahlString=[[NSNumber numberWithInt:feldwert]stringValue];
               if (feldwert<100)
               {
                  offset+=3;
                  if (feldwert<10)
                  {
                     offset+=3;
                  }
               }
               zahlpunkt.x+=offset;
               [ZahlString drawAtPoint:zahlpunkt withAttributes:ZahlAttrs];
               
               [[NSColor lightGrayColor]set];
               //[KarPath moveToPoint:zahlpunkt];
               
               //zeilenwert+=((10-i))*(k+1);
               //[wertString setIntValue:zeilenwert];
               //NSLog(@"zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
            }
            //else
            {
               [[NSColor grayColor]set];
               [Kreis stroke];
            }
         }
      }//for k
      //NSLog(@"zeile: %d zeilenwert: %d",i, zeilenwert);
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=2*d;
      Wertfeld.origin.y+=3;
      //Wertfeld.size.height-=2;
      Wertfeld.size.width*=2;
      //[NSBezierPath strokeRect:Wertfeld];
      NSTextField* Zeilenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
      [Zeilenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 12]];
      
      [self addSubview:Zeilenwertfeld];
      [Zeilenwertfeld setAlignment:NSRightTextAlignment];
      
      if (zeilenwert)
      {
         [Zeilenwertfeld setIntValue:zeilenwert];
         //NSString* wertString=[[NSNumber numberWithInt:zeilenwert]stringValue];
         //[wertString drawInRect:Wertfeld withAttributes:NULL];
      }
      else
      {
         
         [Zeilenwertfeld setStringValue:@""];
      }
      summe+=zeilenwert;
   }//for i
   //Wertfeld=Tastenfeld;
   Wertfeld.origin.x=11*d+offsetx;
   Wertfeld.origin.y=5;
   //Wertfeld.size.height-=2;
   Wertfeld.size.width+=4;
   [NSBezierPath strokeRect:Wertfeld];
   NSTextField* Summenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
   [Summenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 14]];
   
   [self addSubview:Summenwertfeld];
   [Summenwertfeld setAlignment:NSRightTextAlignment];
   if (summe)
   {
      [Summenwertfeld setIntValue:summe];
   }
   else
   {
      [Summenwertfeld setStringValue:@""];
   }
   int delta=10;
   int kar=14;
   NSPoint links=Wertfeld.origin;
   links.y+=Wertfeld.size.height+2;
   links.x-=delta;
   NSPoint rechts=links;
   rechts.x += 3*kar+3*delta;
   if (summe >999)
   {
      rechts.x += kar;
   }
   NSBezierPath* StrichPath=[NSBezierPath bezierPath];
   [StrichPath moveToPoint:links];
   [StrichPath lineToPoint:rechts];
   [[NSColor darkGrayColor]set];
   [StrichPath stroke];
   
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


@implementation rDruckfeld
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
   
   NSDateFormatter *datumformat = [[NSDateFormatter alloc] init];
   [datumformat setLocale:[NSLocale currentLocale]];
   [datumformat setDateFormat:@"dd.MM.yyyy"];
   NSDate *heute = [NSDate date];
   NSString *heuteDatumString = [datumformat stringFromDate:heute];
   [Datumfeld setStringValue:heuteDatumString];
   [Datumfeld setToolTip:@"Aktuelles Datum"];
   
   [ErgebnisDatumfeld setStringValue:heuteDatumString];
   
   NSRect r;
   r=[Titelrahmen frame];
   //NSLog(@"Druckfeld awake Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //[self addSubview:Aufgaberahmen];
   //[Titelfeld setStringValue:@"Reihentabelle"];
   //[ErgebnisTitelfeld setStringValue:@"Reihentabelle"];
   //[Gruppefeld setBezeled:YES];
   //[self addSubview:Titelrahmen];
   //[self addSubview:Gruppefeld];
   Grupperahmen=[Gruppefeld frame];
   r=Grupperahmen;
   //NSLog(@"Druckfeld awake drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   
}


- (void)drawRect:(NSRect)rect
{
   //NSLog(@"Arbeitsblatt Druckfeld drawRect ");
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
   //NSLog(@"Druckfeld drawRect Grupperahmen: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //NSLog(@"AB Druckfeld TastenwerteAktion note: %@",[[note userInfo]description]);
   DruckdatenDic = [NSDictionary dictionaryWithDictionary:[note userInfo]];
   if ([[note userInfo]objectForKey:@"Anzahl"] && [[[note userInfo]objectForKey:@"Anzahl"]intValue])
   {
      NSDateFormatter *datumformat = [[NSDateFormatter alloc] init];
      [datumformat setLocale:[NSLocale currentLocale]];
      [datumformat setDateFormat:@"dd.MM.yyyy"];
      NSDate *heute = [NSDate date];
      NSString *heuteDatumString = [datumformat stringFromDate:heute];
      [Datumfeld setStringValue:heuteDatumString];
      [ErgebnisDatumfeld setStringValue:heuteDatumString];
      
      if ([[note userInfo]objectForKey:@"Gruppe"])
      {
         [Gruppefeld setStringValue:[[note userInfo]objectForKey:@"Gruppe"]];
         [ErgebnisGruppefeld setStringValue:[[note userInfo]objectForKey:@"Gruppe"]];
      }
      if ([[note userInfo]objectForKey:@"Nummer"])
      {
         [Nummerfeld setStringValue:[[note userInfo]objectForKey:@"Nummer"]];
         [ErgebnisNummerfeld setStringValue:[[note userInfo]objectForKey:@"Nummer"]];
      }
      if ([[note userInfo]objectForKey:@"Titel"])
      {
         [Titelfeld setStringValue:[[note userInfo]objectForKey:@"Titel"]];
         [ErgebnisTitelfeld setStringValue:[[note userInfo]objectForKey:@"Titel"]];
      }
   }//if Anzahl
   else
   {
      [Gruppefeld setStringValue:@""];
      [ErgebnisGruppefeld setStringValue:@""];
      [Nummerfeld setStringValue:@""];
      [ErgebnisNummerfeld setStringValue:@""];
      [Titelfeld setStringValue:@""];
      [ErgebnisTitelfeld setStringValue:@""];
      [Datumfeld setStringValue:@""];
      [ErgebnisDatumfeld setStringValue:@""];
      //[Ergebnisfeld setStringValue:@""];
   }
   int erfolg=[[self window]makeFirstResponder:[self window]];
}

- (NSDictionary*)druckdatenDic
{
   return DruckdatenDic;
}

@end

@implementation rArbeitsblatt

- (id)init
{
   self=[super initWithWindowNibName:@"Arbeitsblatt"];
   //NSLog(@"rArbeitsblatt ");
   
   
   // Add your subclass-specific initialization here.
   // If an error occurs here, send a [self release] message and return nil.
   
   return self;
}

- (void)awakeFromNib
{
   //NSLog(@"Arbeitsblatt awake");
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   
   [nc addObserver:self
          selector:@selector(AnzahlKopienAktion:)
              name:@"anzahlkopien"
            object:nil];

   
   
}

- (void) AnzahlKopienAktion:(NSNotification*)note
{
   //NSLog(@"AnzahlKopienAktion: note: %@",[note userInfo]);
   AnzahlKopien = [[[note userInfo]objectForKey:@"morecopies"]intValue];
   return;
   if (!Arbeitsblattfenster_double)
	  {
       // Arbeitsblattfenster_double=[[rArbeitsblatt_double alloc]init];
        
     }
//   [Arbeitsblattfenster_double showWindow:self];
   
  // AnzahlKopien= [EinstellungenFenster AnzahlKopien];
   if (AnzahlKopien%2) // ungerade
   {
      AnzahlKopien++;
   }
   AnzahlKopien /=2;
   
   NSLog(@"AnzahlKopienAktion AnzahlKopien: %d",AnzahlKopien);
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
   [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
//   [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];
   
   
//   [Arbeitsblattfenster_double printSerie:DruckdatenDic];

   
}


- (IBAction)printDocument:(id)sender
{
   // Arbeitsblatt mit lsg drucken. Anschliessend Dialog aufrufen, um anz Kopien abzufragen und diese zu drucken
   NSLog(@"printDocument");
   [self BlattDruckenMitDicArray:NULL];
   //EinstellungenSheet =[[rEinstellungenFenster alloc]init];
   
   //
   /*
    [NSApp beginSheet: EinstellungenSheet
    modalForWindow: [self window]
    modalDelegate: self
    didEndSelector: @selector(EinstellungenFensterDidEnd:returnCode:contextInfo:)
    contextInfo: NULL];
    
    
    */
   //
   if (AnzahlKopien)
   {

   if (!Arbeitsblattfenster_double)
	  {
        Arbeitsblattfenster_double=[[rArbeitsblatt_double alloc]init];
        
     }
   [Arbeitsblattfenster_double showWindow:self];
/*
   EinstellungenFenster =[[rEinstellungenFenster alloc]init];
   NSModalSession EinstellungenSession=[NSApp beginModalSessionForWindow:[EinstellungenFenster window]];
   [EinstellungenFenster setAnzahlKopien:AnzahlKopien];
   
     long antwort= [NSApp   runModalForWindow: [EinstellungenFenster window]];
   
   NSLog(@"antwort: %ld",antwort);
   if (antwort==0)
   {
     
   }
   
   [NSApp endModalSession:EinstellungenSession];

   AnzahlKopien= [EinstellungenFenster AnzahlKopien];
 */
   if (AnzahlKopien%2) // ungerade
   {
      AnzahlKopien++;
   }
   AnzahlKopien /=2;
   NSLog(@"printDok AnzahlKopien: %d",AnzahlKopien);
   
    NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
   [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   
   // Tastenwerte an Arbeitsblatt_double schicken
   [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];

   [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
   [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
   

 //  [nc postNotificationName:@"printserie" object:self userInfo:NotificationDic];
   
   //NSLog(@"Druckdaten aus Druckfeld: %@",[Druckfeld druckdatenDic]);
   [Arbeitsblattfenster_double printSerie:[Druckfeld druckdatenDic]];
   }
   
   
}



- (void)BlattDruckenMitDicArray:(NSArray*)derProjektDicArray
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //NSLog (@"Kommentar: BlattDruckenMitDicArray ProjektDicArray: %@",[derProjektDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   //NSLog (@"BlattDruckenMitDicArray PrintInfo: %@",PrintInfo);
   
   [PrintInfo setOrientation:NSPortraitOrientation];
   [PrintInfo setHorizontalPagination: NSAutoPagination];
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect bounds=[PrintInfo imageablePageBounds];
   
   int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
   //NSLog(@"Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
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
   
   //NSLog(@"platzH: %d  platzV %d",platzH,platzV);
   
   int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
   
   [PrintInfo setLeftMargin:freiLinks];
   [PrintInfo setRightMargin:leftRand];
   [PrintInfo setTopMargin:freiOben];
   [PrintInfo setBottomMargin:botRand];
  /*
   // Get the PMPrintSettings object from the printInfo.
   PMPrintSettings settings = [PrintInfo PMPrintSettings];
   
   // Modify/Set the settings of interest.
   // This code sets the number of copies requested to 10.
   (void)PMSetCopies(settings, 2, false);
   
   // Turn on collation so that the copies are collated.
   (void)PMSetCollate(settings, true);
   
   // Tell Cocoa that the print settings have been changed. This allows
   // Cocoa to perform necessary housekeeping.
   [PrintInfo updateFromPMPrintSettings];
   
   NSLog (@"BlattDruckenMitDicArray PrintInfo nach: %@",PrintInfo);
*/
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   int obererRand=[PrintInfo topMargin];
   int linkerRand=(int)[PrintInfo leftMargin];
   int rechterRand=[PrintInfo rightMargin];
   
   //NSLog(@"linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
 //  NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
   
   //DruckView=[[NSView alloc]initWithFrame:DruckFeld];
   //[DruckView addSubview:Druckfeld];
   //DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];
   
   
   
   
   
   //[DruckView setBackgroundColor:[NSColor grayColor]];
   //[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: Druckfeld
                                                 printInfo:PrintInfo];
   [DruckOperation setShowPanels:YES];
   [DruckOperation runOperation];
   
}





@end
