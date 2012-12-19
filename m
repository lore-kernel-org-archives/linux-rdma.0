From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [infiniband:for-next 4/6]
 drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32
 degrades to integer
Date: Thu, 20 Dec 2012 06:15:51 +0800
Message-ID: <50d23c97.KZPDZfDmL5eugAck%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
head:   4d4b72d11156c560d4a97a20ba4dcda1ee7c976f
commit: fd56c2b766cdcfc0e3d31fc6c192536269f5b94d [4/6] RDMA/cxgb4: Fix LE hash collision bug for passive open connection


sparse warnings:

drivers/infiniband/hw/cxgb4/cm.c:1465:25: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:1465:25:    expected restricted __be32 [usertype] tx_max
drivers/infiniband/hw/cxgb4/cm.c:1465:25:    got unsigned long extern volatile [unsigned] [addressable] [toplevel] jiffies
drivers/infiniband/hw/cxgb4/cm.c:1468:23: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:1468:23:    expected restricted __be64 [usertype] opt0
drivers/infiniband/hw/cxgb4/cm.c:1468:23:    got unsigned long long
drivers/infiniband/hw/cxgb4/cm.c:1480:23: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:1480:23:    expected restricted __be32 [usertype] opt2
drivers/infiniband/hw/cxgb4/cm.c:1480:23:    got int
drivers/infiniband/hw/cxgb4/cm.c:1486:31: sparse: invalid assignment: |=
drivers/infiniband/hw/cxgb4/cm.c:1486:31:    left side has type restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1486:31:    right side has type int
drivers/infiniband/hw/cxgb4/cm.c:1488:31: sparse: invalid assignment: |=
drivers/infiniband/hw/cxgb4/cm.c:1488:31:    left side has type restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1488:31:    right side has type int
drivers/infiniband/hw/cxgb4/cm.c:1490:31: sparse: invalid assignment: |=
drivers/infiniband/hw/cxgb4/cm.c:1490:31:    left side has type restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1490:31:    right side has type int
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:1491:25:    expected unsigned long long [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:1491:25:    got restricted __be64 [usertype] opt0
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1491:25: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:1492:25:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:1492:25:    got restricted __be32 [usertype] opt2
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:1492:25: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2670:68: sparse: incorrect type in argument 2 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2670:68:    expected unsigned int [unsigned] atid
drivers/infiniband/hw/cxgb4/cm.c:2670:68:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2694:20: sparse: cast from restricted __be64
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: incorrect type in argument 1 (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    expected unsigned int [unsigned] [usertype] val
drivers/infiniband/hw/cxgb4/cm.c:2701:35:    got restricted __be32 [usertype] tid
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: cast from restricted __be32
+ drivers/infiniband/hw/cxgb4/cm.c:2701:35: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2748:17: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2748:17:    expected unsigned short [unsigned] [usertype] vlantag
drivers/infiniband/hw/cxgb4/cm.c:2748:17:    got restricted __be16 [usertype] vlan
drivers/infiniband/hw/cxgb4/cm.c:2749:13: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2749:13:    expected unsigned short [unsigned] [usertype] len
drivers/infiniband/hw/cxgb4/cm.c:2749:13:    got restricted __be16 [usertype] len
drivers/infiniband/hw/cxgb4/cm.c:2750:17: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2750:17:    expected unsigned int [unsigned] [usertype] l2info
drivers/infiniband/hw/cxgb4/cm.c:2750:17:    got restricted __be32 [usertype] l2info
drivers/infiniband/hw/cxgb4/cm.c:2751:17: sparse: incorrect type in assignment (different base types)
drivers/infiniband/hw/cxgb4/cm.c:2751:17:    expected unsigned short [unsigned] [usertype] hdr_len
drivers/infiniband/hw/cxgb4/cm.c:2751:17:    got restricted __be16 [usertype] hdr_len
+ drivers/infiniband/hw/cxgb4/cm.c:2762:42: sparse: Using plain integer as NULL pointer
drivers/infiniband/hw/cxgb4/cm.c:2766:23: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2766:23: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2766:23: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2766:23: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be16 degrades to integer
drivers/infiniband/hw/cxgb4/cm.c:2769:24: sparse: restricted __be32 degrades to integer
+ drivers/infiniband/hw/cxgb4/cm.c:2773:19: sparse: too many warnings
drivers/infiniband/hw/cxgb4/cm.c: In function 'passive_ofld_conn_reply':
drivers/infiniband/hw/cxgb4/cm.c:2694:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/infiniband/hw/cxgb4/cm.c: In function 'send_fw_pass_open_req':
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/infiniband/hw/cxgb4/cm.c:2829:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
--
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
+ drivers/infiniband/hw/cxgb4/device.c:671:17: sparse: cast to restricted __be64
drivers/infiniband/hw/cxgb4/device.c: In function 'c4iw_rdev_open':
drivers/infiniband/hw/cxgb4/device.c:414:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

vim +2701 drivers/infiniband/hw/cxgb4/cm.c

fd56c2b7 Vipul Pandya 2012-12-10  2695  	BUG_ON(!rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2696  	if (req->retval) {
fd56c2b7 Vipul Pandya 2012-12-10  2697  		PDBG("%s passive open failure %d\n", __func__, req->retval);
fd56c2b7 Vipul Pandya 2012-12-10  2698  		kfree_skb(rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10  2699  	} else {
fd56c2b7 Vipul Pandya 2012-12-10  2700  		cpl = (struct cpl_pass_accept_req *)cplhdr(rpl_skb);
fd56c2b7 Vipul Pandya 2012-12-10 @2701  		OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_PASS_ACCEPT_REQ,
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
fd56c2b7 Vipul Pandya 2012-12-10 @2751  	hdr_len = cpl->hdr_len;
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
fd56c2b7 Vipul Pandya 2012-12-10 @2762  	tcp_parse_options(skb, &tmp_opt, 0, 0, NULL);
fd56c2b7 Vipul Pandya 2012-12-10  2763  
fd56c2b7 Vipul Pandya 2012-12-10  2764  	req = (struct cpl_pass_accept_req *)__skb_push(skb, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2765  	memset(req, 0, sizeof(*req));
fd56c2b7 Vipul Pandya 2012-12-10  2766  	req->l2info = cpu_to_be16(V_SYN_INTF(intf) |
fd56c2b7 Vipul Pandya 2012-12-10  2767  			 V_SYN_MAC_IDX(G_RX_MACIDX(htonl(l2info))) |
fd56c2b7 Vipul Pandya 2012-12-10  2768  			 F_SYN_XACT_MATCH);
fd56c2b7 Vipul Pandya 2012-12-10 @2769  	req->hdr_len = cpu_to_be32(V_SYN_RX_CHAN(G_RX_CHAN(htonl(l2info))) |
fd56c2b7 Vipul Pandya 2012-12-10  2770  				V_TCP_HDR_LEN(G_RX_TCPHDR_LEN(htons(hdr_len))) |
fd56c2b7 Vipul Pandya 2012-12-10  2771  				V_IP_HDR_LEN(G_RX_IPHDR_LEN(htons(hdr_len))) |
fd56c2b7 Vipul Pandya 2012-12-10  2772  				V_ETH_HDR_LEN(G_RX_ETHHDR_LEN(htonl(l2info))));
fd56c2b7 Vipul Pandya 2012-12-10 @2773  	req->vlan = vlantag;
fd56c2b7 Vipul Pandya 2012-12-10  2774  	req->len = len;
fd56c2b7 Vipul Pandya 2012-12-10  2775  	req->tos_stid = cpu_to_be32(PASS_OPEN_TID(stid) |
fd56c2b7 Vipul Pandya 2012-12-10  2776  				    PASS_OPEN_TOS(tos));

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
