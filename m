From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 10/37] IB/core: Change the type of an ib_dma_alloc_coherent() argument
Date: Fri, 20 Jan 2017 13:04:10 -0800
Message-ID: <20170120210437.26389-11-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change the type of the dma_handle argument from u64 * to dma_addr_t *.
This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 include/rdma/ib_verbs.h | 13 ++++++-------
 net/rds/ib.h            |  6 +++---
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8b9a3767f695..fd4e42dd1efc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3171,19 +3171,18 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
  */
 static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
 					   size_t size,
-					   u64 *dma_handle,
+					   dma_addr_t *dma_handle,
 					   gfp_t flag)
 {
-	if (dev->dma_ops)
-		return dev->dma_ops->alloc_coherent(dev, size, dma_handle, flag);
-	else {
-		dma_addr_t handle;
+	if (dev->dma_ops) {
+		u64 handle;
 		void *ret;
 
-		ret = dma_alloc_coherent(dev->dma_device, size, &handle, flag);
+		ret = dev->dma_ops->alloc_coherent(dev, size, &handle, flag);
 		*dma_handle = handle;
 		return ret;
 	}
+	return dma_alloc_coherent(dev->dma_device, size, dma_handle, flag);
 }
 
 /**
@@ -3195,7 +3194,7 @@ static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
  */
 static inline void ib_dma_free_coherent(struct ib_device *dev,
 					size_t size, void *cpu_addr,
-					u64 dma_handle)
+					dma_addr_t dma_handle)
 {
 	if (dev->dma_ops)
 		dev->dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 45ac8e8e58f4..d21ca88ab628 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -134,7 +134,7 @@ struct rds_ib_connection {
 	struct rds_ib_work_ring	i_send_ring;
 	struct rm_data_op	*i_data_op;
 	struct rds_header	*i_send_hdrs;
-	u64			i_send_hdrs_dma;
+	dma_addr_t		i_send_hdrs_dma;
 	struct rds_ib_send_work *i_sends;
 	atomic_t		i_signaled_sends;
 
@@ -144,7 +144,7 @@ struct rds_ib_connection {
 	struct rds_ib_incoming	*i_ibinc;
 	u32			i_recv_data_rem;
 	struct rds_header	*i_recv_hdrs;
-	u64			i_recv_hdrs_dma;
+	dma_addr_t		i_recv_hdrs_dma;
 	struct rds_ib_recv_work *i_recvs;
 	u64			i_ack_recv;	/* last ACK received */
 	struct rds_ib_refill_cache i_cache_incs;
@@ -161,7 +161,7 @@ struct rds_ib_connection {
 	struct rds_header	*i_ack;
 	struct ib_send_wr	i_ack_wr;
 	struct ib_sge		i_ack_sge;
-	u64			i_ack_dma;
+	dma_addr_t		i_ack_dma;
 	unsigned long		i_ack_queued;
 
 	/* Flow control related information
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
