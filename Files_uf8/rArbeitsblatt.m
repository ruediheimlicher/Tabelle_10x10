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
   //dLog("setAnzahlKopien: %d",dieAnzahl);
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
   //DLog(@"rRahmen drawRect ");
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


@implementation rKnopfRahmen
- (id) initWithFrame:(NSRect)frame
{
   
   self =[super initWithFrame:frame];
   self.wantsLayer = YES;
   return self;
}

- (void)drawRect:(NSRect)rect
{
   [super drawRect:rect];
   NSLog(@"rKnopfRahmen drawRect ");
   //NSBezierPath p=[Aufgaberahmen path];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.6 green:1.0 blue:0.7 alpha:tabalpha];
   //FeldFarbe = [NSColor greenColor];
   [FeldFarbe set];
   [NSBezierPath fillRect:r];
   //[[NSColor grayColor]set];
   [NSBezierPath strokeRect:r];
   
   //dLog("rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}


- (void)awakeFromNib
{
   // ohne wirkung
   float r = 250.0 / 255.0f;
   float g = 255.0  / 255.0f;
   float b = 100.0 / 255.0f;
   
   if(self.layer)
   {
      NSLog(@"rKnopfRahmen  layer");
      //CGColorRef color = CGColorCreateGenericRGB(r, g, b, 1.0f);
      //self.layer.borderColor = color;
      //CGColorRelease(color);
   }
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
  // return self;
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
   //NSLog(@"rRahmen drawRect start");
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
               //[[NSColor lightGrayColor]set];
               NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:tabalpha];
               [FeldFarbe set];
               [Kreis fill];
               switch (mode)
               {
                  case 0: // Hundertertabelle
                     feldwert=(10*(9-i))+(k+1);
                     zeilenwert+=(10*(9-i))+(k+1);
                     summe +=(10*(9-i))+(k+1);
                     //dLog("Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     feldwert=(10*(9-i))+(k+1);
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
   //NSLog(@"rRahmen drawRect end");
}



@end


@implementation rErgebnisRahmen
- (id)initWithFrame:(NSRect)frame
{
   //NSLog(@"rErgebnisRahmen init");
   self=[super initWithFrame:frame];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   
  
   TastenwertArray=[[NSMutableArray alloc]initWithCapacity:100];
   
   int i;
   for (i=0;i<100;i++)
   {
      [TastenwertArray addObject:[NSNumber numberWithInt:0]];
   }
   //dLog("rAufgabeRahmen init Tastenwerte: %@",[TastenwertArray description]);
   
   
   Wertarray=[[NSMutableArray alloc]initWithCapacity:10];
   for (i=0;i<10;i++)
   {
      [Wertarray addObject:[NSNumber numberWithInt:0]];
   }
   
  // nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(TastenwerteAktion:)
              name:@"Tastenwerte"
            object:nil];

 
   return self;
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //NSLog(@"rErgebnisRahmen Tastenwerteaktion");
   if ([[note userInfo]objectForKey:@"Tastenwerte"])
   {
      //NSLog(@"TastenwerteAktion: note: %@",[[[note userInfo]objectForKey:@"Tastenwerte"]description]);
      NSArray* tempArray=[[note userInfo]objectForKey:@"Tastenwerte"];
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
   //NSLog(@"ErgebnisRahmen drawRect start");
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
               //[[NSColor lightGrayColor]set];
               NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:tabalpha];
               [FeldFarbe set];
               [Kreis fill];
               switch (mode)
               {
                  case 0: // Hundertertabelle
                     feldwert=(10*(9-i))+(k+1);
                     zeilenwert+=(10*(9-i))+(k+1);
                     summe +=(10*(9-i))+(k+1);
                     //DLog(@"Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     feldwert=((10-i))*(k+1);
                     zeilenwert+=((10-i))*(k+1);
                     summe += ((10-i))*(k+1);
                     //DLog(@"Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                     
               }//switch mode
               
               //
               NSPoint zahlpunkt=Kreisfeld.origin;;
               zahlpunkt.y+=d/6.0;
               zahlpunkt.x+=d/16.0;
               //NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 9];
               //NSDictionary* ZahlAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
               NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 12];
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
               

               // end neu

               [Kreis setLineWidth:1.6];
               [[NSColor blackColor]set];
               [Kreis stroke];
               
            }
            //else
            {
               [Kreis setLineWidth:1.0];
           //    [[NSColor grayColor]set];
               [[NSColor redColor]set];
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
      //DLog(@"zeile: %d zeilenwert: %d",i, zeilenwert);
      
      
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=2*d;
      Wertfeld.origin.y+=8;
      //   Wertfeld.size.height-=2;
      Wertfeld.size.width=3*kar;
      [NSBezierPath strokeRect:Wertfeld];
      
      NSPoint oben=Wertfeld.origin;
      oben.y+=Wertfeld.size.height;
      oben.x+=kar;
      NSPoint unten=Wertfeld.origin;;
      NSTextField* Zeilenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
      Zeilenwertfeld.editable = NO;
      [Zeilenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 14]];
      [[self superview]addSubview:Zeilenwertfeld];
      [Zeilenwertfeld setAlignment:NSTextAlignmentRight];
      
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

      
      
      
      
      
      unten.x+=kar;
      NSBezierPath* KarPath=[NSBezierPath bezierPath]; // senkrechte Linie in Zilenwertfeld
      [[NSColor lightGrayColor]set];
      [[NSColor blueColor]set];
      [KarPath moveToPoint:oben];
      [KarPath lineToPoint:unten];
      //
      unten.x+=kar;
      oben.x+=kar;
      [KarPath moveToPoint:oben];
      [KarPath lineToPoint:unten];
      
      //[KarPath stroke];
      
      /*
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=2*d;
      Wertfeld.origin.y+=3;
      //Wertfeld.size.height-=2;
      Wertfeld.size.width*=2;
      //[NSBezierPath strokeRect:Wertfeld];
      NSTextField* Zeilenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
      [Zeilenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 12]];

      [self addSubview:Zeilenwertfeld];
      [Zeilenwertfeld setAlignment:NSTextAlignmentRight];
      
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
      
*/
      summe+=zeilenwert;
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
   
   NSTextField* Summenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
   [Summenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 16]];
   Summenwertfeld.editable = NO;
   [[self superview] addSubview:Summenwertfeld];
   [Summenwertfeld setAlignment:NSTextAlignmentRight];
   if (summe)
   {
      [Summenwertfeld setIntValue:summe];
   }
   else
   {
      [Summenwertfeld setStringValue:@""];
   }

   
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
//  [KarPath stroke];
   if (summe >999)
   {
      unten.x+=kar;
      oben.x+=kar;
      [KarPath moveToPoint:oben];
      [KarPath lineToPoint:unten];
 //     [KarPath stroke];
      
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
  // NSLog(@"ErgebnisRahmen drawRect end");
}

- (void)drawRect_a:(NSRect)rect
{
   //NSLog(@"ErgebnisRahmen drawRect start");
   
   //NSBezierPath p=[Aufgaberahmen path];
   NSRect r=[self bounds];//NSMakeRect(20,40,20,20);
   [[NSColor grayColor]set];
   [NSBezierPath strokeRect:r];
   
   //dLog("rRahmen drawRect: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //Tastenwerte=[[[NSArray alloc]init]retain];
   int offsetx=40;
   int offsety=28;
   int durchmesser=22;
   NSRect Tastenfeld=NSMakeRect(0,0,durchmesser,durchmesser);//[self bounds];
   //Tastenfeld.size.width=20;
   //Tastenfeld.size.height=20;
   //Tastenfeld.origin.x=10;
   //Tastenfeld.origin.y=10;
   
   //dLog("TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
   int i, k;
   int summe=0;
   [Wertarray removeAllObjects];
   for (i=0;i<10;i++)
   {
      [Wertarray addObject:[NSNumber numberWithInt:0]];
   }
//   return;
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
                     
                     //dLog("Add zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  case 1: //Reihentabelle
                     feldwert=((10-i))*(k+1);
                     zeilenwert+=((10-i))*(k+1);
                     //dLog("Mult zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
                     break;
                  default:
                  {
                     break;
                  }
               }//switch mode
               
               NSPoint zahlpunkt=Kreisfeld.origin;;
               zahlpunkt.y+=d/6.0;
               zahlpunkt.x+=d/16.0;
               //NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 9];
               //NSDictionary* ZahlAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
               NSFont* ZahlFont=[NSFont fontWithName:@"Helvetica" size: 14];
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
               //dLog("zeile: %d kolonne: %d zeilenwert: %d",i,k,  zeilenwert);
               [Kreis setLineWidth:1.6];
               [[NSColor blackColor]set];
               [Kreis stroke];
               
            }
            else
            {
               [Kreis setLineWidth:1.0];
               [[NSColor lightGrayColor]set];
               
               [Kreis stroke];
               
            }
         }
          
      }//for k
      //dLog("zeile: %d zeilenwert: %d",i, zeilenwert);
      
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=2*d;
      Wertfeld.origin.y+=3;
      //Wertfeld.size.height-=2;
      Wertfeld.size.width*=2;
      //[NSBezierPath strokeRect:Wertfeld];
      NSTextField* Zeilenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
      [Zeilenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 14]];
      
      [[self superview] addSubview:Zeilenwertfeld];
      [Zeilenwertfeld setAlignment:NSTextAlignmentRight];
      
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
   return;
   //Wertfeld=Tastenfeld;
   Wertfeld.origin.x=11*d+offsetx;
   Wertfeld.origin.y=5;
   //Wertfeld.size.height-=2;
   Wertfeld.size.width+=4;
   [NSBezierPath strokeRect:Wertfeld];
   NSTextField* Summenwertfeld=[[NSTextField alloc]initWithFrame:Wertfeld];
   [Summenwertfeld setFont:[NSFont fontWithName:@"Helvetica" size: 14]];
   
   [[self superview] addSubview:Summenwertfeld];
   [Summenwertfeld setAlignment:NSTextAlignmentRight];
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
   //NSLog(@"ErgebnisRahmen drawRect end");

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
   //NSLog(@"Druckfeld  awake");

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
   //NSLog(@"Druckfeld drawRect start");

   //NSBezierPath p=[Aufgaberahmen path];
   NSColor* FeldFarbe=[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:tabalpha];
   [FeldFarbe set];
   [[NSColor blackColor]set];
//   [NSBezierPath strokeRect:[Gruppefeld frame]];
   //[NSBezierPath fillRect:Grupperahmen];
   //[NSBezierPath strokeRect:r];
   NSRect r=[Gruppefeld bounds];
   r.size.width -=2;
//   [NSBezierPath strokeRect:r];
   //dLog("Druckfeld drawRect Grupperahmen: Rect: origin.x %2.2f origin.y: %2.2f  size.height: %2.2f size.width: %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
   //NSLog(@"Druckfeld drawRect end");
}


- (void) TastenwerteAktion:(NSNotification*)note
{
   //DLog(@"AB Druckfeld TastenwerteAktion note: %@",[[note userInfo]description]);
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
   //NSLog(@"rArbeitsblatt init");
   
   NSNotificationCenter * nc;
  
   nc=[NSNotificationCenter defaultCenter];
   
   [nc addObserver:self
          selector:@selector(AnzahlKopienAktion:)
              name:@"anzahlkopien"
            object:nil];

   // Add your subclass-specific initialization here.
   // If an error occurs here, send a [self release] message and return nil.
   
   return self;
}

- (void)awakeFromNib
{
   //NSLog(@"Arbeitsblatt awake");
    
   int rot=0;
   int gruen=236;
   int blau=0;
   NSColor *rahmenfarbe = [NSColor colorWithCalibratedRed:rot/255.0
                                                         green:gruen/255.0
                                                          blue:blau/255.0
                                                         alpha:1.0];
   rahmenfarbe = [NSColor yellowColor];
   // Convert to CGColorRef
   NSInteger numberOfComponents = [rahmenfarbe numberOfComponents];
   CGFloat components[numberOfComponents];
   CGColorSpaceRef colorSpace = [[rahmenfarbe colorSpace] CGColorSpace];
   [rahmenfarbe getComponents:(CGFloat *)&components];
   CGColorRef rahmenGCfarbe = CGColorCreate(colorSpace, components);

   int hgrot=236;
   int hggruen=236;
   int hgblau=250;
   NSColor *hintergrundfarbe = [NSColor colorWithCalibratedRed:hgrot/255.0
                                                         green:hggruen/255.0
                                                          blue:hgblau/255.0
                                                         alpha:1.0];
   
   hintergrundfarbe = [NSColor greenColor];
   // Convert to CGColorRef
   NSInteger hgnumberOfComponents = [hintergrundfarbe numberOfComponents];
   CGFloat hgcomponents[hgnumberOfComponents];
   CGColorSpaceRef hgcolorSpace = [[hintergrundfarbe colorSpace] CGColorSpace];
   [hintergrundfarbe getComponents:(CGFloat *)&hgcomponents];
   CGColorRef hintergrundGCfarbe = CGColorCreate(hgcolorSpace, hgcomponents);
 //  [[[self window] contentView] addSubview:Druckfeld];
  // [[self window]makeKeyAndOrderFront:NULL];
   //[Knopfrahmen setWantsLayer:YES];
  // Knopfrahmen.layer.borderWidth=2.0;
  
   //[Knopfrahmen.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
  // Knopfrahmen.layer.borderColor = [rahmenfarbe CGColor];
 //  Druckfeld = [[rDruckfeld alloc]init];
}
- (void)clearDouble
{
   if (Arbeitsblattfenster_double)
   {
   [[Arbeitsblattfenster_double window] orderOut:nil];
   }
}

- (IBAction)reportDrucken :(id)sender
{
   AnzahlKopien = [moreCopyCheck state];
   Knopfrahmen.hidden = YES;
   DruckKnopf.hidden = YES;
   moreCopyCheck.hidden = YES;
   [self BlattDruckenMitDicArray:NULL];
   
   return;
   
   if (AnzahlKopien)
   {
      //dLog("printOperationDidRun druckdatenDic: %@",[Druckfeld druckdatenDic]);
      
      if (!Arbeitsblattfenster_double)
      {
         Arbeitsblattfenster_double=[[rArbeitsblatt_double alloc]init];
         
      }
      [Arbeitsblattfenster_double showWindow:self];
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
      [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      
      // Tastenwerte an Arbeitsblatt_double schicken
      [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];
      
      [Arbeitsblattfenster_double printSerie:[Druckfeld druckdatenDic]];
      
   }

}

- (IBAction)reportMoreCopies:(id)sender
{
   
}


- (void) AnzahlKopienAktion:(NSNotification*)note
{
   //dLog("AnzahlKopienAktion: note: %@",[note userInfo]);
   AnzahlKopien = [[[note userInfo]objectForKey:@"morecopies"]intValue];
//   return;
   
   
   
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
   AnzahlKopien /=2; // A4, 2 Blaetter
   
   //dLog("AnzahlKopienAktion AnzahlKopien: %d",AnzahlKopien);
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
   
 //  [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //   [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];
   
   
   //   [Arbeitsblattfenster_double printSerie:DruckdatenDic];
   
   
}


- (IBAction)printDocument:(id)sender
{
   // Arbeitsblatt mit lsg drucken. Anschliessend Dialog aufrufen, um anz Kopien abzufragen und diese zu drucken
   // dLog("printDocument AnzahlKopien: %d",AnzahlKopien);
   Knopfrahmen.hidden = YES;
   DruckKnopf.hidden = YES;
   moreCopyCheck.hidden = YES;

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
   return;
   
   // verschoben in printOperationDidRun
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
       
       dLog("antwort: %ld",antwort);
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
      //dLog("printDok AnzahlKopien: %d",AnzahlKopien);
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
      [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      
      // Tastenwerte an Arbeitsblatt_double schicken
      [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];
      
      [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
      [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
      
      
      //  [nc postNotificationName:@"printserie" object:self userInfo:NotificationDic];
      
      //dLog("Druckdaten aus Druckfeld: %@",[Druckfeld druckdatenDic]);
      [Arbeitsblattfenster_double printSerie:[Druckfeld druckdatenDic]];
      
      
   }
   
   
}

- (void)printOperationDidRun:(NSPrintOperation *)printOperation  success:(BOOL)success  contextInfo:(void *)contextInfo
{
   //DLog(@"printOperationDidRun success: %d",success);
   if (success)
   {
      //DLog(@"printOperationDidRun ");
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"printok"];
      
      // Notific an Einstellungen schicken
      [nc postNotificationName:@"endprint" object:self userInfo:NotificationDic];
      
      
      // doble drucken
      
      if (AnzahlKopien)
      {
         //dLog("printOperationDidRun druckdatenDic: %@",[Druckfeld druckdatenDic]);
         
         if (!Arbeitsblattfenster_double)
         {
            Arbeitsblattfenster_double=[[rArbeitsblatt_double alloc]init];
            
         }
         [Arbeitsblattfenster_double showWindow:self];
         
         NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [NotificationDic setObject:[NSNumber numberWithInt:AnzahlKopien] forKey:@"anzahlkopien"];
         [NotificationDic setObject:[Druckfeld druckdatenDic] forKey:@"druckdatendic"];
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         
         // Tastenwerte an Arbeitsblatt_double schicken
         [nc postNotificationName:@"DoubleTastenwerte" object:self userInfo:NotificationDic];
         
         [Arbeitsblattfenster_double printSerie:[Druckfeld druckdatenDic]];

      }
 
   }
   Knopfrahmen.hidden = NO;
   DruckKnopf.hidden = NO;
   moreCopyCheck.hidden = NO;

}


- (void)BlattDruckenMitDicArray:(NSArray*)derProjektDicArray
{
   
   NSTextView* DruckView=[[NSTextView alloc]init];
   //DLog (@"Kommentar: BlattDruckenMitDicArray ProjektDicArray: %@",[derProjektDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   //DLog (@"BlattDruckenMitDicArray PrintInfo: %@",PrintInfo);
   
   [PrintInfo setOrientation:NSPaperOrientationPortrait];
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
    
    DLog (@"BlattDruckenMitDicArray PrintInfo nach: %@",PrintInfo);
    */
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   int obererRand=[PrintInfo topMargin];
   int linkerRand=(int)[PrintInfo leftMargin];
   int rechterRand=[PrintInfo rightMargin];
   
   //dLog("linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
   //  NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
   
   //DruckView=[[NSView alloc]initWithFrame:DruckFeld];
   //[DruckView addSubview:Druckfeld];
   //DruckView=[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];
   
   
   
   
   
   //[DruckView setBackgroundColor:[NSColor grayColor]];
   //[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: Druckfeld
                                                 printInfo:PrintInfo];
   [DruckOperation setShowsPrintPanel:YES];
   //  [DruckOperation runOperation];
   [DruckOperation runOperationModalForWindow:[self window]
                                     delegate:self didRunSelector:@selector(printOperationDidRun: success: contextInfo:)
                                  contextInfo:nil];
   
   
}


- (BOOL)windowShouldClose:(id)sender
{
   NSLog(@"windowShouldClose" );
   [[Arbeitsblattfenster_double window ]orderOut:nil];
   return YES;
}


@end
