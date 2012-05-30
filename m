From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/16] librdmacm/rstream: Check for connection error on async
 connect
Date: Wed, 30 May 2012 17:21:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24BDF@ORSMSX101.amr.corp.intel.com>
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
 examples/rstream.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index 104b318..c440f04 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -448,7 +448,8 @@ static int client_connect(void)
 {
 	struct addrinfo *res;
 	struct pollfd fds;
-	int ret, rs;
+	int ret, rs, err;
+	socklen_t len;
 
  	ret = getaddrinfo(dst_addr, port, NULL, &res);
 	if (ret) {
@@ -477,6 +478,17 @@ static int client_connect(void)
 		ret = do_poll(&fds);
 		if (ret)
 			goto err;
+
+		len = sizeof err;
+		ret = rs_getsockopt(rs, SOL_SOCKET, SO_ERROR, &err, &len);
+		if (ret)
+			goto err;
+		if (err) {
+			ret = -1;
+			errno = err;
+			perror("async rconnect");
+			goto err;
+		}
 	}
 
 free:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
