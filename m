From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/9] ibacm: Relocate client refcnt
Date: Sun, 23 Mar 2014 13:18:16 -0700
Message-ID: <1395605901-9080-5-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Adjust when we take a reference on the client connection.
Increment the client reference when we begin processing
the client's request, and release it when the response
has been sent.

The client reference will no longer be associated with the
lifetime of any underlying acm_request structure.  This change
will allow the acm core to control the client reference
count when we move to a provider plug-in model in subsequent
patches.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index c9e1b3c..4fc650b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -441,7 +441,6 @@ acm_alloc_req(struct acm_client *client, struct acm_msg *msg)
 		return NULL;
 	}
 
-	(void) atomic_inc(&client->refcnt);
 	req->client = client;
 	memcpy(&req->msg, msg, sizeof(req->msg));
 	acm_log(2, "client %d, req %p\n", client->index, req);
@@ -452,7 +451,6 @@ static void
 acm_free_req(struct acm_request *req)
 {
 	acm_log(2, "%p\n", req);
-	(void) atomic_dec(&req->client->refcnt);
 	free(req);
 }
 
@@ -1084,6 +1082,7 @@ acm_client_resolve_resp(struct acm_client *client, struct acm_msg *req_msg,
 
 release:
 	lock_release(&client->lock);
+	(void) atomic_dec(&client->refcnt);
 	return ret;
 }
 
@@ -1340,6 +1339,7 @@ acm_client_query_resp(struct acm_client *client,
 
 release:
 	lock_release(&client->lock);
+	(void) atomic_dec(&client->refcnt);
 	return ret;
 }
 
@@ -2311,6 +2311,8 @@ put:
 
 static int acm_svr_resolve(struct acm_client *client, struct acm_msg *msg)
 {
+	(void) atomic_inc(&client->refcnt);
+
 	if (msg->resolve_data[0].type == ACM_EP_INFO_PATH) {
 		if (msg->resolve_data[0].flags & ACM_FLAGS_QUERY_SA) {
 			return acm_svr_query_path(client, msg);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
