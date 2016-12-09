From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] IB: Update to build vmw_pvrdma
Date: Fri, 9 Dec 2016 09:10:05 -0800
Message-ID: <4b7131beefa5f5a519ea755db8ac27ec095adb91.1481303342.git.aditr@vmware.com>
References: <cover.1481303342.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1481303342.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update Makefile and Kconfig to build vmw_pvrdma target.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS                               | 2 +-
 drivers/infiniband/hw/Makefile            | 2 +-
 drivers/infiniband/hw/vmw_pvrdma/Kconfig  | 2 +-
 drivers/infiniband/hw/vmw_pvrdma/Makefile | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23cd1ad..75a68f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12933,7 +12933,7 @@ M:	Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 M:	VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
-F:	drivers/infiniband/hw/pvrdma/
+F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
 M:	Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index a89a24c..ed553de 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
-obj-$(CONFIG_INFINIBAND_PVRDMA)		+= vmw_pvrdma/
+obj-$(CONFIG_INFINIBAND_VMWARE_PVRDMA)	+= vmw_pvrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
diff --git a/drivers/infiniband/hw/vmw_pvrdma/Kconfig b/drivers/infiniband/hw/vmw_pvrdma/Kconfig
index b345679..5a9790a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/Kconfig
+++ b/drivers/infiniband/hw/vmw_pvrdma/Kconfig
@@ -1,4 +1,4 @@
-config INFINIBAND_PVRDMA
+config INFINIBAND_VMWARE_PVRDMA
 	tristate "VMware Paravirtualized RDMA Driver"
 	depends on NETDEVICES && ETHERNET && PCI && INET && VMXNET3
 	---help---
diff --git a/drivers/infiniband/hw/vmw_pvrdma/Makefile b/drivers/infiniband/hw/vmw_pvrdma/Makefile
index 6ef4b98..0194ed1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/Makefile
+++ b/drivers/infiniband/hw/vmw_pvrdma/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_INFINIBAND_PVRDMA) += vmw_pvrdma.o
+obj-$(CONFIG_INFINIBAND_VMWARE_PVRDMA) += vmw_pvrdma.o
 
 vmw_pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
