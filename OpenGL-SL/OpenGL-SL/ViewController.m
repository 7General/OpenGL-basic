//
//  ViewController.m
//  OpenGL-SL
//
//  Created by zzg on 2018/10/25.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "ViewController.h"
//#import "JFCAEGLayer.h"

@interface ViewController ()
{
    EAGLContext *_eaglContext;
//    JFCAEGLayer * _layer;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
}

@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initGL];
//    [self bindBuffer];
//    [self render];
    
}



- (void)initGL {
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eaglContext];

    // init layer
//    _layer = [[JFCAEGLayer alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view.layer addSublayer:_layer];
}




//- (void)uploadVertexArray {
//    //顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
//    GLfloat vertexData[] =
//    {
//        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
//        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
//
//        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
//        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
//    };
//
//    //顶点数据缓存
//    GLuint buffer;
//    glGenBuffers(1, &buffer);
//    glBindBuffer(GL_ARRAY_BUFFER, buffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
//
//    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
//    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
//    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
//    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
//}

- (void)bindBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
   
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
//    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_layer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _frameBuffer);
}

- (void)uploadTexture {
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"qrcode_for_gh" ofType:@"jpg"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
//    self.mEffect = [[GLKBaseEffect alloc] init];
//    self.mEffect.texture2d0.enabled = GL_TRUE;
//    self.mEffect.texture2d0.name = textureInfo.name;
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


-(void)render
{
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    //GL_COLOR_BUFFER_BIT:   当前可写的颜色缓冲
    //GL_DEPTH_BUFFER_BIT:   深度缓冲
    //GL_ACCUM_BUFFER_BIT:   累积缓冲
    //GL_STENCIL_BUFFER_BIT: 模板缓冲
    glClear(GL_COLOR_BUFFER_BIT);
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}




@end
