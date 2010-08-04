From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] RDMA/nes: Get rid of "set but not used" variables
Date: Wed, 04 Aug 2010 14:32:28 -0700
Message-ID: <ada7hk66p3n.fsf@roland-alpha.cisco.com>
References: <adabp9i6p63.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabp9i6p63.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org> (Roland Dreier's message
	of "Wed, 04 Aug 2010 14:31:00 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Delete dead code in various places that is shown by gcc 4.6's new
-Wunused-but-set-variable warnings.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c       |    5 -----
 drivers/infiniband/hw/nes/nes_cm.c    |    8 +-------
 drivers/infiniband/hw/nes/nes_hw.c    |    3 ---
 drivers/infiniband/hw/nes/nes_nic.c   |    2 --
 drivers/infiniband/hw/nes/nes_verbs.c |    5 +----
 5 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 16b7832..969a01c 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -259,13 +259,11 @@ static void nes_cqp_rem_ref_callback(struct nes_device *nesdev, struct nes_cqp_r
 	unsigned long flags;
 	struct nes_qp *nesqp = cqp_request->cqp_callback_pointer;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
-	u32 qp_id;
 
 	atomic_inc(&qps_destroyed);
 
 	/* Free the control structures */
 
-	qp_id = nesqp->hwqp.qp_id;
 	if (nesqp->pbl_vbase) {
 		pci_free_consistent(nesdev->pcidev, nesqp->qp_mem_size,
 				nesqp->hwqp.q2_vbase, nesqp->hwqp.q2_pbase);
@@ -441,7 +439,6 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	struct net_device *netdev = NULL;
 	struct nes_device *nesdev = NULL;
 	int ret = 0;
-	struct nes_vnic *nesvnic = NULL;
 	void __iomem *mmio_regs = NULL;
 	u8 hw_rev;
 
@@ -677,8 +674,6 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 		}
 
 		nes_print_macaddr(netdev);
-		/* create a CM core for this netdev */
-		nesvnic = netdev_priv(netdev);
 
 		nesdev->netdev_count++;
 		nesdev->nesadapter->netdev_count++;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index d400fa9..8bc11e1 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1719,8 +1719,6 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 {
 	int datasize = 0;
 	u32 inc_sequence;
-	u32 rem_seq_ack;
-	u32 rem_seq;
 	int ret = 0;
 	int optionsize;
 	optionsize = (tcph->doff << 2) - sizeof(struct tcphdr);
@@ -1730,8 +1728,6 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 
 	skb_pull(skb, tcph->doff << 2);
 	inc_sequence = ntohl(tcph->seq);
-	rem_seq = ntohl(tcph->seq);
-	rem_seq_ack =  ntohl(tcph->ack_seq);
 	datasize = skb->len;
 	switch (cm_node->state) {
 	case NES_CM_STATE_SYN_RCVD:
@@ -3128,17 +3124,15 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 	struct nes_vnic *nesvnic;
 	struct nes_cm_listener *cm_node;
 	struct nes_cm_info cm_info;
-	struct nes_adapter *adapter;
 	int err;
 
-
 	nes_debug(NES_DBG_CM, "cm_id = %p, local port = 0x%04X.\n",
 			cm_id, ntohs(cm_id->local_addr.sin_port));
 
 	nesvnic = to_nesvnic(cm_id->device);
 	if (!nesvnic)
 		return -EINVAL;
-	adapter = nesvnic->nesdev->nesadapter;
+
 	nes_debug(NES_DBG_CM, "nesvnic=%p, netdev=%p, %s\n",
 			nesvnic, nesvnic->netdev, nesvnic->netdev->name);
 
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 199107a..07c4004 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2999,11 +2999,8 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 
 static u8 *locate_mpa(u8 *pkt, u32 aeq_info)
 {
-	u16 pkt_len;
-
 	if (aeq_info & NES_AEQE_Q2_DATA_ETHERNET) {
 		/* skip over ethernet header */
-		pkt_len = be16_to_cpu(*(u16 *)(pkt + ETH_HLEN - 2));
 		pkt += ETH_HLEN;
 
 		/* Skip over IP and TCP headers */
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index c0c404e..1901ec7 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -470,7 +470,6 @@ static int nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	u16 nhoffset;
 	u16 wqes_needed;
 	u16 wqes_available;
-	u32 old_head;
 	u32 wqe_misc;
 
 	/*
@@ -510,7 +509,6 @@ sq_no_longer_full:
 		if (skb_is_gso(skb)) {
 			nesvnic->segmented_tso_requests++;
 			nesvnic->tso_requests++;
-			old_head = nesnic->sq_head;
 			/* Basically 4 fragments available per WQE with extended fragments */
 			wqes_needed = nr_frags >> 2;
 			wqes_needed += (nr_frags&3)?1:0;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 3638b83..9046e66 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2112,13 +2112,12 @@ static struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 	u32 driver_key = 0;
 	u32 root_pbl_index = 0;
 	u32 cur_pbl_index = 0;
-	int err = 0, pbl_depth = 0;
+	int err = 0;
 	int ret = 0;
 	u16 pbl_count = 0;
 	u8 single_page = 1;
 	u8 stag_key = 0;
 
-	pbl_depth = 0;
 	region_length = 0;
 	vpbl.pbl_vbase = NULL;
 	root_vpbl.pbl_vbase = NULL;
@@ -2931,7 +2930,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int ret;
 	u16 original_last_aeq;
 	u8 issue_modify_qp = 0;
-	u8 issue_disconnect = 0;
 	u8 dont_wait = 0;
 
 	nes_debug(NES_DBG_MOD_QP, "QP%u: QP State=%u, cur QP State=%u,"
@@ -3083,7 +3081,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			nesqp->iwarp_state = next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK;
 			nes_debug(NES_DBG_MOD_QP, "Change nesqp->iwarp_state=%08x\n",
 					nesqp->iwarp_state);
-			issue_disconnect = 1;
 		} else {
 			nesqp->iwarp_state = next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK;
 			nes_debug(NES_DBG_MOD_QP, "Change nesqp->iwarp_state=%08x\n",
-- 
1.7.2


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
