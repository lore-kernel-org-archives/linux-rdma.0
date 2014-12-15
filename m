From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/4] dtestx: allow scale up to 1000 EP's
Date: Mon, 15 Dec 2014 11:58:53 -0800
Message-ID: <1418673535-1464-3-git-send-email-arlin.r.davis@intel.com>
References: <1418673535-1464-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418673535-1464-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dtest/dtestx.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 8b3294a..931c860 100755
--- a/test/dtest/dtestx.c
+++ b/test/dtest/dtestx.c
@@ -143,7 +143,7 @@ int disconnect_ep(void);
 #define RCV_RDMA_BUF_INDEX	1
 #define SEND_BUF_INDEX		2
 #define RECV_BUF_INDEX		3
-#define MAX_EP_COUNT		8
+#define MAX_EP_COUNT		1000
 #define MAX_AH_COUNT		(MAX_EP_COUNT * 2)
 
 DAT_VADDR *atomic_buf;
@@ -520,8 +520,8 @@ send_msg(void *data,
 		if (ud_test) {
 			/* 
 			 * single QP - ep[0] and ah[0] for client and server
-			 * multi QP  - ep[i]->ah[i] for client, to 0
-			 *             ep[0]->ah[i] for server, to all
+			 * multi QP  - ep[i]->ah[i] for client, i to i
+			 *             ep[0]->ah[i] for server, 0 to all
 			 */
 			if (multi_eps) {
 				ah_idx = i;
@@ -704,7 +704,10 @@ void process_conn(int idx)
 	}
 
 	if (ia_attr.extension_version >= 209) {
-		/* Destroy CM resources for AH resolution */
+		LOGPRINTF("%s EP_L[%d]=%p -> cm %p CM_FREE\n",
+			   ext_event->type == DAT_IB_UD_PASSIVE_REMOTE_AH ?
+			  "PASSIVE":"ACTIVE ", ep_l, ep[ep_l],
+			  ext_event->context.as_ptr);
 		dat_ib_ud_cm_free(ep[ep_l], ext_event->context.as_ptr);
 	}
 
@@ -723,7 +726,7 @@ int connect_ep(char *hostname, struct sockaddr *ser_sa)
 	DAT_DTO_COOKIE cookie;
 	DAT_CONN_QUAL conn_qual;
 	DAT_BOOLEAN in, out;
-	int i, ii, pdata, ctx;
+	int i, ii, pdata, ctx, qdepth = REG_MEM_COUNT;
 	DAT_DTO_COMPLETION_EVENT_DATA *dto_event =
 	    &event.event_data.dto_completion_event_data;
 
@@ -762,8 +765,10 @@ int connect_ep(char *hostname, struct sockaddr *ser_sa)
 	}
 	ep_attr.qos = 0;
 	ep_attr.recv_completion_flags = 0;
-	ep_attr.max_recv_dtos = eps * 10;
-	ep_attr.max_request_dtos = eps * 10;
+	if (ud_test && !multi_eps)
+		qdepth = eps * REG_MEM_COUNT;
+	ep_attr.max_recv_dtos = qdepth;
+	ep_attr.max_request_dtos = qdepth;
 	ep_attr.max_recv_iov = 1;
 	ep_attr.max_request_iov = 1;
 	ep_attr.request_completion_flags = DAT_COMPLETION_DEFAULT_FLAG;
@@ -1548,7 +1553,7 @@ int main(int argc, char **argv)
 		switch (rc) {
 		case 'u':
 			ud_test = 1;
-			eps = MAX_EP_COUNT / 2;
+			eps = 4;
 			break;
 		case 'm':
 			multi_eps = 1;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
