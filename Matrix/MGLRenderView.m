//
//  MGLRenderView.m
//  Matrix
//
//  Created by ruibin.chow on 2023/6/22.
//

#import "MGLRenderView.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#include "matrix.h"

@interface MGLRenderView () {
    MGLSettings * settings_;
}


@end

@implementation MGLRenderView

+ (NSOpenGLPixelFormat *)defaultPixelFormat {
    static NSOpenGLPixelFormat *pf;
    
    if (pf == nil) {
        // You must make sure that the pixel format of the context does not
        // have a recovery renderer is important. Otherwise CoreImage may not be able to
        // create contexts that share textures with this context.
        
        static const NSOpenGLPixelFormatAttribute attr[] = {
            NSOpenGLPFAAccelerated,
            NSOpenGLPFANoRecovery,
            NSOpenGLPFAColorSize, 32,
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
            NSOpenGLPFAAllowOfflineRenderers,
#endif
            0
        };
        
        pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:(void *)&attr];
    }
    
    return pf;
}

- (void)prepareOpenGL {
    GLint parm = 1;
    
    //  Set the swap interval to 1 to ensure that buffers swaps occur only during the vertical retrace of the monitor.
    
    [[self openGLContext] setValues:&parm forParameter:NSOpenGLCPSwapInterval];
    
    // To ensure best performance, disbale everything you don't need.
    
    glDisable (GL_ALPHA_TEST);
    glDisable (GL_DEPTH_TEST);
    glDisable (GL_SCISSOR_TEST);
    glDisable (GL_BLEND);
    glDisable (GL_DITHER);
    glDisable (GL_CULL_FACE);
    glColorMask (GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    glDepthMask (GL_FALSE);
    glStencilMask (0);
    glClearColor (0.0f, 0.0f, 0.0f, 0.0f);
    glHint (GL_TRANSFORM_HINT_APPLE, GL_FASTEST);
//    _needsReshape = YES;
}

// Called when the user scrolls, moves, or resizes the view.
- (void)reshape {
    // Resets the viewport on the next draw operation.
//    _needsReshape = YES;
    [self updateMatrices];
}

- (void)updateMatrices {
    NSRect  visibleRect = [self visibleRect];
    NSRect  mappedVisibleRect = NSIntegralRect([self convertRect: visibleRect toView: [self enclosingScrollView]]);
    
    [[self openGLContext] update];
    
    // Install an orthographic projection matrix (no perspective)
    // with the origin in the bottom left and one unit equal to one device pixel.
    
    glViewport (0, 0,mappedVisibleRect.size.width, mappedVisibleRect.size.height);
    
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    glOrtho(visibleRect.origin.x,
            visibleRect.origin.x + visibleRect.size.width,
            visibleRect.origin.y,
            visibleRect.origin.y + visibleRect.size.height,
            -1, 1);
    
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity ();
//    _needsReshape = NO;
}

- (void)render {
    NSLog(@"render");
    NSRect      frame = [self bounds];
    
//    [[self openGLContext] makeCurrentContext];
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    NSSize tSize = [self bounds].size;
    settings_ = (MGLSettings *)malloc(sizeof(MGLSettings));
    settings_->color = GL_GREEN;
    
    NSLog(@"size: %@", NSStringFromSize(tSize));
    ourInit((int)tSize.width*2, (int)tSize.height*2, settings_);
    initSettings(settings_);
    
//    settings_->classic=0;
//    settings_->pic_offset=(num_pics+1)*(rtext_x*text_y);
//    settings_->pic_mode=1;
//    settings_->timer=70;
    
//    settings_->pic_fade=0;
//    settings_->pic_offset=0;
//    settings_->pic_mode=0;
//    settings_->classic=1;
    
    if (!cbRenderScene(settings_)) {
        [self performSelector:@selector(doScroll:) withObject:nil afterDelay:0.060f];
    }
    
    // Flush the OpenGL command stream. If the view is double-buffered
    // you should  replace  this call with [[self openGLContext]
    
    glFlush();
//    [[self openGLContext] flushBuffer];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSLog(@"drawRect");
    [self render];
}

- (void)startAnimation {
    NSLog(@"startAnimation");
    [[self openGLContext] makeCurrentContext];
    
}

- (void)stopAnimation {
    NSLog(@"stopAnimation");
    [[self openGLContext] makeCurrentContext];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    free(settings_);
}

- (void)animateOneFrame {
    NSLog(@"animateOneFrame");
    [[self openGLContext] makeCurrentContext];
    
    if (!cbRenderScene(settings_)) {
        [self performSelector:@selector(doScroll:) withObject:nil afterDelay:0.060f];
    }
    
    [[self openGLContext] flushBuffer];
}

- (void)doScroll:(id)inObject {
    NSLog(@"doScroll");
    
    if (!mgl_scroll(settings_->mode2, settings_)) {
        
        NSLog(@"performSelector");
        
        SEL tSelector;
        tSelector = @selector(doScroll:);
    
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:tSelector object:nil];
        [self performSelector:tSelector withObject:nil afterDelay:0.060f];
    }
}


@end
