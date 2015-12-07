From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/10] IB/qib: Remove dma.c and use rdmavt version of dma
 functions
Date: Mon, 07 Dec 2015 15:48:58 -0500
Message-ID: <20151207204857.11219.26550.stgit@phlsvslse11.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204735.11219.68688.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes the qib_dma.c file and uses the version which has been
added to rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile    |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c |    3 ++-
 drivers/infiniband/hw/qib/qib_verbs.h |    2 --
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index 57f8103..8a8f892 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_INFINIBAND_QIB) += ib_qib.o
 
-ib_qib-y := qib_cq.o qib_diag.o qib_dma.o qib_driver.o qib_eeprom.o \
+ib_qib-y := qib_cq.o qib_diag.o qib_driver.o qib_eeprom.o \
 	qib_file_ops.o qib_fs.o qib_init.o qib_intr.o qib_keys.o \
 	qib_mad.o qib_mmap.o qib_mr.o qib_pcie.o qib_pio_copy.o \
 	qib_qp.o qib_qsfp.o qib_rc.o qib_ruc.o qib_sdma.o qib_srq.o \
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9c721aa..fb4f045 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -41,6 +41,7 @@
 #include <linux/mm.h>
 #include <linux/random.h>
 #include <linux/vmalloc.h>
+#include <rdma/rdma_vt.h>
 
 #include "qib.h"
 #include "qib_common.h"
@@ -2269,7 +2270,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->detach_mcast = qib_multicast_detach;
 	ibdev->process_mad = qib_process_mad;
 	ibdev->mmap = qib_mmap;
-	ibdev->dma_ops = &qib_dma_mapping_ops;
+	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = qib_port_immutable;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1e43fda..8487914 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1186,6 +1186,4 @@ extern unsigned int ib_qib_max_srq_wrs;
 
 extern const u32 ib_qib_rnr_table[];
 
-extern struct ib_dma_mapping_ops qib_dma_mapping_ops;
-
 #endif                          /* QIB_VERBS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
