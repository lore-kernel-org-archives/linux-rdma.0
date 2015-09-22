From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 31/32] IB/rxe: Add Soft-RoCE to kbuild and makefiles
Date: Tue, 22 Sep 2015 10:31:14 +0300
Message-ID: <1442907075-13228-32-git-send-email-kamalh@mellanox.com>
References: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442907075-13228-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kconfig and Makefiles for RXE driver

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/Kconfig      |  2 ++
 drivers/staging/Makefile     |  1 +
 drivers/staging/rxe/Kconfig  | 23 +++++++++++++++++++++++
 drivers/staging/rxe/Makefile | 24 ++++++++++++++++++++++++
 4 files changed, 50 insertions(+)
 create mode 100644 drivers/staging/rxe/Kconfig
 create mode 100644 drivers/staging/rxe/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 39d9505..9755cd8 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -112,4 +112,6 @@ source "drivers/staging/wilc1000/Kconfig"
 
 source "drivers/staging/most/Kconfig"
 
+source "drivers/staging/rxe/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e4f33d9..ac573a8 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -48,3 +48,4 @@ obj-$(CONFIG_FB_TFT)		+= fbtft/
 obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
 obj-$(CONFIG_WILC1000)		+= wilc1000/
 obj-$(CONFIG_MOST)		+= most/
+obj-$(CONFIG_INFINIBAND_RXE)    += rxe/
diff --git a/drivers/staging/rxe/Kconfig b/drivers/staging/rxe/Kconfig
new file mode 100644
index 0000000..649b7be
--- /dev/null
+++ b/drivers/staging/rxe/Kconfig
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
diff --git a/drivers/staging/rxe/Makefile b/drivers/staging/rxe/Makefile
new file mode 100644
index 0000000..7cf7774
--- /dev/null
+++ b/drivers/staging/rxe/Makefile
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
