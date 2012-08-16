From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] librdmacm/rspreload: Minor cleanup of fork_passive
 handling
Date: Thu, 16 Aug 2012 19:24:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8996E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Minor code cleanup in passive side handling of fork support.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index b18d310..bb8e3fb 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -492,7 +492,7 @@ static void fork_passive(int socket)
 	socklen_t len;
 	uint32_t msg;
 
-	fd_get(socket, &sfd);
+	sfd = fd_getd(socket);
 
 	len = sizeof sin6;
 	ret = real.getsockname(sfd, (struct sockaddr *) &sin6, &len);
@@ -510,7 +510,7 @@ static void fork_passive(int socket)
 
 	lfd = rsocket(sin6.sin6_family, SOCK_STREAM, 0);
 	if (lfd < 0) {
-		ret  = lfd;
+		ret = lfd;
 		goto sclose;
 	}
 
@@ -537,10 +537,7 @@ static void fork_passive(int socket)
 		goto lclose;
 	}
 
-	param = 1;
-	rsetsockopt(dfd, IPPROTO_TCP, TCP_NODELAY, &param, sizeof param);
 	set_rsocket_options(dfd);
-
 	copysockopts(dfd, sfd, &rs, &real);
 	real.shutdown(sfd, SHUT_RDWR);
 	real.close(sfd);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
