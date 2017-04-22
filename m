From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/4] Ib/usnic: Explicitly include usnic headers
Date: Sat, 22 Apr 2017 17:28:50 +0300
Message-ID: <20170422142852.18882-3-leon@kernel.org>
References: <20170422142852.18882-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422142852.18882-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse tool complains about undeclared symbols in usnic_ib_verbs.c
and usnic_ib_sysfs.c This is caused by lack of direct include of
appropriate usnic_ib_verbs.h and usnic_ib_sysfs.h, where all
these functions were declared.

Simple include eliminates 30 warnings similar to the below one:

drivers/infiniband/hw/usnic/usnic_ib_sysfs.c:304:6: warning: symbol
				'usnic_ib_sysfs_unregister_usdev' was
				not declared. Should it be static?

CC: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index 04443242e258..32956f9f5715 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -44,6 +44,7 @@
 #include "usnic_vnic.h"
 #include "usnic_ib_verbs.h"
 #include "usnic_log.h"
+#include "usnic_ib_sysfs.h"

 static ssize_t usnic_ib_show_board(struct device *device,
 					struct device_attribute *attr,
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 3284730d3c09..bcd6f7b1c634 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -46,6 +46,7 @@
 #include "usnic_log.h"
 #include "usnic_uiom.h"
 #include "usnic_transport.h"
+#include "usnic_ib_verbs.h"

 #define USNIC_DEFAULT_TRANSPORT USNIC_TRANSPORT_ROCE_CUSTOM

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
