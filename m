From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 1/1] IB/rxe: remove unnecessary skb_clone
Date: Tue, 13 Feb 2018 02:59:46 -0500
Message-ID: <1518508786-3204-1-git-send-email-yanjun.zhu@oracle.com>
References: <1515140391-24752-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515140391-24752-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In send_atomic_ack function, it is not necessary make a
skb_clone. To gain better performance(high throughput and
low latency), this skb_clone is removed.

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

As the above network, the following tests are made.

Server: ibv_rc_pingpong -d rxe0 -g 1
Client: ibv_rc_pingpong -d rxe0 -g 1 1.1.1.1

The result on Server(10 tests are made).
Before:
Throughput is 137.07 Mbit/sec
Latency is 517.76 usec/iter

After:
Throughput is 148.85 Mbit/sec
Latency is 476.64 usec/iter

The throughput is enhanced and the latency is reduced.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
V1-->V2: 10 tests are made. From throughput and latency, the performance is better.
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index d37bb9b..6d01d16 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -969,7 +969,6 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	int rc = 0;
 	struct rxe_pkt_info ack_pkt;
 	struct sk_buff *skb;
-	struct sk_buff *skb_copy;
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct resp_res *res;
 
@@ -981,15 +980,6 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 		goto out;
 	}
 
-	skb_copy = skb_clone(skb, GFP_ATOMIC);
-	if (skb_copy)
-		rxe_add_ref(qp); /* for the new SKB */
-	else {
-		pr_warn("Could not clone atomic response\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	res = &qp->resp.resources[qp->resp.res_head];
 	free_rd_atomic_resource(qp, res);
 	rxe_advance_resp_resource(qp);
@@ -998,17 +988,16 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	memset((unsigned char *)SKB_TO_PKT(skb) + sizeof(ack_pkt), 0,
 	       sizeof(skb->cb) - sizeof(ack_pkt));
 
+	refcount_inc(&skb->users);
 	res->type = RXE_ATOMIC_MASK;
 	res->atomic.skb = skb;
 	res->first_psn = ack_pkt.psn;
 	res->last_psn  = ack_pkt.psn;
 	res->cur_psn   = ack_pkt.psn;
 
-	rc = rxe_xmit_packet(rxe, qp, &ack_pkt, skb_copy);
+	rc = rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
 	if (rc) {
 		pr_err_ratelimited("Failed sending ack\n");
-		rxe_drop_ref(qp);
-		kfree_skb(skb_copy);
 	}
 
 out:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
