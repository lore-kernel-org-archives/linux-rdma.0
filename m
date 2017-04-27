From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibstat.c: Add include for __be64 type
Date: Thu, 27 Apr 2017 09:24:22 -0400
Message-ID: <9747c5f3-7176-564f-8a74-a3f4a8558c71@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for supporting libibumad prior to it's inclusion in rdma-core

rdma-core dependency was added by:
commit 8e562d3c22840064d7693e22c93f9c0a9112365a
infiniband-diags: Fix type passed to umad_get_ca_portguids

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibstat.c b/src/ibstat.c
index 67ab165..bad4c99 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -48,6 +48,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <linux/types.h> /* __be64 */
 
 #include <infiniband/umad.h>
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
