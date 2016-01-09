From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 03/27] IB/hfi1: Consolidate dma ops for hfi1
Date: Sat, 09 Jan 2016 07:16:54 -0800
Message-ID: <20160109151654.30800.29121.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the dma.c file from hfi1 in favor of using that which is
present in rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Kconfig  |    2 +-
 drivers/staging/rdma/hfi1/Makefile |    2 +-
 drivers/staging/rdma/hfi1/verbs.c  |    2 +-
 drivers/staging/rdma/hfi1/verbs.h  |    2 --
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index fd25078..55048fe 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
-	depends on X86_64
+	depends on X86_64 && INFINIBAND_RDMAVT
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.
diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 2e5daa6..2126b8b 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -7,7 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
-hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o eprom.o file_ops.o firmware.o \
+hfi1-y := chip.o cq.o device.o diag.o driver.o eprom.o file_ops.o firmware.o \
 	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 1ebff05..08ce9d3 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2074,7 +2074,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->detach_mcast = hfi1_multicast_detach;
 	ibdev->process_mad = hfi1_process_mad;
 	ibdev->mmap = hfi1_mmap;
-	ibdev->dma_ops = &hfi1_dma_mapping_ops;
+	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = port_immutable;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 5c8adae..ecc8dde 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1143,6 +1143,4 @@ extern unsigned int hfi1_max_srq_wrs;
 
 extern const u32 ib_hfi1_rnr_table[];
 
-extern struct ib_dma_mapping_ops hfi1_dma_mapping_ops;
-
 #endif                          /* HFI1_VERBS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
