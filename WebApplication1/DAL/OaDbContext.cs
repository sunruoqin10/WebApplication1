using System;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using WebApplication1.Models.Entity;

namespace WebApplication1.DAL
{
    public class OaDbContext : DbContext
    {
        public OaDbContext() : base("name=OaDbContext")
        {
        }

        public OaDbContext(DbConnection existingConnection, bool contextOwnsConnection)
            : base(existingConnection, contextOwnsConnection)
        {
        }

        public DbSet<SysUser> SysUsers { get; set; }
        public DbSet<SysDepartment> SysDepartments { get; set; }
        public DbSet<SysRole> SysRoles { get; set; }
        public DbSet<SysLog> SysLogs { get; set; }
        public DbSet<SysNotification> SysNotifications { get; set; }
        public DbSet<WfTemplate> WfTemplates { get; set; }
        public DbSet<WfApprovalChain> WfApprovalChains { get; set; }
        public DbSet<WfInstance> WfInstances { get; set; }
        public DbSet<WfTask> WfTasks { get; set; }
        public DbSet<WfHistory> WfHistories { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<SysDepartment>()
                .HasOptional(d => d.Parent)
                .WithMany(d => d.Children)
                .HasForeignKey(d => d.ParentId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<SysUser>()
                .HasOptional(u => u.Department)
                .WithMany(d => d.Users)
                .HasForeignKey(u => u.DeptId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<SysUser>()
                .HasOptional(u => u.Role)
                .WithMany()
                .HasForeignKey(u => u.RoleId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<WfTemplate>()
                .HasMany(t => t.ApprovalChains)
                .WithRequired(c => c.Template)
                .HasForeignKey(c => c.TemplateId)
                .WillCascadeOnDelete(true);

            modelBuilder.Entity<WfTemplate>()
                .HasMany(t => t.Instances)
                .WithRequired(i => i.Template)
                .HasForeignKey(i => i.TemplateId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<WfInstance>()
                .HasMany(i => i.Tasks)
                .WithRequired(t => t.Instance)
                .HasForeignKey(t => t.InstanceId)
                .WillCascadeOnDelete(true);

            modelBuilder.Entity<WfInstance>()
                .HasMany(i => i.Histories)
                .WithRequired(h => h.Instance)
                .HasForeignKey(h => h.InstanceId)
                .WillCascadeOnDelete(true);
        }
    }
}