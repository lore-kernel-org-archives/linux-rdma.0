From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH v2 07/12] iser-target: Remove ib_get_dma_mr calls
Date: Thu, 30 Jul 2015 17:22:21 -0600
Message-ID: <1438298547-21404-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 33 +++++++++++----------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 -
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 771700963127..00d75d977131 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -235,7 +235,7 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 		rx_sg = &rx_desc->rx_sg;
 		rx_sg->addr = rx_desc->dma_addr;
 		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
-		rx_sg->lkey = device->mr->lkey;
+		rx_sg->lkey = device->pd->local_dma_lkey;
 	}
 
 	isert_conn->rx_desc_head = 0;
@@ -385,22 +385,12 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(device->mr)) {
-		ret = PTR_ERR(device->mr);
-		isert_err("failed to create dma mr, device %p, ret=%d\n",
-			  device, ret);
-		goto out_mr;
-	}
-
 	/* Check signature cap */
 	device->pi_capable = dev_attr->device_cap_flags &
 			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
 
 	return 0;
 
-out_mr:
-	ib_dealloc_pd(device->pd);
 out_cq:
 	isert_free_comps(device);
 	return ret;
@@ -411,7 +401,6 @@ isert_free_device_ib_res(struct isert_device *device)
 {
 	isert_info("device %p\n", device);
 
-	ib_dereg_mr(device->mr);
 	ib_dealloc_pd(device->pd);
 	isert_free_comps(device);
 }
@@ -1086,8 +1075,8 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	tx_desc->num_sge = 1;
 	tx_desc->isert_cmd = isert_cmd;
 
-	if (tx_desc->tx_sg[0].lkey != device->mr->lkey) {
-		tx_desc->tx_sg[0].lkey = device->mr->lkey;
+	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
+		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
 		isert_dbg("tx_desc %p lkey mismatch, fixing\n", tx_desc);
 	}
 }
@@ -1110,7 +1099,7 @@ isert_init_tx_hdrs(struct isert_conn *isert_conn,
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr	= tx_desc->dma_addr;
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
-	tx_desc->tx_sg[0].lkey = device->mr->lkey;
+	tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
 
 	isert_dbg("Setup tx_sg[0].addr: 0x%llx length: %u lkey: 0x%x\n",
 		  tx_desc->tx_sg[0].addr, tx_desc->tx_sg[0].length,
@@ -1143,7 +1132,7 @@ isert_rdma_post_recvl(struct isert_conn *isert_conn)
 	memset(&sge, 0, sizeof(struct ib_sge));
 	sge.addr = isert_conn->login_req_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey = isert_conn->device->mr->lkey;
+	sge.lkey = isert_conn->device->pd->local_dma_lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
 		sge.addr, sge.length, sge.lkey);
@@ -1193,7 +1182,7 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 
 		tx_dsg->addr	= isert_conn->login_rsp_dma;
 		tx_dsg->length	= length;
-		tx_dsg->lkey	= isert_conn->device->mr->lkey;
+		tx_dsg->lkey	= isert_conn->device->pd->local_dma_lkey;
 		tx_desc->num_sge = 2;
 	}
 	if (!login->login_failed) {
@@ -2210,7 +2199,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->pdu_buf_len = pdu_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 		tx_dsg->length	= pdu_len;
-		tx_dsg->lkey	= device->mr->lkey;
+		tx_dsg->lkey	= device->pd->local_dma_lkey;
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
@@ -2338,7 +2327,7 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_cmd->pdu_buf_len = ISCSI_HDR_LEN;
 	tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 	tx_dsg->length	= ISCSI_HDR_LEN;
-	tx_dsg->lkey	= device->mr->lkey;
+	tx_dsg->lkey	= device->pd->local_dma_lkey;
 	isert_cmd->tx_desc.num_sge = 2;
 
 	isert_init_send_wr(isert_conn, isert_cmd, send_wr);
@@ -2379,7 +2368,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		isert_cmd->pdu_buf_len = txt_rsp_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 		tx_dsg->length	= txt_rsp_len;
-		tx_dsg->lkey	= device->mr->lkey;
+		tx_dsg->lkey	= device->pd->local_dma_lkey;
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 	isert_init_send_wr(isert_conn, isert_cmd, send_wr);
@@ -2420,7 +2409,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		ib_sge->addr = ib_sg_dma_address(ib_dev, tmp_sg) + page_off;
 		ib_sge->length = min_t(u32, data_left,
 				ib_sg_dma_len(ib_dev, tmp_sg) - page_off);
-		ib_sge->lkey = device->mr->lkey;
+		ib_sge->lkey = device->pd->local_dma_lkey;
 
 		isert_dbg("RDMA ib_sge: addr: 0x%llx  length: %u lkey: %x\n",
 			  ib_sge->addr, ib_sge->length, ib_sge->lkey);
@@ -2594,7 +2583,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	u32 page_off;
 
 	if (mem->dma_nents == 1) {
-		sge->lkey = device->mr->lkey;
+		sge->lkey = device->pd->local_dma_lkey;
 		sge->addr = ib_sg_dma_address(ib_dev, &mem->sg[0]);
 		sge->length = ib_sg_dma_len(ib_dev, &mem->sg[0]);
 		isert_dbg("sge: addr: 0x%llx  length: %u lkey: %x\n",
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 9ec23a786c02..6a04ba3c0f72 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -209,7 +209,6 @@ struct isert_device {
 	int			refcount;
 	struct ib_device	*ib_device;
 	struct ib_pd		*pd;
-	struct ib_mr		*mr;
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
-- 
2.1.4
