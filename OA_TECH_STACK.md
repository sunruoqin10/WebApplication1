# OA 系统技术栈方案

> 基于 WebApplication1 项目构建 OA 办公自动化系统

---

## 一、推荐技术栈

### 1.1 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                    表现层 (Presentation)                  │
│         ASP.NET Web Forms / Bootstrap 5                │
├─────────────────────────────────────────────────────────┤
│                    业务逻辑层 (BLL)                      │
│              业务服务类 + 工作流引擎                       │
├─────────────────────────────────────────────────────────┤
│                    数据访问层 (DAL)                      │
│         Entity Framework 6 + MySQL Connector           │
├─────────────────────────────────────────────────────────┤
│                    数据库 (Database)                    │
│                    MySQL 8.0                            │
└─────────────────────────────────────────────────────────┘
```

### 1.2 技术选型明细

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| **后端框架** | ASP.NET Web Forms | .NET 4.7.2 | 沿用现有项目，减少迁移成本 |
| **ORM 框架** | Entity Framework 6 | 6.4.4 | 微软官方 ORM，支持 MySQL |
| **数据库** | MySQL | 8.0 | 开源免费，社区活跃 |
| **MySQL 驱动** | MySQL Connector/NET | 8.0.33 | Oracle 官方驱动 |
| **前端框架** | Bootstrap | 5.2.3 | 已有，响应式 UI |
| **图表库** | ECharts | 5.4.0 | 统计报表可视化 |
| **工作流** | Workflow Engine | 2.0 | 审批流程引擎 |
| **日志框架** | log4net | 2.0.17 | 应用日志记录 |

---

## 二、为什么选择这个技术栈

### 2.1 优势

| 选择 | 理由 |
|------|------|
| **沿用 Web Forms** | 现有项目已是 Web Forms，适合初学者快速上手 |
| **EF6 + MySQL** | 学习曲线平缓，资料丰富，与 SQL Server EF6 用法一致 |
| **MySQL 8.0** | 免费开源，与 Oracle/MySQL 生态兼容好 |
| **Bootstrap 5** | 已有，无需额外安装，响应式设计适合办公场景 |

### 2.2 与现有项目的兼容性

```
现有项目                          OA 项目扩展
─────────────────────────────────────────────
Web Forms (.aspx)          →     保持一致
Global.asax.cs            →     添加身份验证事件
BundleConfig.cs           →     添加 OA 资源包
packages.config           →     添加 EF6、MySQLConnector
Web.config                →     添加 MySQL 连接字符串
```

---

## 三、项目模块规划

### 3.1 核心模块

```
OA_System/
├── Account/                    # 账户模块
│   ├── Login.aspx             # 登录页
│   ├── Login.aspx.cs
│   └── UserInfo.aspx          # 个人信息
│
├── Admin/                     # 系统管理（仅管理员）
│   ├── UserManage.aspx        # 用户管理
│   ├── RoleManage.aspx        # 角色管理
│   └── DeptManage.aspx        # 部门管理
│
├── Workflow/                   # 工作流模块
│   ├── LeaveApp.aspx          # 请假申请
│   ├── LeaveApprove.aspx      # 请假审批
│   ├── Expense.aspx           # 报销申请
│   └── ApprovalHistory.aspx   # 审批历史
│
├── Notice/                    # 通知公告模块
│   ├── NoticeList.aspx        # 公告列表
│   └── NoticeDetail.aspx      # 公告详情
│
├── Document/                  # 文档管理模块
│   ├── DocList.aspx           # 文档列表
│   └── DocUpload.aspx         # 文档上传
│
├── Report/                    # 统计报表模块
│   ├── Dashboard.aspx         # 工作台仪表盘
│   └── LeaveReport.aspx       # 请假统计
│
└── Components/                # 公共组件
    ├── ApprovalControl.ascx    # 审批控件
    └── Pager.ascx            # 分页控件
```

### 3.2 数据库设计（核心表）

```sql
-- 用户表
CREATE TABLE sys_user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(128) NOT NULL,      -- SHA256 加密
    real_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    dept_id INT,
    role_id INT,
    status TINYINT DEFAULT 1,             -- 1:启用 0:禁用
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES sys_department(id),
    FOREIGN KEY (role_id) REFERENCES sys_role(id)
);

-- 部门表
CREATE TABLE sys_department (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    parent_id INT DEFAULT 0,
    leader_id INT
);

-- 角色表
CREATE TABLE sys_role (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    role_desc VARCHAR(200),
    permissions TEXT                      -- JSON 格式权限列表
);

-- 请假申请表
CREATE TABLE oa_leave (
    id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT NOT NULL,
    leave_type VARCHAR(50) NOT NULL,       -- 年假/病假/事假
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days DECIMAL(5,1) NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending',   -- pending/approved/rejected
    approver_id INT,
    approve_time DATETIME,
    approve_comment TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES sys_user(id)
);

-- 审批流程表
CREATE TABLE oa_workflow_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workflow_type VARCHAR(50) NOT NULL,    -- leave/expense
    record_id INT NOT NULL,
    approver_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,           -- approve/reject
    comment TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 系统日志表
CREATE TABLE sys_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    ip_address VARCHAR(50),
    user_agent VARCHAR(200),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

---

## 四、NuGet 包依赖

在 `packages.config` 中添加：

```xml
<!-- Entity Framework + MySQL -->
<package id="EntityFramework" version="6.4.4" targetFramework="net472" />
<package id="MySql.Data" version="8.0.33" targetFramework="net472" />
<package id="MySql.EntityFramework" version="8.0.33" targetFramework="net472" />

<!-- 日志 -->
<package id="log4net" version="2.0.17" targetFramework="net472" />

<!-- JSON 处理（已有）-->
<package id="Newtonsoft.Json" version="13.0.3" targetFramework="net472" />

<!-- Excel 导出 -->
<package id="EPPlus" version="6.2.4" targetFramework="net472" />
```

---

## 五、Web.config 配置

```xml
<configuration>
  <connectionStrings>
    <!-- MySQL 连接字符串 -->
    <add name="MySqlConnection"
         connectionString="Server=localhost;Port=3306;Database=oa_db;Uid=root;Pwd=your_password;Charset=utf8mb4;"
         providerName="MySql.Data.MySqlClient" />
  </connectionStrings>

  <appSettings>
    <add key="Log4net.Config" value="log4net.config" />
    <add key="EncryptionKey" value="your-32-char-key-here" />
  </appSettings>
</configuration>
```

---

## 六、Entity Framework 6 使用示例

### 6.1 DbContext 配置

```csharp
// Data/OaDbContext.cs
using System;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

public class OaDbContext : DbContext
{
    public OaDbContext() : base("name=MySqlConnection")
    {
        Database.SetInitializer<OaDbContext>(null);
    }

    public DbSet<SysUser> Users { get; set; }
    public DbSet<SysDepartment> Departments { get; set; }
    public DbSet<SysRole> Roles { get; set; }
    public DbSet<OaLeave> LeaveRequests { get; set; }
    public DbSet<OaWorkflowHistory> WorkflowHistories { get; set; }
    public DbSet<SysLog> Logs { get; set; }

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
        modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        modelBuilder.Configurations.AddFromAssembly(typeof(OaDbContext).Assembly);
    }
}
```

### 6.2 实体类示例

```csharp
// Models/SysUser.cs
public class SysUser
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Password { get; set; }
    public string RealName { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public int DeptId { get; set; }
    public int RoleId { get; set; }
    public byte Status { get; set; }
    public DateTime CreateTime { get; set; }

    public virtual SysDepartment Department { get; set; }
    public virtual SysRole Role { get; set; }
}
```

### 6.3 数据访问示例

```csharp
// DAL/UserRepository.cs
public class UserRepository
{
    private OaDbContext _db = new OaDbContext();

    public SysUser GetById(int id)
    {
        return _db.Users.Include(u => u.Department).Include(u => u.Role)
                        .FirstOrDefault(u => u.Id == id);
    }

    public SysUser ValidateUser(string username, string password)
    {
        var hashedPwd = HashPassword(password);
        return _db.Users.FirstOrDefault(u =>
            u.Username == username && u.Password == hashedPwd && u.Status == 1);
    }

    public List<SysUser> GetAll()
    {
        return _db.Users.Where(u => u.Status == 1).ToList();
    }

    public void Add(SysUser user)
    {
        user.Password = HashPassword(user.Password);
        _db.Users.Add(user);
        _db.SaveChanges();
    }
}
```

---

## 七、分层架构

```
OA_System/
├── App_Start/                  # 启动配置
│   ├── BundleConfig.cs        # JS/CSS 打包
│   ├── RouteConfig.cs         # 路由配置
│   └── AuthConfig.cs          # 身份验证配置（新增）
│
├── Models/                     # 数据模型
│   ├── Entity/                # EF 实体类
│   │   ├── SysUser.cs
│   │   ├── SysDepartment.cs
│   │   ├── SysRole.cs
│   │   └── OaLeave.cs
│   └── ViewModel/             # 视图模型
│       ├── LeaveAppViewModel.cs
│       └── DashboardViewModel.cs
│
├── DAL/                       # 数据访问层
│   ├── OaDbContext.cs         # EF 上下文
│   ├── UserRepository.cs
│   ├── DepartmentRepository.cs
│   └── LeaveRepository.cs
│
├── BLL/                       # 业务逻辑层
│   ├── UserService.cs
│   ├── LeaveService.cs
│   └── WorkflowService.cs
│
├── Pages/                     # 页面（按模块分组）
│   ├── Account/
│   ├── Admin/
│   ├── Workflow/
│   └── Report/
│
├── Components/                # 公共控件
│   ├── Header.ascx
│   ├── Pager.ascx
│   └── ApprovalPanel.ascx
│
├── Scripts/                   # JS（扩展）
│   ├── oa/
│   │   ├── leave-app.js
│   │   ├── approval.js
│   │   └── dashboard.js
│   └── echarts/               # ECharts 库
│
├── Content/                   # CSS（已有 + 扩展）
│   ├── oa/                    # OA 专用样式
│   │   ├── oa-layout.css
│   │   └── oa-components.css
│   └── bootstrap/             # 已有
│
├── Config/                    # 配置文件
│   ├── log4net.config         # 日志配置
│   └── workflow.config        # 流程配置
│
└── Utils/                     # 工具类
    ├── EncryptionHelper.cs    # 加密工具
    ├── DateHelper.cs          # 日期工具
    ├── JsonHelper.cs          # JSON 工具
    └── ExportHelper.cs        # 导出工具
```

---

## 八、身份认证流程

```
用户访问受保护页面
        ↓
检查 Session["UserId"]
        ↓
    有 → 显示页面
    无 → 跳转到 Login.aspx?returnUrl=xxx
        ↓
用户提交用户名密码
        ↓
UserRepository.ValidateUser()
        ↓
验证成功 → 写入 Session → 重定向到 returnUrl
验证失败 → 显示错误信息
```

---

## 九、权限控制

### 9.1 角色定义

| 角色 | 代码 | 权限 |
|------|------|------|
| 系统管理员 | ADMIN | 全部权限 |
| 部门经理 | MANAGER | 本部门审批 + 查看 |
| 普通员工 | USER | 申请 + 查看本人记录 |

### 9.2 权限检查示例

```csharp
// 在 BasePage 或每个页面 Page_Load 中
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["UserId"] == null)
    {
        Response.Redirect("/Account/Login.aspx");
        return;
    }

    var user = new UserRepository().GetById((int)Session["UserId"]);
    if (user.Role.RoleName != "ADMIN" && user.Role.RoleName != "MANAGER")
    {
        // 无权限，跳转或提示
        Response.Write("<script>alert('无权限访问')</script>");
    }
}
```

---

## 十、下一步开发计划

| 阶段 | 内容 | 优先级 |
|------|------|--------|
| **Phase 1** | 搭建 EF6 + MySQL 环境，配置连接 | 🔴 高 |
| **Phase 2** | 完成用户登录/登出，Session 管理 | 🔴 高 |
| **Phase 3** | 开发系统管理模块（用户/部门/角色） | 🔴 高 |
| **Phase 4** | 开发请假申请/审批功能 | 🟡 中 |
| **Phase 5** | 开发通知公告模块 | 🟡 中 |
| **Phase 6** | 开发工作台仪表盘 | 🟢 低 |
| **Phase 7** | 完善权限控制和日志 | 🟢 低 |

---

## 十一、学习资源

| 资源 | 说明 |
|------|------|
| [EF6 文档](https://learn.microsoft.com/zh-cn/ef/ef6/) | 微软官方 EF6 教程 |
| [MySQL 8.0 手册](https://dev.mysql.com/doc/refman/8.0/en/) | MySQL 官方文档 |
| [Bootstrap 5 文档](https://getbootstrap.com/docs/5.2/) | 前端框架参考 |
| [log4net 教程](https://logging.apache.org/log4net/) | 日志框架 |

---

> **建议**：按 Phase 1-5 的顺序开发，每个阶段完成后进行测试，再进入下一阶段。
