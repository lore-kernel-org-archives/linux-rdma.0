From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] librdmacm/rsocket: Fix resetting O_NONBLOCK after calling shutdown
Date: Thu, 21 Feb 2013 06:48:48 -0800
Message-ID: <1361458128-10134-2-git-send-email-sean.hefty@intel.com>
References: <1361458128-10134-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361458128-10134-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Shutdown switches an rsocket from nonblocking to blocking to
ensure that all data has been sent.  After completing all
transfers, it should switch back to nonblocking; this handles
partial shutdown situations, where only half the connection
is shut down.  However, the code uses the value of '1' to
set the nonblocking flag, rather than O_NONBLOCK.  Fix this.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 9b6c667..03f5dc4 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3023,7 +3023,7 @@ int rshutdown(int socket, int how)
 		rs_process_cq(rs, 0, rs_conn_all_sends_done);
 
 	if ((rs->fd_flags & O_NONBLOCK) && (rs->state & rs_connected))
-		rs_set_nonblocking(rs, 1);
+		rs_set_nonblocking(rs, rs->fd_flags);
 
 	return 0;
 }
@@ -3040,7 +3040,7 @@ static void ds_shutdown(struct rsocket *rs)
 	ds_process_cqs(rs, 0, ds_all_sends_done);
 
 	if (rs->fd_flags & O_NONBLOCK)
-		rs_set_nonblocking(rs, 1);
+		rs_set_nonblocking(rs, rs->fd_flags);
 }
 
 int rclose(int socket)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
