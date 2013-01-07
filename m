From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 11/11] RDMA/cxgb4: Address sparse warnings
Date: Mon,  7 Jan 2013 18:42:00 +0530
Message-ID: <1357564320-15022-12-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It fixes following types of sparse warnings
- cast to pointer from integer of different size
- cast from pointer to integer of different size
- incorrect type in assignment (different base types)
- incorrect type in argument 1 (different base types)
- cast from restricted __be64
- cast from restricted __be32

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c     |   68 +++++++++++++++++++---------------
 drivers/infiniband/hw/cxgb4/device.c |    3 +-
 2 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 37ea2fc..dfca515 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1492,11 +1492,11 @@ static void send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 			V_FW_OFLD_CONNECTION_WR_ASTID(atid));
 	req->tcb.cplrxdataack_cplpassacceptrpl =
 			htons(F_FW_OFLD_CONNECTION_WR_CPLRXDATAACK);
-	req->tcb.tx_max = jiffies;
+	req->tcb.tx_max = (__force __be32) jiffies;
 	req->tcb.rcv_adv = htons(1);
 	cxgb4_best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx);
 	wscale = compute_wscale(rcv_win);
-	req->tcb.opt0 = TCAM_BYPASS(1) |
+	req->tcb.opt0 = (__force __be64) (TCAM_BYPASS(1) |
 		(nocong ? NO_CONG(1) : 0) |
 		KEEP_ALIVE(1) |
 		DELACK(1) |
@@ -1507,20 +1507,20 @@ static void send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 		SMAC_SEL(ep->smac_idx) |
 		DSCP(ep->tos) |
 		ULP_MODE(ULP_MODE_TCPDDP) |
-		RCV_BUFSIZ(rcv_win >> 10);
-	req->tcb.opt2 = PACE(1) |
+		RCV_BUFSIZ(rcv_win >> 10));
+	req->tcb.opt2 = (__force __be32) (PACE(1) |
 		TX_QUEUE(ep->com.dev->rdev.lldi.tx_modq[ep->tx_chan]) |
 		RX_CHANNEL(0) |
 		CCTRL_ECN(enable_ecn) |
-		RSS_QUEUE_VALID | RSS_QUEUE(ep->rss_qid);
+		RSS_QUEUE_VALID | RSS_QUEUE(ep->rss_qid));
 	if (enable_tcp_timestamps)
-		req->tcb.opt2 |= TSTAMPS_EN(1);
+		req->tcb.opt2 |= (__force __be32) TSTAMPS_EN(1);
 	if (enable_tcp_sack)
-		req->tcb.opt2 |= SACK_EN(1);
+		req->tcb.opt2 |= (__force __be32) SACK_EN(1);
 	if (wscale && enable_tcp_window_scaling)
-		req->tcb.opt2 |= WND_SCALE_EN(1);
-	req->tcb.opt0 = cpu_to_be64(req->tcb.opt0);
-	req->tcb.opt2 = cpu_to_be32(req->tcb.opt2);
+		req->tcb.opt2 |= (__force __be32) WND_SCALE_EN(1);
+	req->tcb.opt0 = cpu_to_be64((__force u64) req->tcb.opt0);
+	req->tcb.opt2 = cpu_to_be32((__force u32) req->tcb.opt2);
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, ep->ctrlq_idx);
 	set_bit(ACT_OFLD_CONN, &ep->com.history);
 	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
@@ -2773,7 +2773,8 @@ static void active_ofld_conn_reply(struct c4iw_dev *dev, struct sk_buff *skb,
 	struct c4iw_ep *ep;
 	int atid = be32_to_cpu(req->tid);
 
-	ep = (struct c4iw_ep *)lookup_atid(dev->rdev.lldi.tids, req->tid);
+	ep = (struct c4iw_ep *)lookup_atid(dev->rdev.lldi.tids,
+					   (__force u32) req->tid);
 	if (!ep)
 		return;
 
@@ -2817,7 +2818,7 @@ static void passive_ofld_conn_reply(struct c4iw_dev *dev, struct sk_buff *skb,
 	struct cpl_pass_accept_req *cpl;
 	int ret;
 
-	rpl_skb = (struct sk_buff *)cpu_to_be64(req->cookie);
+	rpl_skb = (__force struct sk_buff *)cpu_to_be64(req->cookie);
 	BUG_ON(!rpl_skb);
 	if (req->retval) {
 		PDBG("%s passive open failure %d\n", __func__, req->retval);
@@ -2828,7 +2829,8 @@ static void passive_ofld_conn_reply(struct c4iw_dev *dev, struct sk_buff *skb,
 	} else {
 		cpl = (struct cpl_pass_accept_req *)cplhdr(rpl_skb);
 		OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_PASS_ACCEPT_REQ,
-						      htonl(req->tid)));
+					(__force u32) htonl(
+					(__force u32) req->tid)));
 		ret = pass_accept_req(dev, rpl_skb);
 		if (!ret)
 			kfree_skb(rpl_skb);
@@ -2874,10 +2876,10 @@ static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
 	struct tcp_options_received tmp_opt;
 
 	/* Store values from cpl_rx_pkt in temporary location. */
-	vlantag = cpl->vlan;
-	len = cpl->len;
-	l2info  = cpl->l2info;
-	hdr_len = cpl->hdr_len;
+	vlantag = (__force u16) cpl->vlan;
+	len = (__force u16) cpl->len;
+	l2info  = (__force u32) cpl->l2info;
+	hdr_len = (__force u16) cpl->hdr_len;
 	intf = cpl->iff;
 
 	__skb_pull(skb, sizeof(*req) + sizeof(struct rss_header));
@@ -2888,19 +2890,24 @@ static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
 	 */
 	memset(&tmp_opt, 0, sizeof(tmp_opt));
 	tcp_clear_options(&tmp_opt);
-	tcp_parse_options(skb, &tmp_opt, 0, 0, NULL);
+	tcp_parse_options(skb, &tmp_opt, NULL, 0, NULL);
 
 	req = (struct cpl_pass_accept_req *)__skb_push(skb, sizeof(*req));
 	memset(req, 0, sizeof(*req));
 	req->l2info = cpu_to_be16(V_SYN_INTF(intf) |
-			 V_SYN_MAC_IDX(G_RX_MACIDX(htonl(l2info))) |
+			 V_SYN_MAC_IDX(G_RX_MACIDX(
+			 (__force int) htonl(l2info))) |
 			 F_SYN_XACT_MATCH);
-	req->hdr_len = cpu_to_be32(V_SYN_RX_CHAN(G_RX_CHAN(htonl(l2info))) |
-				V_TCP_HDR_LEN(G_RX_TCPHDR_LEN(htons(hdr_len))) |
-				V_IP_HDR_LEN(G_RX_IPHDR_LEN(htons(hdr_len))) |
-				V_ETH_HDR_LEN(G_RX_ETHHDR_LEN(htonl(l2info))));
-	req->vlan = vlantag;
-	req->len = len;
+	req->hdr_len = cpu_to_be32(V_SYN_RX_CHAN(G_RX_CHAN(
+					(__force int) htonl(l2info))) |
+				   V_TCP_HDR_LEN(G_RX_TCPHDR_LEN(
+					(__force int) htons(hdr_len))) |
+				   V_IP_HDR_LEN(G_RX_IPHDR_LEN(
+					(__force int) htons(hdr_len))) |
+				   V_ETH_HDR_LEN(G_RX_ETHHDR_LEN(
+					(__force int) htonl(l2info))));
+	req->vlan = (__force __be16) vlantag;
+	req->len = (__force __be16) len;
 	req->tos_stid = cpu_to_be32(PASS_OPEN_TID(stid) |
 				    PASS_OPEN_TOS(tos));
 	req->tcpopt.mss = htons(tmp_opt.mss_clamp);
@@ -2929,7 +2936,7 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL(1));
 	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
 	req->le.version_cpl = htonl(F_FW_OFLD_CONNECTION_WR_CPL);
-	req->le.filter = filter;
+	req->le.filter = (__force __be32) filter;
 	req->le.lport = lport;
 	req->le.pport = rport;
 	req->le.u.ipv4.lip = laddr;
@@ -2955,7 +2962,7 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	 * TP will ignore any value > 0 for MSS index.
 	 */
 	req->tcb.opt0 = cpu_to_be64(V_MSS_IDX(0xF));
-	req->cookie = cpu_to_be64((u64)skb);
+	req->cookie = (__force __u64) cpu_to_be64((u64)skb);
 
 	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
 	cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
@@ -3005,7 +3012,8 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	/*
 	 * Calculate the server tid from filter hit index from cpl_rx_pkt.
 	 */
-	stid = cpu_to_be32(rss->hash_val) - dev->rdev.lldi.tids->sftid_base
+	stid = (__force int) cpu_to_be32((__force u32) rss->hash_val)
+					  - dev->rdev.lldi.tids->sftid_base
 					  + dev->rdev.lldi.tids->nstids;
 
 	lep = (struct c4iw_ep *)lookup_stid(dev->rdev.lldi.tids, stid);
@@ -3066,10 +3074,10 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
 	rss_qid = dev->rdev.lldi.rxq_ids[pi->port_id * step];
-	window = htons(tcph->window);
+	window = (__force u16) htons((__force u16)tcph->window);
 
 	/* Calcuate filter portion for LE region. */
-	filter = cpu_to_be32(select_ntuple(dev, dst, e));
+	filter = (__force unsigned int) cpu_to_be32(select_ntuple(dev, dst, e));
 
 	/*
 	 * Synthesize the cpl_pass_accept_req. We have everything except the
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index ba11c76..dc6adb2 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -797,7 +797,8 @@ static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 		       "RSS %#llx, FL %#llx, len %u\n",
 		       pci_name(ctx->lldi.pdev), gl->va,
 		       (unsigned long long)be64_to_cpu(*rsp),
-		       (unsigned long long)be64_to_cpu(*(u64 *)gl->va),
+		       (unsigned long long)be64_to_cpu(
+		       *(__force __be64 *)gl->va),
 		       gl->tot_len);
 
 		return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
