From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/4] Add set_fd_nonblock to util
Date: Tue, 29 Aug 2017 09:58:42 -0600
Message-ID: <1504022325-31039-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504022325-31039-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504022325-31039-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This wsa often open coded without the GETFL. GETFL is techinically
required by POSIX as we can't know for sure that the flags are 0
(although today, on Linux, they are for sockets).

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 util/CMakeLists.txt |  5 ++---
 util/dummy.c        |  0
 util/util.c         | 22 ++++++++++++++++++++++
 util/util.h         |  4 ++++
 4 files changed, 28 insertions(+), 3 deletions(-)
 delete mode 100644 util/dummy.c
 create mode 100644 util/util.c

diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
index 2ba6a7c79e222c..57d9109653da82 100644
--- a/util/CMakeLists.txt
+++ b/util/CMakeLists.txt
@@ -4,9 +4,8 @@ publish_internal_headers(util
   util.h
   )
 
-# The empty dummy.c is only needed so that cmake always has something to build
-# into the library.
-set(C_FILES dummy.c)
+set(C_FILES
+  util.c)
 
 if (HAVE_COHERENT_DMA)
   publish_internal_headers(util
diff --git a/util/dummy.c b/util/dummy.c
deleted file mode 100644
index e69de29bb2d1d6..00000000000000
diff --git a/util/util.c b/util/util.c
new file mode 100644
index 00000000000000..8c5f8f1ae1989a
--- /dev/null
+++ b/util/util.c
@@ -0,0 +1,22 @@
+/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file */
+#include <util/util.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+int set_fd_nonblock(int fd, bool nonblock)
+{
+	int val;
+
+	val = fcntl(fd, F_GETFL);
+	if (val == -1)
+		return -1;
+
+	if (nonblock)
+		val |= O_NONBLOCK;
+	else
+		val &= ~(unsigned int)(O_NONBLOCK);
+
+	if (fcntl(fd, F_SETFL, val) == -1)
+		return -1;
+	return 0;
+}
diff --git a/util/util.h b/util/util.h
index c3e59554df210c..cbf0deca2dde7b 100644
--- a/util/util.h
+++ b/util/util.h
@@ -2,6 +2,8 @@
 #ifndef UTIL_UTIL_H
 #define UTIL_UTIL_H
 
+#include <stdbool.h>
+
 /* Return true if the snprintf succeeded, false if there was truncation or
  * error */
 #define check_snprintf(buf, len, fmt, ...)                                     \
@@ -16,4 +18,6 @@
 	 ((a)->tv_nsec CMP (b)->tv_nsec) :	\
 	 ((a)->tv_sec CMP (b)->tv_sec))
 
+int set_fd_nonblock(int fd, bool nonblock);
+
 #endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
