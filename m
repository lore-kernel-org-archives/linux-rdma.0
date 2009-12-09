From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/11] RDMA/nes: free kmap() resources
Date: Wed, 9 Dec 2009 16:43:02 -0600
Message-ID: <20091209224302.GA127508@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We fail in creating many qps as kmap() fails for sq_vbase.
Now we do kunmap() as soon as we are done with sq_vbase.
We do kunmap() in one of the locations below.
(1) nes_destroy_qp()
(2) nes_accept()
(3) nes_connect_event
We set a flag, to not cause multiple calls to kunmap().

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c    |   10 ++++++++++
 drivers/infiniband/hw/nes/nes_verbs.c |   10 ++++++++--
 drivers/infiniband/hw/nes/nes_verbs.h |    1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a258168..b139806 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -52,6 +52,7 @@
 #include <linux/random.h>
 #include <linux/list.h>
 #include <linux/threads.h>
+#include <linux/highmem.h>
 #include <net/arp.h>
 #include <net/neighbour.h>
 #include <net/route.h>
@@ -2836,6 +2837,10 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			cpu_to_le32(conn_param->private_data_len +
 			sizeof(struct ietf_mpa_frame));
 		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = ibmr->lkey;
+		if (nesqp->sq_kmapped) {
+			nesqp->sq_kmapped = 0;
+			kunmap(nesqp->page);
+		}
 
 		nesqp->nesqp_context->ird_ord_sizes |=
 			cpu_to_le32(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
@@ -3304,6 +3309,11 @@ static void cm_event_connected(struct nes_cm_event *event)
 		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] = 0;
 		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = 0;
 
+		if (nesqp->sq_kmapped) {
+			nesqp->sq_kmapped = 0;
+			kunmap(nesqp->page);
+		}
+
 		/* use the reserved spot on the WQ for the extra first WQE */
 		nesqp->nesqp_context->ird_ord_sizes &=
 			cpu_to_le32(~(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index de53e88..d8a79fd 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1015,6 +1015,7 @@ static int nes_setup_virt_qp(struct nes_qp *nesqp, struct nes_pbl *nespbl,
 		kunmap(nesqp->page);
 		return -ENOMEM;
 	}
+	nesqp->sq_kmapped = 1;
 	nesqp->hwqp.q2_vbase = mem;
 	mem += 256;
 	memset(nesqp->hwqp.q2_vbase, 0, 256);
@@ -1092,7 +1093,10 @@ static inline void nes_free_qp_mem(struct nes_device *nesdev,
 		pci_free_consistent(nesdev->pcidev, nesqp->qp_mem_size, nesqp->hwqp.q2_vbase, nesqp->hwqp.q2_pbase);
 		pci_free_consistent(nesdev->pcidev, 256, nesqp->pbl_vbase, nesqp->pbl_pbase );
 		nesqp->pbl_vbase = NULL;
-		kunmap(nesqp->page);
+		if (nesqp->sq_kmapped) {
+			nesqp->sq_kmapped = 0;
+			kunmap(nesqp->page);
+		}
 	}
 }
 
@@ -1501,8 +1505,10 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 				nes_ucontext->first_free_wq = nesqp->mmap_sq_db_index;
 			}
 		}
-		if (nesqp->pbl_pbase)
+		if (nesqp->pbl_pbase && nesqp->sq_kmapped) {
+			nesqp->sq_kmapped = 0;
 			kunmap(nesqp->page);
+		}
 	} else {
 		/* Clean any pending completions from the cq(s) */
 		if (nesqp->nesscq)
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index cc7a604..2df9993 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -175,5 +175,6 @@ struct nes_qp {
 	u8                    hw_iwarp_state;
 	u8                    hw_tcp_state;
 	u8                    term_flags;
+	u8                    sq_kmapped;
 };
 #endif			/* NES_VERBS_H */
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
