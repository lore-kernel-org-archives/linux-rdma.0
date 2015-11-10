From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 3/3] RDS_IW: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 12:44:15 +0200
Message-ID: <1447152255-28231-4-git-send-email-sagig@mellanox.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447152255-28231-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of hard-coding remote access (which is not secured
issue in IB).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/rds/iw_send.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index e20bd503f4bd..47d684541342 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -763,7 +763,8 @@ out:
 
 static int rds_iw_build_send_reg(struct rds_iw_send_work *send,
 				 struct scatterlist *sg,
-				 int sg_nents)
+				 int sg_nents,
+				 int access_flags)
 {
 	int n;
 
@@ -776,7 +777,7 @@ static int rds_iw_build_send_reg(struct rds_iw_send_work *send,
 	send->s_reg_wr.wr.num_sge = 0;
 	send->s_reg_wr.mr = send->s_mr;
 	send->s_reg_wr.key = send->s_mr->rkey;
-	send->s_reg_wr.access = IB_ACCESS_REMOTE_WRITE;
+	send->s_reg_wr.access = access_flags;
 
 	ib_update_fast_reg_key(send->s_mr, send->s_remap_count++);
 
@@ -786,6 +787,7 @@ static int rds_iw_build_send_reg(struct rds_iw_send_work *send,
 int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 {
 	struct rds_iw_connection *ic = conn->c_transport_data;
+	struct ib_device *device = ic->i_cm_id->device;
 	struct rds_iw_send_work *send = NULL;
 	struct rds_iw_send_work *first;
 	struct rds_iw_send_work *prev;
@@ -803,11 +805,11 @@ int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 	int num_sge;
 	int sg_nents;
 
-	rds_iwdev = ib_get_client_data(ic->i_cm_id->device, &rds_iw_client);
+	rds_iwdev = ib_get_client_data(device, &rds_iw_client);
 
 	/* map the message the first time we see it */
 	if (!op->op_mapped) {
-		op->op_count = ib_dma_map_sg(ic->i_cm_id->device,
+		op->op_count = ib_dma_map_sg(device,
 					     op->op_sg, op->op_nents, (op->op_write) ?
 					     DMA_TO_DEVICE : DMA_FROM_DEVICE);
 		rdsdebug("ic %p mapping op %p: %d\n", ic, op, op->op_count);
@@ -896,12 +898,12 @@ int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 
 		for (j = 0; j < send->s_rdma_wr.wr.num_sge &&
 		     scat != &op->op_sg[op->op_count]; j++) {
-			len = ib_sg_dma_len(ic->i_cm_id->device, scat);
+			len = ib_sg_dma_len(device, scat);
 
 			if (send->s_rdma_wr.wr.opcode == IB_WR_RDMA_READ_WITH_INV)
 				sg_nents++;
 			else {
-				send->s_sge[j].addr = ib_sg_dma_address(ic->i_cm_id->device, scat);
+				send->s_sge[j].addr = ib_sg_dma_address(device, scat);
 				send->s_sge[j].length = len;
 				send->s_sge[j].lkey = rds_iw_local_dma_lkey(ic);
 			}
@@ -947,7 +949,8 @@ int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 	 */
 	if (!op->op_write) {
 		ret = rds_iw_build_send_reg(&ic->i_sends[fr_pos],
-					    &op->op_sg[0], sg_nents);
+					    &op->op_sg[0], sg_nents,
+					    device->rdma_read_access_flags);
 		if (ret) {
 			printk(KERN_WARNING "RDS/IW: failed to reg send mem\n");
 			goto out;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
