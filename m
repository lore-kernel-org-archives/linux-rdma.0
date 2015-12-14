From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 03/15] IB/hfi1: Consolidate dma ops for hfi1
Date: Mon, 14 Dec 2015 12:28:12 -0500
Message-ID: <20151214172810.11576.29041.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the dma.c file from hfi1 in favor of using that which is
present in rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile |    2 +-
 drivers/staging/rdma/hfi1/verbs.c  |    2 +-
 drivers/staging/rdma/hfi1/verbs.h  |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

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
index c457e82..22e2742 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2064,7 +2064,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->detach_mcast = hfi1_multicast_detach;
 	ibdev->process_mad = hfi1_process_mad;
 	ibdev->mmap = hfi1_mmap;
-	ibdev->dma_ops = &hfi1_dma_mapping_ops;
+	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = port_immutable;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index a290ed3..4f23e00 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1155,6 +1155,4 @@ extern unsigned int hfi1_max_srq_wrs;
 
 extern const u32 ib_hfi1_rnr_table[];
 
-extern struct ib_dma_mapping_ops hfi1_dma_mapping_ops;
-
 #endif                          /* HFI1_VERBS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
