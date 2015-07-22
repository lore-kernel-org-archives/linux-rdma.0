From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 06/10] IB/iser: Use pd->local_dma_lkey
Date: Wed, 22 Jul 2015 17:34:39 -0600
Message-ID: <1437608083-22898-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

Replace all leys with  pd->local_dma_lkey. This driver does not support
iWarp, so this is safe.

The insecure use of ib_get_dma_mr is thus isolated to an rkey, and this
looks trivially fixed by forcing the use of registration in a future
patch.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     | 2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c | 8 ++++----
 drivers/infiniband/ulp/iser/iser_memory.c    | 2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6a594aac2290..f44c6b879329 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -204,7 +204,7 @@ iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
-	tx_desc->tx_sg[0].lkey   = device->mr->lkey;
+	tx_desc->tx_sg[0].lkey   = device->pd->local_dma_lkey;
 
 	iser_task->iser_conn = iser_conn;
 out:
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 3e2118e8ed87..2d02f042c69a 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -173,8 +173,8 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 
 	tx_desc->num_sge = 1;
 
-	if (tx_desc->tx_sg[0].lkey != device->mr->lkey) {
-		tx_desc->tx_sg[0].lkey = device->mr->lkey;
+	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
+		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
 		iser_dbg("sdesc %p lkey mismatch, fixing\n", tx_desc);
 	}
 }
@@ -291,7 +291,7 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 		rx_sg = &rx_desc->rx_sg;
 		rx_sg->addr   = rx_desc->dma_addr;
 		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
-		rx_sg->lkey   = device->mr->lkey;
+		rx_sg->lkey   = device->pd->local_dma_lkey;
 	}
 
 	iser_conn->rx_desc_head = 0;
@@ -543,7 +543,7 @@ int iser_send_control(struct iscsi_conn *conn,
 
 		tx_dsg->addr    = iser_conn->login_req_dma;
 		tx_dsg->length  = task->data_count;
-		tx_dsg->lkey    = device->mr->lkey;
+		tx_dsg->lkey    = device->pd->local_dma_lkey;
 		mdesc->num_sge = 2;
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f0cdc961eb11..3129a42150ff 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -393,7 +393,7 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 {
 	struct scatterlist *sg = mem->sg;
 
-	reg->sge.lkey = device->mr->lkey;
+	reg->sge.lkey = device->pd->local_dma_lkey;
 	reg->rkey = device->mr->rkey;
 	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
 	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5c9f565ea0e8..52268356c79e 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1017,7 +1017,7 @@ int iser_post_recvl(struct iser_conn *iser_conn)
 
 	sge.addr   = iser_conn->login_resp_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey   = ib_conn->device->mr->lkey;
+	sge.lkey   = ib_conn->device->pd->local_dma_lkey;
 
 	rx_wr.wr_id   = (uintptr_t)iser_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
-- 
2.1.4
