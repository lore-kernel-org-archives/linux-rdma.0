From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] umad.{c,h}: moving stdlib.h include from C to H file
Date: Mon, 4 Oct 2010 12:37:11 +0200
Message-ID: <4CA9AE57.5020106@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

umad.h uses size_t type, which requires stdlib.h

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 libibumad/include/infiniband/umad.h |    1 +
 libibumad/src/umad.c                |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libibumad/include/infiniband/umad.h b/libibumad/include/infiniband/umad.h
index 7ad5e4a..23abf0d 100644
--- a/libibumad/include/infiniband/umad.h
+++ b/libibumad/include/infiniband/umad.h
@@ -34,6 +34,7 @@
 #define _UMAD_H

 #include <stdint.h>
+#include <stdlib.h>

 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index d16e750..45a9423 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -46,7 +46,6 @@
 #include <sys/ioctl.h>
 #include <netinet/in.h>
 #include <dirent.h>
-#include <stdlib.h>
 #include <ctype.h>

 #include "umad.h"
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
