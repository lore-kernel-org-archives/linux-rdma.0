From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/rxe: remove unnecessary skb_clone in xmit
Date: Fri,  5 Jan 2018 03:19:51 -0500
Message-ID: <1515140391-24752-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In xmit, there is a skb_clone. This function copies the struct sk_buff.
And some parameters are changed to the new skb. Then the new skb is sent
while the old skb is freed.

While the function skb_clone is removed, the parameter changes are made on
the old skb, then the old skb is sent. It can also work well.

The following tests are made.

 server                       client
---------                    ---------
|1.1.1.1|<----rxe-channel--->|1.1.1.2|
---------                    ---------

On server: rping -s -a 1.1.1.1 -v -C 1000 -S 512
On client: rping -c -a 1.1.1.1 -v -C 1000 -S 512

The kernel config CONFIG_DEBUG_KMEMLEAK is enabled on both server
and client.

This test runs for several hours. There is no memory leak and the whole
system can work well.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 59dee10..5fc6bb5 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -452,31 +452,26 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 
 int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
-	struct sk_buff *nskb;
 	struct rxe_av *av;
 	int err;
 
 	av = rxe_get_av(pkt);
 
-	nskb = skb_clone(skb, GFP_ATOMIC);
-	if (!nskb)
-		return -ENOMEM;
-
-	nskb->destructor = rxe_skb_tx_dtor;
-	nskb->sk = pkt->qp->sk->sk;
+	skb->destructor = rxe_skb_tx_dtor;
+	skb->sk = pkt->qp->sk->sk;
 
 	rxe_add_ref(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (av->network_type == RDMA_NETWORK_IPV4) {
-		err = ip_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
+		err = ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	} else if (av->network_type == RDMA_NETWORK_IPV6) {
-		err = ip6_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
+		err = ip6_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	} else {
 		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
 		atomic_dec(&pkt->qp->skb_out);
 		rxe_drop_ref(pkt->qp);
-		kfree_skb(nskb);
+		kfree_skb(skb);
 		return -EINVAL;
 	}
 
@@ -485,7 +480,6 @@ int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	kfree_skb(skb);
 	return 0;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
