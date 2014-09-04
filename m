From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] rsockets: Support calling listen multiple times on same rsocket
Date: Thu,  4 Sep 2014 11:38:29 -0700
Message-ID: <1409855909-28819-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Standard sockets allows an application to call listen() multiple
times on the same socket without error.  This allows a multi-threaded
app to call listen from all threads.

rsockets will fail the second listen call.  Modify the behavior to
match standard sockets.

Problem reported by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 00d9a18..4833810 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1174,9 +1174,14 @@ int rlisten(int socket, int backlog)
 	rs = idm_lookup(&idm, socket);
 	if (!rs)
 		return ERR(EBADF);
-	ret = rdma_listen(rs->cm_id, backlog);
-	if (!ret)
-		rs->state = rs_listening;
+
+	if (rs->state != rs_listening) {
+		ret = rdma_listen(rs->cm_id, backlog);
+		if (!ret)
+			rs->state = rs_listening;
+	} else {
+		ret = 0;
+	}
 	return ret;
 }
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
