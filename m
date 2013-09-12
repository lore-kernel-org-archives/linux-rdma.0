From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] examples: Remove unneeded include of header file
 when using rocket.h
Date: Thu, 12 Sep 2013 08:53:35 -0400
Message-ID: <5231B94F.1080606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


as it's included in rsocket.h

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/riostream.c b/examples/riostream.c
index a1d3671..6587707 100644
--- a/examples/riostream.c
+++ b/examples/riostream.c
@@ -43,7 +43,6 @@
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 
-#include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
 #include "common.h"
 
diff --git a/examples/rstream.c b/examples/rstream.c
index 278437f..4e50f94 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -43,7 +43,6 @@
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 
-#include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
 #include "common.h"
 
diff --git a/examples/udpong.c b/examples/udpong.c
index af8deb9..58e3d4e 100644
--- a/examples/udpong.c
+++ b/examples/udpong.c
@@ -44,7 +44,6 @@
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 
-#include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
 #include "common.h"
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
