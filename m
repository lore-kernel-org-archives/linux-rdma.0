From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Reducing the number of IB interrupts caused by the SRP initiator
Date: Sun, 17 Jan 2010 20:08:16 +0100
Message-ID: <201001172008.16461.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

Once I noticed that the SRP initiator triggers two IB interrupts per I/O (more
precise, per srp_queuecommand() call) I started looking at reducing the number
of IB interrupts. The patch below didn't help. Does this mean that the patch
below isn't complete or is this because of the hw driver used during the test
(mlx4) ?

Bart.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..1f674b8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -241,7 +241,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
-	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
+	init_attr->sq_sig_type         = IB_SIGNAL_REQ_WR;
 	init_attr->qp_type             = IB_QPT_RC;
 	init_attr->send_cq             = target->cq;
 	init_attr->recv_cq             = target->cq;
@@ -1001,7 +1001,8 @@ static int __srp_post_send(struct srp_target_port *target,
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
-	wr.send_flags = IB_SEND_SIGNALED;
+	wr.send_flags = target->tx_head - target->tx_tail == SRP_SQ_SIZE - 1
+		? IB_SEND_SIGNALED : 0;
 
 	ret = ib_post_send(target->qp, &wr, &bad_wr);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
