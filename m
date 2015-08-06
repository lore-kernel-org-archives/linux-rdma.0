From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 07/22] IB/iser: Remove a redundant always-false condition
Date: Thu,  6 Aug 2015 18:32:51 +0300
Message-ID: <1438875186-4310-8-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We always call iser_initialize_task_headers() and set
the header tx_sg.lkey to the device mr lkey, so no
point in checking it in iser_create_send_desc().

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 174799e..42d6f42 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -170,13 +170,7 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 
 	memset(&tx_desc->iser_header, 0, sizeof(struct iser_hdr));
 	tx_desc->iser_header.flags = ISER_VER;
-
 	tx_desc->num_sge = 1;
-
-	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
-		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
-		iser_dbg("sdesc %p lkey mismatch, fixing\n", tx_desc);
-	}
 }
 
 static void iser_free_login_buf(struct iser_conn *iser_conn)
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
