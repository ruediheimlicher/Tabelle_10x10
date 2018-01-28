/* Einstellungen */

#import <Cocoa/Cocoa.h>

#import "rVorlage.h"
#import "rArbeitsblatt.h"
#import "rArbeitsblatt_double.h"
#import "defines.h"
#include <stdio.h>

@interface rKnopf:NSImageView
{
   BOOL status;
  NSInteger tag;
   int wert;
}
@property (readwrite)NSInteger tag;

- (BOOL)acceptsFirstResponder;
- (id)initWithFrame:(NSRect)frame;
- (void)setStatus:(int)status;
- (void)clearStatus;
@end

@interface Einstellungen : NSPanel <NSTextFieldDelegate>
{
   IBOutlet id Tasten;
   
   int	Mode;
   NSMatrix*		Tastenmatrix;
   
   NSView*			Tastenmatrixfeld;
   NSView*			Wertmatrixfeld;
   NSMatrix*                  Wertmatrix;
   NSMutableArray*            Tastenarray;
   NSMutableArray*            Wertarray;
   NSString*                  heuteDatumString;
   IBOutlet   NSTextField*         Datumfeld;
   IBOutlet NSTextField*      Anzahlfeld;
   IBOutlet NSImageCell*      Iconfeld;
   IBOutlet NSButton*         goArbeitsblattTaste;
   IBOutlet NSButton*         goVorlageTaste;
   IBOutlet NSButton*         ClearTaste;
   IBOutlet NSTextField*      Ergebnisfeld;
   IBOutlet NSTextField*      Nummerfeld;
   IBOutlet NSComboBox*       Gruppefeld;
   IBOutlet NSSegmentedControl* ModeSeg;
   IBOutlet NSButton*         morecopies;
   
   IBOutlet NSImageView*         Knopf;

   IBOutlet NSDrawer*         SettingDrawer;
   
   rVorlage*                  Vorlagefenster;
   rArbeitsblatt*             Arbeitsblattfenster;
   NSMutableDictionary*       PList;
   
}
@property NSWindow* window;

- (IBAction)setMode:(id)sender;
- (IBAction)setWert:(id)sender;
- (IBAction)showVorlage:(id)sender;
- (IBAction)clearTasten:(id)sender;
- (IBAction)reportMoreCopies:(id)sender;
- (IBAction)showEinstellungen:(id)sender;
- (void)reCalc;
- (IBAction)newTabelle:(id)sender;
- (BOOL)beenden;
-(IBAction)terminate:(id)sender;

@end
