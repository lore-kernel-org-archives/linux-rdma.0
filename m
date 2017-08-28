From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 01/11] IB/rxe: Move refcounting earlier in rxe_send()
Date: Mon, 28 Aug 2017 16:11:49 -0400
Message-ID: <1503951119-25573-2-git-send-email-andrew.boyer@dell.com>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503951119-25573-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The network stack will call nskb's destructor, rxe_skb_tx_dtor(), if the
packet gets dropped by ip_local_out()/ip6_local_out(). Thus we need to add
the QP ref before output to avoid extra dereferences during network
congestion. This could lead to unwanted destruction of the QP.

Fix up the skb_out accounting, too.

Fixes: fda85ce91240 ("IB/rxe: Fix kernel panic from skb destructor")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 08f3f90..0810f38 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -460,12 +460,17 @@ int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 	nskb->destructor = rxe_skb_tx_dtor;
 	nskb->sk = pkt->qp->sk->sk;
 
+	rxe_add_ref(pkt->qp);
+	atomic_inc(&pkt->qp->skb_out);
+
 	if (av->network_type == RDMA_NETWORK_IPV4) {
 		err = ip_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
 	} else if (av->network_type == RDMA_NETWORK_IPV6) {
 		err = ip6_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
 	} else {
 		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
+		atomic_dec(&pkt->qp->skb_out);
+		rxe_drop_ref(pkt->qp);
 		kfree_skb(nskb);
 		return -EINVAL;
 	}
@@ -475,10 +480,7 @@ int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	rxe_add_ref(pkt->qp);
-	atomic_inc(&pkt->qp->skb_out);
 	kfree_skb(skb);
-
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
