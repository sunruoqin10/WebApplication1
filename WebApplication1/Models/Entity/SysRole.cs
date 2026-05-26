using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("sys_role")]
    public class SysRole
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string RoleName { get; set; }

        [MaxLength(200)]
        public string RoleDesc { get; set; }

        [Column(TypeName = "text")]
        public string Permissions { get; set; }

        public DateTime CreateTime { get; set; } = DateTime.Now;
    }
}