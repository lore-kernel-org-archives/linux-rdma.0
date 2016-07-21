From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send limit
Date: Thu, 21 Jul 2016 13:03:30 -0700
Message-ID: <c71ece34-36e2-86da-5032-2fc946ff0073@sandisk.com>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75fc8647-16a6-5a89-400f-f5f418a8d6eb-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Compute the SGE limit for RDMA READ and WRITE requests in
ib_create_qp(). Use that limit in the RDMA RW API implementation.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
---
 drivers/infiniband/core/rw.c    | 10 ++--------
 drivers/infiniband/core/verbs.c |  9 +++++++++
 include/rdma/ib_verbs.h         |  6 ++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1ad2baa..dbfd854 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -58,13 +58,6 @@ static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 	return false;
 }
 
-static inline u32 rdma_rw_max_sge(struct ib_device *dev,
-		enum dma_data_direction dir)
-{
-	return dir == DMA_TO_DEVICE ?
-		dev->attrs.max_sge : dev->attrs.max_sge_rd;
-}
-
 static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
 {
 	/* arbitrary limit to avoid allocating gigantic resources */
@@ -186,7 +179,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
 	struct ib_device *dev = qp->pd->device;
-	u32 max_sge = rdma_rw_max_sge(dev, dir);
+	u32 max_sge = dir == DMA_TO_DEVICE ? qp->max_write_sge :
+		      qp->max_read_sge;
 	struct ib_sge *sge;
 	u32 total_len = 0, i, j;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6298f54..e39a0b5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -814,6 +814,15 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		}
 	}
 
+	/*
+	 * Note: all hw drivers guarantee that max_send_sge is lower than
+	 * the device RDMA WRITE SGE limit but not all hw drivers ensure that
+	 * max_send_sge <= max_sge_rd.
+	 */
+	qp->max_write_sge = qp_init_attr->cap.max_send_sge;
+	qp->max_read_sge = min_t(u32, qp_init_attr->cap.max_send_sge,
+				 device->attrs.max_sge_rd);
+
 	return qp;
 }
 EXPORT_SYMBOL(ib_create_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7e440d4..e694f02 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1428,6 +1428,10 @@ struct ib_srq {
 	} ext;
 };
 
+/*
+ * @max_write_sge: Maximum SGE elements per RDMA WRITE request.
+ * @max_read_sge:  Maximum SGE elements per RDMA READ request.
+ */
 struct ib_qp {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
@@ -1449,6 +1453,8 @@ struct ib_qp {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
 	u32			qp_num;
+	u32			max_write_sge;
+	u32			max_read_sge;
 	enum ib_qp_type		qp_type;
 };
 
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
