From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH] rxe: expose num_possible_cpus() cnum_comp_vectors
Date: Thu,  4 May 2017 16:23:07 +0300
Message-ID: <1493904187-13686-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Their completely logical, so don't pose an artificial limitation.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_param.h | 1 -
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 13ed2cc6eaa2..1b596fbbe251 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -114,7 +114,6 @@ enum rxe_device_param {
 	RXE_MAX_UCONTEXT		= 512,
 
 	RXE_NUM_PORT			= 1,
-	RXE_NUM_COMP_VECTORS		= 1,
 
 	RXE_MIN_QP_INDEX		= 16,
 	RXE_MAX_QP_INDEX		= 0x00020000,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 4c9080c94c06..3be4cbe365c6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1237,7 +1237,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->owner = THIS_MODULE;
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
-	dev->num_comp_vectors = RXE_NUM_COMP_VECTORS;
+	dev->num_comp_vectors = num_possible_cpus();
 	dev->dev.parent = rxe_dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	dev->node_guid = rxe_node_guid(rxe);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
