From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 06/13] staging/rdma/hfi1: Move s_sde to the read mostly portion of the hfi1_qp structure
Date: Mon, 16 Nov 2015 21:59:28 -0500
Message-ID: <1447729175-28745-7-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This would reduce L2 cache misses on s_sde in the _hfi1_schedule_send
function when invoked from post_send thereby improving performance of
post_send.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 600bd1b..638094d 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -441,6 +441,7 @@ struct hfi1_qp {
 	struct hfi1_swqe *s_wq;  /* send work queue */
 	struct hfi1_mmap_info *ip;
 	struct ahg_ib_header *s_hdr;     /* next packet header to send */
+	struct sdma_engine *s_sde; /* current sde */
 	u8 s_sc;			/* SC[0..4] for next packet */
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
@@ -504,7 +505,6 @@ struct hfi1_qp {
 	struct hfi1_swqe *s_wqe;
 	struct hfi1_sge_state s_sge;     /* current send request data */
 	struct hfi1_mregion *s_rdma_mr;
-	struct sdma_engine *s_sde; /* current sde */
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
 	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
