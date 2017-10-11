From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 27/45] IB/nes: Fix indentation
Date: Wed, 11 Oct 2017 10:49:09 -0700
Message-ID: <20171011174927.25113-28-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c       | 22 +++++++++++-----------
 drivers/infiniband/hw/nes/nes_hw.c    |  5 +++--
 drivers/infiniband/hw/nes/nes_nic.c   |  9 ++++-----
 drivers/infiniband/hw/nes/nes_utils.c |  8 ++++----
 drivers/infiniband/hw/nes/nes_verbs.c | 12 ++++++------
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 942ca84713c9..ff58dfa071b8 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -757,18 +757,18 @@ static void nes_remove(struct pci_dev *pcidev)
 	int netdev_index = 0;
 	unsigned long flags;
 
-		if (nesdev->netdev_count) {
-			netdev = nesdev->netdev[netdev_index];
-			if (netdev) {
-				netif_stop_queue(netdev);
-				unregister_netdev(netdev);
-				nes_netdev_destroy(netdev);
-
-				nesdev->netdev[netdev_index] = NULL;
-				nesdev->netdev_count--;
-				nesdev->nesadapter->netdev_count--;
-			}
+	if (nesdev->netdev_count) {
+		netdev = nesdev->netdev[netdev_index];
+		if (netdev) {
+			netif_stop_queue(netdev);
+			unregister_netdev(netdev);
+			nes_netdev_destroy(netdev);
+
+			nesdev->netdev[netdev_index] = NULL;
+			nesdev->netdev_count--;
+			nesdev->nesadapter->netdev_count--;
 		}
+	}
 
 	nes_notifiers_registered--;
 	if (nes_notifiers_registered == 0) {
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b0adf65e4bdb..812b59d8f13c 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1861,8 +1861,9 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 	}
 	if ((nesdev->nesadapter->allow_unaligned_fpdus) &&
 		(nes_init_mgt_qp(nesdev, netdev, nesvnic))) {
-			nes_debug(NES_DBG_INIT, "%s: Out of memory for pau nic\n", netdev->name);
-			nes_destroy_nic_qp(nesvnic);
+		nes_debug(NES_DBG_INIT, "%s: Out of memory for pau nic\n",
+			  netdev->name);
+		nes_destroy_nic_qp(nesvnic);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5921ea3d50ae..6977fcfcbb76 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -926,11 +926,10 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 				nesadapter->pft_mcast_map[mc_index] !=
 					nesvnic->nic_index &&
 					mc_index < max_pft_entries_avaiable) {
-						nes_debug(NES_DBG_NIC_RX,
-					"mc_index=%d skipping nic_index=%d, "
-					"used for=%d \n", mc_index,
-					nesvnic->nic_index,
-					nesadapter->pft_mcast_map[mc_index]);
+				nes_debug(NES_DBG_NIC_RX,
+					  "mc_index=%d skipping nic_index=%d, used for=%d\n",
+					  mc_index, nesvnic->nic_index,
+					  nesadapter->pft_mcast_map[mc_index]);
 				mc_index++;
 			}
 			if (mc_index >= max_pft_entries_avaiable)
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 37331e2fdc5f..7b67e9cb57ed 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -888,10 +888,10 @@ void nes_clc(unsigned long parm)
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 
 	spin_lock_irqsave(&nesadapter->phy_lock, flags);
-    nesadapter->link_interrupt_count[0] = 0;
-    nesadapter->link_interrupt_count[1] = 0;
-    nesadapter->link_interrupt_count[2] = 0;
-    nesadapter->link_interrupt_count[3] = 0;
+	nesadapter->link_interrupt_count[0] = 0;
+	nesadapter->link_interrupt_count[1] = 0;
+	nesadapter->link_interrupt_count[2] = 0;
+	nesadapter->link_interrupt_count[3] = 0;
 	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 
 	nesadapter->lc_timer.expires = jiffies + 3600 * HZ;  /* 1 hour */
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f0dc5f4aa177..6abe90b58c91 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2865,11 +2865,11 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 				next_iwarp_state = NES_CQP_QP_IWARP_STATE_ERROR;
 				/* next_iwarp_state = (NES_CQP_QP_IWARP_STATE_TERMINATE | 0x02000000); */
-					if (nesqp->hte_added) {
-						nes_debug(NES_DBG_MOD_QP, "set CQP_QP_DEL_HTE\n");
-						next_iwarp_state |= NES_CQP_QP_DEL_HTE;
-						nesqp->hte_added = 0;
-					}
+				if (nesqp->hte_added) {
+					nes_debug(NES_DBG_MOD_QP, "set CQP_QP_DEL_HTE\n");
+					next_iwarp_state |= NES_CQP_QP_DEL_HTE;
+					nesqp->hte_added = 0;
+				}
 				if ((nesqp->hw_tcp_state > NES_AEQE_TCP_STATE_CLOSED) &&
 						(nesdev->iw_status) &&
 						(nesqp->hw_tcp_state != NES_AEQE_TCP_STATE_TIME_WAIT)) {
@@ -3560,7 +3560,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 				entry->byte_len = le32_to_cpu(cqe.cqe_words[NES_CQE_PAYLOAD_LENGTH_IDX]);
 				wrid = ((u64)(le32_to_cpu(nesqp->hwqp.rq_vbase[wqe_index].wqe_words[NES_IWARP_RQ_WQE_COMP_SCRATCH_LOW_IDX]))) |
 					((u64)(le32_to_cpu(nesqp->hwqp.rq_vbase[wqe_index].wqe_words[NES_IWARP_RQ_WQE_COMP_SCRATCH_HIGH_IDX]))<<32);
-					entry->opcode = IB_WC_RECV;
+				entry->opcode = IB_WC_RECV;
 
 				nesqp->hwqp.rq_tail = (wqe_index+1)&(nesqp->hwqp.rq_size - 1);
 				if ((entry->status != IB_WC_SUCCESS) && (nesqp->hwqp.rq_tail != nesqp->hwqp.rq_head)) {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
