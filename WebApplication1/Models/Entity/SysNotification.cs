using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("sys_notification")]
    public class SysNotification
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int? UserId { get; set; }

        [MaxLength(200)]
        public string Title { get; set; }

        [Column(TypeName = "text")]
        public string Content { get; set; }

        [MaxLength(20)]
        public string Type { get; set; }

        public int? RelatedId { get; set; }

        public byte IsRead { get; set; } = 0;

        public DateTime CreateTime { get; set; } = DateTime.Now;

        [ForeignKey("UserId")]
        public virtual SysUser User { get; set; }
    }
}