From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/5] [librdmacm] rping: added checks to the return values functions
Date: Tue,  9 Oct 2012 14:27:52 +0200
Message-ID: <1349785672-1921-6-git-send-email-dotanb@dev.mellanox.co.il>
References: <1349785672-1921-1-git-send-email-dotanb@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349785672-1921-1-git-send-email-dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This will make rping to exit with return value other than zero in case of an
error.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rping.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index 32bd70a..d702592 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -881,7 +881,14 @@ static int rping_run_server(struct rping_cb *cb)
 		goto err2;
 	}
 
-	rping_test_server(cb);
+	ret = rping_test_server(cb);
+	if (ret) {
+		fprintf(stderr, "rping server failed: %d\n", ret);
+		goto err3;
+	}
+
+	ret = 0;
+err3:
 	rdma_disconnect(cb->child_cm_id);
 	pthread_join(cb->cqthread, NULL);
 	rdma_destroy_id(cb->child_cm_id);
@@ -1049,7 +1056,14 @@ static int rping_run_client(struct rping_cb *cb)
 		goto err2;
 	}
 
-	rping_test_client(cb);
+	ret = rping_test_client(cb);
+	if (ret) {
+		fprintf(stderr, "rping client failed: %d\n", ret);
+		goto err3;
+	}
+
+	ret = 0;
+err3:
 	rdma_disconnect(cb->cm_id);
 	pthread_join(cb->cqthread, NULL);
 err2:
@@ -1189,6 +1203,7 @@ int main(int argc, char *argv[])
 	cb->cm_channel = rdma_create_event_channel();
 	if (!cb->cm_channel) {
 		perror("rdma_create_event_channel");
+		ret = ENOMEM;
 		goto out;
 	}
 
@@ -1210,7 +1225,7 @@ int main(int argc, char *argv[])
 		ret = rping_run_client(cb);
 
 	DEBUG_LOG("destroy cm_id %p\n", cb->cm_id);
-	rdma_destroy_id(cb->cm_id);
+	ret = rdma_destroy_id(cb->cm_id);
 out2:
 	rdma_destroy_event_channel(cb->cm_channel);
 out:
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
