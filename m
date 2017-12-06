From: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/45] drivers: infiniband: remove duplicate includes
Date: Wed,  6 Dec 2017 22:19:39 +0530
Message-ID: <1512578979-5115-1-git-send-email-pravin.shedge4linux@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                | 1 -
 drivers/infiniband/core/netlink.c            | 2 --
 drivers/infiniband/hw/mlx5/main.c            | 4 +---
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 1 -
 5 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index cb91245..c50596f 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -49,7 +49,6 @@
 #include "smi.h"
 #include "opa_smi.h"
 #include "agent.h"
-#include "core_priv.h"
 
 static int mad_sendq_size = IB_MAD_QP_SEND_SIZE;
 static int mad_recvq_size = IB_MAD_QP_RECV_SIZE;
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 1fb72c3..0c7db94 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -41,8 +41,6 @@
 #include <linux/module.h>
 #include "core_priv.h"
 
-#include "core_priv.h"
-
 static DEFINE_MUTEX(rdma_nl_mutex);
 static struct sock *nls;
 static struct {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 543d0a4..fe435ed 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -50,16 +50,14 @@
 #include <rdma/ib_cache.h>
 #include <linux/mlx5/port.h>
 #include <linux/mlx5/vport.h>
+#include <linux/mlx5/fs.h>
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <linux/in.h>
 #include <linux/etherdevice.h>
-#include <linux/mlx5/fs.h>
-#include <linux/mlx5/vport.h>
 #include "mlx5_ib.h"
 #include "cmd.h"
-#include <linux/mlx5/vport.h>
 
 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "5.0-0"
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index 685ef22..4210ca1 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -45,7 +45,6 @@
 #include "usnic_ib_verbs.h"
 #include "usnic_ib_sysfs.h"
 #include "usnic_log.h"
-#include "usnic_ib_sysfs.h"
 
 static ssize_t usnic_ib_show_board(struct device *device,
 					struct device_attribute *attr,
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index aa2456a..a688a56 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -47,7 +47,6 @@
 #include "usnic_log.h"
 #include "usnic_uiom.h"
 #include "usnic_transport.h"
-#include "usnic_ib_verbs.h"
 
 #define USNIC_DEFAULT_TRANSPORT USNIC_TRANSPORT_ROCE_CUSTOM
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
