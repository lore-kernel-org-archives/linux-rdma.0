From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] librspreload: Call init from getsockname()
Date: Tue, 24 Jul 2012 22:34:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6D39D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

netperf for some unknown reason calls getsockname() using a
hard coded value of 0, without first allocating a socket.
This causes the rsocket preload library to crash, since the
library has not been properly initialized.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index e88c958..c8ad747 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -841,6 +841,7 @@ int getpeername(int socket, struct sockaddr *addr, socklen_t *addrlen)
 int getsockname(int socket, struct sockaddr *addr, socklen_t *addrlen)
 {
 	int fd;
+	init_preload();
 	return (fd_get(socket, &fd) == fd_rsocket) ?
 		rgetsockname(fd, addr, addrlen) :
 		real.getsockname(fd, addr, addrlen);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
