From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/9] ibacm: Record index for source and destination addresses
Date: Sun, 23 Mar 2014 13:18:17 -0700
Message-ID: <1395605901-9080-6-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When processing a resolve route message, record what
index the source and destination addresses were located
at directly into the message.  This replaces returning
pointers to the source and destination address that must
then be passed around.

When provider plug-in support is added in subsequent
patches, this will avoid pointer exchanges between the
core and provider code.

Fix a minor issue where the src_out field may be
uninitialized (value read from client message).  Src_out
now becomes a boolean value, rather than an index.  The
actual location for the output is specified as an index.

This change cleanups the call to acm_svr_select_src,
which selects a source address.  It is only called when
a source is needed, which is explicitly determined by
seeing if src_out is set, rather than relying on a zero
src type field.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   54 ++++++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 4fc650b..16e929b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -49,6 +49,8 @@
 #include "acm_mad.h"
 
 #define src_out     data[0]
+#define src_index   data[1]
+#define dst_index   data[2]
 
 #define IB_LID_MCAST_START 0xc000
 
@@ -1069,7 +1071,7 @@ acm_client_resolve_resp(struct acm_client *client, struct acm_msg *req_msg,
 		if (req_msg->hdr.src_out) {
 			msg.hdr.length += ACM_MSG_EP_LENGTH;
 			memcpy(&msg.resolve_data[1],
-				&req_msg->resolve_data[req_msg->hdr.src_out],
+				&req_msg->resolve_data[req_msg->hdr.src_index],
 				ACM_MSG_EP_LENGTH);
 		}
 	}
@@ -1980,9 +1982,6 @@ static int acm_svr_select_src(struct acm_ep_addr_data *src, struct acm_ep_addr_d
 	int ret;
 	SOCKET s;
 
-	if (src->type)
-		return 0;
-
 	acm_log(2, "selecting source address\n");
 	memset(&addr, 0, sizeof addr);
 	switch (dst->type) {
@@ -2038,24 +2037,24 @@ out:
  * references to the source and destination addresses.
  * The message buffer contains extra address data buffers.  If a
  * source address is not given, reference an empty address buffer,
- * and we'll resolve a source address later.
+ * and we'll resolve a source address later.  Record the location of
+ * the source and destination addresses in the message header data
+ * to avoid further searches.
  */
-static uint8_t
-acm_svr_verify_resolve(struct acm_msg *msg,
-	struct acm_ep_addr_data **saddr, struct acm_ep_addr_data **daddr)
+static uint8_t acm_svr_verify_resolve(struct acm_msg *msg)
 {
-	struct acm_ep_addr_data *src = NULL, *dst = NULL;
-	int i, cnt;
+	int i, cnt, have_dst = 0;
 
 	if (msg->hdr.length < ACM_MSG_HDR_LENGTH) {
 		acm_log(0, "ERROR - invalid msg hdr length %d\n", msg->hdr.length);
 		return ACM_STATUS_EINVAL;
 	}
 
+	msg->hdr.src_out = 1;
 	cnt = (msg->hdr.length - ACM_MSG_HDR_LENGTH) / ACM_MSG_EP_LENGTH;
 	for (i = 0; i < cnt; i++) {
 		if (msg->resolve_data[i].flags & ACM_EP_FLAG_SOURCE) {
-			if (src) {
+			if (!msg->hdr.src_out) {
 				acm_log(0, "ERROR - multiple sources specified\n");
 				return ACM_STATUS_ESRCADDR;
 			}
@@ -2064,10 +2063,11 @@ acm_svr_verify_resolve(struct acm_msg *msg,
 				acm_log(0, "ERROR - unsupported source address type\n");
 				return ACM_STATUS_ESRCTYPE;
 			}
-			src = &msg->resolve_data[i];
+			msg->hdr.src_out = 0;
+			msg->hdr.src_index = i;
 		}
 		if (msg->resolve_data[i].flags & ACM_EP_FLAG_DEST) {
-			if (dst) {
+			if (have_dst) {
 				acm_log(0, "ERROR - multiple destinations specified\n");
 				return ACM_STATUS_EDESTADDR;
 			}
@@ -2076,22 +2076,20 @@ acm_svr_verify_resolve(struct acm_msg *msg,
 				acm_log(0, "ERROR - unsupported destination address type\n");
 				return ACM_STATUS_EDESTTYPE;
 			}
-			dst = &msg->resolve_data[i];
+			have_dst = 1;
+			msg->hdr.dst_index = i;
 		}
 	}
 
-	if (!dst) {
+	if (!have_dst) {
 		acm_log(0, "ERROR - destination address required\n");
 		return ACM_STATUS_EDESTTYPE;
 	}
 
-	if (!src) {
-		msg->hdr.src_out = i;
-		src = &msg->resolve_data[i];
-		memset(src, 0, sizeof *src);
+	if (msg->hdr.src_out) {
+		msg->hdr.src_index = i;
+		memset(&msg->resolve_data[i], 0, sizeof(struct acm_ep_addr_data));
 	}
-	*saddr = src;
-	*daddr = dst;
 	return ACM_STATUS_SUCCESS;
 }
 
@@ -2138,16 +2136,20 @@ acm_svr_resolve_dest(struct acm_client *client, struct acm_msg *msg)
 	int ret;
 
 	acm_log(2, "client %d\n", client->index);
-	status = acm_svr_verify_resolve(msg, &saddr, &daddr);
+	status = acm_svr_verify_resolve(msg);
 	if (status) {
 		acm_log(0, "notice - misformatted or unsupported request\n");
 		return acm_client_resolve_resp(client, msg, NULL, status);
 	}
 
-	status = acm_svr_select_src(saddr, daddr);
-	if (status) {
-		acm_log(0, "notice - unable to select suitable source address\n");
-		return acm_client_resolve_resp(client, msg, NULL, status);
+	saddr = &msg->resolve_data[msg->hdr.src_index];
+	daddr = &msg->resolve_data[msg->hdr.dst_index];
+	if (msg->hdr.src_out) {
+		status = acm_svr_select_src(saddr, daddr);
+		if (status) {
+			acm_log(0, "notice - unable to select suitable source address\n");
+			return acm_client_resolve_resp(client, msg, NULL, status);
+		}
 	}
 
 	acm_format_name(2, log_data, sizeof log_data,
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
