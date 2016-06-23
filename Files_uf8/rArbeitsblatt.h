//
//  Arbeitsblatt.h
//  Reihen
//
//  Created by Sysadmin on 25.03.08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "rArbeitsblatt_double.h"
#import "defines.h"

#ifndef tabalpha
#define tabalpha 0.9
#endif

@interface rEinstellungenFenster:NSWindowController
{
   IBOutlet NSView*  hg;
   IBOutlet NSImageView*   Iconfeld;
   IBOutlet id	AnzahlBox;
   IBOutlet id	DruckenKnopf;
}
- (void)setAnzahlKopien:(int)dieAnzahl;
- (int)AnzahlKopien;
- (IBAction)reportDrucken:(id)sender;
@end

@interface rEinstellungenSheet:NSObject
{
   
   IBOutlet id	AnzahlBox;
   IBOutlet id	DruckenKnopf;
}
- (void)setAnzahlKopien:(int)dieAnzahl;
- (int)AnzahlKopien;
- (IBAction)reportDrucken;
@end


@interface rRahmen: NSView
{
   
}

@end

@interface rKnopfRahmen:rRahmen
{
   
}

@end


@interface rAufgabeRahmen: rRahmen
{
   NSMutableArray* TastenwertArray;
   //NSMutableArray* Wertarray;
   int mode;
}
//- (void)setMatrix:(NSArray*)Tastenwerte;
@end


@interface rErgebnisRahmen: rRahmen
{
   NSMutableArray* TastenwertArray;
   NSMutableArray* Wertarray;
   int mode;
}
//- (void)setMatrix:(NSArray*)Tastenwerte;
@end



@interface rDruckfeld: NSView
{
   IBOutlet	NSTextField*			Gruppefeld;
   IBOutlet	NSTextField*			Datumfeld;
   IBOutlet	NSTextField*			Namefeld;
   IBOutlet	NSTextField*			Nummerfeld;
   IBOutlet	NSTextField*			Titelfeld;
   IBOutlet	rRahmen*             Titelrahmen;
 
   IBOutlet	rAufgabeRahmen*		Aufgaberahmen;
   IBOutlet	NSTextField*         Ergebnisfeld;
   IBOutlet	NSTextField*			ErgebnisGruppefeld;
   IBOutlet	NSTextField*			ErgebnisDatumfeld;
   IBOutlet	NSTextField*			ErgebnisNamefeld;
   IBOutlet	NSTextField*			ErgebnisNummerfeld;
   IBOutlet	NSTextField*			ErgebnisTitelfeld;
   IBOutlet	rRahmen*             ErgebnisTitelrahmen;
   //IBOutlet	rErgebnisRahmen*		Ergebnisrahmen;
   NSRect Grupperahmen, Datumrahmen, Namerahmen, Nummerrahmen;
   NSDictionary*                 DruckdatenDic;
}
- (NSDictionary*)druckdatenDic;
@end



@interface rArbeitsblatt : NSWindowController 
{
   IBOutlet NSButton*         DruckKnopf;
   IBOutlet NSButton*         moreCopyCheck;
   IBOutlet	rDruckfeld*				Druckfeld;
   rEinstellungenFenster*			EinstellungenFenster;
   rEinstellungenSheet*				EinstellungenSheet;
   rArbeitsblatt_double*			Arbeitsblattfenster_double;
     IBOutlet	rKnopfRahmen*             Knopfrahmen;
   int									AnzahlKopien;
   
   NSString*            heuteDatumString;
}
- (IBAction)printDocument:(id)sender;
- (void)BlattDruckenMitDicArray:(NSArray*)derProjektDicArray;
- (IBAction)reportDrucken :(id)sender;
- (IBAction)reportMoreCopies:(id)sender;
- (void)clearDouble;
@end
