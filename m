From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] rping: create persistent server threads in DETACHED state
Date: Mon, 12 Jan 2015 10:57:40 -0600
Message-ID: <20150112165740.17112.18209.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since the persistent server threads aren't joined, they must be created in
the DETACHED state or resources will not be cleaned up when they exit.
This results in pthread_create() failures after thousands of rping
instances are run against a persistent server.

Also check the return from all calls to pthread_create() so we don't
ignore a thread creation failure.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 examples/rping.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index 58b642e..9486314 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -793,7 +793,11 @@ static void *rping_persistent_server_thread(void *arg)
 		goto err2;
 	}
 
-	pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	ret = pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	if (ret) {
+		perror("pthread_create");
+		goto err2;
+	}
 
 	ret = rping_accept(cb);
 	if (ret) {
@@ -825,11 +829,27 @@ static int rping_run_persistent_server(struct rping_cb *listening_cb)
 {
 	int ret;
 	struct rping_cb *cb;
+	pthread_attr_t attr;
 
 	ret = rping_bind_server(listening_cb);
 	if (ret)
 		return ret;
 
+	/*
+	 * Set persistent server threads to DEATCHED state so
+	 * they release all their resources when they exit.
+	 */
+	ret = pthread_attr_init(&attr);
+	if (ret) {
+		perror("pthread_attr_init");
+		return ret;
+	}
+	ret = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
+	if (ret) {
+		perror("pthread_attr_setdetachstate");
+		return ret;
+	}
+
 	while (1) {
 		sem_wait(&listening_cb->sem);
 		if (listening_cb->state != CONNECT_REQUEST) {
@@ -841,7 +861,12 @@ static int rping_run_persistent_server(struct rping_cb *listening_cb)
 		cb = clone_cb(listening_cb);
 		if (!cb)
 			return -1;
-		pthread_create(&cb->persistent_server_thread, NULL, rping_persistent_server_thread, cb);
+
+		ret = pthread_create(&cb->persistent_server_thread, &attr, rping_persistent_server_thread, cb);
+		if (ret) {
+			perror("pthread_create");
+			return ret;
+		}
 	}
 	return 0;
 }
@@ -880,7 +905,11 @@ static int rping_run_server(struct rping_cb *cb)
 		goto err2;
 	}
 
-	pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	ret = pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	if (ret) {
+		perror("pthread_create");
+		goto err2;
+	}
 
 	ret = rping_accept(cb);
 	if (ret) {
@@ -1055,7 +1084,11 @@ static int rping_run_client(struct rping_cb *cb)
 		goto err2;
 	}
 
-	pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	ret = pthread_create(&cb->cqthread, NULL, cq_thread, cb);
+	if (ret) {
+		perror("pthread_create");
+		goto err2;
+	}
 
 	ret = rping_connect_client(cb);
 	if (ret) {
@@ -1222,7 +1255,11 @@ int main(int argc, char *argv[])
 	}
 	DEBUG_LOG("created cm_id %p\n", cb->cm_id);
 
-	pthread_create(&cb->cmthread, NULL, cm_thread, cb);
+	ret = pthread_create(&cb->cmthread, NULL, cm_thread, cb);
+	if (ret) {
+		perror("pthread_create");
+		goto out2;
+	}
 
 	if (cb->server) {
 		if (persistent_server)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
