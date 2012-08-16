From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] librdmacm/rspreload: Support sendfile
Date: Thu, 16 Aug 2012 19:24:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89981@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Handle users calling sendfile with an rsocket.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/preload.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/src/preload.c b/src/preload.c
index 8b86415..c6cf176 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -38,6 +38,8 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/sendfile.h>
 #include <stdarg.h>
 #include <dlfcn.h>
 #include <netdb.h>
@@ -84,6 +86,7 @@ struct socket_calls {
 			  void *optval, socklen_t *optlen);
 	int (*fcntl)(int socket, int cmd, ... /* arg */);
 	int (*dup2)(int oldfd, int newfd);
+	ssize_t (*sendfile)(int out_fd, int in_fd, off_t *offset, size_t count);
 };
 
 static struct socket_calls real;
@@ -276,6 +279,7 @@ static void init_preload(void)
 	real.getsockopt = dlsym(RTLD_NEXT, "getsockopt");
 	real.fcntl = dlsym(RTLD_NEXT, "fcntl");
 	real.dup2 = dlsym(RTLD_NEXT, "dup2");
+	real.sendfile = dlsym(RTLD_NEXT, "sendfile");
 
 	rs.socket = dlsym(RTLD_DEFAULT, "rsocket");
 	rs.bind = dlsym(RTLD_DEFAULT, "rbind");
@@ -1009,3 +1013,23 @@ int dup2(int oldfd, int newfd)
 	atomic_inc(&oldfdi->refcnt);
 	return newfd;
 }
+
+ssize_t sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
+{
+	void *file_addr;
+	int fd;
+	size_t ret;
+
+	if (fd_get(out_fd, &fd) != fd_rsocket)
+		return real.sendfile(fd, in_fd, offset, count);
+
+	file_addr = mmap(NULL, count, PROT_READ, 0, in_fd, offset ? *offset : 0);
+	if (file_addr == (void *) -1)
+		return -1;
+
+	ret = rwrite(fd, file_addr, count);
+	if ((ret > 0) && offset)
+		lseek(in_fd, ret, SEEK_CUR);
+	munmap(file_addr, count);
+	return ret;
+}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
