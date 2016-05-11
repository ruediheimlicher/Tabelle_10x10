#import "rEinstellungen.h"

void rLog(char*string )// release, immer zeigen
{
   {
      printf("%s\n",string);
   }
   
}
void dLog(char*string ) // debug, nur bei SHOWLOG zeigen
{
   if (SHOWLOG)
   {
      printf("%s\n",string);
   }
   
}

@implementation rKnopf

- (id)initWithFrame:(NSRect)frame
{
   if ((self = [super initWithFrame:frame]))
      
   {
      return self;
      
   }
   return 0;
}
- (BOOL)acceptsFirstResponder {
   return YES;
}

- (void)awakeFromNib
{
   status = 0;
   self.tag=0;
   [self setImage:[NSImage imageNamed:@"KnopfOFF"]];
   
   wert=13;
   
}

- (void)setStatus:(int)derStatus
{
   status = derStatus;
   NSImage *ON = [NSImage imageNamed:@"KnopfOFF"];
   NSImage *OFF = [NSImage imageNamed:@"KnopfON"];
   if (status)
   {
      [self setImage:ON];
   }
   else
   {
      [self setImage:OFF];
   }
   
}

- (BOOL)status
{
   return status;
}

- (void)clearStatus
{
   [self setImage:[NSImage imageNamed:@"KnopfOFF"]];
   status=0;
}
-(void)setWert:(int)derWert
{
   wert = derWert;
}
- (int)wert
{
   return wert;
}

- (void)drawRect:(NSRect)dirtyRect
{
   [super drawRect:dirtyRect];
}

-(void)setTag:(NSInteger)derTag
{
   //DLog(@"setTag tag: %ld derTag: %ld",self.tag,derTag);
   tag = derTag;
   //DLog(@"setTag tag: %ld",tag);
}

- (NSInteger)tag
{
   return tag;
}

- (void)mouseDown:(NSEvent *)theEvent
{
   [super mouseDown:theEvent];
   //DLog(@"Knopf mouseDown: %d",wert);
   
   
   NSImage *ON = [NSImage imageNamed:@"KnopfOFF"];
   NSImage *OFF = [NSImage imageNamed:@"KnopfON"];
   if (status)
   {
      [self setImage:ON];
   }
   else
   {
      [self setImage:OFF];
   }
   status = !status;
   //return;
   
   //KeyNummer=[NSNumber numberWithInt:nr];
   //DLog(@"keyDown: %@",[theEvent characters]);
   //DLog(@"keyDown AdminListe  nr: %d  char: %@",nr,[theEvent characters]);
   NSMutableDictionary* tempTastenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [tempTastenDic setObject:[NSNumber numberWithInt:wert]forKey:@"wert"];
   [tempTastenDic setObject:[NSNumber numberWithInt:status]forKey:@"status"];
   [tempTastenDic setObject:[NSNumber numberWithInt:self.tag]forKey:@"tag"];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"matrixtaste" object:tempTastenDic];
   
}

@end

@implementation Einstellungen


- (void)awakeFromNib
{
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(MatrixTasteAktion:)
              name:@"matrixtaste"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(EndPrintAktion:)
              name:@"endprint"
            object:nil];
   
   //rLog("hallo");
   NSRect r = Knopf.frame;
   float hoehe = r.size.height;
   float breite = r.size.width;
   int a=0x20;
   int b=-1^a;
   int c=b+1;
   
   //DLog(@"a: %d b: %d c: %d",a,b,c);
   
   
   [[self window]setAcceptsMouseMovedEvents:YES];
   
   PList=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSString* PListPfad=[[[NSString stringWithString:NSHomeDirectory()]
                         stringByAppendingPathComponent:@"Documents"]
                        stringByAppendingPathComponent:@"TabData"];
   
   [Nummerfeld setDelegate:self];
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:PListPfad isDirectory:&istOrdner]&& istOrdner)
   {
      DLog(@"PList-Ordner da");
      if ([Filemanager fileExistsAtPath:[PListPfad stringByAppendingPathComponent:@"TabPList"]])
      {
         [PList setDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:[PListPfad stringByAppendingPathComponent:@"TabPList"]]];
         //DLog(@"PList da: %@",[PList description]);
      }
      
   }
   else
   {
      ALog(@"PList-Ordner nicht da");
   }
   if ([PList objectForKey:@"lastmode"])
   {
      //DLog(@"mode: %d",[[PList objectForKey:@"lastmode"]intValue]);
      [ModeSeg selectSegmentWithTag:[[PList objectForKey:@"lastmode"]intValue]];
      
   }
   if ([PList objectForKey:@"gruppendic"])
   {
      // DLog(@"Gruppendic da: %@",[PList objectForKey:@"gruppendic"]);
      //DLog(@"DLog Gruppendic da: %@",[PList objectForKey:@"gruppendic"]);
      
   }
   else
   {
      NSMutableDictionary* tempGruppenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"A"];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"B"];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"C"];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"D"];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"E"];
      [tempGruppenDic setObject:[NSNumber numberWithInt:1]forKey:@"F"];
      [PList setObject:tempGruppenDic forKey:@"gruppendic"];
   }
   DLog(@"read PList: %@",[PList description]);
   if ([PList objectForKey:@"lastgruppe"])
   {
      if ([[PList objectForKey:@"gruppendic"]objectForKey:[PList objectForKey:@"lastgruppe"]])
      {
         [Nummerfeld setIntValue:[[[PList objectForKey:@"gruppendic"]objectForKey:[PList objectForKey:@"lastgruppe"]]intValue]];
         [Gruppefeld selectItemWithObjectValue:[PList objectForKey:@"lastgruppe"]];
      }
   }
   else
   {
      
   }
   
   
   NSImage* TabImage = [NSImage imageNamed: @"Tab"];
   [NSApp setApplicationIconImage:TabImage];
   [Iconfeld setImage:TabImage];
   
   Tastenarray=[[NSMutableArray alloc]initWithCapacity:0];
   Wertarray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   NSColor *rahmenfarbe = [NSColor lightGrayColor];
   
   // Convert to CGColorRef
   NSInteger numberOfComponents = [rahmenfarbe numberOfComponents];
   CGFloat components[numberOfComponents];
   CGColorSpaceRef colorSpace = [[rahmenfarbe colorSpace] CGColorSpace];
   [rahmenfarbe getComponents:(CGFloat *)&components];
   CGColorRef rahmenCGfarbe = CGColorCreate(colorSpace, components);
   int rot=236;
   int gruen=236;
   int blau=225;
   NSColor *hintergrundfarbe = [NSColor colorWithCalibratedRed:rot/255.0
                                                         green:gruen/255.0
                                                          blue:blau/255.0
                                                         alpha:1.0];
   
   // Convert to CGColorRef
   NSInteger hgnumberOfComponents = [hintergrundfarbe numberOfComponents];
   CGFloat hgcomponents[hgnumberOfComponents];
   CGColorSpaceRef hgcolorSpace = [[hintergrundfarbe colorSpace] CGColorSpace];
   [hintergrundfarbe getComponents:(CGFloat *)&hgcomponents];
   CGColorRef hintergrundGCfarbe = CGColorCreate(hgcolorSpace, hgcomponents);
   
   [Tastenmatrixfeld setWantsLayer:YES];
   Tastenmatrixfeld.layer.borderWidth=2.0;
   Tastenmatrixfeld.layer.borderColor = rahmenCGfarbe;
   Tastenmatrixfeld.layer.backgroundColor = hintergrundGCfarbe;
   Tastenmatrixfeld.toolTip = NSLocalizedString(@"Tastenmatrixfeld",@"Anklicken der gewünschten Positionen, für die eine Rechnung generiert werden soll");
   NSRect TastenmatrixRect= [Tastenmatrixfeld bounds];
   //[[NSColor redColor]set];
   //[NSBezierPath strokeRect:MatrixRect];
   NSRect Tastenfeld=TastenmatrixRect;
   Tastenfeld.size.width=26;
   Tastenfeld.size.height=26;
   // Tastenfeld.origin.y -= 5;
   //DLog(@"TastenmatrixRect: x: %d w: %2.2f",TastenmatrixRect.origin.x, TastenmatrixRect.size.width);
   int i, k;
   int d=30;
   NSRect Wertfeld;
   for(i=0;i<10;i++)//Zeile
   {
      for (k=0;k<10;k++)//Kolonne
      {
         Tastenfeld.origin.x=k*d+10;
         if (k>=5)
            Tastenfeld.origin.x+=5;
         Tastenfeld.origin.y=i*d+10;
         if (i>=5)
            Tastenfeld.origin.y+=5;
         
         /*
          NSButton * Taste=[[NSButton alloc]initWithFrame:Tastenfeld];
          NSButtonCell* Zelle=[[NSButtonCell alloc]init];
          [Zelle setTitle:@""];
          [Taste setTag:k+ 10*(9-i)];
          [Zelle setBordered:YES];
          
          [Zelle setButtonType:NSOnOffButton];
          [Zelle setBezelStyle: NSCircularBezelStyle];
          [Taste setCell:Zelle];
          [Taste setAction:@selector(Tastenaktion:)];
          [Taste sizeToFit];
          [Taste display];
          */
         
         
         
         //  [Tastenarray addObject:Taste];
         //  [Tastenmatrixfeld addSubview:Taste];
         NSImage *OFF = [NSImage imageNamed:@"KnopfOFF"];
         
         rKnopf* tempknopf = [[rKnopf alloc]initWithFrame:Tastenfeld];
         NSUInteger t=k+ 10*(9-i);
         [tempknopf setTag:k+ 10*(9-i)];
         [tempknopf setImage:OFF];
         [Tastenarray addObject:tempknopf];
         [Tastenmatrixfeld addSubview:tempknopf];
         
         
      }//for k
      Wertfeld=Tastenfeld;
      Wertfeld.origin.x+=1.8*d;
      //    Wertfeld.origin.y+=5;
      Wertfeld.size.height-=4;
      Wertfeld.size.width*=1.3;
      
      NSTextField* Wert=[[NSTextField alloc]initWithFrame:Wertfeld];
      //[Wert setBordered:YES];
      Wert.allowsEditingTextAttributes=YES;
      
      [Wert setEditable:NO];
      [Wert setSelectable:NO];
      [Wert setTag:i];
      [Wert setStringValue:@""];
      [Wert setFont:[NSFont fontWithName:@"Helvetica" size: 14]];
      [Wert setAlignment:NSRightTextAlignment];
      Wert.toolTip = NSLocalizedString(@"Wertfeld",nil);
      [Wertarray addObject:Wert];
      [Tastenmatrixfeld addSubview:Wert];
      
   }//for i
   NSPoint w=[Ergebnisfeld frame].origin;
   w.x =Wertfeld.origin.x+[Tastenmatrixfeld frame].origin.x-6;
   //w.x+=3*d;
   [Ergebnisfeld setFrameOrigin:w];
   Ergebnisfeld.toolTip = NSLocalizedString(@"Ergebnisfeld", nil);
   //[Tastenmatrixfeld addSubview:Tastenmatrix];
   
   [Ergebnisfeld setAlignment:NSRightTextAlignment];
   
   //[ModeSeg selectSegmentWithTag:0];
   int erfolg=[self makeFirstResponder:NULL];
   NSURLRequest* Anfrage=[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.duernten.ch"]];
   //DLog(@"Header: %@",[[Anfrage allHTTPHeaderFields]description]);
   
   //self.window.backgroundColor = NSColor.whiteColor;
   Anzahlfeld.toolTip = NSLocalizedString(@"Anzahlfeld", nil);
   goArbeitsblattTaste.toolTip = NSLocalizedString(@"goArbeitsblattTaste", nil);
   goVorlageTaste.toolTip = NSLocalizedString(@"goVorlageTaste", nil);
   Nummerfeld.toolTip = NSLocalizedString(@"Nummerfeld", nil);
   Gruppefeld.toolTip = NSLocalizedString(@"Gruppefeld", nil);
   ClearTaste.toolTip = NSLocalizedString(@"ClearTaste", nil);
   ModeSeg.toolTip = NSLocalizedString(@"ModSeg", nil);
}

- (IBAction)showArbeitsblatt:(id)sender
{
   //DLog(@"showVorlage: ");
   
   if (!Arbeitsblattfenster)
	  {
        Arbeitsblattfenster=[[rArbeitsblatt alloc]init];
        
     }
   [Arbeitsblattfenster showWindow:self];
   
}


- (IBAction)showVorlage:(id)sender
{
   DLog(@"showVorlage: ");
   
   if (!Vorlagefenster)
	  {
        Vorlagefenster=[[rVorlage alloc]init];
        
     }
   [Vorlagefenster showWindow:self];
   
}


- (IBAction)showEinstellungen:(id)sender
{
   DLog(@"showEinstellungen: ");
   if (!SettingDrawer)
	  {
        SettingDrawer=[[NSDrawer alloc]init];
        
     }
   [SettingDrawer open];
   
}


- (IBAction)setMode:(id)sender
{
   
   
}


- (IBAction)setWert:(id)sender
{
   
   
}

- (void)EndPrintAktion:(NSNotification*)note
{
   //DLog(@"EndPrintAktion %@:",note);
   long gruppeindex = [Gruppefeld indexOfSelectedItem];
   NSString* titel =[Gruppefeld objectValueOfSelectedItem];
   //DLog(@"SndCalccontroller: EndPrintAktion titel :%@ gruppeindex: %ld",titel,gruppeindex);
   NSMutableDictionary* tempGruppenDic=(NSMutableDictionary*)[PList objectForKey:@"gruppendic"];
   int aktuelleNummer =[Nummerfeld intValue];
   
   [tempGruppenDic setObject:[NSNumber numberWithInt:aktuelleNummer+1]forKey:titel];
   [Nummerfeld setIntValue:aktuelleNummer+1];
   //DLog(@"EndPrintAktion tempGruppenDic: %@",tempGruppenDic);
   //DLog(@"EndPrintAktion PList: %@",PList);
   
}

- (void) MatrixTasteAktion:(NSNotification*)note
{
   //DLog(@"MatrixTastenAktion %@:",note.object);
   int tastentag =[[note.object objectForKey:@"tag"]intValue];
   int zeile=[[note.object objectForKey:@"tag"]intValue]/10;
   int kolonne=[[note.object objectForKey:@"tag"]intValue]%10 ;
   int status = [[note.object objectForKey:@"status"]intValue];
   // DLog(@"MatrixTasteAktion: %d, zeile: %d kolonne: %d status: %d",tastentag, zeile, kolonne,status);
   int zeilenwert=[[Wertarray objectAtIndex:9-zeile]intValue];
   int add;
   switch ([ModeSeg selectedSegment])
   {
      case 0://Hundertertabelle
         //DLog(@"Hundertertabelle");
         add=10*(zeile)+(kolonne+1);
         //DLog(@"Hundertertabelle add: %d",add);
         break;
         
      case 1://Reihentabelle
         add=(zeile+1)*(kolonne+1);
         
         //DLog(@"Reihentabelle add: %d",add);
         break;
         
   }//switch
   
   if (status==0)
   {
      add *=(-1);
   }
   zeilenwert+=add;
   
   
   if (zeilenwert)
   {
      [[Wertarray objectAtIndex:9-zeile]setIntValue:zeilenwert];
   }
   else
   {
      [[Wertarray objectAtIndex:9-zeile]setStringValue:@""];
   }
   
   int ergebnis=[Ergebnisfeld intValue];
   if ((ergebnis+add) > 0)
   {
      [Ergebnisfeld setIntValue:ergebnis+add];
   }
   else
   {
      [Ergebnisfeld setStringValue:@""];
   }
   
   int i;
   int summe=0;
   for (i=0;i<[Tastenarray count];i++)
   {
      int tempstatus =[(rKnopf*)[Tastenarray objectAtIndex:i]status];
      summe += tempstatus;
      
      
   }
   [Anzahlfeld setIntValue:summe];
   if (summe)
   {
      //[goArbeitsblattTaste setKeyEquivalent:@"\r"];
      [self  setDefaultButtonCell:[goArbeitsblattTaste cell]];
   }
   else
   {
      //[goArbeitsblattTaste setKeyEquivalent:@""];
      int erfolg=[self makeFirstResponder:NULL];
      [self  setDefaultButtonCell:NULL];
   }
   
}

- (void)Tastenaktion:(id)sender
{
   //DLog(@"Taste: %d",[sender tag]);
   int zeile=[sender tag]/10;
   int kolonne=[sender tag]%10 ;
   //DLog(@"Taste: %d, zeile: %d kolonne: %d state: %d",[sender tag], zeile, kolonne,[[sender cell]state]);
   int zeilenwert=[[Wertarray objectAtIndex:9-zeile]intValue];
   int add;
   switch ([ModeSeg selectedSegment])
   {
      case 0://Hundertertabelle
         //DLog(@"Hundertertabelle");
         add=10*(zeile)+(kolonne+1);
         break;
         
      case 1://Reihentabelle
         //DLog(@"Reihentabelle");
         add=(zeile+1)*(kolonne+1);
         break;
         
   }//switch
   
   if ([[sender cell]state]==0)
   {
      add *=(-1);
   }
   zeilenwert+=add;
   
   
   if (zeilenwert)
   {
      [[Wertarray objectAtIndex:9-zeile]setIntValue:zeilenwert];
   }
   else
   {
      [[Wertarray objectAtIndex:9-zeile]setStringValue:@""];
   }
   
   int ergebnis=[Ergebnisfeld intValue];
   if (ergebnis+add)
   {
      [Ergebnisfeld setIntValue:ergebnis+add];
   }
   else
   {
      [Ergebnisfeld setStringValue:@""];
   }
   
   int i;
   int summe=0;
   for (i=0;i<[Tastenarray count];i++)
   {
      summe+=[[[Tastenarray objectAtIndex:i]cell] state];
   }
   [Anzahlfeld setIntValue:summe];
   if (summe)
   {
      //[goArbeitsblattTaste setKeyEquivalent:@"\r"];
      [self  setDefaultButtonCell:[goArbeitsblattTaste cell]];
   }
   else
   {
      //[goArbeitsblattTaste setKeyEquivalent:@""];
      int erfolg=[self makeFirstResponder:NULL];
      [self  setDefaultButtonCell:NULL];
   }
   //[Aufgaberahmen setTastenwerte:WertArray];
}

- (void)reCalc
{
   int i,k, wert,add, anz;
   int summe=0;
   anz=0;
   for (i=0;i<[Wertarray count];i++)
   {
      [[Wertarray objectAtIndex:i] setStringValue:@""];
      
   }
   for (i=0;i<[Tastenarray count];i++)//zeile
   {
      if ([(rKnopf*)[Tastenarray objectAtIndex:i]status])
      {
         anz++;
         int zeile=[(rKnopf*)[Tastenarray objectAtIndex:i] tag]/10;
         int kolonne=[(rKnopf*)[Tastenarray objectAtIndex:i] tag]%10 ;
         wert=[[Wertarray objectAtIndex:9-zeile]intValue];
         switch ([ModeSeg selectedSegment])
         {
            case 0: //Hundertertabelle
               
               add=10*(zeile)+(kolonne+1);
               wert +=add;
               
               summe += add;
               break;
               
            case 1:
               add=(zeile+1)*(kolonne+1);
               wert +=add;
               summe +=add;
               
               
               break;
         }
         [[Wertarray objectAtIndex:9-zeile]setIntValue:wert];
      }//if state
   }//for i
   [Ergebnisfeld setIntValue:summe];
   [Anzahlfeld setIntValue:anz];
   
}

- (IBAction)switchSeg:(id)sender
{
   if ([Anzahlfeld intValue])
   {
      [self reCalc];
   }
   //[self clearTasten:NULL];
}

- (IBAction)reportGruppe:(id)sender
{
   NSString* titel =[Gruppefeld objectValueOfSelectedItem];
   DLog(@"reportGruppe: %@ index: %ld titel: %@",[sender stringValue],(long)[sender indexOfSelectedItem],titel );
   int nummer=1;
   NSMutableDictionary* tempGruppenDic=(NSMutableDictionary*)[PList objectForKey:@"gruppendic"];
   if (tempGruppenDic)
   {
      [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:titel]intValue]];
      /*
       switch ([sender indexOfSelectedItem])
       {
       case 0:// A
       if ([tempGruppenDic objectForKey:@"A"])
       {
       
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"A"]intValue]];
       }
       // [tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"A"];
       
       break;
       
       case 1:// B
       if ([tempGruppenDic objectForKey:@"B"])
       {
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"B"]intValue]];
       }
       //[tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"B"];
       
       break;
       
       case 2:// C
       if ([tempGruppenDic objectForKey:@"C"])
       {
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"C"]intValue]];
       }
       // [tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"C"];
       
       break;
       
       case 3:// D
       if ([tempGruppenDic objectForKey:@"D"])
       {
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"D"]intValue]];
       }
       // [tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"D"];
       
       break;
       
       case 4:// E
       if ([tempGruppenDic objectForKey:@"E"])
       {
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"E"]intValue]];
       }
       // [tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"E"];
       
       break;
       
       case 5:// F
       if ([tempGruppenDic objectForKey:@"F"])
       {
       [Nummerfeld setIntValue:[[tempGruppenDic objectForKey:@"F"]intValue]];
       }
       //[tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:@"F"];
       
       break;
       
       
       }//switch index
       */
      DLog(@"reportGruppe tempGruppenDic: %@",tempGruppenDic);
   }//if tempGruppenDic
   //  DLog(@"PList: %@",PList);
}

- (IBAction)reportMoreCopies:(id)sender
{
   //DLog(@"reportMoreCopies: %ld",[sender state]);
   NSMutableDictionary* moreCopiesDic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithLong:[morecopies state]] forKey:@"morecopies"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   
   [nc postNotificationName:@"anzahlkopien" object:self userInfo:moreCopiesDic];
   
}


- (IBAction)goArbeitsblatt:(id)sender
{
   
   if (!Arbeitsblattfenster)
	  {
        Arbeitsblattfenster=[[rArbeitsblatt alloc]init];
        
     }
   [Arbeitsblattfenster showWindow:self];
   
   [Arbeitsblattfenster clearDouble];
   
   NSMutableDictionary* MatrixDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSMutableArray* stateArray=[[NSMutableArray alloc]initWithCapacity:0];
   int i;
   for (i=0;i<100;i++)
   {
      [stateArray addObject:[NSNumber numberWithInt:[(rKnopf*)[Tastenarray objectAtIndex:i]status]]];
      
   }//for i
   [MatrixDic setObject:stateArray forKey:@"Tastenwerte"];
   [MatrixDic setObject:[Gruppefeld stringValue] forKey:@"Gruppe"];
   [MatrixDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]] forKey:@"Nummer"];
   [MatrixDic setObject:[NSNumber numberWithInt:[ModeSeg selectedSegment]] forKey:@"Mode"];
   [MatrixDic setObject:[ModeSeg labelForSegment:[ModeSeg selectedSegment]] forKey:@"Titel"];
   [MatrixDic setObject:[NSNumber numberWithInt:[Anzahlfeld intValue]] forKey:@"Anzahl"];
   [MatrixDic setObject:[NSNumber numberWithLong:[morecopies state]] forKey:@"morecopies"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Tastenwerte" object:self userInfo:MatrixDic];
   
   NSMutableDictionary* moreCopiesDic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithLong:[morecopies state]] forKey:@"morecopies"];
   [nc postNotificationName:@"anzahlkopien" object:self userInfo:moreCopiesDic];
   
   [[PList objectForKey:@"gruppendic"]setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:[Gruppefeld stringValue]];
}


- (IBAction)goVorlage:(id)sender
{
   
   if (!Vorlagefenster)
	  {
        Vorlagefenster=[[rVorlage alloc]init];
        
     }
   [Vorlagefenster showWindow:self];
   
   
   NSMutableDictionary* MatrixDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSMutableArray* stateArray=[[NSMutableArray alloc]initWithCapacity:0];
   int i;
   for (i=0;i<100;i++)
   {
      [stateArray addObject:[NSNumber numberWithInt:[(rKnopf*)[Tastenarray objectAtIndex:i]status]]];
      
   }//for i
   [MatrixDic setObject:stateArray forKey:@"Tastenwerte"];
   [MatrixDic setObject:[Gruppefeld stringValue] forKey:@"Gruppe"];
   [MatrixDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]] forKey:@"Nummer"];
   [MatrixDic setObject:[NSNumber numberWithInt:[ModeSeg selectedSegment]] forKey:@"Mode"];
   [MatrixDic setObject:[ModeSeg labelForSegment:[ModeSeg selectedSegment]] forKey:@"Titel"];
   [MatrixDic setObject:[NSNumber numberWithInt:[Anzahlfeld intValue]] forKey:@"Anzahl"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Tastenwerte" object:self userInfo:MatrixDic];
   [[PList objectForKey:@"gruppendic"]setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:[Gruppefeld stringValue]];
   
}

- (IBAction)clearTasten:(id)sender
{
   int i,k;
   for(i=0;i<10;i++)//Zeile
   {
      for (k=0;k<10;k++)//Kolonne
      {
         // rKnopf* tempKnopf =(rKnopf*)[Tastenarray objectAtIndex:i+10*k];
         // DLog(@"tempKnopf: %@",tempKnopf);
         [(rKnopf*)[Tastenarray objectAtIndex:i+10*k]clearStatus];
         
      }
      [[Wertarray objectAtIndex:i]setStringValue:@""];
   }
   [Ergebnisfeld setStringValue:@""];
   self.defaultButtonCell=nil;
   [goVorlageTaste becomeFirstResponder];
   //[Anzahlfeld setStringValue:@""];
}
- (IBAction)newTabelle:(id)sender
{
   [self clearTasten:NULL];
}

-(IBAction)terminate:(id)sender
{
   BOOL OK=[self beenden];
   //DLog(@"terminate");
   if (OK)
   {
      [NSApp terminate:self];
      
   }
   
}



- (BOOL)beenden
{
   //DLog(@"beenden last Gruppe: %@ last Nummer: %d",[Gruppefeld stringValue],[Nummerfeld intValue]);
   [[PList objectForKey:@"gruppendic"]setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:[Gruppefeld stringValue]];
   
   BOOL BeendenOK=YES;
   NSString* PListPfad=[[[NSString stringWithString:NSHomeDirectory()]
                         stringByAppendingPathComponent:@"Documents"]
                        stringByAppendingPathComponent:@"TabData"];
   
   
   BOOL istOrdner=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:PListPfad isDirectory:&istOrdner]&& istOrdner)
   {
      //DLog(@"PList-Ordner da");
      
   }
   else
   {
      //DLog(@"PList-Ordner nicht da");
      NSError* err;
      BOOL OK=[Filemanager createDirectoryAtPath:PListPfad withIntermediateDirectories:YES attributes:nil error:&err];
      // BOOL OK=[Filemanager createDirectoryAtPath:PListPfad  attributes:NULL];
   }
   if (!PList) //noch keine PList
   {
      //DLog(@"beenden save PList: neue PList anlegen");
      PList=[[NSMutableDictionary alloc]initWithCapacity:0];
   }
			NSArray* gruppearray = [Gruppefeld objectValues];
   DLog(@"beenden gruppearray: %@",[gruppearray description]);
   [[PList objectForKey:@"A"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"A"];
   [[PList objectForKey:@"B"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"B"];
   [[PList objectForKey:@"C"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"C"];
   [[PList objectForKey:@"D"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"D"];
   [[PList objectForKey:@"E"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"E"];
   [[PList objectForKey:@"F"]setObject:[Gruppefeld itemObjectValueAtIndex:0]  forKey:@"F"];
   
   
   [PList setObject: [NSDate date] forKey:@"lastdate"];
   [PList setObject: [NSNumber numberWithInt:[ModeSeg selectedSegment]] forKey:@"lastmode"];
   [PList setObject: [NSNumber numberWithInt:[Nummerfeld intValue]] forKey:@"lastnummer"];
   [PList setObject: [Gruppefeld stringValue] forKey:@"lastgruppe"];
   DLog(@"beenden save PList: %@",[PList description]);
   PListPfad=[PListPfad stringByAppendingPathComponent:@"TabPList"];
   BOOL PListOK=[PList writeToFile:PListPfad atomically:YES];
   
   
   
   return BeendenOK;
}


- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
   DLog(@"controlTextDidBeginEditing: %@",[[aNotification object]stringValue]);
   
   
}


- (void)controlTextDidChange:(NSNotification *)aNotification

{
   
   DLog(@"SndCalccontroller: controlTextDidChange object: %@ %@",[aNotification object],[[aNotification object]stringValue]);
   long gruppeindex = [Gruppefeld indexOfSelectedItem];
   NSString* titel =[Gruppefeld objectValueOfSelectedItem];
   DLog(@"SndCalccontroller: controlTextDidChange titel :%@ gruppeindex: %ld",titel,gruppeindex);
   NSMutableDictionary* tempGruppenDic=(NSMutableDictionary*)[PList objectForKey:@"gruppendic"];
   
   [tempGruppenDic setObject:[NSNumber numberWithInt:[Nummerfeld intValue]]forKey:titel];
   //DLog(@"controlTextDidChange tempGruppenDic: %@",tempGruppenDic);
   //DLog(@"controlTextDidChange PList: %@",PList);
   
}


- (BOOL)windowShouldClose:(id)sender
{
   BOOL OK=[self beenden];
   //DLog(@"windowShouldClose");
   if (OK)
   {
      
      [NSApp terminate:self];
      
   }
   return OK;
}

@end
