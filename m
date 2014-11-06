From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] rping: Fixes race, where ibv context was getting freed before memory was deregistered
Date: Thu,  6 Nov 2014 14:42:56 +0530
Message-ID: <1415265177-7616-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While running rping as a client without server on the other end, rping_test_client fails
and the ibv context was getting freed before memory was deregistered. This patch fixes it.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 examples/rping.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index 949cbe6..f0414de 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -1055,18 +1055,19 @@ static int rping_run_client(struct rping_cb *cb)
 	ret = rping_connect_client(cb);
 	if (ret) {
 		fprintf(stderr, "connect error %d\n", ret);
-		goto err2;
+		goto err3;
 	}
 
 	ret = rping_test_client(cb);
 	if (ret) {
 		fprintf(stderr, "rping client failed: %d\n", ret);
-		goto err3;
+		goto err4;
 	}
 
 	ret = 0;
-err3:
+err4:
 	rdma_disconnect(cb->cm_id);
+err3:
 	pthread_join(cb->cqthread, NULL);
 err2:
 	rping_free_buffers(cb);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
