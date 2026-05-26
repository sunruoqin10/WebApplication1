using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("sys_log")]
    public class SysLog
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int? UserId { get; set; }

        [MaxLength(100)]
        public string Action { get; set; }

        [MaxLength(50)]
        public string TargetType { get; set; }

        public int? TargetId { get; set; }

        [Column(TypeName = "text")]
        public string Detail { get; set; }

        [MaxLength(50)]
        public string IpAddress { get; set; }

        public DateTime CreateTime { get; set; } = DateTime.Now;

        [ForeignKey("UserId")]
        public virtual SysUser User { get; set; }
    }
}