From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/11] IB/core: add a need_inval flag to struct ib_mr
Date: Tue,  3 May 2016 18:01:08 +0200
Message-ID: <1462291273-22403-7-git-send-email-hch@lst.de>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462291273-22403-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

This is the first step toward moving MR invalidation decisions
to the core.  It will be needed by the upcoming RW API.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8549345..76c9c3f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1353,6 +1353,7 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 		mr->pd      = pd;
 		mr->uobject = NULL;
 		atomic_inc(&pd->usecnt);
+		mr->need_inval = false;
 	}
 
 	return mr;
@@ -1399,6 +1400,7 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 		mr->pd      = pd;
 		mr->uobject = NULL;
 		atomic_inc(&pd->usecnt);
+		mr->need_inval = false;
 	}
 
 	return mr;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 400a8a0..3f66647 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1446,6 +1446,7 @@ struct ib_mr {
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
+	bool		   need_inval;
 	union {
 		struct ib_uobject	*uobject;	/* user */
 		struct list_head	qp_entry;	/* FR */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
