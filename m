From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/54] staging/rdma/hfi1: Remove unnecessary duplicated
 variable
Date: Wed, 03 Feb 2016 14:33:31 -0800
Message-ID: <20160203223327.5923.17815.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

struct hfi1_devdata contained 2 variables which represented the numa
node the device is attached to.  Remove the duplicated one.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h   |    1 -
 drivers/staging/rdma/hfi1/init.c  |    5 -----
 drivers/staging/rdma/hfi1/qp.h    |    2 +-
 drivers/staging/rdma/hfi1/verbs.c |    2 +-
 4 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index cb2f90a..897046c 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1128,7 +1128,6 @@ struct hfi1_devdata {
 	struct timer_list rcverr_timer;
 	u32 rcv_ovfl_cnt;
 
-	int assigned_node_id;
 	wait_queue_head_t event_queue;
 
 	/* Save the enabled LCB error bits */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 1680808..17b876d 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -130,15 +130,10 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 {
 	unsigned i;
 	int ret;
-	int local_node_id = pcibus_to_node(dd->pcidev->bus);
 
 	/* Control context has to be always 0 */
 	BUILD_BUG_ON(HFI1_CTRL_CTXT != 0);
 
-	if (local_node_id < 0)
-		local_node_id = numa_node_id();
-	dd->assigned_node_id = local_node_id;
-
 	dd->rcd = kcalloc(dd->num_rcv_contexts, sizeof(*dd->rcd), GFP_KERNEL);
 	if (!dd->rcd)
 		goto nomem;
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 36be547..973c14b 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -157,7 +157,7 @@ static inline void _hfi1_schedule_send(struct rvt_qp *qp)
 	iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
 			priv->s_sde ?
 			priv->s_sde->cpu :
-			cpumask_first(cpumask_of_node(dd->assigned_node_id)));
+			cpumask_first(cpumask_of_node(dd->node)));
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 6d541ca..d617324 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1567,7 +1567,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
 		 sizeof(dd->verbs_dev.rdi.dparms.cq_name),
 		 "hfi1_cq%d", dd->unit);
-	dd->verbs_dev.rdi.dparms.node = dd->assigned_node_id;
+	dd->verbs_dev.rdi.dparms.node = dd->node;
 
 	/* misc settings */
 	dd->verbs_dev.rdi.flags = 0; /* Let rdmavt handle it all */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
