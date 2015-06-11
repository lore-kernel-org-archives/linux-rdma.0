From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 40/41] IB/hfi1: add driver make/config files
Date: Thu, 11 Jun 2015 19:12:04 -0400
Message-ID: <20150611231204.16479.50325.stgit@phlsvslse11.ph.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611230710.16479.62955.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Kconfig  |   27 +++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/Makefile |   20 ++++++++++++++++++++
 2 files changed, 47 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi1/Kconfig
 create mode 100644 drivers/infiniband/hw/hfi1/Makefile

diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
new file mode 100644
index 0000000..4d1ff19
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -0,0 +1,27 @@
+config INFINIBAND_HFI1
+	tristate "Intel OPA Gen1 support"
+	depends on X86_64
+	default m
+	---help---
+	This is a low-level driver for Intel OPA Gen1 adapter.
+config HFI1_DEBUG_SDMA_ORDER
+	bool "HFI1 SDMA Order debug"
+	depends on INFINIBAND_HFI1
+	default n
+	---help---
+	This is a debug flag to test for out of order
+	sdma completions for unit testing
+config HFI1_VERBS_31BIT_PSN
+	bool "HFI1 enable 31 bit PSN"
+	depends on INFINIBAND_HFI1
+	default y
+	---help---
+	Setting this enables 31 BIT PSN
+	For verbs RC/UC
+config CONFIG_SDMA_VERBOSITY
+	bool "Config SDMA Verbosity"
+	depends on INFINIBAND_HFI1
+	default n
+	---help---
+	This is a configuration flag to enable verbose
+	SDMA debug
diff --git a/drivers/infiniband/hw/hfi1/Makefile b/drivers/infiniband/hw/hfi1/Makefile
new file mode 100644
index 0000000..7e1c06d
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/Makefile
@@ -0,0 +1,20 @@
+#
+# HFI driver
+#
+#
+#
+# Called from the kernel module build system.
+#
+obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
+
+hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o eprom.o file_ops.o firmware.o \
+	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
+	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
+	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
+hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
+
+CFLAGS_trace.o = -I$(src)
+ifdef MVERSION
+CFLAGS_driver.o = -DHFI_DRIVER_VERSION_BASE=\"$(MVERSION)\"
+endif
+

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
