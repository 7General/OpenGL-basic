//
//  MainViewController.m
//  OpenGL-SL
//
//  Created by zzg on 2018/10/29.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "MainViewController.h"

// 这个数据类型用于存储每一个顶点数据
typedef struct {
    /* 顶点数据 */
    GLKVector3 positionCoords;
    /* 纹理坐标 */
    GLKVector2 textureCoords;
} SceneVertex;

// 创建本例中要用到的三角形顶点数据
const SceneVertex vertices []  =
{
    {{-0.5, -0.5, 0.0},{0.0,0.0}},  // 左下
    {{ 0.5, -0.5, 0.0},{1.0,0.0}},  // 右下
    {{-0.5, 0.5, 0.0},{0.0,1.0}},  // 左上

    {{-0.5, 0.5, 0.0},{0.0,1.0}},  // 左上
    {{ 0.5, 0.5, 0.0},{1.0,1.0}},  // 右上
    {{0.5,  -0.5, 0.0},{1.0,0.0}}  // 右下
    
};


@interface MainViewController ()
{
    /* 用于保存盛放本例即将用到的顶点数据的缓存的OpenGL ES标识符 */
    GLuint vertexBufferId;
}
/* 是为了简化OpenGL ES的很多常用操作（好吧，我也不太懂这个）。
 GLKBaseEffect隐藏了iOS设备支持的多个OpenGL ES版本之间的差异。在应用中使用GLKBaseEffect能减少代码的数量 */
@property (nonatomic, strong) GLKBaseEffect * baseEffect;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView * view = (GLKView *)self.view;
    /* 创建一个GL2.0的context并将其提供给view */
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    /* 将当前创建的context设置为当前的context */
    [EAGLContext setCurrentContext:view.context];
    
    /* 创建一个提供标准GL的GLKBaseEffect */
    self.baseEffect = [[GLKBaseEffect alloc] init];
    /* 启动shading language programs（含着色器） */
    self.baseEffect.useConstantColor = GL_TRUE;
    /* 设置渲染图形用的颜色为白色 */
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    /* 设置当前的context的背景色为黑色 */
    glClearColor(0.0, 0.0, 0.0, 1.0);

    /*
     * glGenBuffers(GLsizei n, GLuint *buffers);
     * 生成缓存，指定缓存数量，并保存在vertexBufferId中
     * 第一个参数：指定要生成的缓存标识符的数量
     * 第二个参数：指针，指向生成的标识符的内存位置（熟悉C和C++的小伙伴应该不陌生了）
     */
    glGenBuffers(1, &vertexBufferId);
    
    /*
     * glBindBuffer(GLenum target, GLuint buffer);
     * 绑定由于指定标识符的缓存到当前缓存
     * 第一个参数：用于指定要绑定哪一类型的内存(GL_ARRAY_BUFFER | GL_ELEMENT_ARRAY_BUFFER)，GL_ARRAY_BUFFER用于指定一个顶点属性数组
     * 第二个参数：要绑定存缓存的标识符
     */
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferId);
    
    /*
     * glBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
     * 复制应用的顶点数据到context所绑定的顶点缓存中
     * 第一个参数：指定要更新当前context中所绑定的是哪一类型的缓存
     * 第二个参数：指定要复制进缓存的字节的数量
     * 第三个参数：要复制的字节的地址
     * 第四个参数：提示缓存在未来的运算中将被怎样使用(GL_STATIC_DRAW | GL_DYNAMIC_DRAW)，GL_STATIC_DRAW是指缓存中的内容可以复制到GPU的内存中，因为很少对其进行更改。
     */
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    
    
    // 读入需要绘制的图片的CGImageRef内容
    // 毕竟OpenGL是基于C++的嘛，你直接给一个UIImage人怎么识别
    //CGImageRef imageRefTulip = [UIImage imageNamed:@"qrcode_for_gh.jpg"].CGImage;
    // 使用GLKTextureLoader（纹理读取）从上边得到的imageRefTulip读取纹理信息
    //GLKTextureInfo *textureInfoTulip = [GLKTextureLoader textureWithCGImage:imageRefTulip
//                                                                    options:nil
//                                                                      error:nil];
    
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"qrcode_for_gh" ofType:@"jpg"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo * textureInfoTulip = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    // 将读取到的纹理信息缓存到baseEffec的texture2d0中
    self.baseEffect.texture2d0.name = textureInfoTulip.name;
    self.baseEffect.texture2d0.target = textureInfoTulip.target;
    
}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    /* 启动纹理 */
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL+offsetof(SceneVertex, textureCoords));
    
     // 告诉baseEffect准备好当前OpenGL ES的context，马上就要绘画了
    [self.baseEffect prepareToDraw];
     // 清除当前绑定的帧缓存的像素颜色渲染缓存中的每一个像素的颜色为前面使用glClearColor函数设置的值
    glClear(GL_COLOR_BUFFER_BIT);
    /*
     * glEnableVertexAttribArray(GLuint index)
     * 启动某项缓存的渲染操作（GLKVertexAttribPosition | GLKVertexAttribNormal | GLKVertexAttribTexCoord0 | GLKVertexAttribTexCoord1）
     * GLKVertexAttribPosition 用于顶点数据
     * GLKVertexAttribNormal 用于法线
     * GLKVertexAttribTexCoord0 与 GLKVertexAttribTexCoord1 均为纹理
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    /*
     * glVertexAttribPointer(GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *ptr);
     * 渲染相应数据（此处绘制顶点数据）
     * 第一个参数：当前要绘制的值什么类型的数据，与glEnableVertexAttribArray()相同
     * 第二个参数：每个位置有3个部分
     * 第三个参数：每个部分都保存为一个float值
     * 第四个参数：告诉OpenGL ES小数点固定数据是否可以被改变
     * 第五个参数：“步幅”，即从一个顶点的内存开始位置转到下一个顶点的内存开始位置需要跳过多少字节
     * 第六个参数：告诉OpenGL ES从当前的绑定的顶点缓存的开始位置访问顶点数据
     */
    glVertexAttribPointer(GLKVertexAttribPosition,      // 当前绘制顶点数据
                          3,                                            // 每个顶点3个值
                          GL_FLOAT,                                // 数据为float
                          GL_FALSE,                                 // 不需要做任何转化
                          sizeof(SceneVertex),                     // 每个顶点之间的内存间隔为sizeof(SceneVertex)
                          NULL);                                        // 偏移量为0，从开始绘制，也可以传0
    
    /*
     * glDrawArrays(GLenum mode, GLint first, GLsizei count)
     * 执行绘图操作
     * 第一个参数：告诉GPU如何处理绑定的顶点缓存内的数据
     * 第二个参数：指定缓存内需要渲染的第一个数据（此处为顶点）的位置，0即为从开始绘制
     * 第三个参数：指定缓存内需要渲染的数据（此处为顶点）的数量
     */
    
    glDrawArrays(GL_TRIANGLES,  // 绘制三角形
                 0,                             // 从开始绘制
                 6);                            // 共3个顶点
}


@end
