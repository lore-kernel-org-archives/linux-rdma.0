From: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: clean up send_connect()
Date: Mon, 30 Jan 2017 21:12:42 +0530
Message-ID: <1485790962-15147-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clean up send_connect() and make use of t6 specific
active open request struct.

Acked-by: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Signed-off-by: Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 56 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f1510cc..b9c2163 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -692,6 +692,10 @@ static int send_connect(struct c4iw_ep *ep)
 	int ret;
 	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
 	u32 isn = (prandom_u32() & ~7UL) - 1;
+	struct net_device *netdev;
+	u64 params;
+
+	netdev = ep->com.dev->rdev.lldi.ports[0];
 
 	switch (CHELSIO_CHIP_VERSION(adapter_type)) {
 	case CHELSIO_T4:
@@ -768,6 +772,8 @@ static int send_connect(struct c4iw_ep *ep)
 		opt2 |= T5_ISS_F;
 	}
 
+	params = cxgb4_select_ntuple(netdev, ep->l2t);
+
 	if (ep->com.remote_addr.ss_family == AF_INET6)
 		cxgb4_clip_get(ep->com.dev->rdev.lldi.ports[0],
 			       (const u32 *)&la6->sin6_addr.s6_addr, 1);
@@ -809,18 +815,22 @@ static int send_connect(struct c4iw_ep *ep)
 		req->opt0 = cpu_to_be64(opt0);
 
 		if (is_t4(ep->com.dev->rdev.lldi.adapter_type)) {
-			req->params = cpu_to_be32(cxgb4_select_ntuple(
-						ep->com.dev->rdev.lldi.ports[0],
-						ep->l2t));
+			req->params = cpu_to_be32(params);
 			req->opt2 = cpu_to_be32(opt2);
 		} else {
-			t5req->params = cpu_to_be64(FILTER_TUPLE_V(
-						cxgb4_select_ntuple(
-						ep->com.dev->rdev.lldi.ports[0],
-						ep->l2t)));
-			t5req->rsvd = cpu_to_be32(isn);
-			PDBG("%s snd_isn %u\n", __func__, t5req->rsvd);
-			t5req->opt2 = cpu_to_be32(opt2);
+			if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
+				t5req->params =
+					  cpu_to_be64(FILTER_TUPLE_V(params));
+				t5req->rsvd = cpu_to_be32(isn);
+				PDBG("%s snd_isn %u\n", __func__, t5req->rsvd);
+				t5req->opt2 = cpu_to_be32(opt2);
+			} else {
+				t6req->params =
+					  cpu_to_be64(FILTER_TUPLE_V(params));
+				t6req->rsvd = cpu_to_be32(isn);
+				PDBG("%s snd_isn %u\n", __func__, t6req->rsvd);
+				t6req->opt2 = cpu_to_be32(opt2);
+			}
 		}
 	} else {
 		switch (CHELSIO_CHIP_VERSION(adapter_type)) {
@@ -859,18 +869,24 @@ static int send_connect(struct c4iw_ep *ep)
 		req6->opt0 = cpu_to_be64(opt0);
 
 		if (is_t4(ep->com.dev->rdev.lldi.adapter_type)) {
-			req6->params = cpu_to_be32(cxgb4_select_ntuple(
-						ep->com.dev->rdev.lldi.ports[0],
-						ep->l2t));
+			req6->params = cpu_to_be32(cxgb4_select_ntuple(netdev,
+								      ep->l2t));
 			req6->opt2 = cpu_to_be32(opt2);
 		} else {
-			t5req6->params = cpu_to_be64(FILTER_TUPLE_V(
-						cxgb4_select_ntuple(
-						ep->com.dev->rdev.lldi.ports[0],
-						ep->l2t)));
-			t5req6->rsvd = cpu_to_be32(isn);
-			PDBG("%s snd_isn %u\n", __func__, t5req6->rsvd);
-			t5req6->opt2 = cpu_to_be32(opt2);
+			if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
+				t5req6->params =
+					    cpu_to_be64(FILTER_TUPLE_V(params));
+				t5req6->rsvd = cpu_to_be32(isn);
+				PDBG("%s snd_isn %u\n", __func__, t5req6->rsvd);
+				t5req6->opt2 = cpu_to_be32(opt2);
+			} else {
+				t6req6->params =
+					    cpu_to_be64(FILTER_TUPLE_V(params));
+				t6req6->rsvd = cpu_to_be32(isn);
+				PDBG("%s snd_isn %u\n", __func__, t6req6->rsvd);
+				t6req6->opt2 = cpu_to_be32(opt2);
+			}
+
 		}
 	}
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
