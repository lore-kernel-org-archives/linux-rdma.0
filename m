From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] RDMA/bnxt_re: Implement the alloc/get_hw_stats callback
Date: Tue,  1 Aug 2017 09:06:19 -0700
Message-ID: <1501603579-13844-3-git-send-email-selvin.xavier@broadcom.com>
References: <1501603579-13844-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501603579-13844-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Expose HW counters using the get_hw_stats callback

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/Makefile      |   2 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 105 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/hw_counters.h |  62 ++++++++++++++++
 drivers/infiniband/hw/bnxt_re/main.c        |   4 ++
 4 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.c
 create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.h

diff --git a/drivers/infiniband/hw/bnxt_re/Makefile b/drivers/infiniband/hw/bnxt_re/Makefile
index 036f84e..afbaa0e 100644
--- a/drivers/infiniband/hw/bnxt_re/Makefile
+++ b/drivers/infiniband/hw/bnxt_re/Makefile
@@ -3,4 +3,4 @@ ccflags-y := -Idrivers/net/ethernet/broadcom/bnxt
 obj-$(CONFIG_INFINIBAND_BNXT_RE) += bnxt_re.o
 bnxt_re-y := main.o ib_verbs.o \
 	     qplib_res.o qplib_rcfw.o	\
-	     qplib_sp.o qplib_fp.o
+	     qplib_sp.o qplib_fp.o  hw_counters.o
diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
new file mode 100644
index 0000000..8b0929e
--- /dev/null
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -0,0 +1,105 @@
+/*
+ * Broadcom NetXtreme-E RoCE driver.
+ *
+ * Copyright (c) 2016 - 2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Description: Statistics
+ *
+ */
+
+#include <rdma/ib_addr.h>
+
+#include "bnxt_ulp.h"
+#include "roce_hsi.h"
+#include "qplib_res.h"
+#include "qplib_sp.h"
+#include "qplib_fp.h"
+#include "qplib_rcfw.h"
+#include "bnxt_re.h"
+#include "hw_counters.h"
+
+static const char * const bnxt_re_stat_name[] = {
+	[BNXT_RE_ACTIVE_QP]           =  "active_qps",
+	[BNXT_RE_ACTIVE_SRQ]          =  "active_srqs",
+	[BNXT_RE_ACTIVE_CQ]           =  "active_cqs",
+	[BNXT_RE_ACTIVE_MR]           =  "active_mrs",
+	[BNXT_RE_ACTIVE_MW]           =  "active_mws",
+	[BNXT_RE_RX_PKTS]             =  "rx_pkts",
+	[BNXT_RE_RX_BYTES]            =  "rx_bytes",
+	[BNXT_RE_TX_PKTS]             =  "tx_pkts",
+	[BNXT_RE_TX_BYTES]            =  "tx_bytes",
+	[BNXT_RE_RECOVERABLE_ERRORS]  =  "recoverable_errors"
+};
+
+int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
+			    struct rdma_hw_stats *stats,
+			    u8 port, int index)
+{
+	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
+	struct ctx_hw_stats *bnxt_re_stats = rdev->qplib_ctx.stats.dma;
+
+	if (!port || !stats)
+		return -EINVAL;
+
+	stats->value[BNXT_RE_ACTIVE_QP] = atomic_read(&rdev->qp_count);
+	stats->value[BNXT_RE_ACTIVE_SRQ] = atomic_read(&rdev->srq_count);
+	stats->value[BNXT_RE_ACTIVE_CQ] = atomic_read(&rdev->cq_count);
+	stats->value[BNXT_RE_ACTIVE_MR] = atomic_read(&rdev->mr_count);
+	stats->value[BNXT_RE_ACTIVE_MW] = atomic_read(&rdev->mw_count);
+	if (bnxt_re_stats) {
+		stats->value[BNXT_RE_RECOVERABLE_ERRORS] =
+			le64_to_cpu(bnxt_re_stats->tx_bcast_pkts);
+		stats->value[BNXT_RE_RX_PKTS] =
+			le64_to_cpu(bnxt_re_stats->rx_ucast_pkts);
+		stats->value[BNXT_RE_RX_BYTES] =
+			le64_to_cpu(bnxt_re_stats->rx_ucast_bytes);
+		stats->value[BNXT_RE_TX_PKTS] =
+			le64_to_cpu(bnxt_re_stats->tx_ucast_pkts);
+		stats->value[BNXT_RE_TX_BYTES] =
+			le64_to_cpu(bnxt_re_stats->tx_ucast_bytes);
+	}
+	return ARRAY_SIZE(bnxt_re_stat_name);
+}
+
+struct rdma_hw_stats *bnxt_re_ib_alloc_hw_stats(struct ib_device *ibdev,
+						u8 port_num)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(bnxt_re_stat_name) != BNXT_RE_NUM_COUNTERS);
+	/* We support only per port stats */
+	if (!port_num)
+		return NULL;
+
+	return rdma_alloc_hw_stats_struct(bnxt_re_stat_name,
+					  ARRAY_SIZE(bnxt_re_stat_name),
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.h b/drivers/infiniband/hw/bnxt_re/hw_counters.h
new file mode 100644
index 0000000..c624fa3
--- /dev/null
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.h
@@ -0,0 +1,62 @@
+/*
+ * Broadcom NetXtreme-E RoCE driver.
+ *
+ * Copyright (c) 2016 - 2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Description: Statistics (header)
+ *
+ */
+
+#ifndef HW_STATS_H
+#define HW_STATS_H
+
+enum bnxt_re_hw_stats {
+	BNXT_RE_ACTIVE_QP,
+	BNXT_RE_ACTIVE_SRQ,
+	BNXT_RE_ACTIVE_CQ,
+	BNXT_RE_ACTIVE_MR,
+	BNXT_RE_ACTIVE_MW,
+	BNXT_RE_RX_PKTS,
+	BNXT_RE_RX_BYTES,
+	BNXT_RE_TX_PKTS,
+	BNXT_RE_TX_BYTES,
+	BNXT_RE_RECOVERABLE_ERRORS,
+	BNXT_RE_NUM_COUNTERS
+};
+
+struct rdma_hw_stats *bnxt_re_ib_alloc_hw_stats(struct ib_device *ibdev,
+						u8 port_num);
+int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
+			    struct rdma_hw_stats *stats,
+			    u8 port, int index);
+#endif /* HW_STATS_H */
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 5b78d8f..82d1cbc 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -64,6 +64,8 @@
 #include "ib_verbs.h"
 #include <rdma/bnxt_re-abi.h>
 #include "bnxt.h"
+#include "hw_counters.h"
+
 static char version[] =
 		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
 
@@ -513,6 +515,8 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	ibdev->alloc_ucontext		= bnxt_re_alloc_ucontext;
 	ibdev->dealloc_ucontext		= bnxt_re_dealloc_ucontext;
 	ibdev->mmap			= bnxt_re_mmap;
+	ibdev->get_hw_stats             = bnxt_re_ib_get_hw_stats;
+	ibdev->alloc_hw_stats           = bnxt_re_ib_alloc_hw_stats;
 
 	return ib_register_device(ibdev, NULL);
 }
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
