From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rxe: impoved debug prints & other code cleanup
Date: Wed, 28 Sep 2016 20:26:26 +0000
Message-ID: <1475094386-18449-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

1. Debugging qp state transitions and qp errors in loopback and
multiple QP tests is difficult without qp numbers in debug logs.
This patch adds qp number to important debug logs.

2. Instead of having rxe: prefix in few logs and not having in
few logs, using uniform module name prefix using pr_fmt macro.

3. Code cleanup for various warnings reported by checkpatch for
incomplete unsigned data type, line over 80 characters, return
statements.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.c       | 12 ++++++------
 drivers/infiniband/sw/rxe/rxe.h       |  5 +++++
 drivers/infiniband/sw/rxe/rxe_av.c    |  4 ++--
 drivers/infiniband/sw/rxe/rxe_comp.c  |  6 ++++--
 drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c   | 16 +++++++---------
 drivers/infiniband/sw/rxe/rxe_qp.c    | 31 +++++++++++++++++--------------
 drivers/infiniband/sw/rxe/rxe_recv.c  |  3 ++-
 drivers/infiniband/sw/rxe/rxe_req.c   | 19 ++++++++++---------
 drivers/infiniband/sw/rxe/rxe_resp.c  | 25 +++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_sysfs.c | 12 ++++++------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 12 +++++++-----
 13 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index ddd5927..006817b 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -358,31 +358,31 @@ static int __init rxe_module_init(void)
 	/* initialize slab caches for managed objects */
 	err = rxe_cache_init();
 	if (err) {
-		pr_err("rxe: unable to init object pools\n");
+		pr_err("unable to init object pools\n");
 		return err;
 	}
 
 	err = rxe_net_ipv4_init();
 	if (err) {
-		pr_err("rxe: unable to init ipv4 tunnel\n");
+		pr_err("unable to init ipv4 tunnel\n");
 		rxe_cache_exit();
 		goto exit;
 	}
 
 	err = rxe_net_ipv6_init();
 	if (err) {
-		pr_err("rxe: unable to init ipv6 tunnel\n");
+		pr_err("unable to init ipv6 tunnel\n");
 		rxe_cache_exit();
 		goto exit;
 	}
 
 	err = register_netdevice_notifier(&rxe_net_notifier);
 	if (err) {
-		pr_err("rxe: Failed to rigister netdev notifier\n");
+		pr_err("Failed to rigister netdev notifier\n");
 		goto exit;
 	}
 
-	pr_info("rxe: loaded\n");
+	pr_info("loaded\n");
 
 	return 0;
 
@@ -398,7 +398,7 @@ static void __exit rxe_module_exit(void)
 	rxe_net_exit();
 	rxe_cache_exit();
 
-	pr_info("rxe: unloaded\n");
+	pr_info("unloaded\n");
 }
 
 module_init(rxe_module_init);
diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index 12c71c5..a696af8 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -34,6 +34,11 @@
 #ifndef RXE_H
 #define RXE_H
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 5c94742..604f6fe 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -39,7 +39,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr)
 	struct rxe_port *port;
 
 	if (attr->port_num != 1) {
-		pr_info("rxe: invalid port_num = %d\n", attr->port_num);
+		pr_info("invalid port_num = %d\n", attr->port_num);
 		return -EINVAL;
 	}
 
@@ -47,7 +47,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr)
 
 	if (attr->ah_flags & IB_AH_GRH) {
 		if (attr->grh.sgid_index > port->attr.gid_tbl_len) {
-			pr_info("rxe: invalid sgid index = %d\n",
+			pr_info("invalid sgid index = %d\n",
 				attr->grh.sgid_index);
 			return -EINVAL;
 		}
diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1c59ef2..6c5e29d 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -567,7 +567,8 @@ int rxe_completer(void *arg)
 	state = COMPST_GET_ACK;
 
 	while (1) {
-		pr_debug("state = %s\n", comp_state_name[state]);
+		pr_debug("qp#%d state = %s\n", qp_num(qp),
+			 comp_state_name[state]);
 		switch (state) {
 		case COMPST_GET_ACK:
 			skb = skb_dequeue(&qp->resp_pkts);
@@ -709,7 +710,8 @@ int rxe_completer(void *arg)
 					qp->comp.rnr_retry--;
 
 				qp->req.need_retry = 1;
-				pr_debug("set rnr nak timer\n");
+				pr_debug("qp#%d set rnr nak timer\n",
+					 qp_num(qp));
 				mod_timer(&qp->rnr_nak_timer,
 					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
 						& ~AETH_TYPE_MASK));
diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index 54b3c7c..c572a4c 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -126,7 +126,7 @@ found_it:
 
 	ret = remap_vmalloc_range(vma, ip->obj, 0);
 	if (ret) {
-		pr_err("rxe: err %d from remap_vmalloc_range\n", ret);
+		pr_err("err %d from remap_vmalloc_range\n", ret);
 		goto done;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index f3dab65..1869152 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -39,7 +39,7 @@
  */
 static u8 rxe_get_key(void)
 {
-	static unsigned key = 1;
+	static u32 key = 1;
 
 	key = key << 1;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 549aa84..f08609c 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -65,7 +65,7 @@ struct rxe_dev *net_to_rxe(struct net_device *ndev)
 	return found;
 }
 
-struct rxe_dev *get_rxe_by_name(const char* name)
+struct rxe_dev *get_rxe_by_name(const char *name)
 {
 	struct rxe_dev *rxe;
 	struct rxe_dev *found = NULL;
@@ -601,8 +601,7 @@ void rxe_port_up(struct rxe_dev *rxe)
 	port->attr.phys_state = IB_PHYS_STATE_LINK_UP;
 
 	rxe_port_event(rxe, IB_EVENT_PORT_ACTIVE);
-	pr_info("rxe: set %s active\n", rxe->ib_dev.name);
-	return;
+	pr_info("set %s active\n", rxe->ib_dev.name);
 }
 
 /* Caller must hold net_info_lock */
@@ -615,8 +614,7 @@ void rxe_port_down(struct rxe_dev *rxe)
 	port->attr.phys_state = IB_PHYS_STATE_LINK_DOWN;
 
 	rxe_port_event(rxe, IB_EVENT_PORT_ERR);
-	pr_info("rxe: set %s down\n", rxe->ib_dev.name);
-	return;
+	pr_info("set %s down\n", rxe->ib_dev.name);
 }
 
 static int rxe_notify(struct notifier_block *not_blk,
@@ -641,7 +639,7 @@ static int rxe_notify(struct notifier_block *not_blk,
 		rxe_port_down(rxe);
 		break;
 	case NETDEV_CHANGEMTU:
-		pr_info("rxe: %s changed mtu to %d\n", ndev->name, ndev->mtu);
+		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
 		rxe_set_mtu(rxe, ndev->mtu);
 		break;
 	case NETDEV_REBOOT:
@@ -651,7 +649,7 @@ static int rxe_notify(struct notifier_block *not_blk,
 	case NETDEV_CHANGENAME:
 	case NETDEV_FEAT_CHANGE:
 	default:
-		pr_info("rxe: ignoring netdev event = %ld for %s\n",
+		pr_info("ignoring netdev event = %ld for %s\n",
 			event, ndev->name);
 		break;
 	}
@@ -671,7 +669,7 @@ int rxe_net_ipv4_init(void)
 				htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(recv_sockets.sk4)) {
 		recv_sockets.sk4 = NULL;
-		pr_err("rxe: Failed to create IPv4 UDP tunnel\n");
+		pr_err("Failed to create IPv4 UDP tunnel\n");
 		return -1;
 	}
 
@@ -688,7 +686,7 @@ int rxe_net_ipv6_init(void)
 						htons(ROCE_V2_UDP_DPORT), true);
 	if (IS_ERR(recv_sockets.sk6)) {
 		recv_sockets.sk6 = NULL;
-		pr_err("rxe: Failed to create IPv6 UDP tunnel\n");
+		pr_err("Failed to create IPv6 UDP tunnel\n");
 		return -1;
 	}
 #endif
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 22ba24f..f2c0dc2 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -298,8 +298,8 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 		wqe_size = rcv_wqe_size(qp->rq.max_sge);
 
-		pr_debug("max_wr = %d, max_sge = %d, wqe_size = %d\n",
-			 qp->rq.max_wr, qp->rq.max_sge, wqe_size);
+		pr_debug("qp#%d max_wr = %d, max_sge = %d, wqe_size = %d\n",
+			 qp_num(qp), qp->rq.max_wr, qp->rq.max_sge, wqe_size);
 
 		qp->rq.queue = rxe_queue_init(rxe,
 					      &qp->rq.max_wr,
@@ -673,24 +673,27 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 	if (mask & IB_QP_RETRY_CNT) {
 		qp->attr.retry_cnt = attr->retry_cnt;
 		qp->comp.retry_cnt = attr->retry_cnt;
-		pr_debug("set retry count = %d\n", attr->retry_cnt);
+		pr_debug("qp#%d set retry count = %d\n", qp_num(qp),
+			 attr->retry_cnt);
 	}
 
 	if (mask & IB_QP_RNR_RETRY) {
 		qp->attr.rnr_retry = attr->rnr_retry;
 		qp->comp.rnr_retry = attr->rnr_retry;
-		pr_debug("set rnr retry count = %d\n", attr->rnr_retry);
+		pr_debug("qp#%d set rnr retry count = %d\n", qp_num(qp),
+			 attr->rnr_retry);
 	}
 
 	if (mask & IB_QP_RQ_PSN) {
 		qp->attr.rq_psn = (attr->rq_psn & BTH_PSN_MASK);
 		qp->resp.psn = qp->attr.rq_psn;
-		pr_debug("set resp psn = 0x%x\n", qp->resp.psn);
+		pr_debug("qp#%d set resp psn = 0x%x\n", qp_num(qp),
+			 qp->resp.psn);
 	}
 
 	if (mask & IB_QP_MIN_RNR_TIMER) {
 		qp->attr.min_rnr_timer = attr->min_rnr_timer;
-		pr_debug("set min rnr timer = 0x%x\n",
+		pr_debug("qp#%d set min rnr timer = 0x%x\n", qp_num(qp),
 			 attr->min_rnr_timer);
 	}
 
@@ -698,7 +701,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		qp->attr.sq_psn = (attr->sq_psn & BTH_PSN_MASK);
 		qp->req.psn = qp->attr.sq_psn;
 		qp->comp.psn = qp->attr.sq_psn;
-		pr_debug("set req psn = 0x%x\n", qp->req.psn);
+		pr_debug("qp#%d set req psn = 0x%x\n", qp_num(qp), qp->req.psn);
 	}
 
 	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
@@ -717,38 +720,38 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 
 		switch (attr->qp_state) {
 		case IB_QPS_RESET:
-			pr_debug("qp state -> RESET\n");
+			pr_debug("qp#%d state -> RESET\n", qp_num(qp));
 			rxe_qp_reset(qp);
 			break;
 
 		case IB_QPS_INIT:
-			pr_debug("qp state -> INIT\n");
+			pr_debug("qp#%d state -> INIT\n", qp_num(qp));
 			qp->req.state = QP_STATE_INIT;
 			qp->resp.state = QP_STATE_INIT;
 			break;
 
 		case IB_QPS_RTR:
-			pr_debug("qp state -> RTR\n");
+			pr_debug("qp#%d state -> RTR\n", qp_num(qp));
 			qp->resp.state = QP_STATE_READY;
 			break;
 
 		case IB_QPS_RTS:
-			pr_debug("qp state -> RTS\n");
+			pr_debug("qp#%d state -> RTS\n", qp_num(qp));
 			qp->req.state = QP_STATE_READY;
 			break;
 
 		case IB_QPS_SQD:
-			pr_debug("qp state -> SQD\n");
+			pr_debug("qp#%d state -> SQD\n", qp_num(qp));
 			rxe_qp_drain(qp);
 			break;
 
 		case IB_QPS_SQE:
-			pr_warn("qp state -> SQE !!?\n");
+			pr_warn("qp#%d state -> SQE !!?\n", qp_num(qp));
 			/* Not possible from modify_qp. */
 			break;
 
 		case IB_QPS_ERR:
-			pr_debug("qp state -> ERR\n");
+			pr_debug("qp#%d state -> ERR\n", qp_num(qp));
 			rxe_qp_error(qp);
 			break;
 		}
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 144d2f1..46f0628 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -387,7 +387,8 @@ int rxe_rcv(struct sk_buff *skb)
 	pack_icrc = be32_to_cpu(*icrcp);
 
 	calc_icrc = rxe_icrc_hdr(pkt, skb);
-	calc_icrc = crc32_le(calc_icrc, (u8 *)payload_addr(pkt), payload_size(pkt));
+	calc_icrc = crc32_le(calc_icrc, (u8 *)payload_addr(pkt),
+			     payload_size(pkt));
 	calc_icrc = cpu_to_be32(~calc_icrc);
 	if (unlikely(calc_icrc != pack_icrc)) {
 		char saddr[sizeof(struct in6_addr)];
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 13a848a..832846b 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -38,7 +38,7 @@
 #include "rxe_queue.h"
 
 static int next_opcode(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-		       unsigned opcode);
+		       u32 opcode);
 
 static inline void retry_first_write_send(struct rxe_qp *qp,
 					  struct rxe_send_wqe *wqe,
@@ -121,7 +121,7 @@ void rnr_nak_timer(unsigned long data)
 {
 	struct rxe_qp *qp = (struct rxe_qp *)data;
 
-	pr_debug("rnr nak timer fired\n");
+	pr_debug("qp#%d rnr nak timer fired\n", qp_num(qp));
 	rxe_run_task(&qp->req.task, 1);
 }
 
@@ -187,7 +187,7 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 	return wqe;
 }
 
-static int next_opcode_rc(struct rxe_qp *qp, unsigned opcode, int fits)
+static int next_opcode_rc(struct rxe_qp *qp, u32 opcode, int fits)
 {
 	switch (opcode) {
 	case IB_WR_RDMA_WRITE:
@@ -259,7 +259,7 @@ static int next_opcode_rc(struct rxe_qp *qp, unsigned opcode, int fits)
 	return -EINVAL;
 }
 
-static int next_opcode_uc(struct rxe_qp *qp, unsigned opcode, int fits)
+static int next_opcode_uc(struct rxe_qp *qp, u32 opcode, int fits)
 {
 	switch (opcode) {
 	case IB_WR_RDMA_WRITE:
@@ -311,7 +311,7 @@ static int next_opcode_uc(struct rxe_qp *qp, unsigned opcode, int fits)
 }
 
 static int next_opcode(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-		       unsigned opcode)
+		       u32 opcode)
 {
 	int fits = (wqe->dma.resid <= qp->mtu);
 
@@ -588,7 +588,7 @@ int rxe_requester(void *arg)
 	struct rxe_pkt_info pkt;
 	struct sk_buff *skb;
 	struct rxe_send_wqe *wqe;
-	unsigned mask;
+	enum rxe_hdr_mask mask;
 	int payload;
 	int mtu;
 	int opcode;
@@ -626,7 +626,8 @@ next_wqe:
 			rmr = rxe_pool_get_index(&rxe->mr_pool,
 						 wqe->wr.ex.invalidate_rkey >> 8);
 			if (!rmr) {
-				pr_err("No mr for key %#x\n", wqe->wr.ex.invalidate_rkey);
+				pr_err("No mr for key %#x\n",
+				       wqe->wr.ex.invalidate_rkey);
 				wqe->state = wqe_state_error;
 				wqe->status = IB_WC_MW_BIND_ERR;
 				goto exit;
@@ -702,12 +703,12 @@ next_wqe:
 
 	skb = init_req_packet(qp, wqe, opcode, payload, &pkt);
 	if (unlikely(!skb)) {
-		pr_err("Failed allocating skb\n");
+		pr_err("qp#%d Failed allocating skb\n", qp_num(qp));
 		goto err;
 	}
 
 	if (fill_packet(qp, wqe, &pkt, skb, payload)) {
-		pr_debug("Error during fill packet\n");
+		pr_debug("qp#%d Error during fill packet\n", qp_num(qp));
 		goto err;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 3e0f0f2..d0be8f2 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -749,6 +749,18 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	return state;
 }
 
+static void build_rdma_network_hdr(union rdma_network_hdr *hdr,
+				   struct rxe_pkt_info *pkt)
+{
+	struct sk_buff *skb = PKT_TO_SKB(pkt);
+
+	memset(hdr, 0, sizeof(*hdr));
+	if (skb->protocol == htons(ETH_P_IP))
+		memcpy(&hdr->roce4grh, ip_hdr(skb), sizeof(hdr->roce4grh));
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		memcpy(&hdr->ibgrh, ipv6_hdr(skb), sizeof(hdr->ibgrh));
+}
+
 /* Executes a new request. A retried request never reach that function (send
  * and writes are discarded, and reads and atomics are retried elsewhere.
  */
@@ -761,13 +773,8 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 		    qp_type(qp) == IB_QPT_SMI ||
 		    qp_type(qp) == IB_QPT_GSI) {
 			union rdma_network_hdr hdr;
-			struct sk_buff *skb = PKT_TO_SKB(pkt);
 
-			memset(&hdr, 0, sizeof(hdr));
-			if (skb->protocol == htons(ETH_P_IP))
-				memcpy(&hdr.roce4grh, ip_hdr(skb), sizeof(hdr.roce4grh));
-			else if (skb->protocol == htons(ETH_P_IPV6))
-				memcpy(&hdr.ibgrh, ipv6_hdr(skb), sizeof(hdr.ibgrh));
+			build_rdma_network_hdr(&hdr, pkt);
 
 			err = send_data_in(qp, &hdr, sizeof(hdr));
 			if (err)
@@ -881,7 +888,8 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 				rmr = rxe_pool_get_index(&rxe->mr_pool,
 							 wc->ex.invalidate_rkey >> 8);
 				if (unlikely(!rmr)) {
-					pr_err("Bad rkey %#x invalidation\n", wc->ex.invalidate_rkey);
+					pr_err("Bad rkey %#x invalidation\n",
+					       wc->ex.invalidate_rkey);
 					return RESPST_ERROR;
 				}
 				rmr->state = RXE_MEM_STATE_FREE;
@@ -1208,7 +1216,8 @@ int rxe_responder(void *arg)
 	}
 
 	while (1) {
-		pr_debug("state = %s\n", resp_state_name[state]);
+		pr_debug("qp#%d state = %s\n", qp_num(qp),
+			 resp_state_name[state]);
 		switch (state) {
 		case RESPST_GET_REQ:
 			state = get_req(qp, &pkt);
diff --git a/drivers/infiniband/sw/rxe/rxe_sysfs.c b/drivers/infiniband/sw/rxe/rxe_sysfs.c
index cf8e778..d5ed757 100644
--- a/drivers/infiniband/sw/rxe/rxe_sysfs.c
+++ b/drivers/infiniband/sw/rxe/rxe_sysfs.c
@@ -79,7 +79,7 @@ static int rxe_param_set_add(const char *val, const struct kernel_param *kp)
 
 	len = sanitize_arg(val, intf, sizeof(intf));
 	if (!len) {
-		pr_err("rxe: add: invalid interface name\n");
+		pr_err("add: invalid interface name\n");
 		err = -EINVAL;
 		goto err;
 	}
@@ -92,20 +92,20 @@ static int rxe_param_set_add(const char *val, const struct kernel_param *kp)
 	}
 
 	if (net_to_rxe(ndev)) {
-		pr_err("rxe: already configured on %s\n", intf);
+		pr_err("already configured on %s\n", intf);
 		err = -EINVAL;
 		goto err;
 	}
 
 	rxe = rxe_net_add(ndev);
 	if (!rxe) {
-		pr_err("rxe: failed to add %s\n", intf);
+		pr_err("failed to add %s\n", intf);
 		err = -EINVAL;
 		goto err;
 	}
 
 	rxe_set_port_state(ndev);
-	pr_info("rxe: added %s to %s\n", rxe->ib_dev.name, intf);
+	pr_info("added %s to %s\n", rxe->ib_dev.name, intf);
 err:
 	if (ndev)
 		dev_put(ndev);
@@ -120,7 +120,7 @@ static int rxe_param_set_remove(const char *val, const struct kernel_param *kp)
 
 	len = sanitize_arg(val, intf, sizeof(intf));
 	if (!len) {
-		pr_err("rxe: add: invalid interface name\n");
+		pr_err("add: invalid interface name\n");
 		return -EINVAL;
 	}
 
@@ -133,7 +133,7 @@ static int rxe_param_set_remove(const char *val, const struct kernel_param *kp)
 	rxe = get_rxe_by_name(intf);
 
 	if (!rxe) {
-		pr_err("rxe: not configured on %s\n", intf);
+		pr_err("not configured on %s\n", intf);
 		return -EINVAL;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index a5af691..19841c8 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -100,10 +100,12 @@ static int rxe_query_port(struct ib_device *dev,
 		rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
 		speed = cmd.speed;
 	} else {
-		pr_warn("%s speed is unknown, defaulting to 1000\n", rxe->ndev->name);
+		pr_warn("%s speed is unknown, defaulting to 1000\n",
+			rxe->ndev->name);
 		speed = 1000;
 	}
-	rxe_eth_speed_to_ib_speed(speed, &attr->active_speed, &attr->active_width);
+	rxe_eth_speed_to_ib_speed(speed, &attr->active_speed,
+				  &attr->active_width);
 	mutex_unlock(&rxe->usdev_lock);
 
 	return 0;
@@ -761,7 +763,7 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 }
 
 static int post_one_send(struct rxe_qp *qp, struct ib_send_wr *ibwr,
-			 unsigned mask, u32 length)
+			 unsigned int mask, u32 length)
 {
 	int err;
 	struct rxe_sq *sq = &qp->sq;
@@ -1145,8 +1147,8 @@ static int rxe_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-static int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-			 unsigned int *sg_offset)
+static int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+			 int sg_nents, unsigned int *sg_offset)
 {
 	struct rxe_mem *mr = to_rmr(ibmr);
 	int n;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
