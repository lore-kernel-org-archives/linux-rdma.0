From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 29/29] IB/rxe: Add Soft-RoCE to kbuild and makefiles
Date: Thu,  2 Jun 2016 19:57:37 +0300
Message-ID: <1464886657-14258-30-git-send-email-monis@mellanox.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464886657-14258-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kconfig and Makefiles for Soft RoCE driver.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig         |  1 +
 drivers/infiniband/hw/Makefile     |  1 +
 drivers/infiniband/hw/rxe/Kconfig  | 23 +++++++++++++++++++++++
 drivers/infiniband/hw/rxe/Makefile | 24 ++++++++++++++++++++++++
 4 files changed, 49 insertions(+)
 create mode 100644 drivers/infiniband/hw/rxe/Kconfig
 create mode 100644 drivers/infiniband/hw/rxe/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 2137adf..f942ec1 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -74,6 +74,7 @@ source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
+source "drivers/infiniband/hw/rxe/Kconfig"
 
 source "drivers/infiniband/ulp/ipoib/Kconfig"
 
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c0c7cf8..739e5c1 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
+obj-$(CONFIG_INFINIBAND_RXE)		+= rxe/
diff --git a/drivers/infiniband/hw/rxe/Kconfig b/drivers/infiniband/hw/rxe/Kconfig
new file mode 100644
index 0000000..649b7be
--- /dev/null
+++ b/drivers/infiniband/hw/rxe/Kconfig
@@ -0,0 +1,23 @@
+config INFINIBAND_RXE
+	tristate "Software RDMA over Ethernet (RoCE) driver"
+	depends on INET && PCI && INFINIBAND
+	---help---
+	This driver implements the InfiniBand RDMA transport over
+	the Linux network stack. It enables a system with a
+	standard Ethernet adapter to interoperate with a RoCE
+	adapter or with another system running the RXE driver.
+	Documentation on InfiniBand and RoCE can be downloaded at
+	www.infinibandta.org and www.openfabrics.org. (See also
+	siw which is a similar software driver for iWARP.)
+
+	The driver is split into two layers, one interfaces with the
+	Linux RDMA stack and implements a kernel or user space
+	verbs API. The user space verbs API requires a support
+	library named librxe which is loaded by the generic user
+	space verbs API, libibverbs. The other layer interfaces
+	with the Linux network stack at layer 3.
+
+	To configure and work with soft-RoCE driver please use the
+	following wiki page under "configure Soft-RoCE (RXE)" section:
+
+	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
diff --git a/drivers/infiniband/hw/rxe/Makefile b/drivers/infiniband/hw/rxe/Makefile
new file mode 100644
index 0000000..7cf7774
--- /dev/null
+++ b/drivers/infiniband/hw/rxe/Makefile
@@ -0,0 +1,24 @@
+obj-$(CONFIG_INFINIBAND_RXE) += ib_rxe.o
+
+ib_rxe-y := \
+	rxe.o \
+	rxe_comp.o \
+	rxe_req.o \
+	rxe_resp.o \
+	rxe_recv.o \
+	rxe_pool.o \
+	rxe_queue.o \
+	rxe_verbs.o \
+	rxe_av.o \
+	rxe_srq.o \
+	rxe_qp.o \
+	rxe_cq.o \
+	rxe_mr.o \
+	rxe_dma.o \
+	rxe_opcode.o \
+	rxe_mmap.o \
+	rxe_icrc.o \
+	rxe_mcast.o \
+	rxe_task.o \
+	rxe_net.o \
+	rxe_sysfs.o
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
