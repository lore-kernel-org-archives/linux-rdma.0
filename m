From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/21] staging/rdma/hfi1: Add comment for spinlock_t
 definition
Date: Sun, 14 Feb 2016 20:21:34 -0800
Message-ID: <20160215042131.351.34725.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add comments describing the spinlock for spinlock_t definitions to
fix checkpatch check:
CHECK: spinlock_t definition without comment

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h  |    3 +++
 drivers/staging/rdma/hfi1/qsfp.h |    1 +
 drivers/staging/rdma/hfi1/sdma.h |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 805535e..774d8ff 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -313,6 +313,7 @@ struct hfi1_ctxtdata {
 	 */
 	struct task_struct *progress;
 	struct list_head sdma_queues;
+	/* protect sdma queues */
 	spinlock_t sdma_qlock;
 
 	/* Is ASPM interrupt supported for this context */
@@ -380,6 +381,7 @@ struct hfi1_snoop_data {
 	int mode_flag;
 	struct cdev cdev;
 	struct device *class_dev;
+	/* protect snoop data */
 	spinlock_t snoop_lock;
 	struct list_head queue;
 	wait_queue_head_t waitq;
@@ -561,6 +563,7 @@ enum {
 };
 
 struct vl_arb_cache {
+	/* protect vl arb cache */
 	spinlock_t lock;
 	struct ib_vl_weight_elem table[VL_ARB_TABLE_SIZE];
 };
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index 9f6e2f3..c391750 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -215,6 +215,7 @@ struct qsfp_data {
 	struct hfi1_pportdata *ppd;
 	struct work_struct qsfp_work;
 	u8 cache[QSFP_MAX_NUM_PAGES * 128];
+	/* protect qsfp data */
 	spinlock_t qsfp_lock;
 	u8 check_interrupt_flags;
 	u8 reset_needed;
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 0c5f501..5aec18b 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -412,6 +412,7 @@ struct sdma_engine {
 	u32                   progress_check_head;
 	/* private: */
 	struct work_struct flush_worker;
+	/* protect flush list */
 	spinlock_t flushlist_lock;
 	/* private: */
 	struct list_head flushlist;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
