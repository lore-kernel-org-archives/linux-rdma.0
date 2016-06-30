From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send limit
Date: Thu, 30 Jun 2016 15:49:44 +0200
Message-ID: <7b9f8bca-38fa-b289-a92f-19cf93955e32@sandisk.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SGE limit for a queue pair is typically lower than what is
defined by the HCA limits. Hence use the QP SGE send limit
instead of the HCA send limit.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/rw.c    | 9 +--------
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 1 +
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1ad2baa..425e711 100644
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
@@ -186,7 +179,7 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
 	struct ib_device *dev = qp->pd->device;
-	u32 max_sge = rdma_rw_max_sge(dev, dir);
+	u32 max_sge = qp->max_send_sge;
 	struct ib_sge *sge;
 	u32 total_len = 0, i, j;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6298f54..c7f840e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -814,6 +814,8 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		}
 	}
 
+	qp->max_send_sge = qp_init_attr->cap.max_send_sge;
+
 	return qp;
 }
 EXPORT_SYMBOL(ib_create_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7e440d4..c44dbf6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1449,6 +1449,7 @@ struct ib_qp {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
 	u32			qp_num;
+	u32			max_send_sge;
 	enum ib_qp_type		qp_type;
 };
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
