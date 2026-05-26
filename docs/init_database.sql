-- OA审批系统数据库初始化脚本
-- 注意：外键约束已在 EF6 的 Fluent API 中实现，此处不创建外键

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `oa_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `oa_db`;

-- ==================== 基础表 ====================

-- 用户表
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Username` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(128) NOT NULL,
  `RealName` VARCHAR(50) DEFAULT NULL,
  `Email` VARCHAR(100) DEFAULT NULL,
  `Phone` VARCHAR(20) DEFAULT NULL,
  `DeptId` INT DEFAULT NULL,
  `RoleId` INT DEFAULT NULL,
  `Status` TINYINT NOT NULL DEFAULT 1 COMMENT '1:启用 0:禁用',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` DATETIME DEFAULT NULL,
  UNIQUE KEY `UK_sys_user_username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 部门表
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `DeptName` VARCHAR(100) NOT NULL,
  `ParentId` INT NOT NULL DEFAULT 0 COMMENT '0为根节点',
  `LeaderId` INT DEFAULT NULL COMMENT '部门负责人ID',
  `SortOrder` INT NOT NULL DEFAULT 0,
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

-- 角色表
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `RoleName` VARCHAR(50) NOT NULL,
  `RoleDesc` VARCHAR(200) DEFAULT NULL,
  `Permissions` TEXT DEFAULT NULL COMMENT 'JSON权限列表',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 操作日志表
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `UserId` INT DEFAULT NULL,
  `Action` VARCHAR(100) DEFAULT NULL,
  `TargetType` VARCHAR(50) DEFAULT NULL,
  `TargetId` INT DEFAULT NULL,
  `Detail` TEXT DEFAULT NULL,
  `IpAddress` VARCHAR(50) DEFAULT NULL,
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- 通知表
DROP TABLE IF EXISTS `sys_notification`;
CREATE TABLE `sys_notification` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `UserId` INT DEFAULT NULL,
  `Title` VARCHAR(200) DEFAULT NULL,
  `Content` TEXT DEFAULT NULL,
  `Type` VARCHAR(20) DEFAULT NULL COMMENT 'approval_pending/approval_result',
  `RelatedId` INT DEFAULT NULL COMMENT '关联ID',
  `IsRead` TINYINT NOT NULL DEFAULT 0 COMMENT '0:未读 1:已读',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知表';

-- ==================== 流程表 ====================

-- 流程模板表
DROP TABLE IF EXISTS `wf_template`;
CREATE TABLE `wf_template` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `TemplateName` VARCHAR(100) NOT NULL,
  `TemplateCode` VARCHAR(50) NOT NULL,
  `Description` VARCHAR(500) DEFAULT NULL,
  `FormDefinition` TEXT DEFAULT NULL COMMENT '表单字段定义JSON',
  `Status` TINYINT NOT NULL DEFAULT 1 COMMENT '1:启用 0:禁用',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` DATETIME DEFAULT NULL,
  UNIQUE KEY `UK_wf_template_code` (`TemplateCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='流程模板表';

-- 审批链配置表
DROP TABLE IF EXISTS `wf_approval_chain`;
CREATE TABLE `wf_approval_chain` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `TemplateId` INT NOT NULL COMMENT '模板ID',
  `Level` INT NOT NULL COMMENT '审批级别 1,2,3...',
  `ApproverType` VARCHAR(20) DEFAULT NULL COMMENT 'fixed:固定指派 / role:按角色',
  `ApproverId` INT DEFAULT NULL COMMENT '审批人ID（固定指派时）',
  `ApproverRoleId` INT DEFAULT NULL COMMENT '审批角色ID（按角色时）',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批链配置表';

-- ==================== 审批实例表 ====================

-- 审批实例表
DROP TABLE IF EXISTS `wf_instance`;
CREATE TABLE `wf_instance` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `TemplateId` INT NOT NULL,
  `ApplicantId` INT NOT NULL,
  `FormData` TEXT DEFAULT NULL COMMENT '表单数据JSON',
  `Status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending/approved/rejected/withdrawn',
  `CurrentLevel` INT NOT NULL DEFAULT 1,
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批实例表';

-- 审批任务表
DROP TABLE IF EXISTS `wf_task`;
CREATE TABLE `wf_task` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `InstanceId` INT NOT NULL,
  `Level` INT NOT NULL,
  `ApproverId` INT NOT NULL,
  `Status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending/approved/rejected/skipped',
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批任务表';

-- 审批历史表
DROP TABLE IF EXISTS `wf_history`;
CREATE TABLE `wf_history` (
  `Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `InstanceId` INT NOT NULL,
  `Level` INT NOT NULL,
  `ApproverId` INT NOT NULL,
  `Action` VARCHAR(20) DEFAULT NULL COMMENT 'approve/reject',
  `Comment` TEXT DEFAULT NULL,
  `CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批历史表';

-- ==================== 初始数据 ====================

-- 插入默认角色
INSERT INTO `sys_role` (`RoleName`, `RoleDesc`, `Permissions`, `CreateTime`) VALUES
('系统管理员', '拥有全部权限', '["system:user","system:dept","system:role","system:log","workflow:template","workflow:form_designer","workflow:approval_chain","apply:create","apply:list","approve:pending","approve:history","notice:list","report:dashboard"]', NOW()),
('普通用户', '基础权限', '["apply:create","apply:list","approve:pending","approve:history","notice:list","report:dashboard"]', NOW());

-- 插入默认部门
INSERT INTO `sys_department` (`DeptName`, `ParentId`, `LeaderId`, `SortOrder`, `CreateTime`) VALUES
('总公司', 0, NULL, 0, NOW()),
('技术部', 1, NULL, 1, NOW()),
('人事部', 1, NULL, 2, NOW()),
('财务部', 1, NULL, 3, NOW());

-- 插入默认管理员用户 (密码: admin123 SHA256)
INSERT INTO `sys_user` (`Username`, `Password`, `RealName`, `Email`, `Phone`, `DeptId`, `RoleId`, `Status`, `CreateTime`) VALUES
('admin', '240be518fabd2724ddb6f04ceebcc92a5b0f6f5ac3c62f5d6c93fe1a1effc996', '系统管理员', 'admin@example.com', '13800138000', 1, 1, 1, NOW());

-- 插入默认流程模板
INSERT INTO `wf_template` (`TemplateName`, `TemplateCode`, `Description`, `FormDefinition`, `Status`, `CreateTime`) VALUES
('请假申请', 'leave', '员工请假申请模板', '[{"fieldName":"realName","fieldType":"text","label":"姓名","required":true,"readonly":true},{"fieldName":"leaveType","fieldType":"select","label":"请假类型","required":true,"options":[{"value":"annual","text":"年假"},{"value":"sick","text":"病假"},{"value":"personal","text":"事假"},{"value":"marriage","text":"婚假"},{"value":"maternity","text":"产假"}]},{"fieldName":"startDate","fieldType":"date","label":"开始日期","required":true},{"fieldName":"endDate","fieldType":"date","label":"结束日期","required":true},{"fieldName":"days","fieldType":"number","label":"请假天数","required":true},{"fieldName":"reason","fieldType":"textarea","label":"请假事由","required":false}]', 1, NOW()),
('报销申请', 'expense', '费用报销申请模板', '[{"fieldName":"realName","fieldType":"text","label":"姓名","required":true,"readonly":true},{"fieldName":"expenseType","fieldType":"select","label":"报销类型","required":true,"options":[{"value":"travel","text":"差旅费"},{"value":"transport","text":"交通费"},{"value":"meal","text":"餐饮费"},{"value":"office","text":"办公费"},{"value":"other","text":"其他"}]},{"fieldName":"amount","fieldType":"number","label":"报销金额","required":true},{"fieldName":"detail","fieldType":"textarea","label":"费用明细","required":true},{"fieldName":"attachment","fieldType":"attachment","label":"附件","required":false}]', 1, NOW());

-- 为请假模板配置默认审批链（第1级：按角色匹配部门经理）
INSERT INTO `wf_approval_chain` (`TemplateId`, `Level`, `ApproverType`, `ApproverId`, `ApproverRoleId`, `CreateTime`)
SELECT Id, 1, 'role', NULL, (SELECT Id FROM sys_role WHERE RoleName = '系统管理员'), NOW()
FROM wf_template WHERE TemplateCode = 'leave';

-- 为报销模板配置默认审批链
INSERT INTO `wf_approval_chain` (`TemplateId`, `Level`, `ApproverType`, `ApproverId`, `ApproverRoleId`, `CreateTime`)
SELECT Id, 1, 'role', NULL, (SELECT Id FROM sys_role WHERE RoleName = '系统管理员'), NOW()
FROM wf_template WHERE TemplateCode = 'expense';

SELECT '数据库初始化完成！' AS Message;