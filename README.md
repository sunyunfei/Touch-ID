# Touch-ID
iOS指纹解锁这个需求在一些软件上可能会有需要，比如支付宝的指纹解锁之类的。前几天有个🐔友问这个，正好看了一下。很简单的一个framework的应用:LocalAuthentication.
判断指纹解锁各种状态的一个枚举：
```
失败授权(3次机会失败 --身份验证失败)
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 
 用户取消touchid授权(用户点击取消按钮)
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 用户选择输入密码,用户点击回退按钮(输入密码)
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 系统取消授权，系统跳转app之类的(比如另一个应用程序去前台,切换到其他 APP)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 设置touchid不可用，因为触摸ID在设备上不可用
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 身份验证无法启动,因为没有登记的手指触摸ID。 没有设置指纹密码时。
 LAErrorTouchIDNotEnrolled = kLAErrorTouchIDNotEnrolled,
 
 这个错误出现，源自用户多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁，这个错误的交互LocalAuthentication.framework已经封装好了，不需要开发者关心
 LAErrorTouchIDLockout   NS_ENUM_AVAILABLE(10_11, 9_0) __WATCHOS_AVAILABLE(3.0) __TVOS_AVAILABLE(10.0) = kLAErrorTouchIDLockout,
 
 LAErrorAppCancel和LAErrorSystemCancel相似，都是当前软件被挂起取消了授权，但是前者是用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。后者是用户自己切到了别的应用，例如按home键挂起
 LAErrorAppCancel        NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorAppCancel,
 
 就是授权过程中,LAContext对象被释放掉了，造成的授权失败
 LAErrorInvalidContext   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorInvalidContext
 }
```
