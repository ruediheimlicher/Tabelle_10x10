//
//  Arbeitsblatt_double.h
//  Reihen
//
//  Created by Sysadmin on 25.03.08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "defines.h"

#define tabalpha 0.9

@interface rRahmen_double: NSView
{

}

@end

@interface rAufgabeRahmen_double: rRahmen_double
{
	NSMutableArray* TastenwertArray;
	//NSMutableArray* Wertarray;
	int mode;
}
- (void)setMatrix:(NSArray*)Tastenwerte;
@end




@interface rDruckfeld_double: NSView
{
IBOutlet	NSTextField*			Gruppefeld;
IBOutlet	NSTextField*			Gruppefeld2;
IBOutlet	NSTextField*			Datumfeld2;
IBOutlet	NSTextField*			Datumfeld;
IBOutlet	NSTextField*			ErgebnisDatumfeld;

IBOutlet	NSTextField*			Namefeld;
IBOutlet	NSTextField*			Namefeld2;
IBOutlet	NSTextField*			Nummerfeld;
IBOutlet	NSTextField*			Nummerfeld2;
IBOutlet	NSTextField*			Titelfeld;
IBOutlet	rRahmen_double*				Titelrahmen;
IBOutlet	rAufgabeRahmen_double*			Aufgaberahmen;
IBOutlet	rAufgabeRahmen_double*			Aufgaberahmen2;
IBOutlet	NSTextField*			Titelfeld2;
NSRect Grupperahmen, Datumrahmen, Namerahmen, Nummerrahmen;
}

@end 



@interface rArbeitsblatt_double : NSWindowController
{
IBOutlet	rDruckfeld_double*				Druckfeld_double;

NSMutableArray* TastenwertArray;
int mode;
}
- (void)setMatrix:(NSArray*)Tastenwerte;

- (void)printSerie:(NSDictionary*)druckdaten;
- (IBAction)printDocument:(id)sender;
- (void)BlattDruckenMitDic:(NSDictionary*)derPrintDic;
@end
