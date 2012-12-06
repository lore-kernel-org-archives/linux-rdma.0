From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix for terminate timer crash
Date: Thu, 6 Dec 2012 13:58:27 -0600
Message-ID: <20121206195827.GA9996@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for terminate timer crash.
Nes terminate timer needs to be initialized just once.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h       |    1 +
 drivers/infiniband/hw/nes/nes_hw.c    |    9 ++-------
 drivers/infiniband/hw/nes/nes_verbs.c |    4 +++-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 5cac29e..33cc589 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -532,6 +532,7 @@ void nes_iwarp_ce_handler(struct nes_device *, struct nes_hw_cq *);
 int nes_destroy_cqp(struct nes_device *);
 int nes_nic_cm_xmit(struct sk_buff *, struct net_device *);
 void nes_recheck_link_status(struct work_struct *work);
+void nes_terminate_timeout(unsigned long context);
 
 /* nes_nic.c */
 struct net_device *nes_netdev_init(struct nes_device *, void __iomem *);
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index fe7965e..67647e2 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -75,7 +75,6 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 static void process_critical_error(struct nes_device *nesdev);
 static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number);
 static unsigned int nes_reset_adapter_ne020(struct nes_device *nesdev, u8 *OneG_Mode);
-static void nes_terminate_timeout(unsigned long context);
 static void nes_terminate_start_timer(struct nes_qp *nesqp);
 
 #ifdef CONFIG_INFINIBAND_NES_DEBUG
@@ -3520,7 +3519,7 @@ static void nes_terminate_received(struct nes_device *nesdev,
 }
 
 /* Timeout routine in case terminate fails to complete */
-static void nes_terminate_timeout(unsigned long context)
+void nes_terminate_timeout(unsigned long context)
 {
 	struct nes_qp *nesqp = (struct nes_qp *)(unsigned long)context;
 
@@ -3530,11 +3529,7 @@ static void nes_terminate_timeout(unsigned long context)
 /* Set a timer in case hw cannot complete the terminate sequence */
 static void nes_terminate_start_timer(struct nes_qp *nesqp)
 {
-	init_timer(&nesqp->terminate_timer);
-	nesqp->terminate_timer.function = nes_terminate_timeout;
-	nesqp->terminate_timer.expires = jiffies + HZ;
-	nesqp->terminate_timer.data = (unsigned long)nesqp;
-	add_timer(&nesqp->terminate_timer);
+	mod_timer(&nesqp->terminate_timer, (jiffies + HZ));
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index cd0ecb2..c47ec25 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1404,6 +1404,9 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	}
 
 	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
+	init_timer(&nesqp->terminate_timer);
+	nesqp->terminate_timer.function = nes_terminate_timeout;
+	nesqp->terminate_timer.data = (unsigned long)nesqp;
 
 	/* update the QP table */
 	nesdev->nesadapter->qp_table[nesqp->hwqp.qp_id-NES_FIRST_QPN] = nesqp;
@@ -1413,7 +1416,6 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	return &nesqp->ibqp;
 }
 
-
 /**
  * nes_clean_cq
  */
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
