From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] RPING: Make sure CQ event thread exits before destroying
	the CQ.
Date: Wed, 20 Oct 2010 14:28:59 -0500
Message-ID: <20101020192859.1431.68877.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is possible for the CQ event thread to poll the CQ after it has been
destroyed which can result in a seg fault on T3 interfaces.  This patch
cancels the thread and waits for it to exit before destroying the CQ.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 examples/rping.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index 91952e7..e603d3b 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -800,10 +800,10 @@ static void *rping_persistent_server_thread(void *arg)
 
 	rping_test_server(cb);
 	rdma_disconnect(cb->child_cm_id);
-	rping_free_buffers(cb);
-	rping_free_qp(cb);
 	pthread_cancel(cb->cqthread);
 	pthread_join(cb->cqthread, NULL);
+	rping_free_buffers(cb);
+	rping_free_qp(cb);
 	rdma_destroy_id(cb->child_cm_id);
 	free_cb(cb);
 	return NULL;
@@ -888,6 +888,8 @@ static int rping_run_server(struct rping_cb *cb)
 
 	rping_test_server(cb);
 	rdma_disconnect(cb->child_cm_id);
+	pthread_cancel(cb->cqthread);
+	pthread_join(cb->cqthread, NULL);
 	rdma_destroy_id(cb->child_cm_id);
 err2:
 	rping_free_buffers(cb);
@@ -1055,6 +1057,8 @@ static int rping_run_client(struct rping_cb *cb)
 
 	rping_test_client(cb);
 	rdma_disconnect(cb->cm_id);
+	pthread_cancel(cb->cqthread);
+	pthread_join(cb->cqthread, NULL);
 err2:
 	rping_free_buffers(cb);
 err1:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
