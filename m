From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 1/3] rdma: Allow demand loading of NETLINK_RDMA
Date: Mon, 24 Jul 2017 16:26:42 -0600
Message-ID: <1500935204-6505-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500935204-6505-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide a module alias so that if userspace opens a netlink
socket for RDMA the kernel support is loaded automatically.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 94931c474d41db..1165fe81d104a3 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -37,6 +37,7 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <rdma/rdma_netlink.h>
+#include <linux/module.h>
 #include "core_priv.h"
 
 struct ibnl_client {
@@ -273,3 +274,5 @@ void ibnl_cleanup(void)
 
 	netlink_kernel_release(nls);
 }
+
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_RDMA);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
