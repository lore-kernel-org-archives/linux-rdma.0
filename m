From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 05/32] net/bonding: make DRV macros private
Date: Wed, 11 Mar 2015 10:25:57 +0530
Message-ID: <19822496-d528-4445-92c8-c09826922487@CMEXHTCAS2.ad.emulex.com>
References: <1426049785-30364-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426049785-30364-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The bonding modules currently defines 4 macros with
general names that pollute the global namespace:
DRV_VERSION
DRV_RELDATE
DRV_NAME
DRV_DESCRIPTION

Fixing that by defining a private bonding_priv.h
header files which includes those defines.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/bonding/bond_main.c    |  2 ++
 drivers/net/bonding/bond_procfs.c  |  1 +
 drivers/net/bonding/bonding_priv.h | 26 ++++++++++++++++++++++++++
 include/net/bonding.h              |  7 -------
 4 files changed, 29 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/bonding/bonding_priv.h

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 468c70e..55f2d3e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -81,6 +81,8 @@
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
 
+#include "bonding_priv.h"
+
 /*---------------------------- Module parameters ----------------------------*/
 
 /* monitor all links that often (in milliseconds). <=0 disables monitoring */
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 976f5ad..b50a002 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -4,6 +4,7 @@
 #include <net/netns/generic.h>
 #include <net/bonding.h>
 
+#include "bonding_priv.h"
 
 static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
new file mode 100644
index 0000000..c093e91
--- /dev/null
+++ b/drivers/net/bonding/bonding_priv.h
@@ -0,0 +1,26 @@
+/*
+ * Bond several ethernet interfaces into a Cisco, running 'Etherchannel'.
+ *
+ * Portions are (c) Copyright 1995 Simon "Guru Aleph-Null" Janes
+ * NCM: Network and Communications Management, Inc.
+ *
+ * BUT, I'm the one who modified it for ethernet, so:
+ * (c) Copyright 1999, Thomas Davis, tadavis-/3juihCSby0@public.gmane.org
+ *
+ *	This software may be used and distributed according to the terms
+ *	of the GNU Public License, incorporated herein by reference.
+ *
+ */
+
+#ifndef _BONDING_PRIV_H
+#define _BONDING_PRIV_H
+
+#define DRV_VERSION	"3.7.1"
+#define DRV_RELDATE	"April 27, 2011"
+#define DRV_NAME	"bonding"
+#define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
+
+#define bond_version DRV_DESCRIPTION ": v" DRV_VERSION " (" DRV_RELDATE ")\n"
+
+#endif
+
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 4c2b0f4..a124173 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -30,13 +30,6 @@
 #include <net/bond_alb.h>
 #include <net/bond_options.h>
 
-#define DRV_VERSION	"3.7.1"
-#define DRV_RELDATE	"April 27, 2011"
-#define DRV_NAME	"bonding"
-#define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
-
-#define bond_version DRV_DESCRIPTION ": v" DRV_VERSION " (" DRV_RELDATE ")\n"
-
 #define BOND_MAX_ARP_TARGETS	16
 
 #define BOND_DEFAULT_MIIMON	100
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
