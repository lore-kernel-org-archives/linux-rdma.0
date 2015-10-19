From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/23] staging/rdma/hfi1: close shared context security hole
Date: Mon, 19 Oct 2015 12:43:34 -0400
Message-ID: <1445273027-29634-11-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jareer Abdel-Qader <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jareer Abdel-Qader <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Driver does not verify userid for shared context assignments, allowing
malicious user access.

Reviewed by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jareer H Abdel-Qader <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 7d2868050981..3c9cae6f64a3 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -948,6 +948,7 @@ static int find_shared_ctxt(struct file *fp,
 			/* Skip ctxt if it doesn't match the requested one */
 			if (memcmp(uctxt->uuid, uinfo->uuid,
 				   sizeof(uctxt->uuid)) ||
+			    uctxt->jkey != generate_jkey(current_uid()) ||
 			    uctxt->subctxt_id != uinfo->subctxt_id ||
 			    uctxt->subctxt_cnt != uinfo->subctxt_cnt)
 				continue;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
