From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] librdmacm/preload.c: Eliminate some compile warnings
Date: Thu, 12 Jul 2012 10:35:41 -0400
Message-ID: <4FFEE0BD.3010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


by fixing a couple of typecasts

src/preload.c: In function ?bind?:
src/preload.c:350: warning: assignment from incompatible pointer type
src/preload.c: In function ?connect?:
src/preload.c:397: warning: assignment from incompatible pointer type

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/preload.c b/src/preload.c
index 8758d5c..2750b30 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -347,7 +347,7 @@ int bind(int socket, const struct sockaddr *addr, socklen_t addrlen)
 	int fd, ret;
 
 	if (fd_get(socket, &fd) == fd_rsocket) {
-		sin = (struct sockaddr_sin *) addr;
+		sin = (struct sockaddr_in *) addr;
 		if (!sin->sin_port || ntohs(sin->sin_port) > 1024)
 			return rbind(fd, addr, addrlen);
 
@@ -394,7 +394,7 @@ int connect(int socket, const struct sockaddr *addr, socklen_t addrlen)
 	int fd, ret;
 
 	if (fd_get(socket, &fd) == fd_rsocket) {
-		sin = (struct sockaddr_sin *) addr;
+		sin = (struct sockaddr_in *) addr;
 		if (ntohs(sin->sin_port) > 1024) {
 			ret = rconnect(fd, addr, addrlen);
 			if (!ret || errno == EINPROGRESS)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
