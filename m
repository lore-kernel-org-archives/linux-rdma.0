From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/3] RDMA/cxgb4: Take IPv6 into account for best_mtu and set_emss
Date: Wed, 24 Sep 2014 03:53:41 +0530
Message-ID: <1411511023-14101-2-git-send-email-hariprasad@chelsio.com>
References: <1411511023-14101-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411511023-14101-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

best_mtu and set_emss was not considering ipv6 header for ipv6 case

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c2fb71c..2ca9ec8 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -236,10 +236,12 @@ static void release_tid(struct c4iw_rdev *rdev, u32 hwtid, struct sk_buff *skb)
 static void set_emss(struct c4iw_ep *ep, u16 opt)
 {
 	ep->emss = ep->com.dev->rdev.lldi.mtus[GET_TCPOPT_MSS(opt)] -
-		   sizeof(struct iphdr) - sizeof(struct tcphdr);
+		   ((AF_INET == ep->com.remote_addr.ss_family) ?
+		    sizeof(struct iphdr) : sizeof(struct ipv6hdr)) -
+		   sizeof(struct tcphdr);
 	ep->mss = ep->emss;
 	if (GET_TCPOPT_TSTAMP(opt))
-		ep->emss -= 12;
+		ep->emss -= round_up(TCPOLEN_TIMESTAMP, 4);
 	if (ep->emss < 128)
 		ep->emss = 128;
 	if (ep->emss & 7)
@@ -581,11 +583,14 @@ static void c4iw_record_pm_msg(struct c4iw_ep *ep,
 }
 
 static void best_mtu(const unsigned short *mtus, unsigned short mtu,
-		     unsigned int *idx, int use_ts)
+		     unsigned int *idx, int use_ts, int ipv6)
 {
-	unsigned short hdr_size = sizeof(struct iphdr) +
+	unsigned short hdr_size = (ipv6 ?
+				   sizeof(struct ipv6hdr) :
+				   sizeof(struct iphdr)) +
 				  sizeof(struct tcphdr) +
-				  (use_ts ? 12 : 0);
+				  (use_ts ?
+				   round_up(TCPOLEN_TIMESTAMP, 4) : 0);
 	unsigned short data_size = mtu - hdr_size;
 
 	cxgb4_best_aligned_mtu(mtus, hdr_size, data_size, 8, idx);
@@ -634,7 +639,8 @@ static int send_connect(struct c4iw_ep *ep)
 	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->ctrlq_idx);
 
 	best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx,
-		 enable_tcp_timestamps);
+		 enable_tcp_timestamps,
+		 (AF_INET == ep->com.remote_addr.ss_family) ? 0 : 1);
 	wscale = compute_wscale(rcv_win);
 
 	/*
@@ -1763,7 +1769,8 @@ static void send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 	req->tcb.tx_max = (__force __be32) jiffies;
 	req->tcb.rcv_adv = htons(1);
 	best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx,
-		 enable_tcp_timestamps);
+		 enable_tcp_timestamps,
+		 (AF_INET == ep->com.remote_addr.ss_family) ? 0 : 1);
 	wscale = compute_wscale(rcv_win);
 
 	/*
@@ -2162,7 +2169,8 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 						    ep->hwtid));
 
 	best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx,
-		 enable_tcp_timestamps && req->tcpopt.tstamp);
+		 enable_tcp_timestamps && req->tcpopt.tstamp,
+		 (AF_INET == ep->com.remote_addr.ss_family) ? 0 : 1);
 	wscale = compute_wscale(rcv_win);
 
 	/*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
