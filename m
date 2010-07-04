From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Sometimes ifdown command hangs
Date: Sat, 3 Jul 2010 19:17:59 -0500
Message-ID: <20100704001759.GA2716@FLATIF-MOBL3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When ib_unregister_device() is called from netdev stop during ifdown, it
sometimes hangs. Changes made to indicate port_err to ib_dispatch_event() during
netdev stop and port_active during netdev open. The ib_unregister_device()
is only called during remove of the module.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h       |    2 ++
 drivers/infiniband/hw/nes/nes_hw.c    |   12 +++++++++---
 drivers/infiniband/hw/nes/nes_nic.c   |   13 ++++++++++---
 drivers/infiniband/hw/nes/nes_verbs.c |   12 ++++++++++++
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index cc78fee..b3d145e 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -262,6 +262,7 @@ struct nes_device {
 	u16                    base_doorbell_index;
 	u16                    currcq_count;
 	u16                    deepcq_count;
+	u8                     iw_status;
 	u8                     msi_enabled;
 	u8                     netdev_count;
 	u8                     napi_isr_ran;
@@ -527,6 +528,7 @@ void nes_cm_disconn_worker(void *);
 int nes_hw_modify_qp(struct nes_device *, struct nes_qp *, u32, u32, u32);
 int nes_modify_qp(struct ib_qp *, struct ib_qp_attr *, int, struct ib_udata *);
 struct nes_ib_device *nes_init_ofa_device(struct net_device *);
+void  nes_port_ibevent(struct nes_vnic *nesvnic);
 void nes_destroy_ofa_device(struct nes_ib_device *);
 int nes_register_ofa_device(struct nes_ib_device *);
 
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 57874a1..679dd01 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3283,9 +3283,15 @@ static void nes_terminate_connection(struct nes_device *nesdev, struct nes_qp *n
 	else
 		mod_qp_flags |= NES_CQP_QP_TERM_DONT_SEND_TERM_MSG;
 
-	nes_terminate_start_timer(nesqp);
-	nesqp->term_flags |= NES_TERM_SENT;
-	nes_hw_modify_qp(nesdev, nesqp, mod_qp_flags, termlen, 0);
+	if (!nesdev->iw_status)  {
+		nesqp->term_flags = NES_TERM_DONE;
+		nes_hw_modify_qp(nesdev, nesqp, NES_CQP_QP_IWARP_STATE_ERROR, 0, 0);
+		nes_cm_disconn(nesqp);
+	} else {
+		nes_terminate_start_timer(nesqp);
+		nesqp->term_flags |= NES_TERM_SENT;
+		nes_hw_modify_qp(nesdev, nesqp, mod_qp_flags, termlen, 0);
+	}
 }
 
 static void nes_terminate_send_fin(struct nes_device *nesdev,
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5cc0a9a..c0c404e 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -232,6 +232,13 @@ static int nes_netdev_open(struct net_device *netdev)
 				NES_MAC_INT_TX_UNDERFLOW | NES_MAC_INT_TX_ERROR));
 		first_nesvnic = nesvnic;
 	}
+
+	if (nesvnic->of_device_registered) {
+		nesdev->iw_status = 1;
+		nesdev->nesadapter->send_term_ok = 1;
+		nes_port_ibevent(nesvnic);
+	}
+
 	if (first_nesvnic->linkup) {
 		/* Enable network packets */
 		nesvnic->linkup = 1;
@@ -309,9 +316,9 @@ static int nes_netdev_stop(struct net_device *netdev)
 
 
 	if (nesvnic->of_device_registered) {
-		nes_destroy_ofa_device(nesvnic->nesibdev);
-		nesvnic->nesibdev = NULL;
-		nesvnic->of_device_registered = 0;
+		nesdev->nesadapter->send_term_ok = 0;
+		nesdev->iw_status = 0;
+		nes_port_ibevent(nesvnic);
 	}
 	nes_destroy_nic_qp(nesvnic);
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 9bc2d74..3b95d04 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3058,6 +3058,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 						nesqp->hte_added = 0;
 					}
 				if ((nesqp->hw_tcp_state > NES_AEQE_TCP_STATE_CLOSED) &&
+						(nesdev->iw_status) &&
 						(nesqp->hw_tcp_state != NES_AEQE_TCP_STATE_TIME_WAIT)) {
 					next_iwarp_state |= NES_CQP_QP_RESET;
 				} else {
@@ -3936,6 +3937,17 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	return nesibdev;
 }
 
+void  nes_port_ibevent(struct nes_vnic *nesvnic)
+{
+	struct nes_ib_device *nesibdev = nesvnic->nesibdev;
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct ib_event event;
+	event.device = &nesibdev->ibdev;
+	event.element.port_num = nesvnic->logical_port + 1;
+	event.event = nesdev->iw_status ? IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
+	ib_dispatch_event(&event);
+}
+
 
 /**
  * nes_destroy_ofa_device
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
