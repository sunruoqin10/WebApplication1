using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("wf_template")]
    public class WfTemplate
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string TemplateName { get; set; }

        [Required]
        [MaxLength(50)]
        public string TemplateCode { get; set; }

        [MaxLength(500)]
        public string Description { get; set; }

        [Column(TypeName = "text")]
        public string FormDefinition { get; set; }

        public byte Status { get; set; } = 1;

        public DateTime CreateTime { get; set; } = DateTime.Now;

        public DateTime? UpdateTime { get; set; }

        public virtual ICollection<WfApprovalChain> ApprovalChains { get; set; }

        public virtual ICollection<WfInstance> Instances { get; set; }
    }
}