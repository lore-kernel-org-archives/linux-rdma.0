From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] rsocket: Update correct rsocket keepalive time
Date: Thu,  3 Jul 2014 15:08:44 -0700
Message-ID: <1404425324-20201-2-git-send-email-sean.hefty@intel.com>
References: <1404425324-20201-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404425324-20201-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the keepalive time of an rsocket is updated, the
updated information is forwarded to the keepalive service
thread.  However, the thread updates the time for the
wrong service as shown:

tcp_svc_timeouts[svc->cnt] = rs_get_time() + msg.rs->keepalive_time;

The index into tcp_svc_timeouts should correspond to the
rsocket being updated, not the last one in the list.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index e9d12c7..b869d88 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3941,19 +3941,28 @@ static int rs_svc_add_rs(struct rs_svc *svc, struct rsocket *rs)
 	return 0;
 }
 
-static int rs_svc_rm_rs(struct rs_svc *svc, struct rsocket *rs)
+static int rs_svc_index(struct rs_svc *svc, struct rsocket *rs)
 {
 	int i;
 
 	for (i = 1; i <= svc->cnt; i++) {
-		if (svc->rss[i] == rs) {
-			svc->rss[i] = svc->rss[svc->cnt];
-			memcpy(svc->contexts + i * svc->context_size,
-			       svc->contexts + svc->cnt * svc->context_size,
-			       svc->context_size);
-			svc->cnt--;
-			return 0;
-		}
+		if (svc->rss[i] == rs)
+			return i;
+	}
+	return -1;
+}
+
+static int rs_svc_rm_rs(struct rs_svc *svc, struct rsocket *rs)
+{
+	int i;
+
+	if ((i = rs_svc_index(svc, rs)) >= 0) {
+		svc->rss[i] = svc->rss[svc->cnt];
+		memcpy(svc->contexts + i * svc->context_size,
+		       svc->contexts + svc->cnt * svc->context_size,
+		       svc->context_size);
+		svc->cnt--;
+		return 0;
 	}
 	return EBADF;
 }
@@ -4197,6 +4206,7 @@ static uint32_t rs_get_time(void)
 static void tcp_svc_process_sock(struct rs_svc *svc)
 {
 	struct rs_svc_msg msg;
+	int i;
 
 	read(svc->sock[1], &msg, sizeof msg);
 	switch (msg.cmd) {
@@ -4215,8 +4225,13 @@ static void tcp_svc_process_sock(struct rs_svc *svc)
 			msg.rs->opts &= ~RS_OPT_SVC_ACTIVE;
 		break;
 	case RS_SVC_MOD_KEEPALIVE:
-		tcp_svc_timeouts[svc->cnt] = rs_get_time() + msg.rs->keepalive_time;
-		msg.status = 0;
+		i = rs_svc_index(svc, msg.rs);
+		if (i >= 0) {
+			tcp_svc_timeouts[i] = rs_get_time() + msg.rs->keepalive_time;
+			msg.status = 0;
+		} else {
+			msg.status = EBADF;
+		}
 		break;
 	case RS_SVC_NOOP:
 		msg.status = 0;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
