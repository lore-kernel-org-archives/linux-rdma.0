Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.38
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807855;
	b=RJFWD/TGf5XB2k9zxS7/B4IzQ6Sw3ypzwtgWfbqntwqjsHDVLswWV0Fm8ro16mkg+ngl
	 wzoUZcVhBC2c4X0OteGkqoK0xNJXQPhpokRIYuuHcYOTNahKDxknhAwMuT8+f99i0Q8E8
	 UxvkAljxpgQ1uJsG5JEsDGOnndT/7TrS6jGlSd5HHGHybAS2/9FseKfJx9RmXea7Tsmei
	 2e6DVYZ7gT/JlWV9ijSkKG77doJHkrSPd6dcdQtYjAK7QG/NMh50BuEyM3WqvhF1+EcTU
	 pdfxlIM7fVSm7OalONGjXHZuyQwwCVuO87wQotQ4Olqvyi9J8IlQz2o1wGV88dfjbCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807855;
	h=DMARC-Filter:DKIM-Signature:Subject:Date:Cc:In-Reply-To:References:
	 X-Mailer:Content-Type:Received:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Message-Id:From:X-Original-From:To:
	 Mime-Version;
	bh=eWdrVGrpU92nuNpng2D3gyGIzVmlf5m4aqLr9Q+QIlc=;
	b=Z+AeJpIB8mqBaTOLNsEjNFAEj/mg3dn+qhcRjBZcDItwpmElSSl80tynzQH2H8C0HpZQ
	 JX5qeoqaFLSvi+ZKTiJSQIOsz3gLTJHqZbpDgKo1ilJleTnE40dhvpk2r0XcxJ+/ljm9N
	 KMyTrPRiMe3wImFGcAD/EzzUInFO5Vax3DcsEH07WkV3kh+k9+2f1jP0BIKJ6NiNz55v6
	 tcb+08X9mF34CRA9uboMhd9tuoelRgIAsMgQje/H5oKjv85g8zXJKAokPNjP77vuNJdja
	 jv5sKqPToyxM85gyf53UMcGKIYrZi7NPHokTTf70RFh0YJjeoawE+I77inygNhGYmKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=CwUVMjKG;
	arc=none smtp.remote-ip=209.127.231.38
Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E698760A380A
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E698760A380A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=CwUVMjKG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807850; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=eWdrVGrpU92nuNpng2D3gyGIzVmlf5m4aqLr9Q+QIlc=;
 b=CwUVMjKGQbtaDf2gWmQBeyzNdJxfDMxhlranEwvpGTOMulOYjt5ZjtF553x9aNGdv9RJMF
 jyqv626hwBTmJPhqBa2LQjhH0stnanR3B++zqK4OHG06ZGejYJbZve977afQyIGrTZU6OR
 8qAxWOjbFLeiTVJbpmeOdzgh+rXsNJz1MbazBRpdjv8wU6sLQxydjPxvGDt2+sSpng5Z8U
 FX/XuaQBKK/R55hBjoqIHDl6ID6vVbXBsL+fQDqgd/hWwBrjZ6BJ41GFrM38Geldc4VjMT
 RKmJxCsF/ezOfWflvxy0q7DwlYJf5pzlYsoKgh2CjCdetpC4dPJGMnlvGcfRmw==
Subject: [PATCH v1 15/15] RDMA/xsc: add RDMA counters and sysfs
Date: Wed, 04 Nov 2026 23:57:28 +0800
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:28 +0800
X-Lms-Return-Path: <lba+26aeb55e8+dcd2e2+vger.kernel.org+tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Message-Id: <20261104155726.37053-16-tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

Add the rdma hw_stats implementation and two driver sysfs
attributes.

get_hw_stats reads the per-function RDMA statistics from firmware
and converts the big-endian fields into the registered counter set
using offsets recorded in the descriptor table.  The set covers
TX/RX packet and byte counts, RoCE congestion control counters
(ECN marks, CNP sent and handled, CNP ignores) and per-function
error counters such as out-of-buffer, RNR NAK retries and local ACK
timeouts.  Six card-global counters (loopback traffic, encapsulated
ICRC, completion and message code errors) come from a separate
firmware query and are only registered on PF 0, since the global
statistics are valid only there.

Expose hca_type, reporting the PCI device ID, and hw_rev, composed
from the chip version and hotfix number, as read-only attributes on
the ib_device class device, attached through the standard
device_group so the driver core manages their lifetime.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/Makefile            |   3 +-
 drivers/infiniband/hw/xsc/counters.c          | 134 ++++++++++++++++++
 drivers/infiniband/hw/xsc/main.c              |   4 +-
 drivers/infiniband/hw/xsc/xsc_ib.h            |   3 +
 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c      |  50 +++++++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |   1 +
 6 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/hw/xsc/counters.c
 create mode 100644 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c

diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/xsc/Makefile
index d5ad0e573..48a6d2b0a 100644
--- a/drivers/infiniband/hw/xsc/Makefile
+++ b/drivers/infiniband/hw/xsc/Makefile
@@ -6,4 +6,5 @@ ccflags-y := -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_INFINIBAND_XSC) += xsc_ib.o
 
-xsc_ib-y := main.o cq.o qp.o mem.o mr.o srq.o ah.o
+xsc_ib-y := main.o cq.o qp.o mem.o mr.o ah.o counters.o \
+		xsc_ib_sysfs.o srq.o
diff --git a/drivers/infiniband/hw/xsc/counters.c b/drivers/infiniband/hw/xsc/counters.c
new file mode 100644
index 000000000..c29a5bf80
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/counters.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "xsc_ib.h"
+
+/*
+ * Per-function/per-mac-port counters reported by
+ * XSC_CMD_OP_QUERY_HW_STATS_RDMA.  .priv carries the byte offset of the
+ * counter inside the firmware statistics payload.
+ */
+#define XSC_HW_STAT(type, fld) \
+	{ .name = #fld, .priv = (const void *)(uintptr_t)offsetof(type, fld) }
+
+/*
+ * Card-global counters from XSC_CMD_OP_QUERY_HW_GLOBAL_STATS.  They are
+ * only valid on PF 0, so the name is prefixed to make that visible to
+ * whoever reads the counters.
+ */
+#define XSC_HW_GLOBAL_STAT(type, fld) \
+	{ .name = "global_" #fld, \
+	  .priv = (const void *)(uintptr_t)offsetof(type, fld) }
+
+#define XSC_NUM_PF_STATS	22
+
+static const struct rdma_stat_desc xsc_rdma_pf_stats_descs[] = {
+	/* by mac port */
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_tx_pkts),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_tx_bytes),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_rx_pkts),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_rx_bytes),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, np_cnp_sent),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rp_cnp_handled),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, np_ecn_marked_roce_packets),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rp_cnp_ignored),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, read_rsp_out_of_seq),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, implied_nak_seq_err),
+	/* by function */
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, out_of_sequence),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, packet_seq_err),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, out_of_buffer),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rnr_nak_retry_err),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, local_ack_timeout_err),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rx_read_requests),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rx_write_requests),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, duplicate_requests),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_tx_pkts_func),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_tx_payload_bytes),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_rx_pkts_func),
+	XSC_HW_STAT(struct xsc_hw_stats_rdma_pf, rdma_rx_payload_bytes),
+	/*
+	 * The PF payload also carries rdma_loopback_[pkts,bytes], but they
+	 * are the same registers as the card-global ones.  Expose them once,
+	 * from the global query.
+	 */
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, rdma_loopback_pkts),
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, rdma_loopback_bytes),
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, rx_icrc_encapsulated),
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, req_cqe_error),
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, resp_cqe_error),
+	XSC_HW_GLOBAL_STAT(struct xsc_hw_global_stats_rdma, cqe_msg_code_error),
+};
+
+static int xsc_ib_query_hw_stats_rdma(struct xsc_core_device *xdev,
+				      struct xsc_hw_stats_rdma *stats_rdma)
+{
+	struct xsc_hw_stats_mbox_in in = {};
+	struct xsc_hw_stats_rdma_mbox_out out = {};
+	int ret;
+
+	in.mac_port = xdev->mac_port;
+	in.hdr.ver = cpu_to_be16(XSC_CMDQ_GET_HW_STATS_RDMA_V1);
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HW_STATS_RDMA);
+
+	ret = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (ret || out.hdr.status)
+		return -EIO;
+
+	memcpy(stats_rdma, &out.hw_stats, sizeof(*stats_rdma));
+	return 0;
+}
+
+struct rdma_hw_stats *xsc_ib_alloc_hw_device_stats(struct ib_device *ib_dev)
+{
+	struct xsc_core_device *xdev = to_xdev(ib_dev)->xdev;
+	int num;
+
+	num = xdev->pf_id == 0 ? ARRAY_SIZE(xsc_rdma_pf_stats_descs)
+			       : XSC_NUM_PF_STATS;
+
+	return rdma_alloc_hw_stats_struct(xsc_rdma_pf_stats_descs, num,
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+int xsc_ib_get_hw_stats(struct ib_device *ib_dev, struct rdma_hw_stats *stats,
+		       u32 port_num, int index)
+{
+	struct xsc_core_device *xdev = to_xdev(ib_dev)->xdev;
+	struct xsc_hw_stats_rdma stats_rdma;
+	u8 *hw_stats;
+	int ret;
+	int i;
+
+	ret = xsc_ib_query_hw_stats_rdma(xdev, &stats_rdma);
+	if (ret)
+		return ret;
+
+	hw_stats = (u8 *)&stats_rdma.stats.pf_stats;
+
+	for (i = 0; i < stats->num_counters && i < XSC_NUM_PF_STATS; i++)
+		stats->value[i] =
+			be64_to_cpu(*(u64 *)(hw_stats + (uintptr_t)stats->descs[i].priv));
+
+	if (stats->num_counters > XSC_NUM_PF_STATS) {
+		struct xsc_hw_global_stats_mbox_in gin = {};
+		struct xsc_hw_global_stats_mbox_out gout = {};
+
+		gin.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HW_GLOBAL_STATS);
+		ret = xsc_cmd_exec(xdev, &gin, sizeof(gin), &gout, sizeof(gout));
+		if (ret || gout.hdr.status)
+			return -EIO;
+
+		hw_stats = (u8 *)&gout.hw_stats;
+		for (i = XSC_NUM_PF_STATS; i < stats->num_counters; i++)
+			stats->value[i] = be64_to_cpu(
+				*(u64 *)(hw_stats + (uintptr_t)stats->descs[i].priv));
+	}
+
+	return stats->num_counters;
+}
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index 057468798..0690b3e2f 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -552,7 +552,10 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 
 	dev->ib_dev.ops.drain_sq		= xsc_ib_drain_sq;
 	dev->ib_dev.ops.drain_rq		= xsc_ib_drain_rq;
+	dev->ib_dev.ops.device_group		= xsc_ib_attr_group();
 	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
+	dev->ib_dev.ops.alloc_hw_device_stats = xsc_ib_alloc_hw_device_stats;
+	dev->ib_dev.ops.get_hw_stats	= xsc_ib_get_hw_stats;
 	dev->ib_dev.ops.create_srq		= xsc_ib_create_srq;
 	dev->ib_dev.ops.destroy_srq		= xsc_ib_destroy_srq;
 	dev->ib_dev.ops.query_srq		= xsc_ib_query_srq;
@@ -712,7 +715,6 @@ static int init_one(struct xsc_core_device *xdev,
 	dev->ib_active = true;
 	*ibdev = dev;
 
-
 	return 0;
 
 err_free:
diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/xsc/xsc_ib.h
index fe111b2c6..30cafad88 100644
--- a/drivers/infiniband/hw/xsc/xsc_ib.h
+++ b/drivers/infiniband/hw/xsc/xsc_ib.h
@@ -306,6 +306,9 @@ int xsc_ib_destroy_qp(struct ib_qp *qp, struct ib_udata *udata);
 int xsc_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
 int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
 void xsc_ib_dealloc_ucontext(struct ib_ucontext *ibcontext);
+struct rdma_hw_stats *xsc_ib_alloc_hw_device_stats(struct ib_device *ib_dev);
+int xsc_ib_get_hw_stats(struct ib_device *ib_dev, struct rdma_hw_stats *stats,
+			u32 port_num, int index);
 int xsc_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
 int xsc_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 
diff --git a/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c b/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c
new file mode 100644
index 000000000..c8d199a0e
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/time.h>
+#include "common/xsc_core.h"
+#include "common/xsc_hsi.h"
+#include "common/driver.h"
+#include "common/xsc_cmd.h"
+#include "xsc_ib.h"
+
+static ssize_t hca_type_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct xsc_ib_dev *dev = rdma_device_to_drv_device(device, struct xsc_ib_dev, ib_dev);
+
+	return sysfs_emit(buf, "%x\n", dev->xdev->pdev->device);
+}
+
+static DEVICE_ATTR_RO(hca_type);
+
+static ssize_t hw_rev_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct xsc_ib_dev *dev = rdma_device_to_drv_device(device, struct xsc_ib_dev, ib_dev);
+	u32 hw_ver;
+
+	hw_ver = ((dev->xdev->chip_ver_l & 0xffff) << 16) |
+		(dev->xdev->hotfix_num & 0xffff);
+	return sysfs_emit(buf, "0x%x\n", hw_ver);
+}
+
+static DEVICE_ATTR_RO(hw_rev);
+
+static struct attribute *xsc_class_attributes[] = {
+	&dev_attr_hca_type.attr,
+	&dev_attr_hw_rev.attr,
+	NULL,
+};
+
+static const struct attribute_group xsc_attr_group = {
+	.attrs = xsc_class_attributes,
+};
+
+const struct attribute_group *xsc_ib_attr_group(void)
+{
+	return &xsc_attr_group;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index ea536389e..dfffde442 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -631,6 +631,7 @@ static inline bool is_support_multi_doorbell(struct xsc_core_device *dev)
 }
 
 void xsc_remove_rdma_driver(void);
+const struct attribute_group *xsc_ib_attr_group(void);
 
 void xsc_init_hal(struct xsc_core_device *xdev);
 
-- 
2.18.4
