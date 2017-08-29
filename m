From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/4] Use set_fd_nonblock in instead of open coding F_SETFL
Date: Tue, 29 Aug 2017 09:58:44 -0600
Message-ID: <1504022325-31039-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504022325-31039-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504022325-31039-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In all places.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/src/acm.c     | 2 +-
 librdmacm/rsocket.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index aba0deaa6de37f..08937345a0c112 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2684,7 +2684,7 @@ static int acmc_init_sa_fds(void)
 		for (p = 0; p < dev->port_cnt; p++) {
 			sa.fds[i].fd = umad_get_fd(dev->port[p].mad_portid);
 			sa.fds[i].events = POLLIN;
-			ret = fcntl(sa.fds[i].fd, F_SETFL, O_NONBLOCK);
+			ret = set_fd_nonblock(sa.fds[i].fd, true);
 			if (ret)
 				acm_log(0, "WARNING - umad fd is blocking\n");
 
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index ca0b9bf2a21f7d..693d9eb5cb7e06 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -49,6 +49,7 @@
 #include <search.h>
 #include <byteswap.h>
 #include <util/compiler.h>
+#include <util/util.h>
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
@@ -790,7 +791,7 @@ static int rs_create_cq(struct rsocket *rs, struct rdma_cm_id *cm_id)
 		goto err1;
 
 	if (rs->fd_flags & O_NONBLOCK) {
-		if (fcntl(cm_id->recv_cq_channel->fd, F_SETFL, O_NONBLOCK))
+		if (set_fd_nonblock(cm_id->recv_cq_channel->fd, true))
 			goto err2;
 	}
 
@@ -1253,7 +1254,7 @@ int raccept(int socket, struct sockaddr *addr, socklen_t *addrlen)
 	}
 
 	if (rs->fd_flags & O_NONBLOCK)
-		fcntl(new_rs->cm_id->channel->fd, F_SETFL, O_NONBLOCK);
+		set_fd_nonblock(new_rs->cm_id->channel->fd, true);
 
 	ret = rs_create_ep(new_rs);
 	if (ret)
@@ -1377,7 +1378,7 @@ connected:
 		break;
 	case rs_accepting:
 		if (!(rs->fd_flags & O_NONBLOCK))
-			fcntl(rs->cm_id->channel->fd, F_SETFL, 0);
+			set_fd_nonblock(rs->cm_id->channel->fd, true);
 
 		ret = ucma_complete(rs->cm_id);
 		if (ret)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
