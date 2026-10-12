Received: from sg-3-28.ptr.tlmpb.com (sg-3-28.ptr.tlmpb.com [101.45.255.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6529E47605E
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805518; cv=none; b=auZVOXAkJH8JWjEXA60uomy8PEhkejT5zepIkF4jnEsZGn/8qux3eKc/DcqjeGAwuxJebfPN93IOeuidz2sAlyx1hseiw3zI950Nzp3iPW0ny68xS3SyE4YV/4N5crp4fSZBLVqShr8Huf/72/STFBOj0WU/fzkzwpBfoDQQNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805518; c=relaxed/simple;
	bh=2G7c9vQKUltC+JpHkHcK5hyY+xe0EB1ZoWfw64a8TqY=;
	h=References:To:Subject:From:Mime-Version:Cc:Date:Message-Id:
	 Content-Type:In-Reply-To; b=E2DPOfraYxVwRRlXB2Vx+m+XTt90DEQ29WI/wXfoGAou8bPxuhYWAPDQXASdCjCPa2PggQi6XHQ14avs7u2dcmMQUjOy3JuLoTf25VJxwI4zVegA7uF83ziruuZoGQc4xM9hW0fssYn1WPndlUFcuU7RU8/OlKeB/HePdpRG6tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=Iabc+QaK; arc=none smtp.client-ip=101.45.255.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="Iabc+QaK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805469; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ktaZru8FBKQ0hA/J27yYCCZPtpNE8ueht4nhNL/qolE=;
 b=Iabc+QaKS0IVxbfbXYIVqg5HvFi1M5CHZaAThD9PMESzeND0SLt/dcS+2d3pMpEWKxWr+K
 bXv5+TuzbHVPFkiOjaRaId2RdFiTtskgK4XI0YmG7hEVtq18mAdC/aIVp1hJwVxPG5D6DT
 HDK10SpGYR/1++sWnM55dIqYLvWs41PEd2tLqsuaCmsOzH2yHzo0H9HNaHtzCnZyJYGpPi
 vgDiG+SmNjRoSVraxcvVmlbE9JwTt+xCDEWsty++zul1Z/EZWkSAyhsfyi/TufJPYobT5h
 EzgajhQX1aKuxdE5yS7YHXJUdc1eZuV/bN53YKESuNEYfDQmS8Y0CMieKABx0w==
X-Mailer: git-send-email 2.25.1
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Subject: [PATCH 14/15] yunsilicon: add RDMA counters and sysfs
X-Lms-Return-Path: <lba+26accc81b+e00f9c+vger.kernel.org+tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
From: "Xin Tian" <tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:27 +0800
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Mon, 12 Oct 2026 19:44:27 +0800
Message-Id: <20261012114425.2471317-15-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>

Add the hardware counter reporting through the RDMA counter interface,
the global counter sysfs attributes and the hca_type/hw_rev sysfs
attributes.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/Makefile       |   3 +-
 drivers/infiniband/hw/xsc/counters.c     | 422 +++++++++++++++++++++++
 drivers/infiniband/hw/xsc/counters.h     |  31 ++
 drivers/infiniband/hw/xsc/main.c         |   4 +
 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c |  64 ++++
 5 files changed, 523 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/xsc/counters.c
 create mode 100644 drivers/infiniband/hw/xsc/counters.h
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
index 000000000..135df9595
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/counters.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include "common/xsc_core.h"
+#include "common/xsc_hsi.h"
+#include "common/driver.h"
+#include "common/xsc_cmd.h"
+#include "counters.h"
+#include "xsc_ib.h"
+
+#define COUNTERS_FILE_NAME         "counters"
+#define COUNTERS_NAMES_FILE_NAME   "counters_names"
+#define COUNTERS_VALUE_FILE_NAME   "counters_value"
+#define COUNTERS_ATTER_GROUP_NAME  "counters"
+#define GLOBAL_COUNTERS_GROUP_NAME "global_counters"
+#define GLOBAL_COUNTERS_FILE_NAME  "counters"
+
+static const struct counter_desc hw_rdma_stats_pf_desc[] = {
+	/*by mac port*/
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_tx_pkts) },//0
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_tx_bytes) },//1
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_rx_pkts) },//2
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_rx_bytes) },//3
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  np_cnp_sent) },//4
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rp_cnp_handled) },//5
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  np_ecn_marked_roce_packets) },//6
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rp_cnp_ignored) },//7
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  read_rsp_out_of_seq) },//8
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  implied_nak_seq_err) },//9
+	/*by function*/
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  out_of_sequence) },//10
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  packet_seq_err) },//11
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  out_of_buffer) },//12
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rnr_nak_retry_err) },//13
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  local_ack_timeout_err) },//14
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rx_read_requests) },//15
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rx_write_requests) },//16
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  duplicate_requests) },//17
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_tx_pkts_func) },//18
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_tx_payload_bytes) },//19
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_rx_pkts_func) },//20
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_rx_payload_bytes) },//21
+	/*global*/
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_loopback_pkts) },//22
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_loopback_bytes) },//23
+	/*for diamond*/
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  out_of_sequence_sr) },//24
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  packet_seq_err_sr) },//25
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_ndp_rx_pkts) },//26
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_ndp_rx_trimmed_pkts) },//27
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rdma_ndp_trimmed_pkts_sr) },//28
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_pf,  rx_icrc_encapsulated) },//29
+	/*XSC_CMDQ_GET_HW_STATS_RDMA_V1*/
+};
+
+static const struct counter_desc hw_rdma_stats_vf_desc[] = {
+	/*by function*/
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rdma_tx_pkts_func) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rdma_tx_payload_bytes) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rdma_rx_pkts_func) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rdma_rx_payload_bytes) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  out_of_sequence) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  packet_seq_err) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  out_of_buffer) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rnr_nak_retry_err) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  local_ack_timeout_err) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rx_read_requests) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  rx_write_requests) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_stats_rdma_vf,  duplicate_requests) },
+};
+
+static const struct counter_desc hw_global_rdma_stats_desc[] = {
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  rdma_loopback_pkts) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  rdma_loopback_bytes) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  rx_icrc_encapsulated) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  req_cqe_error) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  resp_cqe_error) },
+	{ XSC_DECLARE_STAT(struct xsc_hw_global_stats_rdma,  cqe_msg_code_error) },
+};
+
+static int get_hw_stats_rdma(struct xsc_core_device *dev, struct xsc_hw_stats_rdma *stats_rdma)
+{
+	int ret;
+	struct xsc_hw_stats_mbox_in in;
+	struct xsc_hw_stats_rdma_mbox_out out;
+
+	memset(stats_rdma, 0, sizeof(*stats_rdma));
+
+	if (!dev)
+		return -1;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.mac_port = dev->mac_port;
+	in.hdr.ver = cpu_to_be16(XSC_CMDQ_GET_HW_STATS_RDMA_V1);
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HW_STATS_RDMA);
+
+	ret = xsc_cmd_exec(dev, (void *)&in, sizeof(in), (void *)&out, sizeof(out));
+	if (ret || out.hdr.status)
+		return -1;
+
+	memcpy(stats_rdma, &out.hw_stats, sizeof(*stats_rdma));
+
+	return 0;
+}
+
+static ssize_t counters_names_show(struct device *device,
+				   struct device_attribute *attr, char *buf)
+{
+	struct xsc_ib_dev *ibdev = container_of(device, struct xsc_ib_dev, ib_dev.dev);
+	struct xsc_core_device *xdev = ibdev->xdev;
+	struct xsc_hw_stats_rdma stats_rdma;
+	const struct counter_desc *desc;
+	int desc_size;
+	ssize_t count = 0;
+	u64 mask;
+	int i;
+
+	if (get_hw_stats_rdma(xdev, &stats_rdma))
+		return 0;
+
+	if (is_support_hw_pf_stats(xdev)) {
+		desc = hw_rdma_stats_pf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_pf_desc);
+	} else {
+		desc = hw_rdma_stats_vf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_vf_desc);
+	}
+
+	mask = xsc_get_rdma_stat_mask(xdev, be16_to_cpu(stats_rdma.ver));
+	for (i = 0; i < desc_size; i++) {
+		if (!((1ULL << i) & mask))
+			continue;
+		count += sysfs_emit_at(buf, count, "%s\n", desc[i].format);
+	}
+
+	return count;
+}
+static DEVICE_ATTR_RO(counters_names);
+
+static ssize_t counters_show(struct device *device,
+			     struct device_attribute *attr, char *buf)
+{
+	struct xsc_ib_dev *ibdev = container_of(device, struct xsc_ib_dev, ib_dev.dev);
+	struct xsc_core_device *xdev = ibdev->xdev;
+	struct xsc_hw_stats_rdma stats_rdma;
+	const struct counter_desc *desc;
+	int desc_size;
+	ssize_t count = 0;
+	u8 *stats;
+	u64 mask;
+	int i;
+
+	if (get_hw_stats_rdma(xdev, &stats_rdma) ||
+	    is_support_hw_pf_stats(xdev) != stats_rdma.is_pf)
+		return 0;
+
+	if (is_support_hw_pf_stats(xdev)) {
+		desc = hw_rdma_stats_pf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_pf_desc);
+		stats = (u8 *)&stats_rdma.stats.pf_stats;
+	} else {
+		desc = hw_rdma_stats_vf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_vf_desc);
+		stats = (u8 *)&stats_rdma.stats.vf_stats;
+	}
+
+	mask = xsc_get_rdma_stat_mask(xdev, be16_to_cpu(stats_rdma.ver));
+	for (i = 0; i < desc_size; i++) {
+		u64 value;
+
+		if (!((1ULL << i) & mask))
+			continue;
+		value = be64_to_cpu(*(u64 *)(stats + desc[i].offset));
+		count += sysfs_emit_at(buf, count, "%-26s    %-20llu\n",
+				       desc[i].format, value);
+	}
+
+	return count;
+}
+static DEVICE_ATTR_RO(counters);
+
+static ssize_t counters_value_read(struct file *file, struct kobject *kob,
+				   const struct bin_attribute *bin_attr,
+				   char *buf, loff_t loff, size_t size)
+{
+	struct xsc_ib_dev *ibdev = container_of(kob, struct xsc_ib_dev, ib_dev.dev.kobj);
+	struct xsc_core_device *xdev = ibdev->xdev;
+	struct xsc_hw_stats_rdma stats_rdma;
+	const struct counter_desc *desc;
+	int desc_size;
+	int bin_size;
+	u64 *tmp_value;
+	u8 *stats;
+	u64 mask;
+	int i, j;
+
+	if (bin_attr->size > size || bin_attr->size == 0)
+		return 0;
+
+	if (get_hw_stats_rdma(xdev, &stats_rdma) ||
+	    is_support_hw_pf_stats(xdev) != stats_rdma.is_pf)
+		return 0;
+
+	if (is_support_hw_pf_stats(xdev)) {
+		desc = hw_rdma_stats_pf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_pf_desc);
+		stats = (u8 *)&stats_rdma.stats.pf_stats;
+	} else {
+		desc = hw_rdma_stats_vf_desc;
+		desc_size = ARRAY_SIZE(hw_rdma_stats_vf_desc);
+		stats = (u8 *)&stats_rdma.stats.vf_stats;
+	}
+
+	bin_size = desc_size * sizeof(u64);
+	if (bin_attr->size < bin_size)
+		return 0;
+
+	tmp_value = kzalloc(bin_attr->size, GFP_KERNEL);
+	if (!tmp_value)
+		return 0;
+
+	mask = xsc_get_rdma_stat_mask(xdev, be16_to_cpu(stats_rdma.ver));
+	j = 0;
+	for (i = 0; i < desc_size; i++) {
+		if (!((1ULL << i) & mask))
+			continue;
+		tmp_value[j] = be64_to_cpu(*(u64 *)(stats + desc[i].offset));
+		j++;
+	}
+
+	memcpy(buf, tmp_value, bin_attr->size);
+
+	kfree(tmp_value);
+	return bin_attr->size;
+}
+static BIN_ATTR_RO(counters_value, sizeof(struct xsc_hw_stats_rdma));
+
+static struct attribute *counters_attrs[] = {
+	&dev_attr_counters_names.attr,
+	&dev_attr_counters.attr,
+	NULL,
+};
+
+static const struct bin_attribute *const counters_bin_attrs[] = {
+	&bin_attr_counters_value,
+	NULL,
+};
+
+static const struct attribute_group counters_group = {
+	.name = "counters",
+	.attrs = counters_attrs,
+	.bin_attrs = counters_bin_attrs,
+};
+
+static int counters_sysfs_init(struct ib_device *ib_dev)
+{
+	return sysfs_create_group(&ib_dev->dev.kobj, &counters_group);
+}
+
+static void counters_sysfs_fini(struct ib_device *ib_dev)
+{
+	sysfs_remove_group(&ib_dev->dev.kobj, &counters_group);
+}
+
+static ssize_t global_cnt_attr_show(struct kobject *kobj,
+				    struct attribute *attr, char *buf)
+{
+	struct xsc_global_cnt_attributes *a =
+		container_of(attr, struct xsc_global_cnt_attributes, attr);
+	struct xsc_global_cnt_interface *g =
+		container_of(kobj, struct xsc_global_cnt_interface, kobj);
+
+	if (!a->show)
+		return -EIO;
+
+	return a->show(g, a, buf);
+}
+
+static ssize_t global_cnt_attr_store(struct kobject *kobj,
+				     struct attribute *attr,
+				     const char *buf, size_t size)
+{
+	struct xsc_global_cnt_attributes *a =
+		container_of(attr, struct xsc_global_cnt_attributes, attr);
+	struct xsc_global_cnt_interface *g =
+		container_of(kobj, struct xsc_global_cnt_interface, kobj);
+
+	if (!a->store)
+		return -EIO;
+
+	return a->store(g, a, buf, size);
+}
+
+static ssize_t global_counters_show(struct xsc_global_cnt_interface *g,
+				    struct xsc_global_cnt_attributes *a, char *buf)
+{
+	int i;
+	int ret;
+	u8 *stats;
+	u64 value;
+	int desc_size;
+	ssize_t count = 0;
+	const struct counter_desc *desc;
+	struct xsc_hw_global_stats_mbox_in in;
+	struct xsc_hw_global_stats_mbox_out out;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HW_GLOBAL_STATS);
+	ret = xsc_cmd_exec(g->xdev, (void *)&in, sizeof(in),
+			   (void *)&out, sizeof(out));
+	if (ret || out.hdr.status)
+		return 0;
+
+	desc = &hw_global_rdma_stats_desc[0];
+	desc_size = ARRAY_SIZE(hw_global_rdma_stats_desc);
+	stats = (u8 *)&out.hw_stats;
+
+	for (i = 0 ; i < desc_size; i++) {
+		value = *(u64 *)(stats + desc[i].offset);
+		value = be64_to_cpu(value);
+		count += sprintf(&buf[count], "%-26s    %-20llu\n",
+				desc[i].format, value);
+	}
+
+	return count;
+}
+
+static ssize_t global_counters_store(struct xsc_global_cnt_interface *g,
+				     struct xsc_global_cnt_attributes *a,
+				     const char *buf, size_t count)
+{
+	return -EOPNOTSUPP;
+}
+
+#define GLOBAL_CNT_ATTR(_name) struct xsc_global_cnt_attributes xsc_global_cnt_attr_##_name = \
+	__ATTR(_name, 0444, global_##_name##_show, global_##_name##_store)
+
+GLOBAL_CNT_ATTR(counters);
+
+static const struct sysfs_ops global_cnt_sysfs_ops = {
+	.show = global_cnt_attr_show,
+	.store = global_cnt_attr_store,
+};
+
+static struct attribute *global_cnt_attrs[] = {
+	&xsc_global_cnt_attr_counters.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(global_cnt);
+
+static const struct kobj_type global_cnt_ktype = {
+	.sysfs_ops     = &global_cnt_sysfs_ops,
+	.default_groups = global_cnt_groups,
+};
+
+static struct xsc_global_cnt_interface *g_global_cnt_interface;
+
+static int global_cnt_sysfs_init(struct ib_device *ib_dev, struct xsc_core_device *xdev)
+{
+	struct xsc_global_cnt_interface *tmp;
+	int err;
+
+	if (!xdev || !xsc_core_is_pf(xdev) || xdev->pf_id != 0)
+		return 0;
+
+	tmp = kzalloc_obj(*tmp, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	err = kobject_init_and_add(&tmp->kobj, &global_cnt_ktype,
+				   &ib_dev->dev.kobj, GLOBAL_COUNTERS_GROUP_NAME);
+	if (err)
+		goto error_return;
+
+	g_global_cnt_interface = tmp;
+	tmp->xdev = xdev;
+	return 0;
+
+error_return:
+	kobject_put(&tmp->kobj);
+	kfree(tmp);
+	return err;
+}
+
+static void global_cnt_sysfs_fini(struct xsc_core_device *xdev)
+{
+	if (!g_global_cnt_interface || !xdev || !xsc_core_is_pf(xdev) || xdev->pf_id != 0)
+		return;
+
+	kobject_put(&g_global_cnt_interface->kobj);
+	kfree(g_global_cnt_interface);
+	g_global_cnt_interface = NULL;
+}
+
+int xsc_counters_init(struct ib_device *ib_dev, struct xsc_core_device *xdev)
+{
+	int ret;
+
+	ret = counters_sysfs_init(ib_dev);
+	if (ret)
+		return ret;
+
+	ret = global_cnt_sysfs_init(ib_dev, xdev);
+	if (ret)
+		counters_sysfs_fini(ib_dev);
+
+	return ret;
+}
+
+void xsc_counters_fini(struct ib_device *ib_dev, struct xsc_core_device *xdev)
+{
+	counters_sysfs_fini(ib_dev);
+	global_cnt_sysfs_fini(xdev);
+}
diff --git a/drivers/infiniband/hw/xsc/counters.h b/drivers/infiniband/hw/xsc/counters.h
new file mode 100644
index 000000000..944dbafb6
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/counters.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __COUNTERS_H__
+#define __COUNTERS_H__
+
+#define STRING_LEN		32
+#define XSC_DECLARE_STAT(type, fld)	""#fld, offsetof(type, fld)
+
+struct counter_desc {
+	char		format[STRING_LEN];
+	size_t		offset; /* Byte offset */
+};
+
+struct xsc_global_cnt_interface {
+	struct xsc_core_device  *xdev;
+	struct kobject		kobj;
+};
+
+struct xsc_global_cnt_attributes {
+	struct attribute attr;
+	ssize_t (*show)(struct xsc_global_cnt_interface *g, struct xsc_global_cnt_attributes *a,
+			char *buf);
+	ssize_t (*store)(struct xsc_global_cnt_interface *g, struct xsc_global_cnt_attributes *a,
+			 const char *buf, size_t count);
+};
+
+#endif
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index 30927006b..38c8b4f06 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -745,7 +745,9 @@ static int init_one(struct xsc_core_device *xdev,
 
 	xsc_register_netdev_notifier(dev);
 
+	xsc_counters_init(&dev->ib_dev, xdev);
 
+	xsc_ib_sysfs_init(&dev->ib_dev, xdev);
 
 	return 0;
 
@@ -759,6 +761,8 @@ static void remove_one(struct xsc_core_device *xdev, void *intf_ctx)
 {
 	struct xsc_ib_dev *dev = (struct xsc_ib_dev *)intf_ctx;
 
+	xsc_ib_sysfs_fini(&dev->ib_dev, xdev);
+	xsc_counters_fini(&dev->ib_dev, xdev);
 	xsc_unregister_netdev_notifier(dev);
 	ib_unregister_device(&dev->ib_dev);
 	ib_dealloc_device(&dev->ib_dev);
diff --git a/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c b/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c
new file mode 100644
index 000000000..a0b577bde
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/xsc_ib_sysfs.c
@@ -0,0 +1,64 @@
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
+	struct ib_device *ib_dev = container_of(device, struct ib_device, dev);
+	struct xsc_core_device *dev = to_xdev(ib_dev)->xdev;
+	struct pci_dev *pdev = dev->pdev;
+
+	return sprintf(buf, "%x\n", pdev->subsystem_device);
+}
+
+static DEVICE_ATTR_RO(hca_type);
+
+static ssize_t hw_rev_show(struct device *device, struct device_attribute *attr, char *buf)
+{
+	struct ib_device *ib_dev = container_of(device, struct ib_device, dev);
+	struct xsc_core_device *dev = to_xdev(ib_dev)->xdev;
+	u32 hw_ver = 0;
+
+	hw_ver = ((dev->chip_ver_l & 0xffff) << 16) |
+		(dev->hotfix_num & 0xffff);
+	return sprintf(buf, "0x%x\n", hw_ver);
+}
+
+static DEVICE_ATTR_RO(hw_rev);
+
+static struct device_attribute *xsc_ib_attributes[] = {
+	&dev_attr_hca_type,
+	&dev_attr_hw_rev,
+};
+
+void xsc_ib_sysfs_init(struct ib_device *ib_dev, struct xsc_core_device *xdev)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xsc_ib_attributes); i++) {
+		err = device_create_file(&ib_dev->dev, xsc_ib_attributes[i]);
+		if (err)
+			dev_err(&xdev->pdev->dev, "Create sysfs file for %s failed.\n",
+				xsc_ib_attributes[i]->attr.name);
+	}
+}
+
+void xsc_ib_sysfs_fini(struct ib_device *ib_dev, struct xsc_core_device *xdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xsc_ib_attributes); i++)
+		device_remove_file(&ib_dev->dev, xsc_ib_attributes[i]);
+}
