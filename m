From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/17] staging/rdma/hfi1: Fix qp.h comments
Date: Tue,  1 Dec 2015 15:38:13 -0500
Message-ID: <1449002306-15180-5-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes a few incorrect header file comments in qp.h

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/qp.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 94fd748..62a94c5 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -211,7 +211,7 @@ int hfi1_qp_init(struct hfi1_ibdev *dev);
 void hfi1_qp_exit(struct hfi1_ibdev *dev);
 
 /**
- * hfi1_qp_waitup - wake up on the indicated event
+ * hfi1_qp_wakeup - wake up on the indicated event
  * @qp: the QP
  * @flag: flag the qp on which the qp is stalled
  */
@@ -222,19 +222,19 @@ struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5);
 struct qp_iter;
 
 /**
- * qp_iter_init - wake up on the indicated event
+ * qp_iter_init - initialize the iterator for the qp hash list
  * @dev: the hfi1_ibdev
  */
 struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev);
 
 /**
- * qp_iter_next - wakeup on the indicated event
+ * qp_iter_next - Find the next qp in the hash list
  * @iter: the iterator for the qp hash list
  */
 int qp_iter_next(struct qp_iter *iter);
 
 /**
- * qp_iter_next - wake up on the indicated event
+ * qp_iter_print - print the qp information to seq_file
  * @s: the seq_file to emit the qp information on
  * @iter: the iterator for the qp hash list
  */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
