From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm/rsocket: Set readfds event if rsocket has been
 disconnected
Date: Wed, 27 Jun 2012 22:24:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A3F30D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 394fed4..c833d46 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1631,7 +1631,7 @@ rs_poll_to_select(int nfds, struct pollfd *fds, fd_set *readfds,
 	int i, cnt = 0;
 
 	for (i = 0; i < nfds; i++) {
-		if (readfds && (fds[i].revents & POLLIN)) {
+		if (readfds && (fds[i].revents & (POLLIN | POLLHUP))) {
 			FD_SET(fds[i].fd, readfds);
 			cnt++;
 		}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
