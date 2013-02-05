//
//  MF_AppDelegate.m
//  MathLib
//
//  Public Domain
//  By Freshcode, Cutting edge Mac, iPhone & iPad software development. http://madefresh.ca/
//  Created by Dave Poirier on 2013-02-01.
//

#import "MF_AppDelegate.h"
#import <Accelerate/Accelerate.h>
#include "mfmathlib.h"

#define TESTCOUNT 300

@implementation MF_AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    vU256 v_a, v_b, v_r, v_o;
    vU512 v_r512;
    mfU256 mf_a, mf_b, mf_r, mf_o;
    NSString *bc_a, *bc_b, *bc_r, *bc_o;
    NSString *f_bc, *f_v, *f_mf;

    // Validating Additions
    unsigned int tests = TESTCOUNT;
    unsigned int success = 0;
    unsigned int failure = 0;
    while( tests-- ) {
        [self randomizeU256:&v_a];
        [self randomizeU256:&v_b];
        vU256Add(&v_a, &v_b, &v_r);
        f_v = [self stringFromVU256:&v_r];
        
        bc_a = [self stringFromVU256:&v_a];
        bc_b = [self stringFromVU256:&v_b];
        bc_r = [self bcWithOp:[NSString stringWithFormat:@"%@ + %@", bc_a, bc_b]];
        if( [bc_r length] > 64 ) { bc_r = [bc_r substringWithRange:NSMakeRange(1, 64)]; }
        while( [bc_r length] < 64 ) { bc_r = [@"0" stringByAppendingString:bc_r]; }
        f_bc = bc_r;

        [self setMfU256:&mf_a toVU256:&v_a];
        [self setMfU256:&mf_b toVU256:&v_b];
        mfAddU256(&mf_a, &mf_b, &mf_r);
        f_mf = [self stringFromU256:&mf_r];

        if( [f_mf isEqualToString:f_bc] && [f_mf isEqualToString:f_v] ) {
            success++;
        } else {
            failure++;
            NSLog(@"-----> Addition Failed:\nA :%@\nB :%@\nV :%@\nBC:%@\nMF:%@",
                  bc_a,
                  bc_b,
                  f_v,
                  f_bc,
                  f_mf);
        }
    }
    NSLog(@"Addition tests completed total: %u success: %u failure: %u", TESTCOUNT, success, failure);
    
    // Validating Substractions
    tests = TESTCOUNT;
    success = 0;
    failure = 0;
    while( tests-- ) {
        [self randomizeU256:&v_a];
        [self randomizeU256:&v_b];
        vU256Sub(&v_a, &v_b, &v_r);
        f_v = [self stringFromVU256:&v_r];
        
        bc_a = [self stringFromVU256:&v_a];
        bc_b = [self stringFromVU256:&v_b];
        bc_r = [self bcWithOp:[NSString stringWithFormat:@"%@ - %@", bc_a, bc_b]];
        if( [bc_r hasPrefix:@"-"] ) {
            bc_r = [self bcWithOp:[NSString stringWithFormat:@"1%@ - %@", bc_a, bc_b]];
        }
        if( [bc_r length] > 64 ) { bc_r = [bc_r substringWithRange:NSMakeRange(1, 64)]; }
        while( [bc_r length] < 64 ) { bc_r = [@"0" stringByAppendingString:bc_r]; }
        f_bc = bc_r;
        
        [self setMfU256:&mf_a toVU256:&v_a];
        [self setMfU256:&mf_b toVU256:&v_b];
        mfSubstractU256(&mf_a, &mf_b, &mf_r);
        f_mf = [self stringFromU256:&mf_r];
        
        if( [f_mf isEqualToString:f_bc] && [f_mf isEqualToString:f_v] ) {
            success++;
        } else {
            failure++;
            NSLog(@"-----> Substraction Failed:\nA :%@\nB :%@\nV :%@\nBC:%@\nMF:%@",
                  bc_a,
                  bc_b,
                  f_v,
                  f_bc,
                  f_mf);
        }
    }
    NSLog(@"Substraction tests completed total: %u success: %u failure: %u", TESTCOUNT, success, failure);

    // Validating Multiplications
    tests = TESTCOUNT;
    success = 0;
    failure = 0;
    while( tests-- ) {
        [self randomizeU256:&v_a];
        [self randomizeU256:&v_b];
        vU256FullMultiply(&v_a, &v_b, &v_r512);
        v_o.s.MSW = v_r512.s.MSW;
        v_o.s.d2  = v_r512.s.d2;
        v_o.s.d3  = v_r512.s.d3;
        v_o.s.d4  = v_r512.s.d4;
        v_o.s.d5  = v_r512.s.d5;
        v_o.s.d6  = v_r512.s.d6;
        v_o.s.d7  = v_r512.s.d7;
        v_o.s.LSW = v_r512.s.d8;
        v_r.s.MSW = v_r512.s.d9;
        v_r.s.d2  = v_r512.s.d10;
        v_r.s.d3  = v_r512.s.d11;
        v_r.s.d4  = v_r512.s.d12;
        v_r.s.d5  = v_r512.s.d13;
        v_r.s.d6  = v_r512.s.d14;
        v_r.s.d7  = v_r512.s.d15;
        v_r.s.LSW  = v_r512.s.LSW;
        f_v = [[self stringFromVU256:&v_o] stringByAppendingString:[self stringFromVU256:&v_r]];

        bc_a = [self stringFromVU256:&v_a];
        bc_b = [self stringFromVU256:&v_b];
        bc_r = [self bcWithOp:[NSString stringWithFormat:@"%@ * %@", bc_a, bc_b]];
        while( [bc_r length] < 128 ) { bc_r = [@"0" stringByAppendingString:bc_r]; }
        f_bc = bc_r;
        
        [self setMfU256:&mf_a toVU256:&v_a];
        [self setMfU256:&mf_b toVU256:&v_b];
        mfMultiplyU256(&mf_a, &mf_b, &mf_r, &mf_o);
        f_mf = [[self stringFromU256:&mf_o] stringByAppendingString:[self stringFromU256:&mf_r]];
        
        if( [f_mf isEqualToString:f_bc] && [f_mf isEqualToString:f_v] ) {
            success++;
        } else {
            failure++;
            NSLog(@"-----> Multiply Failed:\nA :%@\nB :%@\nV :%@\nBC:%@\nMF:%@",
                  bc_a,
                  bc_b,
                  f_v,
                  f_bc,
                  f_mf);
        }
    }
    NSLog(@"Multiply tests completed total: %u success: %u failure: %u", TESTCOUNT, success, failure);

    // Validating Divisions
    tests = TESTCOUNT;
    success = 0;
    failure = 0;
    while( tests-- ) {
        [self randomizeU256:&v_a];
        [self randomizeU256:&v_b];
        vU256Divide(&v_a, &v_b, &v_r, &v_o);
        f_v = [[self stringFromVU256:&v_o] stringByAppendingString:[self stringFromVU256:&v_r]];
        
        bc_a = [self stringFromVU256:&v_a];
        bc_b = [self stringFromVU256:&v_b];
        bc_r = [self bcWithOp:[NSString stringWithFormat:@"%@ / %@", bc_a, bc_b]];
        bc_o = [self bcWithOp:[NSString stringWithFormat:@"%@ %% %@", bc_a, bc_b]];
        while( [bc_r length] < 64 ) { bc_r = [@"0" stringByAppendingString:bc_r]; }
        while( [bc_o length] < 64 ) { bc_o = [@"0" stringByAppendingString:bc_o]; }
        f_bc = [bc_o stringByAppendingString:bc_r];
        
        [self setMfU256:&mf_a toVU256:&v_a];
        [self setMfU256:&mf_b toVU256:&v_b];
        mfDivideU256(&mf_a, &mf_b, &mf_r, &mf_o);
        f_mf = [[self stringFromU256:&mf_o] stringByAppendingString:[self stringFromU256:&mf_r]];
        
        if( [f_mf isEqualToString:f_bc] && [f_mf isEqualToString:f_v] ) {
            success++;
        } else {
            failure++;
            NSLog(@"-----> (%u/%u) Divide Failed:\nA :%@\nB :%@\nV :%@\nBC:%@\nMF:%@",
                  TESTCOUNT-tests,
                  TESTCOUNT,
                  bc_a,
                  bc_b,
                  f_v,
                  f_bc,
                  f_mf);
        }
    }
    NSLog(@"Division tests completed total: %u success: %u failure: %u", TESTCOUNT, success, failure);

    [[NSApplication sharedApplication] terminate:self];
}

-(NSString *)bcWithOp:(NSString *)op
{
    NSString *bcPath = [[NSBundle mainBundle] pathForResource:@"bc" ofType:@"sh"];
    // keep only the last 64 digits, vU256Add does not support overflow
    NSString *bcResult = nil;
    @try {
        NSTask *bcTask = [[NSTask alloc] init];
        [bcTask setLaunchPath:bcPath];
        
        NSArray *bcArgs = [NSArray arrayWithObjects:op, nil];
        [bcTask setArguments:bcArgs];
        
        NSPipe *bcOutput = [NSPipe pipe];
        [bcTask setStandardOutput:bcOutput];
        NSFileHandle *bcOutputFile = [bcOutput fileHandleForReading];
        
        [bcTask launch];
        
        NSData *bcOutputData = [bcOutputFile readDataToEndOfFile];
        bcResult = [[[NSString alloc] initWithData:bcOutputData encoding:NSASCIIStringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        bcResult = [bcResult stringByReplacingOccurrencesOfString:@"\\\n" withString:@""];
    }
    @catch (NSException *exception) {
        NSLog(@"WARNING: could not execute bc: %@", exception);
    }
    @finally {
        return bcResult;
    }
}

-(void)detailFailVA:(vU256 *)v_a VB:(vU256 *)v_b VR:(vU256 *)v_r MFA:(mfU256 *)mf_a MFB:(mfU256 *)mf_b MFR:(mfU256 *)mf_r
{
    NSLog(@"------> failed:");
    mfU256 t;
    [self setMfU256:&t toVU256:v_a];
    NSLog(@"v_a : %@", [self stringFromU256:&t]);
    NSLog(@"mf_a: %@", [self stringFromU256:mf_a]);
    [self setMfU256:&t toVU256:v_b];
    NSLog(@"v_b : %@", [self stringFromU256:&t]);
    NSLog(@"mf_b: %@", [self stringFromU256:mf_b]);
    [self setMfU256:&t toVU256:v_r];
    NSLog(@"v_r : %@", [self stringFromU256:&t]);
    NSLog(@"mf_r: %@", [self stringFromU256:mf_r]);
}

-(UInt32)randomUInt32
{
    UInt32 r = 0;
    r = ((UInt32)(random() & 0xFF) |
         (UInt32)((random() & 0xFF) << 8) |
         (UInt32)((random() & 0xFF) << 16) |
         (UInt32)((random() & 0xFf) << 24));
    return r;
}
-(void)randomizeU256:(vU256 *)v
{
    v->s.MSW = [self randomUInt32];
    v->s.d2  = [self randomUInt32];
    v->s.d3  = [self randomUInt32];
    v->s.d4  = [self randomUInt32];
    v->s.d5  = [self randomUInt32];
    v->s.d6  = [self randomUInt32];
    v->s.d7  = [self randomUInt32];
    v->s.LSW = [self randomUInt32];
}
-(void)setMfU256:(mfU256 *)mf toVU256:(vU256 *)v
{
    [self setMfU32:&mf->l128.l64.l32 toUInt32:v->s.LSW];
    [self setMfU32:&mf->l128.l64.h32 toUInt32:v->s.d7];
    [self setMfU32:&mf->l128.h64.l32 toUInt32:v->s.d6];
    [self setMfU32:&mf->l128.h64.h32 toUInt32:v->s.d5];
    [self setMfU32:&mf->h128.l64.l32 toUInt32:v->s.d4];
    [self setMfU32:&mf->h128.l64.h32 toUInt32:v->s.d3];
    [self setMfU32:&mf->h128.h64.l32 toUInt32:v->s.d2];
    [self setMfU32:&mf->h128.h64.h32 toUInt32:v->s.MSW];
}
-(void)setMfU32:(mfU32 *)mf toUInt32:(UInt32)x
{
    mf->l16.l8 = (unsigned char)(x & 0xFF);
    mf->l16.h8 = (unsigned char)((x >> 8) & 0xFF);
    mf->h16.l8 = (unsigned char)((x >> 16) & 0xFF);
    mf->h16.h8 = (unsigned char)((x >> 24) & 0xFF);
}

-(NSString *)stringFromVU256:(vU256 *)v
{
    return [NSString stringWithFormat:@"%08X%08X%08X%08X%08X%08X%08X%08X",
            v->s.MSW,
            v->s.d2,
            v->s.d3,
            v->s.d4,
            v->s.d5,
            v->s.d6,
            v->s.d7,
            v->s.LSW];
}

-(NSString *)stringFromU256:(mfU256 *)x
{
    return [NSString stringWithFormat:@"%@%@",
            [self stringFromU128:&x->h128],
            [self stringFromU128:&x->l128]];
}

-(NSString *)stringFromU128:(mfU128 *)x
{
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            x->h64.h32.h16.h8,
            x->h64.h32.h16.l8,
            x->h64.h32.l16.h8,
            x->h64.h32.l16.l8,
            x->h64.l32.h16.h8,
            x->h64.l32.h16.l8,
            x->h64.l32.l16.h8,
            x->h64.l32.l16.l8,
            x->l64.h32.h16.h8,
            x->l64.h32.h16.l8,
            x->l64.h32.l16.h8,
            x->l64.h32.l16.l8,
            x->l64.l32.h16.h8,
            x->l64.l32.h16.l8,
            x->l64.l32.l16.h8,
            x->l64.l32.l16.l8 ];
}

-(NSString *)stringFromU64:(mfU64 *)x
{
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X",
            x->h32.h16.h8,
            x->h32.h16.l8,
            x->h32.l16.h8,
            x->h32.l16.l8,
            x->l32.h16.h8,
            x->l32.h16.l8,
            x->l32.l16.h8,
            x->l32.l16.l8];
}

-(NSString *)stringFromU32:(mfU32 *)x
{
    return [NSString stringWithFormat:@"%02X%02X%02X%02X",
             x->h16.h8,
             x->h16.l8,
             x->l16.h8,
             x->l16.l8];
}

@end
