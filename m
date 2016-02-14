From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/12] IB/rdmavt: Remove RVT_FLAGs
Date: Sun, 14 Feb 2016 12:11:03 -0800
Message-ID: <20160214201100.1410.58605.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While hfi1 and qib were still supporting bits and pieces of core verbs
components there needed to be a way to convey if rdmavt should handle
allocation and initialize of resources like the queue pair table. Now
that all of this is moved into rdmavt there is no need for these flags.
They are no longer used in the drivers.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/cq.c |    5 -----
 drivers/infiniband/sw/rdmavt/mr.c |    5 -----
 drivers/infiniband/sw/rdmavt/qp.c |    8 --------
 include/rdma/rdma_vt.h            |   10 ----------
 4 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index c69c070..b1ffc8b 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -508,11 +508,6 @@ int rvt_driver_cq_init(struct rvt_dev_info *rdi)
 	int cpu;
 	struct task_struct *task;
 
-	if (rdi->flags & RVT_FLAG_CQ_INIT_DRIVER) {
-		rvt_pr_info(rdi, "Driver is doing CQ init.\n");
-		return 0;
-	}
-
 	if (rdi->worker)
 		return 0;
 	rdi->worker = kzalloc(sizeof(*rdi->worker), GFP_KERNEL);
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 8549652..4d5ef73 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -66,11 +66,6 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 	unsigned lk_tab_size;
 	int i;
 
-	if (rdi->flags & RVT_FLAG_MR_INIT_DRIVER) {
-		rvt_pr_info(rdi, "Driver is doing MR init.\n");
-		return 0;
-	}
-
 	/*
 	 * The top hfi1_lkey_table_size bits are used to index the
 	 * table.  The lower 8 bits can be owned by the user (copied from
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 5809562..441e17a 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -173,11 +173,6 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 	int i;
 	int ret = -ENOMEM;
 
-	if (rdi->flags & RVT_FLAG_QP_INIT_DRIVER) {
-		rvt_pr_info(rdi, "Driver is doing QP init.\n");
-		return 0;
-	}
-
 	if (!rdi->dparms.qp_table_size)
 		return -EINVAL;
 
@@ -284,9 +279,6 @@ void rvt_qp_exit(struct rvt_dev_info *rdi)
 	if (!rdi->qp_dev)
 		return;
 
-	if (rdi->flags & RVT_FLAG_QP_INIT_DRIVER)
-		return; /* driver did the qp init so nothing else to do */
-
 	kfree(rdi->qp_dev->qp_table);
 	free_qpn_table(&rdi->qp_dev->qpn_table);
 	kfree(rdi->qp_dev);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 2c3a04c..264c514 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -60,16 +60,6 @@
 #include <rdma/rdmavt_mr.h>
 #include <rdma/rdmavt_qp.h>
 
-/*
- * For some of the IBTA objects there will likely be some
- * initializations required. We need flags to determine whether it is OK
- * for rdmavt to do this or not. This does not imply any functions of a
- * partiuclar IBTA object are overridden.
- */
-#define RVT_FLAG_MR_INIT_DRIVER BIT(1)
-#define RVT_FLAG_QP_INIT_DRIVER BIT(2)
-#define RVT_FLAG_CQ_INIT_DRIVER BIT(3)
-
 #define RVT_MAX_PKEY_VALUES 16
 
 struct rvt_ibport {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
