using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("sys_user")]
    public class SysUser
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Username { get; set; }

        [Required]
        [MaxLength(128)]
        public string Password { get; set; }

        [MaxLength(50)]
        public string RealName { get; set; }

        [MaxLength(100)]
        public string Email { get; set; }

        [MaxLength(20)]
        public string Phone { get; set; }

        public int? DeptId { get; set; }

        public int? RoleId { get; set; }

        public byte Status { get; set; } = 1;

        public DateTime CreateTime { get; set; } = DateTime.Now;

        public DateTime? UpdateTime { get; set; }

        [ForeignKey("DeptId")]
        public virtual SysDepartment Department { get; set; }

        [ForeignKey("RoleId")]
        public virtual SysRole Role { get; set; }
    }
}