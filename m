From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 04/22] IB/iser: Fix missing return status check in iser_send_data_out
Date: Thu,  6 Aug 2015 18:32:48 +0300
Message-ID: <1438875186-4310-5-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since commit "IB/iser: Fix race between iser connection teardown..."
iser_initialize_task_headers() might fail, so we need to check that.

Fixes: 7414dde0a6c3a958e (IB/iser: Fix race between iser connection ...)
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 2d02f04..174799e 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -454,7 +454,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	unsigned long buf_offset;
 	unsigned long data_seg_len;
 	uint32_t itt;
-	int err = 0;
+	int err;
 	struct ib_sge *tx_dsg;
 
 	itt = (__force uint32_t)hdr->itt;
@@ -475,7 +475,9 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	memcpy(&tx_desc->iscsi_header, hdr, sizeof(struct iscsi_hdr));
 
 	/* build the tx desc */
-	iser_initialize_task_headers(task, tx_desc);
+	err = iser_initialize_task_headers(task, tx_desc);
+	if (err)
+		goto send_data_out_error;
 
 	mem_reg = &iser_task->rdma_reg[ISER_DIR_OUT];
 	tx_dsg = &tx_desc->tx_sg[1];
@@ -502,7 +504,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 
 send_data_out_error:
 	kmem_cache_free(ig.desc_cache, tx_desc);
-	iser_err("conn %p failed err %d\n",conn, err);
+	iser_err("conn %p failed err %d\n", conn, err);
 	return err;
 }
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
