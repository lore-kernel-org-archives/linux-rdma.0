From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] rsocket: Return ECONNRESET when socket in recv is disconnected
Date: Wed,  8 Oct 2014 15:19:33 -0700
Message-ID: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following behavior difference was reported between rsockets and
sockets:

when remote end is suddenly closed, recv() waiting on it receives
tcp/ip => ECONNRESET error
rsockets => 0 value

Update rrecv() to return ECONNRESET if no data is available and
the connection is no longer readable.

Problem reported by: srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 074fb18..7c7af52 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2013 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2008-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -2394,7 +2394,7 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 	struct rsocket *rs;
 	size_t left = len;
 	uint32_t end_size, rsize;
-	int ret;
+	int ret = 0;
 
 	rs = idm_at(&idm, socket);
 	if (rs->type == SOCK_DGRAM) {
@@ -2419,9 +2419,11 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 					  rs_conn_have_rdata);
 			if (ret)
 				break;
+
+			if (!(rs->state & rs_readable))
+				ret = ERR(ECONNRESET);
 		}
 
-		ret = 0;
 		if (flags & MSG_PEEK) {
 			left = len - rs_peek(rs, buf, left);
 			break;
@@ -2456,7 +2458,7 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 	} while (left && (flags & MSG_WAITALL) && (rs->state & rs_readable));
 
 	fastlock_release(&rs->rlock);
-	return ret ? ret : len - left;
+	return (ret && left == len) ? ret : len - left;
 }
 
 ssize_t rrecvfrom(int socket, void *buf, size_t len, int flags,
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
