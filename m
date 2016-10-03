From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 15/16] IB: Add PVRDMA driver
Date: Sun, 2 Oct 2016 19:10:35 -0700
Message-ID: <82ef1265c0134b52f2611cf6d8c318accd776a6c.1475458407.git.aditr@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates the InfiniBand subsystem to build the PVRDMA driver.

Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig     | 1 +
 drivers/infiniband/hw/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 19a418a..dff4bcf 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -88,5 +88,6 @@ source "drivers/infiniband/sw/rdmavt/Kconfig"
 source "drivers/infiniband/sw/rxe/Kconfig"
 
 source "drivers/infiniband/hw/hfi1/Kconfig"
+source "drivers/infiniband/hw/pvrdma/Kconfig"
 
 endif # INFINIBAND
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 21fe401..c8a7a36 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
+obj-$(CONFIG_INFINIBAND_PVRDMA)		+= pvrdma/
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
