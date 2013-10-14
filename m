From: Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] drivers: infiniband: ulp: Fix possible use-after-free
Date: Sun, 13 Oct 2013 21:22:46 -0300
Message-ID: <1381710166-27341-1-git-send-email-felipensp@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The tx_desc variable is being used to access its type member
after a kmem_cache_free call

Signed-off-by: Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 5388226..15b545c 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -610,17 +610,15 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
 		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
 					ISER_HEADERS_LEN, DMA_TO_DEVICE);
 		kmem_cache_free(ig.desc_cache, tx_desc);
-	}
-
-	atomic_dec(&ib_conn->post_send_buf_count);
-
-	if (tx_desc->type == ISCSI_TX_CONTROL) {
+	} else if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		task = (void *) ((long)(void *)tx_desc -
 				  sizeof(struct iscsi_task));
 		if (task->hdr->itt == RESERVED_ITT)
 			iscsi_put_task(task);
 	}
+
+	atomic_dec(&ib_conn->post_send_buf_count);
 }
 
 void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
