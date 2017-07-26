From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/8] RDMA/qedr: Rename the qedr_cm file as a preparation for iWARP support
Date: Wed, 26 Jul 2017 14:41:51 +0300
Message-ID: <1501069317-16601-3-git-send-email-Michal.Kalderon@cavium.com>
References: <1501069317-16601-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501069317-16601-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yuval.mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The main differences between iWARP and RoCE lay in the communication
 management functions. These will be placed in separate files.

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/Makefile                      | 2 +-
 drivers/infiniband/hw/qedr/{qedr_cm.c => qedr_roce_cm.c} | 2 +-
 drivers/infiniband/hw/qedr/{qedr_cm.h => qedr_roce_cm.h} | 0
 drivers/infiniband/hw/qedr/verbs.c                       | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/infiniband/hw/qedr/{qedr_cm.c => qedr_roce_cm.c} (99%)
 rename drivers/infiniband/hw/qedr/{qedr_cm.h => qedr_roce_cm.h} (100%)

diff --git a/drivers/infiniband/hw/qedr/Makefile b/drivers/infiniband/hw/qedr/Makefile
index ba7067c..331a361 100644
--- a/drivers/infiniband/hw/qedr/Makefile
+++ b/drivers/infiniband/hw/qedr/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_INFINIBAND_QEDR) := qedr.o
 
-qedr-y := main.o verbs.o qedr_cm.o
+qedr-y := main.o verbs.o qedr_roce_cm.o
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
similarity index 99%
rename from drivers/infiniband/hw/qedr/qedr_cm.c
rename to drivers/infiniband/hw/qedr/qedr_roce_cm.c
index 4689e80..c3c249b 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
@@ -48,7 +48,7 @@
 #include "qedr.h"
 #include "verbs.h"
 #include <rdma/qedr-abi.h>
-#include "qedr_cm.h"
+#include "qedr_roce_cm.h"
 
 void qedr_inc_sw_gsi_cons(struct qedr_qp_hwq_info *info)
 {
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.h b/drivers/infiniband/hw/qedr/qedr_roce_cm.h
similarity index 100%
rename from drivers/infiniband/hw/qedr/qedr_cm.h
rename to drivers/infiniband/hw/qedr/qedr_roce_cm.h
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 9ee2dce..03a24a6 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -49,7 +49,7 @@
 #include "qedr.h"
 #include "verbs.h"
 #include <rdma/qedr-abi.h>
-#include "qedr_cm.h"
+#include "qedr_roce_cm.h"
 
 #define DB_ADDR_SHIFT(addr)		((addr) << DB_PWM_ADDR_OFFSET_SHIFT)
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
