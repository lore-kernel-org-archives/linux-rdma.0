From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] IB/isert: do not ignore errors in dma_map_single()
Date: Sat, 22 Oct 2016 01:01:21 +0300
Message-ID: <1477087281-26275-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-rdma@vger.kernel.org

There are several places, where errors in dma_map_single() are
ignored. The patch fixes them.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f63238e..f0ba5f83b02c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1851,6 +1851,8 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
 				(void *)cmd->sense_buffer, pdu_len,
 				DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+			return -ENOMEM;
 
 		isert_cmd->pdu_buf_len = pdu_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
@@ -1978,6 +1980,8 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
 			(void *)cmd->buf_ptr, ISCSI_HDR_LEN,
 			DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+		return -ENOMEM;
 	isert_cmd->pdu_buf_len = ISCSI_HDR_LEN;
 	tx_dsg->addr	= isert_cmd->pdu_buf_dma;
 	tx_dsg->length	= ISCSI_HDR_LEN;
@@ -2018,6 +2022,8 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 		isert_cmd->pdu_buf_dma = ib_dma_map_single(ib_dev,
 				txt_rsp_buf, txt_rsp_len, DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ib_dev, isert_cmd->pdu_buf_dma))
+			return -ENOMEM;
 
 		isert_cmd->pdu_buf_len = txt_rsp_len;
 		tx_dsg->addr	= isert_cmd->pdu_buf_dma;
-- 
2.7.4
