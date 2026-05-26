using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("wf_history")]
    public class WfHistory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int InstanceId { get; set; }

        public int Level { get; set; }

        public int ApproverId { get; set; }

        [MaxLength(20)]
        public string Action { get; set; }

        [Column(TypeName = "text")]
        public string Comment { get; set; }

        public DateTime CreateTime { get; set; } = DateTime.Now;

        [ForeignKey("InstanceId")]
        public virtual WfInstance Instance { get; set; }

        [ForeignKey("ApproverId")]
        public virtual SysUser Approver { get; set; }
    }
}