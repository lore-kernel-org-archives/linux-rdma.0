From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/5] ocrdma: Remove ocrdma_dev_list
Date: Thu, 31 Aug 2017 14:50:59 -0600
Message-ID: <1504212659-9674-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Nothing ever reads this.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/ocrdma/ocrdma_main.c | 7 -------
 providers/ocrdma/ocrdma_main.h | 1 -
 2 files changed, 8 deletions(-)

diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 591630677461cf..8888067761ab37 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -66,9 +66,6 @@ static struct {
 	UCNA(EMULEX, GEN1), UCNA(EMULEX, GEN2), UCNA(EMULEX, GEN2_VF)
 };
 
-static LIST_HEAD(ocrdma_dev_list);
-static pthread_mutex_t ocrdma_dev_list_lock = PTHREAD_MUTEX_INITIALIZER;
-
 static struct ibv_context *ocrdma_alloc_context(struct ibv_device *, int);
 static void ocrdma_free_context(struct ibv_context *);
 
@@ -229,10 +226,6 @@ found:
 	pthread_mutex_init(&dev->dev_lock, NULL);
 	pthread_spin_init(&dev->flush_q_lock, PTHREAD_PROCESS_PRIVATE);
 	dev->ibv_dev.ops = &ocrdma_dev_ops;
-	list_node_init(&dev->entry);
-	pthread_mutex_lock(&ocrdma_dev_list_lock);
-	list_add_tail(&ocrdma_dev_list, &dev->entry);
-	pthread_mutex_unlock(&ocrdma_dev_list_lock);
 	return &dev->ibv_dev;
 qp_err:
 	free(dev);
diff --git a/providers/ocrdma/ocrdma_main.h b/providers/ocrdma/ocrdma_main.h
index b2b27abdcabfd1..05bb12435fb1cc 100644
--- a/providers/ocrdma/ocrdma_main.h
+++ b/providers/ocrdma/ocrdma_main.h
@@ -58,7 +58,6 @@ struct ocrdma_device {
 	struct ocrdma_qp **qp_tbl;
 	pthread_mutex_t dev_lock;
 	pthread_spinlock_t flush_q_lock;
-	struct list_node entry;
 	int id;
 	int gen;
 	uint32_t wqe_size;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
