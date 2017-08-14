From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 1/2] rdma: Allow demand loading of NETLINK_RDMA
Date: Mon, 14 Aug 2017 14:57:38 -0600
Message-ID: <1502744259-16966-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502744259-16966-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide a module alias so that if userspace opens a netlink
socket for RDMA the kernel support is loaded automatically.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 27352a35277011..f782697cf4d819 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -38,6 +38,7 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <rdma/rdma_netlink.h>
+#include <linux/module.h>
 #include "core_priv.h"
 
 #include "core_priv.h"
@@ -290,3 +291,5 @@ void rdma_nl_exit(void)
 
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
