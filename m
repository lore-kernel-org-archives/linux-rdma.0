From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH v2 13/13] Add SoftiWarp to kernel build environment
Date: Fri,  6 Oct 2017 08:28:53 -0400
Message-ID: <20171006122853.16310-14-bmt@zurich.ibm.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
---
 drivers/infiniband/Kconfig         |  1 +
 drivers/infiniband/sw/Makefile     |  1 +
 drivers/infiniband/sw/siw/Kconfig  | 18 ++++++++++++++++++
 drivers/infiniband/sw/siw/Makefile | 15 +++++++++++++++
 4 files changed, 35 insertions(+)
 create mode 100644 drivers/infiniband/sw/siw/Kconfig
 create mode 100644 drivers/infiniband/sw/siw/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 234fe01904e7..6c963e814208 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -88,6 +88,7 @@ source "drivers/infiniband/ulp/isert/Kconfig"
 source "drivers/infiniband/ulp/opa_vnic/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 source "drivers/infiniband/sw/rxe/Kconfig"
+source "drivers/infiniband/sw/siw/Kconfig"
 
 source "drivers/infiniband/hw/hfi1/Kconfig"
 
diff --git a/drivers/infiniband/sw/Makefile b/drivers/infiniband/sw/Makefile
index 8b095b27db87..d37610fcbbc7 100644
--- a/drivers/infiniband/sw/Makefile
+++ b/drivers/infiniband/sw/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_INFINIBAND_RDMAVT)		+= rdmavt/
 obj-$(CONFIG_RDMA_RXE)			+= rxe/
+obj-$(CONFIG_RDMA_SIW)			+= siw/
diff --git a/drivers/infiniband/sw/siw/Kconfig b/drivers/infiniband/sw/siw/Kconfig
new file mode 100644
index 000000000000..482a0e992bc8
--- /dev/null
+++ b/drivers/infiniband/sw/siw/Kconfig
@@ -0,0 +1,18 @@
+config RDMA_SIW
+	tristate "Software RDMA over TCP/IP (iWARP) driver"
+	depends on INET && INFINIBAND
+	depends on CRYPTO_CRC32
+	---help---
+	This driver implements the iWARP RDMA transport over
+	the Linux TCP/IP network stack. It enables a system with a
+	standard Ethernet adapter to interoperate with a iWARP
+	adapter or with another system running the SIW driver.
+	(See also RXE which is a similar software driver for RoCE.)
+
+	The driver interfaces with the Linux RDMA stack and
+	implements both a kernel and user space RDMA verbs API.
+	The user space verbs API requires a support
+	library named libsiw which is loaded by the generic user
+	space verbs API, libibverbs. To implement RDMA over
+	TCP/IP, the driver further interfaces with the Linux
+	in-kernel TCP socket layer.
diff --git a/drivers/infiniband/sw/siw/Makefile b/drivers/infiniband/sw/siw/Makefile
new file mode 100644
index 000000000000..20f31c9e827b
--- /dev/null
+++ b/drivers/infiniband/sw/siw/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_RDMA_SIW) += siw.o
+
+siw-y := \
+	siw_main.o \
+	siw_cm.o \
+	siw_verbs.o \
+	siw_obj.o \
+	siw_qp.o \
+	siw_qp_tx.o \
+	siw_qp_rx.o \
+	siw_cq.o \
+	siw_cm.o \
+	siw_debug.o \
+	siw_ae.o \
+	siw_mem.o
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
