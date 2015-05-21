From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] rds: re-entry of rds_ib_xmit/rds_iw_xmit
Date: Thu, 21 May 2015 13:11:40 +0800
Message-ID: <1432185100-5613-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The BUG_ON at line 452/453 is triggered in function rds_send_xmit.

 441                         while (ret) {
 442                                 tmp = min_t(int, ret, sg->length -
 443                                                       conn->c_xmit_data_off);
 444                                 conn->c_xmit_data_off += tmp;
 445                                 ret -= tmp;
 446                                 if (conn->c_xmit_data_off == sg->length) {
 447                                         conn->c_xmit_data_off = 0;
 448                                         sg++;
 449                                         conn->c_xmit_sg++;
 450                                         if (ret != 0 && conn->c_xmit_sg == rm->data.op_nents)
 451                                                 printk(KERN_ERR "conn %p rm %p sg %p ret %d\n", conn, rm, sg, ret);
 452                                         BUG_ON(ret != 0 &&
 453                                                conn->c_xmit_sg == rm->data.op_nents);
 454                                 }
 455                         }

it is complaining the total sent length is bigger that we want to send.

rds_ib_xmit() is wrong for the second entry for the same rds_message returning
wrong value.

the sg and off passed by rds_send_xmit to rds_ib_xmit is based on
scatterlist.offset/length, but the rds_ib_xmit action is based on
scatterlist.dma_address/dma_length. in case dma_length is larger than length
there is problem. for the 2nd and later entries of rds_ib_xmit for same
rds_message, at least one of the following two is wrong:

1) the scatterlist to start with,  the choosen one can far beyond the correct
   one.
2) the offset to start with within the scatterlist.

fix:
add op_dmasg and op_dmaoff to rm_data_op structure indicating the scatterlist
and offset within the it to start with for rds_ib_xmit respectively. op_dmasg
and op_dmaoff are initialized to zero when doing dma mapping for the first see
of the message and are changed when filling send slots.

the same applies to rds_iw_xmit too.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/rds/ib_send.c | 17 +++++++++++------
 net/rds/iw_send.c | 18 +++++++++++-------
 net/rds/rds.h     |  2 ++
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index bd3825d..1df6c84 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -605,6 +605,8 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		}
 
 		rds_message_addref(rm);
+		rm->data.op_dmasg = 0;
+		rm->data.op_dmaoff = 0;
 		ic->i_data_op = &rm->data;
 
 		/* Finalize the header */
@@ -658,7 +660,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	send = &ic->i_sends[pos];
 	first = send;
 	prev = NULL;
-	scat = &ic->i_data_op->op_sg[sg];
+	scat = &ic->i_data_op->op_sg[rm->data.op_dmasg];
 	i = 0;
 	do {
 		unsigned int len = 0;
@@ -680,17 +682,20 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		/* Set up the data, if present */
 		if (i < work_alloc
 		    && scat != &rm->data.op_sg[rm->data.op_count]) {
-			len = min(RDS_FRAG_SIZE, ib_sg_dma_len(dev, scat) - off);
+			len = min(RDS_FRAG_SIZE,
+				ib_sg_dma_len(dev, scat) - rm->data.op_dmaoff);
 			send->s_wr.num_sge = 2;
 
-			send->s_sge[1].addr = ib_sg_dma_address(dev, scat) + off;
+			send->s_sge[1].addr = ib_sg_dma_address(dev, scat);
+			send->s_sge[1].addr += rm->data.op_dmaoff;
 			send->s_sge[1].length = len;
 
 			bytes_sent += len;
-			off += len;
-			if (off == ib_sg_dma_len(dev, scat)) {
+			rm->data.op_dmaoff += len;
+			if (rm->data.op_dmaoff == ib_sg_dma_len(dev, scat)) {
 				scat++;
-				off = 0;
+				rm->data.op_dmasg++;
+				rm->data.op_dmaoff = 0;
 			}
 		}
 
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index 1383478..334fe98 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -581,6 +581,8 @@ int rds_iw_xmit(struct rds_connection *conn, struct rds_message *rm,
 		ic->i_unsignaled_wrs = rds_iw_sysctl_max_unsig_wrs;
 		ic->i_unsignaled_bytes = rds_iw_sysctl_max_unsig_bytes;
 		rds_message_addref(rm);
+		rm->data.op_dmasg = 0;
+		rm->data.op_dmaoff = 0;
 		ic->i_rm = rm;
 
 		/* Finalize the header */
@@ -622,7 +624,7 @@ int rds_iw_xmit(struct rds_connection *conn, struct rds_message *rm,
 	send = &ic->i_sends[pos];
 	first = send;
 	prev = NULL;
-	scat = &rm->data.op_sg[sg];
+	scat = &rm->data.op_sg[rm->data.op_dmasg];
 	sent = 0;
 	i = 0;
 
@@ -656,10 +658,11 @@ int rds_iw_xmit(struct rds_connection *conn, struct rds_message *rm,
 
 		send = &ic->i_sends[pos];
 
-		len = min(RDS_FRAG_SIZE, ib_sg_dma_len(dev, scat) - off);
+		len = min(RDS_FRAG_SIZE,
+			  ib_sg_dma_len(dev, scat) - rm->data.op_dmaoff);
 		rds_iw_xmit_populate_wr(ic, send, pos,
-				ib_sg_dma_address(dev, scat) + off, len,
-				send_flags);
+			ib_sg_dma_address(dev, scat) + rm->data.op_dmaoff, len,
+			send_flags);
 
 		/*
 		 * We want to delay signaling completions just enough to get
@@ -687,10 +690,11 @@ int rds_iw_xmit(struct rds_connection *conn, struct rds_message *rm,
 			 &send->s_wr, send->s_wr.num_sge, send->s_wr.next);
 
 		sent += len;
-		off += len;
-		if (off == ib_sg_dma_len(dev, scat)) {
+		rm->data.op_dmaoff += len;
+		if (rm->data.op_dmaoff == ib_sg_dma_len(dev, scat)) {
 			scat++;
-			off = 0;
+			rm->data.op_dmaoff = 0;
+			rm->data.op_dmasg++;
 		}
 
 add_header:
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 0d41155..d2c6009 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -363,6 +363,8 @@ struct rds_message {
 			unsigned int		op_active:1;
 			unsigned int		op_nents;
 			unsigned int		op_count;
+			unsigned int		op_dmasg;
+			unsigned int		op_dmaoff;
 			struct scatterlist	*op_sg;
 		} data;
 	};
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
