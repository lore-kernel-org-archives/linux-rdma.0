From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/16] librdmacm/rs-preload: Handle recursive socket() calls
Date: Wed, 30 May 2012 17:21:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24BF7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org" <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When ACM support is enabled in the librdmacm, it will attempt to
establish a socket connection to the ACM daemon.  When the rsocket
preload library is in use, this can result in a recursive call
to socket() that results in the library hanging.  The resulting
call stack is:

socket() -> rsocket() -> rdma_create_id() -> ucma_init() ->
socket() -> rsocket() -> rdma_create_id() -> ucma_init()

The second call to ucma_init() hangs because initialization is
still pending.

Fix this by checking for recursive calls to socket() in the preload
library.  When detected, call the real socket() call instead of
directing the call back into rsockets().  Since rsockets is a part
of the librdmacm, it can call rsockets directly if it wants to use
rsockets instead of standard sockets.

This problem and the cause was reported by Chet Murthy <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index 87778eb..99afd26 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -287,21 +287,27 @@ err:
 
 int socket(int domain, int type, int protocol)
 {
+	static __thread int recursive;
 	int index, ret;
 
+	if (recursive)
+		goto real;
+
 	init_preload();
 	index = fd_open();
 	if (index < 0)
 		return index;
 
+	recursive = 1;
 	ret = rsocket(domain, type, protocol);
+	recursive = 0;
 	if (ret >= 0) {
 		fd_store(index, ret, fd_rsocket);
 		return index;
-	} else {
-		fd_close(index, &ret);
-		return real_socket(domain, type, protocol);
 	}
+	fd_close(index, &ret);
+real:
+	return real_socket(domain, type, protocol);
 }
 
 int bind(int socket, const struct sockaddr *addr, socklen_t addrlen)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
