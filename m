From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 6/9] IB/core: add a need_inval flag to struct ib_mr
Date: Fri, 11 Mar 2016 19:53:16 +0100
Message-ID: <1457722399-25811-7-git-send-email-hch@lst.de>
References: <1457722399-25811-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457722399-25811-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com, bart.vanassche@sandisk.com
Cc: swise@opengridcomputing.com, sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@chelsio.com>

This is the first step toward moving MR invalidation decisions
to the core.  It will be needed by the upcoming RW API.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5e017c1..5955d14 100644
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
index 355f5b2..068d540 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1430,6 +1430,7 @@ struct ib_mr {
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
+	bool		   need_inval;
 	union {
 		struct ib_uobject	*uobject;	/* user */
 		struct list_head	qp_entry;	/* FR */
-- 
2.1.4
