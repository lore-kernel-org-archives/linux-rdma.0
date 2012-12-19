From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [infiniband:for-next 4/6]
 drivers/infiniband/hw/cxgb4/cm.c:2694:12: warning: cast to pointer from
 integer of different size
Date: Thu, 20 Dec 2012 02:49:32 +0800
Message-ID: <50d20c3c.PNa/XRRWXcY6p/B8%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
head:   73b32b46c1484afa58e959fb62f9979516341998
commit: fd56c2b766cdcfc0e3d31fc6c192536269f5b94d [4/6] RDMA/cxgb4: Fix LE hash collision bug for passive open connection
config: make ARCH=i386 allyesconfig

All warnings:

drivers/infiniband/hw/cxgb4/cm.c: In function 'passive_ofld_conn_reply':
drivers/infiniband/hw/cxgb4/cm.c:2694:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/infiniband/hw/cxgb4/cm.c: In function 'send_fw_pass_open_req':
drivers/infiniband/hw/cxgb4/cm.c:2829:57: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:92: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:155: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:218: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:281: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:343: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:405: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:468: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:531: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:596: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

vim +2694 drivers/infiniband/hw/cxgb4/cm.c

fd56c2b7 Vipul Pandya 2012-12-10  2688  			struct cpl_fw6_msg_ofld_connection_wr_rpl *req)
fd56c2b7 Vipul Pandya 2012-12-10  2689  {
fd56c2b7 Vipul Pandya 2012-12-10  2690  	struct sk_buff *rpl_skb;
fd56c2b7 Vipul Pandya 2012-12-10  2691  	struct cpl_pass_accept_req *cpl;
fd56c2b7 Vipul Pandya 2012-12-10  2692  	int ret;
fd56c2b7 Vipul Pandya 2012-12-10  2693  
fd56c2b7 Vipul Pandya 2012-12-10 @2694  	rpl_skb = (struct sk_buff *)cpu_to_be64(req->cookie);
fd56c2b7 Vipul Pandya 2012-12-10  2695  	BUG_ON(!rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2696  	if (req->retval) {
fd56c2b7 Vipul Pandya 2012-12-10  2697  		PDBG("%s passive open failure %d\n", __func__, req->retval);
fd56c2b7 Vipul Pandya 2012-12-10  2698  		kfree_skb(rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2699  	} else {
fd56c2b7 Vipul Pandya 2012-12-10  2700  		cpl = (struct cpl_pass_accept_req *)cplhdr(rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2701  		OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_PASS_ACCEPT_REQ,
fd56c2b7 Vipul Pandya 2012-12-10  2702  						      htonl(req->tid)));
fd56c2b7 Vipul Pandya 2012-12-10  2703  		ret = pass_accept_req(dev, rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2704  		if (!ret)
fd56c2b7 Vipul Pandya 2012-12-10  2705  			kfree_skb(rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2706  	}
fd56c2b7 Vipul Pandya 2012-12-10  2707  	return;
fd56c2b7 Vipul Pandya 2012-12-10  2708  }
fd56c2b7 Vipul Pandya 2012-12-10  2709  
fd56c2b7 Vipul Pandya 2012-12-10  2710  static int deferred_fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
2f5b48c3 Steve Wise   2010-09-10  2711  {
2f5b48c3 Steve Wise   2010-09-10  2712  	struct cpl_fw6_msg *rpl = cplhdr(skb);
fd56c2b7 Vipul Pandya 2012-12-10  2713  	struct cpl_fw6_msg_ofld_connection_wr_rpl *req;
fd56c2b7 Vipul Pandya 2012-12-10  2714  
fd56c2b7 Vipul Pandya 2012-12-10  2715  	switch (rpl->type) {
fd56c2b7 Vipul Pandya 2012-12-10  2716  	case FW6_TYPE_CQE:
fd56c2b7 Vipul Pandya 2012-12-10  2717  		c4iw_ev_dispatch(dev, (struct t4_cqe *)&rpl->data[0]);
fd56c2b7 Vipul Pandya 2012-12-10  2718  		break;
fd56c2b7 Vipul Pandya 2012-12-10  2719  	case FW6_TYPE_OFLD_CONNECTION_WR_RPL:
fd56c2b7 Vipul Pandya 2012-12-10  2720  		req = (struct cpl_fw6_msg_ofld_connection_wr_rpl *)rpl->data;
fd56c2b7 Vipul Pandya 2012-12-10  2721  		switch (req->t_state) {
fd56c2b7 Vipul Pandya 2012-12-10  2722  		case TCP_SYN_SENT:
fd56c2b7 Vipul Pandya 2012-12-10  2723  			active_ofld_conn_reply(dev, skb, req);
fd56c2b7 Vipul Pandya 2012-12-10  2724  			break;
fd56c2b7 Vipul Pandya 2012-12-10  2725  		case TCP_SYN_RECV:
fd56c2b7 Vipul Pandya 2012-12-10  2726  			passive_ofld_conn_reply(dev, skb, req);
fd56c2b7 Vipul Pandya 2012-12-10  2727  			break;
fd56c2b7 Vipul Pandya 2012-12-10  2728  		default:
fd56c2b7 Vipul Pandya 2012-12-10  2729  			pr_err("%s unexpected ofld conn wr state %d\n",
fd56c2b7 Vipul Pandya 2012-12-10  2730  			       __func__, req->t_state);
fd56c2b7 Vipul Pandya 2012-12-10  2731  			break;
fd56c2b7 Vipul Pandya 2012-12-10  2732  		}
fd56c2b7 Vipul Pandya 2012-12-10  2733  		break;
fd56c2b7 Vipul Pandya 2012-12-10  2734  	}
fd56c2b7 Vipul Pandya 2012-12-10  2735  	return 0;
fd56c2b7 Vipul Pandya 2012-12-10  2736  }
fd56c2b7 Vipul Pandya 2012-12-10  2737  
fd56c2b7 Vipul Pandya 2012-12-10  2738  static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
fd56c2b7 Vipul Pandya 2012-12-10  2739  {
fd56c2b7 Vipul Pandya 2012-12-10  2740  	u32 l2info;
fd56c2b7 Vipul Pandya 2012-12-10  2741  	u16 vlantag, len, hdr_len;
fd56c2b7 Vipul Pandya 2012-12-10  2742  	u8 intf;
fd56c2b7 Vipul Pandya 2012-12-10  2743  	struct cpl_rx_pkt *cpl = cplhdr(skb);
fd56c2b7 Vipul Pandya 2012-12-10  2744  	struct cpl_pass_accept_req *req;
fd56c2b7 Vipul Pandya 2012-12-10  2745  	struct tcp_options_received tmp_opt;
fd56c2b7 Vipul Pandya 2012-12-10  2746  
fd56c2b7 Vipul Pandya 2012-12-10  2747  	/* Store values from cpl_rx_pkt in temporary location. */
fd56c2b7 Vipul Pandya 2012-12-10  2748  	vlantag = cpl->vlan;
fd56c2b7 Vipul Pandya 2012-12-10  2749  	len = cpl->len;
fd56c2b7 Vipul Pandya 2012-12-10  2750  	l2info  = cpl->l2info;
fd56c2b7 Vipul Pandya 2012-12-10  2751  	hdr_len = cpl->hdr_len;
fd56c2b7 Vipul Pandya 2012-12-10  2752  	intf = cpl->iff;
fd56c2b7 Vipul Pandya 2012-12-10  2753  
fd56c2b7 Vipul Pandya 2012-12-10  2754  	__skb_pull(skb, sizeof(*req) + sizeof(struct rss_header));
fd56c2b7 Vipul Pandya 2012-12-10  2755  
fd56c2b7 Vipul Pandya 2012-12-10  2756  	/*
fd56c2b7 Vipul Pandya 2012-12-10  2757  	 * We need to parse the TCP options from SYN packet.
fd56c2b7 Vipul Pandya 2012-12-10  2758  	 * to generate cpl_pass_accept_req.
fd56c2b7 Vipul Pandya 2012-12-10  2759  	 */
fd56c2b7 Vipul Pandya 2012-12-10  2760  	memset(&tmp_opt, 0, sizeof(tmp_opt));
fd56c2b7 Vipul Pandya 2012-12-10  2761  	tcp_clear_options(&tmp_opt);
fd56c2b7 Vipul Pandya 2012-12-10  2762  	tcp_parse_options(skb, &tmp_opt, 0, 0, NULL);
fd56c2b7 Vipul Pandya 2012-12-10  2763  
fd56c2b7 Vipul Pandya 2012-12-10  2764  	req = (struct cpl_pass_accept_req *)__skb_push(skb, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2765  	memset(req, 0, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2766  	req->l2info = cpu_to_be16(V_SYN_INTF(intf) |
fd56c2b7 Vipul Pandya 2012-12-10  2767  			 V_SYN_MAC_IDX(G_RX_MACIDX(htonl(l2info))) |
fd56c2b7 Vipul Pandya 2012-12-10  2768  			 F_SYN_XACT_MATCH);
fd56c2b7 Vipul Pandya 2012-12-10  2769  	req->hdr_len = cpu_to_be32(V_SYN_RX_CHAN(G_RX_CHAN(htonl(l2info))) |
fd56c2b7 Vipul Pandya 2012-12-10  2770  				V_TCP_HDR_LEN(G_RX_TCPHDR_LEN(htons(hdr_len))) |
fd56c2b7 Vipul Pandya 2012-12-10  2771  				V_IP_HDR_LEN(G_RX_IPHDR_LEN(htons(hdr_len))) |
fd56c2b7 Vipul Pandya 2012-12-10  2772  				V_ETH_HDR_LEN(G_RX_ETHHDR_LEN(htonl(l2info))));
fd56c2b7 Vipul Pandya 2012-12-10  2773  	req->vlan = vlantag;
fd56c2b7 Vipul Pandya 2012-12-10  2774  	req->len = len;
fd56c2b7 Vipul Pandya 2012-12-10  2775  	req->tos_stid = cpu_to_be32(PASS_OPEN_TID(stid) |
fd56c2b7 Vipul Pandya 2012-12-10  2776  				    PASS_OPEN_TOS(tos));
fd56c2b7 Vipul Pandya 2012-12-10  2777  	req->tcpopt.mss = htons(tmp_opt.mss_clamp);
fd56c2b7 Vipul Pandya 2012-12-10  2778  	if (tmp_opt.wscale_ok)
fd56c2b7 Vipul Pandya 2012-12-10  2779  		req->tcpopt.wsf = tmp_opt.snd_wscale;
fd56c2b7 Vipul Pandya 2012-12-10  2780  	req->tcpopt.tstamp = tmp_opt.saw_tstamp;
fd56c2b7 Vipul Pandya 2012-12-10  2781  	if (tmp_opt.sack_ok)
fd56c2b7 Vipul Pandya 2012-12-10  2782  		req->tcpopt.sack = 1;
fd56c2b7 Vipul Pandya 2012-12-10  2783  	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_PASS_ACCEPT_REQ, 0));
fd56c2b7 Vipul Pandya 2012-12-10  2784  	return;
fd56c2b7 Vipul Pandya 2012-12-10  2785  }
fd56c2b7 Vipul Pandya 2012-12-10  2786  
fd56c2b7 Vipul Pandya 2012-12-10  2787  static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
fd56c2b7 Vipul Pandya 2012-12-10  2788  				  __be32 laddr, __be16 lport,
fd56c2b7 Vipul Pandya 2012-12-10  2789  				  __be32 raddr, __be16 rport,
fd56c2b7 Vipul Pandya 2012-12-10  2790  				  u32 rcv_isn, u32 filter, u16 window,
fd56c2b7 Vipul Pandya 2012-12-10  2791  				  u32 rss_qid, u8 port_id)
fd56c2b7 Vipul Pandya 2012-12-10  2792  {
fd56c2b7 Vipul Pandya 2012-12-10  2793  	struct sk_buff *req_skb;
fd56c2b7 Vipul Pandya 2012-12-10  2794  	struct fw_ofld_connection_wr *req;
fd56c2b7 Vipul Pandya 2012-12-10  2795  	struct cpl_pass_accept_req *cpl = cplhdr(skb);
fd56c2b7 Vipul Pandya 2012-12-10  2796  
fd56c2b7 Vipul Pandya 2012-12-10  2797  	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
fd56c2b7 Vipul Pandya 2012-12-10  2798  	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2799  	memset(req, 0, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2800  	req->op_compl = htonl(V_WR_OP(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL(1));
fd56c2b7 Vipul Pandya 2012-12-10  2801  	req->len16_pkd = htonl(FW_WR_LEN16(DIV_ROUND_UP(sizeof(*req), 16)));
fd56c2b7 Vipul Pandya 2012-12-10  2802  	req->le.version_cpl = htonl(F_FW_OFLD_CONNECTION_WR_CPL);
fd56c2b7 Vipul Pandya 2012-12-10  2803  	req->le.filter = filter;
fd56c2b7 Vipul Pandya 2012-12-10  2804  	req->le.lport = lport;
fd56c2b7 Vipul Pandya 2012-12-10  2805  	req->le.pport = rport;
fd56c2b7 Vipul Pandya 2012-12-10  2806  	req->le.u.ipv4.lip = laddr;
fd56c2b7 Vipul Pandya 2012-12-10  2807  	req->le.u.ipv4.pip = raddr;
fd56c2b7 Vipul Pandya 2012-12-10  2808  	req->tcb.rcv_nxt = htonl(rcv_isn + 1);
fd56c2b7 Vipul Pandya 2012-12-10  2809  	req->tcb.rcv_adv = htons(window);
fd56c2b7 Vipul Pandya 2012-12-10  2810  	req->tcb.t_state_to_astid =
fd56c2b7 Vipul Pandya 2012-12-10  2811  		 htonl(V_FW_OFLD_CONNECTION_WR_T_STATE(TCP_SYN_RECV) |
fd56c2b7 Vipul Pandya 2012-12-10  2812  			V_FW_OFLD_CONNECTION_WR_RCV_SCALE(cpl->tcpopt.wsf) |
fd56c2b7 Vipul Pandya 2012-12-10  2813  			V_FW_OFLD_CONNECTION_WR_ASTID(
fd56c2b7 Vipul Pandya 2012-12-10  2814  			GET_PASS_OPEN_TID(ntohl(cpl->tos_stid))));
fd56c2b7 Vipul Pandya 2012-12-10  2815  
fd56c2b7 Vipul Pandya 2012-12-10  2816  	/*
fd56c2b7 Vipul Pandya 2012-12-10  2817  	 * We store the qid in opt2 which will be used by the firmware
fd56c2b7 Vipul Pandya 2012-12-10  2818  	 * to send us the wr response.
fd56c2b7 Vipul Pandya 2012-12-10  2819  	 */
fd56c2b7 Vipul Pandya 2012-12-10  2820  	req->tcb.opt2 = htonl(V_RSS_QUEUE(rss_qid));
fd56c2b7 Vipul Pandya 2012-12-10  2821  
fd56c2b7 Vipul Pandya 2012-12-10  2822  	/*
fd56c2b7 Vipul Pandya 2012-12-10  2823  	 * We initialize the MSS index in TCB to 0xF.
fd56c2b7 Vipul Pandya 2012-12-10  2824  	 * So that when driver sends cpl_pass_accept_rpl
fd56c2b7 Vipul Pandya 2012-12-10  2825  	 * TCB picks up the correct value. If this was 0
fd56c2b7 Vipul Pandya 2012-12-10  2826  	 * TP will ignore any value > 0 for MSS index.
fd56c2b7 Vipul Pandya 2012-12-10  2827  	 */
fd56c2b7 Vipul Pandya 2012-12-10  2828  	req->tcb.opt0 = cpu_to_be64(V_MSS_IDX(0xF));
fd56c2b7 Vipul Pandya 2012-12-10 @2829  	req->cookie = cpu_to_be64((u64)skb);
fd56c2b7 Vipul Pandya 2012-12-10  2830  
fd56c2b7 Vipul Pandya 2012-12-10  2831  	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
fd56c2b7 Vipul Pandya 2012-12-10  2832  	cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
