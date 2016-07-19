From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send limit
Date: Tue, 19 Jul 2016 09:22:03 -0700
Message-ID: <03e7f98e-d810-2299-9f3e-2c697d2699fb@sandisk.com>
References: <8fb358c3-3504-02ca-fcb8-1624f28be1b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8fb358c3-3504-02ca-fcb8-1624f28be1b0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For IB and RoCE, the SGE limit for a queue pair is typically lower
than what is defined by the HCA limits. For iWARP, the RDMA READ SGE
limit is defined by dev->attrs.max_sge_rd. Modify rdma_rw_max_sge()
accordingly.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/rw.c    | 8 ++++----
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1ad2baa..6ecdad6 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -58,11 +58,11 @@ static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 	return false;
 }
 
-static inline u32 rdma_rw_max_sge(struct ib_device *dev,
+static inline u32 rdma_rw_max_sge(struct ib_device *dev, struct ib_qp *qp,
 		enum dma_data_direction dir)
 {
-	return dir == DMA_TO_DEVICE ?
-		dev->attrs.max_sge : dev->attrs.max_sge_rd;
+	return dir == DMA_TO_DEVICE ? qp->max_send_sge :
+		min_t(u32, qp->max_send_sge, dev->attrs.max_sge_rd);
 }
 
 static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
@@ -186,7 +186,7 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
 	struct ib_device *dev = qp->pd->device;
-	u32 max_sge = rdma_rw_max_sge(dev, dir);
+	u32 max_sge = rdma_rw_max_sge(dev, qp, dir);
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
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
