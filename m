From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 13/15] IB/pvrdma: Add Kconfig and Makefile
Date: Wed, 3 Aug 2016 16:27:42 -0700
Message-ID: <1470266864-16888-14-git-send-email-aditr@vmware.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470266864-16888-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds a Kconfig and Makefile for the PVRDMA driver.

Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/pvrdma/Kconfig  | 8 ++++++++
 drivers/infiniband/hw/pvrdma/Makefile | 3 +++
 2 files changed, 11 insertions(+)
 create mode 100644 drivers/infiniband/hw/pvrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/pvrdma/Makefile

diff --git a/drivers/infiniband/hw/pvrdma/Kconfig b/drivers/infiniband/hw/pvrdma/Kconfig
new file mode 100644
index 0000000..cefa441
--- /dev/null
+++ b/drivers/infiniband/hw/pvrdma/Kconfig
@@ -0,0 +1,8 @@
+config INFINIBAND_PVRDMA
+	tristate "VMware Paravirtualized RDMA Driver"
+	depends on NETDEVICES && ETHERNET && PCI && INET
+	select VMXNET3
+	---help---
+	  This driver provides low-level support for VMware Paravirtual
+	  RDMA adapter. It interacts with the VMXNet3 driver to provide
+	  Ethernet capabilities.
diff --git a/drivers/infiniband/hw/pvrdma/Makefile b/drivers/infiniband/hw/pvrdma/Makefile
new file mode 100644
index 0000000..e6f078b
--- /dev/null
+++ b/drivers/infiniband/hw/pvrdma/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INFINIBAND_PVRDMA) += pvrdma.o
+
+pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
