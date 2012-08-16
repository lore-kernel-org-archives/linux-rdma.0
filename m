From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] librdmacm/rspreload: Add fstat support
Date: Thu, 16 Aug 2012 19:24:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89989@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

vsftpd calls fstat on a socket.  Fake it out.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index c6cf176..8f19af5 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -87,6 +87,7 @@ struct socket_calls {
 	int (*fcntl)(int socket, int cmd, ... /* arg */);
 	int (*dup2)(int oldfd, int newfd);
 	ssize_t (*sendfile)(int out_fd, int in_fd, off_t *offset, size_t count);
+	int (*fxstat)(int ver, int fd, struct stat *buf);
 };
 
 static struct socket_calls real;
@@ -280,6 +281,7 @@ static void init_preload(void)
 	real.fcntl = dlsym(RTLD_NEXT, "fcntl");
 	real.dup2 = dlsym(RTLD_NEXT, "dup2");
 	real.sendfile = dlsym(RTLD_NEXT, "sendfile");
+	real.fxstat = dlsym(RTLD_NEXT, "__fxstat");
 
 	rs.socket = dlsym(RTLD_DEFAULT, "rsocket");
 	rs.bind = dlsym(RTLD_DEFAULT, "rbind");
@@ -1033,3 +1035,18 @@ ssize_t sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
 	munmap(file_addr, count);
 	return ret;
 }
+
+int __fxstat(int ver, int socket, struct stat *buf)
+{
+	int fd, ret;
+
+	init_preload();
+	if (fd_get(socket, &fd) == fd_rsocket) {
+		ret = real.fxstat(ver, socket, buf);
+		if (!ret)
+			buf->st_mode = (buf->st_mode & ~S_IFMT) | __S_IFSOCK;
+	} else {
+		ret = real.fxstat(ver, fd, buf);
+	}
+	return ret;
+}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
