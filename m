From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/9] ibacm: Rename client array
Date: Sun, 23 Mar 2014 13:18:14 -0700
Message-ID: <1395605901-9080-3-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rename the client array to client_array, to make it easier
to distinguish between the array and local variables, which
are also named client.

And, hey, this found the bug in the previous patch.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index c403aa8..57d34dc 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -210,7 +210,7 @@ static event_t timeout_event;
 static atomic_t wait_cnt;
 
 static SOCKET listen_socket;
-static struct acm_client client[FD_SETSIZE - 1];
+static struct acm_client client_array[FD_SETSIZE - 1];
 
 static FILE *flog;
 static lock_t log_lock;
@@ -1690,10 +1690,10 @@ static void acm_init_server(void)
 	int i;
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
-		lock_init(&client[i].lock);
-		client[i].index = i;
-		client[i].sock = INVALID_SOCKET;
-		atomic_init(&client[i].refcnt);
+		lock_init(&client_array[i].lock);
+		client_array[i].index = i;
+		client_array[i].sock = INVALID_SOCKET;
+		atomic_init(&client_array[i].refcnt);
 	}
 
 	if (!(f = fopen("/var/run/ibacm.port", "w"))) {
@@ -1758,7 +1758,7 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
-		if (!atomic_get(&client[i].refcnt))
+		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
 
@@ -1768,8 +1768,8 @@ static void acm_svr_accept(void)
 		return;
 	}
 
-	client[i].sock = s;
-	atomic_set(&client[i].refcnt, 1);
+	client_array[i].sock = s;
+	atomic_set(&client_array[i].refcnt, 1);
 	acm_log(2, "assigned client %d\n", i);
 }
 
@@ -2407,9 +2407,9 @@ static void acm_server(void)
 		FD_SET(listen_socket, &readfds);
 
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
-			if (client[i].sock != INVALID_SOCKET) {
-				FD_SET(client[i].sock, &readfds);
-				n = max(n, (int) client[i].sock);
+			if (client_array[i].sock != INVALID_SOCKET) {
+				FD_SET(client_array[i].sock, &readfds);
+				n = max(n, (int) client_array[i].sock);
 			}
 		}
 
@@ -2423,10 +2423,10 @@ static void acm_server(void)
 			acm_svr_accept();
 
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
-			if (client[i].sock != INVALID_SOCKET &&
-				FD_ISSET(client[i].sock, &readfds)) {
+			if (client_array[i].sock != INVALID_SOCKET &&
+				FD_ISSET(client_array[i].sock, &readfds)) {
 				acm_log(2, "receiving from client %d\n", i);
-				acm_svr_receive(&client[i]);
+				acm_svr_receive(&client_array[i]);
 			}
 		}
 	}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
