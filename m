From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.3] iw_cxgb4: Add support for clip
Date: Tue, 25 Aug 2015 14:08:23 +0530
Message-ID: <1440491903-14261-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for ipv6 address handling clip api provided by lld

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 76 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3ad8dc7..d699719 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -50,6 +50,7 @@
 #include <rdma/ib_addr.h>
 
 #include "iw_cxgb4.h"
+#include "clip_tbl.h"
 
 static char *states[] = {
 	"idle",
@@ -298,6 +299,16 @@ void _c4iw_free_ep(struct kref *kref)
 	if (test_bit(QP_REFERENCED, &ep->com.flags))
 		deref_qp(ep);
 	if (test_bit(RELEASE_RESOURCES, &ep->com.flags)) {
+		if (ep->com.remote_addr.ss_family == AF_INET6) {
+			struct sockaddr_in6 *sin6 =
+					(struct sockaddr_in6 *)
+					&ep->com.mapped_local_addr;
+
+			cxgb4_clip_release(
+					ep->com.dev->rdev.lldi.ports[0],
+					(const u32 *)&sin6->sin6_addr.s6_addr,
+					1);
+		}
 		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
@@ -442,6 +453,12 @@ static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 	kfree_skb(skb);
 	connect_reply_upcall(ep, -EHOSTUNREACH);
 	state_set(&ep->com, DEAD);
+	if (ep->com.remote_addr.ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6 =
+			(struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+	}
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
 	dst_release(ep->dst);
@@ -640,6 +657,7 @@ static int send_connect(struct c4iw_ep *ep)
 	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)
 				   &ep->com.mapped_remote_addr;
 	int win;
+	int ret;
 
 	wrlen = (ep->com.remote_addr.ss_family == AF_INET) ?
 			roundup(sizev4, 16) :
@@ -693,6 +711,11 @@ static int send_connect(struct c4iw_ep *ep)
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
 		opt2 |= T5_ISS_F;
 	}
+
+	if (ep->com.remote_addr.ss_family == AF_INET6)
+		cxgb4_clip_get(ep->com.dev->rdev.lldi.ports[0],
+			       (const u32 *)&la6->sin6_addr.s6_addr, 1);
+
 	t4_set_arp_err_handler(skb, ep, act_open_req_arp_failure);
 
 	if (is_t4(ep->com.dev->rdev.lldi.adapter_type)) {
@@ -790,7 +813,11 @@ static int send_connect(struct c4iw_ep *ep)
 	}
 
 	set_bit(ACT_OPEN_REQ, &ep->com.history);
-	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	ret = c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	if (ret && ep->com.remote_addr.ss_family == AF_INET6)
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&la6->sin6_addr.s6_addr, 1);
+	return ret;
 }
 
 static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
@@ -2091,6 +2118,15 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	case CPL_ERR_CONN_EXIST:
 		if (ep->retry_count++ < ACT_OPEN_RETRY_COUNT) {
 			set_bit(ACT_RETRY_INUSE, &ep->com.history);
+			if (ep->com.remote_addr.ss_family == AF_INET6) {
+				struct sockaddr_in6 *sin6 =
+						(struct sockaddr_in6 *)
+						&ep->com.mapped_local_addr;
+				cxgb4_clip_release(
+						ep->com.dev->rdev.lldi.ports[0],
+						(const u32 *)
+						&sin6->sin6_addr.s6_addr, 1);
+			}
 			remove_handle(ep->com.dev, &ep->com.dev->atid_idr,
 					atid);
 			cxgb4_free_atid(t, atid);
@@ -2118,6 +2154,12 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	connect_reply_upcall(ep, status2errno(status));
 	state_set(&ep->com, DEAD);
 
+	if (ep->com.remote_addr.ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6 =
+			(struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+	}
 	if (status && act_open_has_tid(status))
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, GET_TID(rpl));
 
@@ -2302,6 +2344,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct dst_entry *dst;
 	__u8 local_ip[16], peer_ip[16];
 	__be16 local_port, peer_port;
+	struct sockaddr_in6 *sin6;
 	int err;
 	u16 peer_mss = ntohs(req->tcpopt.mss);
 	int iptype;
@@ -2400,9 +2443,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 		sin->sin_port = peer_port;
 		sin->sin_addr.s_addr = *(__be32 *)peer_ip;
 	} else {
-		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
-			&child_ep->com.mapped_local_addr;
-
+		sin6 = (struct sockaddr_in6 *)&child_ep->com.mapped_local_addr;
 		sin6->sin6_family = PF_INET6;
 		sin6->sin6_port = local_port;
 		memcpy(sin6->sin6_addr.s6_addr, local_ip, 16);
@@ -2436,6 +2477,11 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	insert_handle(dev, &dev->hwtid_idr, child_ep, child_ep->hwtid);
 	accept_cr(child_ep, skb, req);
 	set_bit(PASS_ACCEPT_REQ, &child_ep->com.history);
+	if (iptype == 6) {
+		sin6 = (struct sockaddr_in6 *)&child_ep->com.mapped_local_addr;
+		cxgb4_clip_get(child_ep->com.dev->rdev.lldi.ports[0],
+			       (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+	}
 	goto out;
 reject:
 	reject_cr(dev, hwtid, skb);
@@ -2672,6 +2718,15 @@ out:
 	if (release)
 		release_ep_resources(ep);
 	else if (ep->retry_with_mpa_v1) {
+		if (ep->com.remote_addr.ss_family == AF_INET6) {
+			struct sockaddr_in6 *sin6 =
+					(struct sockaddr_in6 *)
+					&ep->com.mapped_local_addr;
+			cxgb4_clip_release(
+					ep->com.dev->rdev.lldi.ports[0],
+					(const u32 *)&sin6->sin6_addr.s6_addr,
+					1);
+		}
 		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
@@ -3186,6 +3241,9 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 		pr_err("cxgb4_create_server6/filter failed err %d stid %d laddr %pI6 lport %d\n",
 		       err, ep->stid,
 		       sin6->sin6_addr.s6_addr, ntohs(sin6->sin6_port));
+	else
+		cxgb4_clip_get(ep->com.dev->rdev.lldi.ports[0],
+			       (const u32 *)&sin6->sin6_addr.s6_addr, 1);
 	return err;
 }
 
@@ -3334,6 +3392,7 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 			ep->com.dev->rdev.lldi.ports[0], ep->stid,
 			ep->com.dev->rdev.lldi.rxq_ids[0], 0);
 	} else {
+		struct sockaddr_in6 *sin6;
 		c4iw_init_wr_wait(&ep->com.wr_wait);
 		err = cxgb4_remove_server(
 				ep->com.dev->rdev.lldi.ports[0], ep->stid,
@@ -3342,6 +3401,9 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 			goto done;
 		err = c4iw_wait_for_reply(&ep->com.dev->rdev, &ep->com.wr_wait,
 					  0, 0, __func__);
+		sin6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
 	}
 	remove_handle(ep->com.dev, &ep->com.dev->stid_idr, ep->stid);
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
@@ -3461,6 +3523,12 @@ static void active_ofld_conn_reply(struct c4iw_dev *dev, struct sk_buff *skb,
 	mutex_unlock(&dev->rdev.stats.lock);
 	connect_reply_upcall(ep, status2errno(req->retval));
 	state_set(&ep->com, DEAD);
+	if (ep->com.remote_addr.ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6 =
+			(struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+		cxgb4_clip_release(ep->com.dev->rdev.lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+	}
 	remove_handle(dev, &dev->atid_idr, atid);
 	cxgb4_free_atid(dev->rdev.lldi.tids, atid);
 	dst_release(ep->dst);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
