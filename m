From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 05/10] Remove extraneous byteswap.h include
Date: Thu,  9 Feb 2017 14:53:27 -0700
Message-ID: <1486677212-3188-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Only one place actually needs this now.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/linux/osd.h                 | 1 -
 libibumad/sysfs.c                 | 1 -
 libibumad/umad.h                  | 1 -
 libibverbs/arch.h                 | 1 -
 libibverbs/examples/asyncwatch.c  | 1 -
 libibverbs/examples/device_list.c | 1 -
 libibverbs/examples/devinfo.c     | 1 -
 librdmacm/cma.c                   | 1 -
 librdmacm/cma.h                   | 1 -
 librdmacm/examples/cmatose.c      | 1 -
 librdmacm/examples/common.c       | 1 -
 librdmacm/examples/mckey.c        | 1 -
 librdmacm/examples/rping.c        | 1 -
 librdmacm/examples/udaddy.c       | 1 -
 librdmacm/rsocket.c               | 1 +
 providers/hfi1verbs/hfiverbs.h    | 1 -
 providers/ipathverbs/ipathverbs.h | 1 -
 providers/rxe/rxe.c               | 1 -
 srp_daemon/srp_daemon.c           | 1 -
 srp_daemon/srp_daemon.h           | 1 -
 srp_daemon/srp_handle_traps.c     | 1 -
 21 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 4169ec54f0f38e..75eb2a327db1f0 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -37,7 +37,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
-#include <byteswap.h>
 #include <pthread.h>
 #include <sys/socket.h>
 #include <sys/types.h>
diff --git a/libibumad/sysfs.c b/libibumad/sysfs.c
index 9ef16fd9fa09f7..cacf69a07b1bf8 100644
--- a/libibumad/sysfs.c
+++ b/libibumad/sysfs.c
@@ -41,7 +41,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <byteswap.h>
 #include <netinet/in.h>
 #include "sysfs.h"
 
diff --git a/libibumad/umad.h b/libibumad/umad.h
index 1db450591401b2..d574d5d32e0d20 100644
--- a/libibumad/umad.h
+++ b/libibumad/umad.h
@@ -36,7 +36,6 @@
 
 #include <stdint.h>
 #include <stdlib.h>
-#include <byteswap.h>
 #include <arpa/inet.h>
 
 #ifdef __cplusplus
diff --git a/libibverbs/arch.h b/libibverbs/arch.h
index bf0feec08d7357..1c90c26d6f721d 100644
--- a/libibverbs/arch.h
+++ b/libibverbs/arch.h
@@ -35,7 +35,6 @@
 
 #include <stdint.h>
 #include <endian.h>
-#include <byteswap.h>
 
 #undef htonll
 #undef ntohll
diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index f2234e3e540159..724796e58a7cad 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -34,7 +34,6 @@
 
 #include <stdio.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <getopt.h>
 #include <string.h>
 
diff --git a/libibverbs/examples/device_list.c b/libibverbs/examples/device_list.c
index 084ede597af026..f5602ca1906842 100644
--- a/libibverbs/examples/device_list.c
+++ b/libibverbs/examples/device_list.c
@@ -35,7 +35,6 @@
 #include <stdio.h>
 
 #include <endian.h>
-#include <byteswap.h>
 
 #include <infiniband/verbs.h>
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index cf34803d44b374..2eeaec85962b5a 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -40,7 +40,6 @@
 #include <getopt.h>
 #include <netinet/in.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <inttypes.h>
 
 #include <infiniband/verbs.h>
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 0c742845dde8d6..218c1347f79e2e 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -43,7 +43,6 @@
 #include <unistd.h>
 #include <pthread.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <stddef.h>
 #include <netdb.h>
 #include <syslog.h>
diff --git a/librdmacm/cma.h b/librdmacm/cma.h
index 2e7c4182e7d98e..8795d2894d262f 100644
--- a/librdmacm/cma.h
+++ b/librdmacm/cma.h
@@ -39,7 +39,6 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <semaphore.h>
 
 #include <rdma/rdma_cma.h>
diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
index d9b6ca62239350..68bd015edf6cde 100644
--- a/librdmacm/examples/cmatose.c
+++ b/librdmacm/examples/cmatose.c
@@ -40,7 +40,6 @@
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
 #include <getopt.h>
 
 #include <rdma/rdma_cma.h>
diff --git a/librdmacm/examples/common.c b/librdmacm/examples/common.c
index 8037dd830fa805..4f92e764743108 100644
--- a/librdmacm/examples/common.c
+++ b/librdmacm/examples/common.c
@@ -40,7 +40,6 @@
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
 
 #include <rdma/rdma_cma.h>
 #include "common.h"
diff --git a/librdmacm/examples/mckey.c b/librdmacm/examples/mckey.c
index 2032aa99424234..306dde9e46aaa2 100644
--- a/librdmacm/examples/mckey.c
+++ b/librdmacm/examples/mckey.c
@@ -41,7 +41,6 @@
 #include <arpa/inet.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
 #include <unistd.h>
 #include <getopt.h>
 
diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index c56b6ef3010f53..6bcc92ad10619c 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -40,7 +40,6 @@
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
 #include <semaphore.h>
 #include <arpa/inet.h>
 #include <pthread.h>
diff --git a/librdmacm/examples/udaddy.c b/librdmacm/examples/udaddy.c
index af0d6f713ed183..5fae212c2d4636 100644
--- a/librdmacm/examples/udaddy.c
+++ b/librdmacm/examples/udaddy.c
@@ -40,7 +40,6 @@
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <netdb.h>
-#include <byteswap.h>
 #include <getopt.h>
 
 #include <rdma/rdma_cma.h>
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index e2e29a30eb59ed..9838384dd78bc0 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -47,6 +47,7 @@
 #include <netinet/tcp.h>
 #include <sys/epoll.h>
 #include <search.h>
+#include <byteswap.h>
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
diff --git a/providers/hfi1verbs/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
index af93dc43e059d9..194db8350dac6f 100644
--- a/providers/hfi1verbs/hfiverbs.h
+++ b/providers/hfi1verbs/hfiverbs.h
@@ -59,7 +59,6 @@
 #define HFI1_H
 
 #include <endian.h>
-#include <byteswap.h>
 #include <pthread.h>
 #include <stddef.h>
 #include <stdatomic.h>
diff --git a/providers/ipathverbs/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
index ebd2dcfbc413a9..b036c69a4158b3 100644
--- a/providers/ipathverbs/ipathverbs.h
+++ b/providers/ipathverbs/ipathverbs.h
@@ -39,7 +39,6 @@
 #define IPATH_H
 
 #include <endian.h>
-#include <byteswap.h>
 #include <pthread.h>
 #include <stddef.h>
 #include <stdatomic.h>
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index f2bf2cd37ed699..7fcd754b8058c1 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -45,7 +45,6 @@
 #include <errno.h>
 
 #include <endian.h>
-#include <byteswap.h>
 #include <pthread.h>
 #include <stddef.h>
 
diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 19a1bfaeb22c88..8a3650f38c8af8 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -54,7 +54,6 @@
 #include <netinet/in.h>
 #include <linux/types.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <errno.h>
 #include <getopt.h>
 #include <dirent.h>
diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index 3de8ee0e9827cb..214b77a2a26b0a 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -39,7 +39,6 @@
 #include <stdint.h>
 #include <signal.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <infiniband/verbs.h>
 #include <infiniband/umad.h>
 
diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index 6a7a2d1ab479a1..c9f3d8a4ecff41 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -39,7 +39,6 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 #include <endian.h>
-#include <byteswap.h>
 #include <time.h>
 #include <errno.h>
 #include <string.h>
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
