From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] librdmacm/rsockets: Enable support for privileged ports
Date: Mon, 30 Jul 2012 18:33:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6E649@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the preload library to use rsockets with privileged ports.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index c8ad747..52eaf1a 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -405,23 +405,9 @@ real:
 
 int bind(int socket, const struct sockaddr *addr, socklen_t addrlen)
 {
-	struct sockaddr_in *sin;
-	int fd, ret;
-
-	if (fd_get(socket, &fd) == fd_rsocket) {
-		sin = (struct sockaddr_in *) addr;
-		if (!sin->sin_port || ntohs(sin->sin_port) > 1024)
-			return rbind(fd, addr, addrlen);
-
-		ret = transpose_socket(socket, fd_normal);
-		if (ret < 0)
-			return ret;
-
-		rclose(fd);
-		fd = ret;
-	}
-
-	return real.bind(fd, addr, addrlen);
+	int fd;
+	return (fd_get(socket, &fd) == fd_rsocket) ?
+		rbind(fd, addr, addrlen) : real.bind(fd, addr, addrlen);
 }
 
 int listen(int socket, int backlog)
@@ -582,19 +568,15 @@ static inline enum fd_type fd_fork_get(int index, int *fd)
 
 int connect(int socket, const struct sockaddr *addr, socklen_t addrlen)
 {
-	struct sockaddr_in *sin;
 	int fd, ret;
 
 	switch (fd_get(socket, &fd)) {
 	case fd_fork:
 		return fork_active(socket, addr, addrlen);
 	case fd_rsocket:
-		sin = (struct sockaddr_in *) addr;
-		if (ntohs(sin->sin_port) > 1024) {
-			ret = rconnect(fd, addr, addrlen);
-			if (!ret || errno == EINPROGRESS)
-				return ret;
-		}
+		ret = rconnect(fd, addr, addrlen);
+		if (!ret || errno == EINPROGRESS)
+			return ret;
 
 		ret = transpose_socket(socket, fd_normal);
 		if (ret < 0)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
