From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/5] libbnxt_re: unmap DB page during uninit ucontext
Date: Fri, 12 May 2017 06:24:25 -0400
Message-ID: <1494584666-11064-5-git-send-email-devesh.sharma@broadcom.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Library is trying to map DPI page every time a new PD is
allocated on a given user-context. Similarly, the free-PD
is trying to unmap the PD in every call. However, dapltest
is trying to ring the DB after a free-PD.

Library needs to mmap the DB page only once during first
PD allocation on a given user-context. The unmap of DB page
should be done during uninit_ucontext. This function is
called during ibv_close.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.c  |  9 +++++++++
 providers/bnxt_re/verbs.c | 27 ++++++++++++---------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index da4dd06..29ac7cd 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -159,6 +159,15 @@ static void bnxt_re_uninit_context(struct verbs_device *vdev,
 	if (cntx->shpg)
 		munmap(cntx->shpg, dev->pg_size);
 	pthread_spin_destroy(&cntx->fqlock);
+
+	/* Un-map DPI only for the first PD that was
+	 * allocated in this context.
+	 */
+	if (cntx->udpi.dbpage && cntx->udpi.dbpage != MAP_FAILED) {
+		pthread_spin_destroy(&cntx->udpi.db_lock);
+		munmap(cntx->udpi.dbpage, dev->pg_size);
+		cntx->udpi.dbpage = NULL;
+	}
 }
 
 static struct verbs_device_ops bnxt_re_dev_ops = {
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index abe4e2e..d337514 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -96,14 +96,17 @@ struct ibv_pd *bnxt_re_alloc_pd(struct ibv_context *ibvctx)
 	dbr = *(uint64_t *)((uint32_t *)&resp + 3);
 
 	/* Map DB page now. */
-	cntx->udpi.dpindx = resp.dpi;
-	cntx->udpi.dbpage = mmap(NULL, dev->pg_size, PROT_WRITE, MAP_SHARED,
-				 ibvctx->cmd_fd, dbr);
-	if (cntx->udpi.dbpage == MAP_FAILED) {
-		(void)ibv_cmd_dealloc_pd(&pd->ibvpd);
-		goto out;
-	}
-	pthread_spin_init(&cntx->udpi.db_lock, PTHREAD_PROCESS_PRIVATE);
+	if (!cntx->udpi.dbpage) {
+		cntx->udpi.dpindx = resp.dpi;
+		cntx->udpi.dbpage = mmap(NULL, dev->pg_size, PROT_WRITE,
+					 MAP_SHARED, ibvctx->cmd_fd, dbr);
+		if (cntx->udpi.dbpage == MAP_FAILED) {
+			(void)ibv_cmd_dealloc_pd(&pd->ibvpd);
+			goto out;
+		}
+		pthread_spin_init(&cntx->udpi.db_lock,
+				  PTHREAD_PROCESS_PRIVATE);
+        }
 
 	return &pd->ibvpd;
 out:
@@ -114,18 +117,12 @@ out:
 int bnxt_re_free_pd(struct ibv_pd *ibvpd)
 {
 	struct bnxt_re_pd *pd = to_bnxt_re_pd(ibvpd);
-	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
-	struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
 	int status;
 
 	status = ibv_cmd_dealloc_pd(ibvpd);
 	if (status)
 		return status;
-
-	pthread_spin_destroy(&cntx->udpi.db_lock);
-	if (cntx->udpi.dbpage && (cntx->udpi.dbpage != MAP_FAILED))
-		munmap(cntx->udpi.dbpage, dev->pg_size);
-
+	/* DPI un-mapping will be during uninit_ucontext */
 	free(pd);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
