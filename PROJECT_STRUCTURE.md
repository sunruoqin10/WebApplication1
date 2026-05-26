# WebApplication1 项目结构说明

> 适合 .NET 初学者的 ASP.NET Web Forms 项目解析

---

## 一、项目整体架构

```
WebApplication1/
├── WebApplication1.slnx          # 解决方案文件（双击打开整个项目）
├── packages/                      # NuGet 包存放目录（自动生成）
└── WebApplication1/               # 主项目文件夹
```

---

## 二、WebApplication1 项目内部结构

### 2.1 根目录文件

| 文件 | 说明 |
|------|------|
| `Web.config` | 应用程序配置文件（数据库连接、认证方式等） |
| `Web.Debug.config` | Debug 模式的配置（发布时使用） |
| `Web.Release.config` | Release 模式的配置 |
| `packages.config` | NuGet 包依赖清单 |
| `Global.asax` | 全局应用程序文件 |
| `favicon.ico` | 网站图标 |

### 2.2 页面文件（.aspx）

| 文件 | 说明 | 代码后台 |
|------|------|----------|
| `Default.aspx` | 首页 | `Default.aspx.cs` |
| `About.aspx` | 关于页面 | `About.aspx.cs` |
| `Contact.aspx` | 联系页面 | `Contact.aspx.cs` |
| `Site.Master` | 母版页（所有页面的"外壳"） | `Site.Master.cs` |
| `Site.Mobile.Master` | 移动版母版页 | `Site.Mobile.Master.cs` |
| `ViewSwitcher.ascx` | 用户控件（切换视图） | `ViewSwitcher.ascx.cs` |

### 2.3 App_Start 目录（应用程序启动配置）

```
App_Start/
├── BundleConfig.cs    # 脚本和样式打包配置
└── RouteConfig.cs     # 路由配置（友好URL）
```

**BundleConfig.cs** - 负责将多个 CSS/JS 文件合并打包，减少浏览器请求次数：
- `~/bundles/jquery` - jQuery 库
- `~/bundles/modernizr` - Modernizr 库
- `~/bundles/WebFormsJs` - Web Forms 核心脚本

**RouteConfig.cs** - 启用友好 URL，例如 `/About` 等同于 `/About.aspx`

### 2.4 其他重要目录

| 目录 | 说明 |
|------|------|
| `Content/` | CSS 样式文件（Bootstrap 5） |
| `Scripts/` | JavaScript 文件（jQuery、Bootstrap、WebForms） |
| `Properties/` | 程序集信息 |
| `App_Data/` | 数据库文件存放目录 |
| `bin/` | 编译输出的 DLL 文件 |

---

## 三、母版页（Master Page）结构

`Site.Master` 是所有页面的"外壳"，提供了统一的导航和布局：

```
Site.Master 结构：
┌─────────────────────────────────────────┐
│  导航栏 (Navbar)                         │
│  [主页] [关于] [联系人]                   │
├─────────────────────────────────────────┤
│                                         │
│  <asp:ContentPlaceHolder ID="MainContent">│
│       页面内容在此区域显示                 │
│  </asp:ContentPlaceHolder>               │
│                                         │
├─────────────────────────────────────────┤
│  页脚 (Footer)                           │
│  © 2026 - 我的 ASP.NET 应用程序          │
└─────────────────────────────────────────┘
```

子页面（如 Default.aspx）只需要编写 `<asp:Content>` 中的内容。

---

## 四、代码后台（Code-Behind）模式

Web Forms 使用"代码后台"模式，将界面和逻辑分离：

### Default.aspx（界面）
```aspx
<%@ Page Title="Home Page" ... %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>欢迎！</h1>
</asp:Content>
```

### Default.aspx.cs（逻辑）
```csharp
public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 页面加载时执行的代码
    }
}
```

### Default.aspx.designer.cs（自动生成）
```csharp
public partial class _Default
{
    protected global::System.Web.UI.WebControls.ContentPlaceHolder MainContent;
}
```

---

## 五、应用程序启动流程

```
1. 用户访问网站
       ↓
2. Global.asax.cs 中的 Application_Start 被调用
       ↓
3. RouteConfig.RegisterRoutes() → 启用友好 URL
       ↓
4. BundleConfig.RegisterBundles() → 注册脚本和样式包
       ↓
5. 请求被路由到具体页面（如 /About）
       ↓
6. About.aspx.cs 的 Page_Load 执行
```

---

## 六、关键配置文件说明

### Web.config 主要节点
```xml
<configuration>
    <appSettings>        <!-- 应用程序设置 -->
    <connectionStrings>   <!-- 数据库连接字符串 -->
    <system.web>          <!-- 编译模式、认证、页面设置 -->
    <system.webServer>    <!-- IIS 配置 -->
</configuration>
```

---

## 七、依赖的 NuGet 包

| 包名 | 版本 | 用途 |
|------|------|------|
| Bootstrap | 5.2.3 | CSS/JS 前端框架 |
| jQuery | 3.7.0 | JavaScript 库 |
| Modernizr | 2.8.3 | 浏览器特性检测 |
| Microsoft.AspNet.FriendlyUrls | 1.0.2 | 友好 URL 支持 |
| Newtonsoft.Json | 13.0.3 | JSON 序列化 |

---

## 八、常用操作

### 添加新页面
1. 在项目中右键 → 添加 → Web 窗体
2. 命名（如 `Products.aspx`）
3. 选择使用母版页 `Site.Master`
4. 在 `Content` 区域编写内容

### 修改导航栏
编辑 `Site.Master` 中的 `<ul class="navbar-nav">` 部分

### 添加 CSS 样式
在 `Content/Site.css` 中添加，或在页面中引用新的 CSS 文件

---

## 九、学习建议

1. **从页面开始**：先修改 `.aspx` 文件中的 HTML，观察效果
2. **理解代码后台**：在 `.aspx.cs` 的 `Page_Load` 中添加 `Response.Write("Hello")` 理解执行顺序
3. **探索母版页**：修改 `Site.Master` 理解如何影响所有页面
4. **Web Forms 控件**：尝试添加 `<asp:Button>`、`<asp:TextBox>` 等服务器控件

---

> 如果你是初学者，建议按以下顺序学习：
> 1. HTML/CSS 基础 → 2. C# 基础 → 3. ASP.NET Web Forms 页面生命周期
