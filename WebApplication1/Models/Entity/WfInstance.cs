using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("wf_instance")]
    public class WfInstance
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int TemplateId { get; set; }

        public int ApplicantId { get; set; }

        [Column(TypeName = "text")]
        public string FormData { get; set; }

        [MaxLength(20)]
        public string Status { get; set; } = "pending";

        public int CurrentLevel { get; set; } = 1;

        public DateTime CreateTime { get; set; } = DateTime.Now;

        public DateTime? UpdateTime { get; set; }

        [ForeignKey("TemplateId")]
        public virtual WfTemplate Template { get; set; }

        [ForeignKey("ApplicantId")]
        public virtual SysUser Applicant { get; set; }

        public virtual ICollection<WfTask> Tasks { get; set; }

        public virtual ICollection<WfHistory> Histories { get; set; }
    }
}