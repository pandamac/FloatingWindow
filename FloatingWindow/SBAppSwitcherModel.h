@class NSMutableArray, NSTimer ,NSObject;
@interface SBAppSwitcherModel
+ (id)sharedInstance;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
- (id)snapshot;
- (void)remove:(id)arg1;
- (void)removeDisplayItem:(id)arg1;
- (void)addToFront:(id)arg1;
- (void)_verifyAppList;
- (id)_recentsFromPrefs;
- (id)_recentsFromLegacyPrefs;
- (void)_saveRecents;
- (void)_saveRecentsDelayed;
- (void)_invalidateSaveTimer;
- (void)dealloc;
- (id)init;
@end
