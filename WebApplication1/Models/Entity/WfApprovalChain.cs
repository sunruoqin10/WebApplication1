using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApplication1.Models.Entity
{
    [Table("wf_approval_chain")]
    public class WfApprovalChain
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int TemplateId { get; set; }

        public int Level { get; set; }

        [MaxLength(20)]
        public string ApproverType { get; set; }

        public int? ApproverId { get; set; }

        public int? ApproverRoleId { get; set; }

        public DateTime CreateTime { get; set; } = DateTime.Now;

        [ForeignKey("TemplateId")]
        public virtual WfTemplate Template { get; set; }

        [ForeignKey("ApproverId")]
        public virtual SysUser Approver { get; set; }

        [ForeignKey("ApproverRoleId")]
        public virtual SysRole ApproverRole { get; set; }
    }
}