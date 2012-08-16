From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] librdmacm/rsockets: Support SO_OOBINLINE
Date: Thu, 16 Aug 2012 19:24:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89968@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We don't support urgent data, so just return success.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index b9105a1..996cb2f 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1820,6 +1820,10 @@ int rsetsockopt(int socket, int level, int optname,
 			opt_on = *(int *) optval;
 			ret = 0;
 			break;
+		case SO_OOBINLINE:
+			opt_on = *(int *) optval;
+			ret = 0;
+			break;
 		default:
 			break;
 		}
@@ -1898,6 +1902,7 @@ int rgetsockopt(int socket, int level, int optname,
 		switch (optname) {
 		case SO_REUSEADDR:
 		case SO_KEEPALIVE:
+		case SO_OOBINLINE:
 			*((int *) optval) = !!(rs->so_opts & (1 << optname));
 			*optlen = sizeof(int);
 			break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
