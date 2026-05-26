using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("sys_department")]
    public class SysDepartment
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string DeptName { get; set; }

        public int ParentId { get; set; } = 0;

        public int? LeaderId { get; set; }

        public int SortOrder { get; set; } = 0;

        public DateTime CreateTime { get; set; } = DateTime.Now;

        [ForeignKey("ParentId")]
        public virtual SysDepartment Parent { get; set; }

        public virtual ICollection<SysDepartment> Children { get; set; }

        public virtual ICollection<SysUser> Users { get; set; }
    }
}