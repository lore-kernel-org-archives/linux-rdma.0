From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RESUBMIT PATCH v2 06/14] staging/rdma/hfi1: Remove un-needed variable
Date: Mon, 11 Jan 2016 12:56:42 -0500
Message-ID: <1452535010-14087-7-git-send-email-ira.weiny@intel.com>
References: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452535010-14087-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is no need to use a separate variable for a
return value and a label when returning right away
would do just as well.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index c66693532be0..76fe60315bb4 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1037,22 +1037,19 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo)
 {
-	int ret = 0;
 	unsigned num_subctxts;
 
 	num_subctxts = uinfo->subctxt_cnt;
-	if (num_subctxts > HFI1_MAX_SHARED_CTXTS) {
-		ret = -EINVAL;
-		goto bail;
-	}
+	if (num_subctxts > HFI1_MAX_SHARED_CTXTS)
+		return -EINVAL;
 
 	uctxt->subctxt_cnt = uinfo->subctxt_cnt;
 	uctxt->subctxt_id = uinfo->subctxt_id;
 	uctxt->active_slaves = 1;
 	uctxt->redirect_seq_cnt = 1;
 	set_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
-bail:
-	return ret;
+
+	return 0;
 }
 
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
