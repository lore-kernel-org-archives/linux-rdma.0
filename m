From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V2 31/32] IB/rxe: Add Soft-RoCE to kbuild and makefiles
Date: Thu, 24 Dec 2015 11:18:17 +0200
Message-ID: <1450948698-13383-32-git-send-email-kamalh@mellanox.com>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450948698-13383-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kconfig and Makefiles for RXE driver

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rdma/Kconfig      |  2 ++
 drivers/staging/rdma/Makefile     |  1 +
 drivers/staging/rdma/rxe/Kconfig  | 23 +++++++++++++++++++++++
 drivers/staging/rdma/rxe/Makefile | 24 ++++++++++++++++++++++++
 4 files changed, 50 insertions(+)
 create mode 100644 drivers/staging/rdma/rxe/Kconfig
 create mode 100644 drivers/staging/rdma/rxe/Makefile

diff --git a/drivers/staging/rdma/Kconfig b/drivers/staging/rdma/Kconfig
index ba87650..9f92e0d 100644
--- a/drivers/staging/rdma/Kconfig
+++ b/drivers/staging/rdma/Kconfig
@@ -30,4 +30,6 @@ source "drivers/staging/rdma/hfi1/Kconfig"
 
 source "drivers/staging/rdma/ipath/Kconfig"
 
+source "drivers/staging/rdma/rxe/Kconfig"
+
 endif
diff --git a/drivers/staging/rdma/Makefile b/drivers/staging/rdma/Makefile
index 139d78e..3648a42 100644
--- a/drivers/staging/rdma/Makefile
+++ b/drivers/staging/rdma/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
 obj-$(CONFIG_INFINIBAND_EHCA)	+= ehca/
 obj-$(CONFIG_INFINIBAND_HFI1)	+= hfi1/
 obj-$(CONFIG_INFINIBAND_IPATH)	+= ipath/
+obj-$(CONFIG_INFINIBAND_RXE)    += rxe/
diff --git a/drivers/staging/rdma/rxe/Kconfig b/drivers/staging/rdma/rxe/Kconfig
new file mode 100644
index 0000000..649b7be
--- /dev/null
+++ b/drivers/staging/rdma/rxe/Kconfig
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
diff --git a/drivers/staging/rdma/rxe/Makefile b/drivers/staging/rdma/rxe/Makefile
new file mode 100644
index 0000000..7cf7774
--- /dev/null
+++ b/drivers/staging/rdma/rxe/Makefile
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
