Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8528466B66
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805474; cv=none; b=MHYEuVeBBWDFFW1gd9o7SS0JuW90h/+klgCjhSBALD/7NcVZvKRV3r7PnGGqMa8EVzXAGFZLJqqWLDw0MGU2JYCEX/WuKK8rCEVhoityHHqX20ukUZryodZT8Dew1DMyFrDS+AeXowUWy/WmOefOPdqhoVL1g57Jwfk2ShveZEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805474; c=relaxed/simple;
	bh=gt41+yWOJgI7/4kRjnz3wDbQ73mEpVLc9EjP8YXUMEM=;
	h=Content-Type:Date:Mime-Version:To:Message-Id:In-Reply-To:
	 References:Cc:From:Subject; b=f1TlYw9f0qu2AVsd4g+Hs6cIQu+SaD+HhWS23viN95gilfhVl4RTaWoIK1k3rOFfravCYFZxFmUwGFQhTCFxcQNJhAW2NuyqoZOjWheHWfHApBuDtsWUrf2dBtDMkqiGaQdl1qegk8dYdy7Og4snnqzcYclKTuVPJSJpI2QYQbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=bIbROwAj; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="bIbROwAj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805457; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Si8Ugi7Zw7pT1CEXAhvWxsGcMlQ6f3wjVWJk2q5cuL0=;
 b=bIbROwAj2IYBtMN+BMZDwmddJE51AC/b/rxATQCndZAErN6Mapl2Gr1aRIMs0lUj90u8HF
 SJPzMk0GorpkvMJcxyT+yL34eweLpr7J1b5N7rBDZcUQZz85d8CmFFy8SaVD7C0fypH+Fy
 DGBO4HQgEqX1LABAxLbr/H1bn+PHyxYe8Vv9oSnYeQUpBCMcwm4SNemZ8ZRcqEX+31hEJ7
 0uAt03fUJx9FlxwP4eGPeREh/0qWmv86skqxooRgEYd5UVSDHSx+r2Tr46M45oquMF+UEq
 gklMRIKRm3uP7mnhAfAoMAmjshFIWXs2PPFxws4/E3Ya1lRF33LXqA8Wt3jmuA==
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.25.1
Date: Mon, 12 Oct 2026 19:44:14 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:14 +0800
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Message-Id: <20261012114412.2471317-10-tianx@yunsilicon.com>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26accc80f+bb7624+vger.kernel.org+tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH 09/15] yunsilicon: add RDMA device support

Add the RDMA driver's uverbs ABI header (include/uapi/rdma/xsc-abi.h),
the ib_device scaffolding and device registration: query_device,
query_port, query_pkey, ucontext allocation and mmap, port attributes and
the netdev notifier that tracks the port state.

The driver reports RDMA_DRIVER_XSC, which is added to the rdma_driver_id
enum at the end so existing IDs are untouched.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/Kconfig                    |   1 +
 drivers/infiniband/hw/Makefile                |   1 +
 drivers/infiniband/hw/xsc/Kconfig             |  17 +
 drivers/infiniband/hw/xsc/Makefile            |   9 +
 drivers/infiniband/hw/xsc/main.c              | 797 ++++++++++++++++++
 drivers/infiniband/hw/xsc/xsc_ib.h            | 542 ++++++++++++
 .../net/ethernet/yunsilicon/xsc/common/cq.h   |  30 +
 .../ethernet/yunsilicon/xsc/common/driver.h   |  95 +++
 .../net/ethernet/yunsilicon/xsc/common/qp.h   | 104 +++
 .../net/ethernet/yunsilicon/xsc/common/srq.h  |  54 ++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/pci/link.c    |  35 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 include/uapi/rdma/xsc-abi.h                   | 295 +++++++
 14 files changed, 1982 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/xsc/Kconfig
 create mode 100644 drivers/infiniband/hw/xsc/Makefile
 create mode 100644 drivers/infiniband/hw/xsc/main.c
 create mode 100644 drivers/infiniband/hw/xsc/xsc_ib.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/driver.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/qp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/srq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/link.c
 create mode 100644 include/uapi/rdma/xsc-abi.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 086195758..b3cc506db 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -100,6 +100,7 @@ source "drivers/infiniband/hw/ocrdma/Kconfig"
 source "drivers/infiniband/hw/qedr/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
 source "drivers/infiniband/hw/vmw_pvrdma/Kconfig"
+source "drivers/infiniband/hw/xsc/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 endif # !UML
 source "drivers/infiniband/sw/rxe/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c42b22ac3..1bcd2d50a 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
 obj-$(CONFIG_INFINIBAND_BNG_RE)		+= bng_re/
 obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
 obj-$(CONFIG_INFINIBAND_IONIC)		+= ionic/
+obj-$(CONFIG_INFINIBAND_XSC)	+= xsc/
diff --git a/drivers/infiniband/hw/xsc/Kconfig b/drivers/infiniband/hw/xsc/Kconfig
new file mode 100644
index 000000000..5cf46df2d
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+
+config INFINIBAND_XSC
+	tristate "Yunsilicon XSC RDMA driver"
+	depends on INFINIBAND && PCI && INET
+	depends on YUNSILICON_XSC_PCI && YUNSILICON_XSC_ETH
+	help
+	  This driver provides RDMA support for Yunsilicon XSC devices.
+	  It uses the auxiliary device published by the XSC PCI core and,
+	  for now, the netdev registered by the XSC ethernet driver to
+	  derive the port state and GID.  Because of that netdev
+	  dependency it also depends on YUNSILICON_XSC_ETH.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called xsc_ib.
diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/xsc/Makefile
new file mode 100644
index 000000000..6c4ec1ca0
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+
+ccflags-y := -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
+
+obj-$(CONFIG_INFINIBAND_XSC) += xsc_ib.o
+
+xsc_ib-y := main.o
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
new file mode 100644
index 000000000..9d53a89be
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -0,0 +1,797 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/namei.h>
+#include <linux/kobject.h>
+#include <linux/kernfs.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/io-mapping.h>
+#include <linux/sched.h>
+#include <linux/netdevice.h>
+#include "common/xsc_core.h"
+#include "common/xsc_hsi.h"
+#include "common/xsc_cmd.h"
+#include "common/driver.h"
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_umem.h>
+
+#include <rdma/xsc-abi.h>
+#include "xsc_ib.h"
+
+#define DRIVER_NAME "xsc_ib"
+
+#define XSC_IB_GID_TBL_LEN	256
+#define XSC_IB_MAX_PKEYS	0x80
+
+MODULE_DESCRIPTION("Yunsilicon HCA IB driver");
+MODULE_LICENSE("GPL");
+
+static int xsc_ib_query_device(struct ib_device *ibdev,
+			       struct ib_device_attr *props,
+			       struct ib_udata *udata)
+{
+	size_t udata_outlen = (udata) ? udata->outlen : 0;
+	struct xsc_ib_dev *dev = to_xdev(ibdev);
+	struct xsc_ib_query_device_resp resp;
+	union xsc_ib_fw_ver fw_ver;
+	int err = -ENOMEM;
+	size_t resp_len;
+	int max_rq_sg;
+	u64 max_tso;
+	u64 flags;
+
+	err = ib_is_udata_in_empty(udata);
+	if (err)
+		return err;
+
+	memset(&resp, 0, sizeof(resp));
+	memset(props, 0, sizeof(*props));
+
+	resp_len = sizeof(resp.comp_mask) + sizeof(resp.response_length);
+	/*check param*/
+	if (udata_outlen && udata_outlen < resp_len)
+		return -EINVAL;
+
+	resp.response_length = resp_len;
+
+	fw_ver.data = 0;
+	fw_ver.s.ver_major = dev->xdev->fw_version_major;
+	fw_ver.s.ver_minor = dev->xdev->fw_version_minor;
+	fw_ver.s.ver_patch = dev->xdev->fw_version_patch;
+	fw_ver.s.ver_tweak = dev->xdev->fw_version_tweak;
+	props->fw_ver = fw_ver.data;
+
+	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
+		IB_DEVICE_PORT_ACTIVE_EVENT		|
+		IB_DEVICE_SYS_IMAGE_GUID		|
+		IB_DEVICE_RC_RNR_NAK_GEN;
+	props->kernel_cap_flags =  IBK_BLOCK_MULTICAST_LOOPBACK;
+	props->kernel_cap_flags |= IBK_LOCAL_DMA_LKEY;
+
+	flags = dev->xdev->caps.flags;
+	if (flags & XSC_DEV_CAP_FLAG_BAD_PKEY_CNTR)
+		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
+	if (flags & XSC_DEV_CAP_FLAG_BAD_QKEY_CNTR)
+		props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
+	if (flags & XSC_DEV_CAP_FLAG_APM)
+		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
+	props->page_size_cap	   = dev->xdev->caps.min_page_sz;
+	props->max_mr_size	   = xsc_get_max_mr_size(dev->xdev);
+	props->max_qp		   = dev->xdev->caps.max_qp;
+	props->max_qp_wr	   = xsc_get_max_qp_depth(dev->xdev);
+	max_rq_sg = dev->xdev->caps.max_rq_desc_sz / sizeof(struct xsc_wqe_data_seg);
+
+	props->max_send_sge = dev->xdev->caps.send_ds_num - XSC_CTRL_SEG_NUM -
+		XSC_RADDR_SEG_NUM;
+	props->max_recv_sge = dev->xdev->caps.recv_ds_num;
+	props->max_sge_rd	   = 1;/*max sge per read wqe*/
+	props->max_cq		   = dev->xdev->caps.max_cq;
+	props->max_cqe		   = dev->xdev->caps.max_cqes;
+	props->max_mr		   = (1 << dev->xdev->caps.log_max_mkey) - 1;
+	props->max_pd		   = dev->xdev->caps.max_pd;
+	props->max_qp_rd_atom	   = dev->xdev->caps.max_ra_res_qp;
+	props->max_qp_init_rd_atom = dev->xdev->caps.max_ra_req_qp;
+	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
+	props->max_srq		   =
+		dev->xdev->caps.log_max_srq ? (1 << dev->xdev->caps.log_max_srq) : 0;
+	props->max_srq_wr	   = dev->xdev->caps.max_srq_wqes - 1;
+	props->max_srq_sge	   = dev->xdev->caps.log_max_srq ? (max_rq_sg - 1) : 0;
+	props->local_ca_ack_delay  = dev->xdev->caps.local_ca_ack_delay;
+	props->atomic_cap	   = is_support_rdma_atomic(dev->xdev) ?
+		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
+	props->masked_atomic_cap   = IB_ATOMIC_HCA;
+	props->max_mcast_grp	   =
+		dev->xdev->caps.log_max_mcg ? (1 << dev->xdev->caps.log_max_mcg) : 0;
+	props->max_mcast_qp_attach = dev->xdev->caps.max_qp_mcg;
+	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
+					   props->max_mcast_grp;
+
+	props->sys_image_guid = dev->xdev->board_info->guid;
+	props->vendor_id = dev->xdev->pdev->vendor;
+	props->vendor_part_id = dev->xdev->pdev->device;
+	props->hw_ver = ((dev->xdev->chip_ver_l & 0xffff) << 16) |
+		(dev->xdev->hotfix_num & 0xffff);
+	props->max_pkeys = XSC_IB_MAX_PKEYS;
+	props->max_wq_type_rq = dev->xdev->caps.max_qp;
+	props->hca_core_clock = dev->xdev->caps.hca_core_clock * 1000; /* KHz */
+	props->rss_caps.max_rwq_indirection_tables =
+		dev->xdev->caps.max_rwq_indirection_tables;
+	props->rss_caps.max_rwq_indirection_table_size =
+		dev->xdev->caps.max_rwq_indirection_table_size;
+	props->rss_caps.supported_qpts = 1 << IB_QPT_RAW_PACKET;
+
+	/*response tso_caps extend param*/
+	if (offsetofend(typeof(resp), tso_caps) <= udata_outlen) {
+		max_tso = dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_max_tso) : 0;
+		if (max_tso) {
+			resp.tso_caps.max_tso = max_tso;
+			resp.tso_caps.supported_qpts |= 1 << IB_QPT_RAW_PACKET;
+			resp.response_length += sizeof(resp.tso_caps);
+		}
+	}
+
+	/*response rss_caps extend param*/
+	if (offsetofend(typeof(resp), rss_caps) <= udata_outlen) {
+		resp.rss_caps.rx_hash_function = XSC_RX_HASH_FUNC_TOEPLITZ;
+		resp.rss_caps.rx_hash_fields_mask =
+			XSC_RX_HASH_SRC_IPV4 |
+			XSC_RX_HASH_DST_IPV4 |
+			XSC_RX_HASH_SRC_IPV6 |
+			XSC_RX_HASH_DST_IPV6 |
+			XSC_RX_HASH_SRC_PORT_TCP |
+			XSC_RX_HASH_DST_PORT_TCP |
+			XSC_RX_HASH_SRC_PORT_UDP |
+			XSC_RX_HASH_DST_PORT_UDP |
+			XSC_RX_HASH_INNER;
+		resp.response_length += sizeof(resp.rss_caps);
+	}
+
+	/*response packet pacing caps*/
+	if (offsetofend(typeof(resp), packet_pacing_caps) <= udata_outlen) {
+		resp.packet_pacing_caps.qp_rate_limit_max =
+			dev->xdev->caps.qp_rate_limit_max;
+		resp.packet_pacing_caps.qp_rate_limit_min =
+			dev->xdev->caps.qp_rate_limit_min;
+		resp.packet_pacing_caps.supported_qpts |= 1 << IB_QPT_RAW_PACKET;
+
+		resp.response_length += sizeof(resp.packet_pacing_caps);
+	}
+
+	/*copy response data to user*/
+	if (udata_outlen) {
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err) {
+			ibdev_err(&dev->ib_dev, "copy response info to udata fail,err=%d\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static void xsc_calc_link_info(struct xsc_core_device *xdev,
+			       struct ib_port_attr *props)
+{
+	switch (xsc_get_link_speed(xdev)) {
+	case MODULE_SPEED_10G:
+		props->active_speed = XSC_RDMA_LINK_SPEED_10GB;
+		props->active_width = 1;
+		break;
+	case MODULE_SPEED_25G:
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+		props->active_width = 1;
+		break;
+	case MODULE_SPEED_40G_R4:
+		props->active_speed = XSC_RDMA_LINK_SPEED_10GB;
+		props->active_width = 2;
+		break;
+	case MODULE_SPEED_50G_R:
+		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
+		props->active_width = 1;
+		break;
+	case MODULE_SPEED_50G_R2:
+		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
+		props->active_width = 1;
+		break;
+	case MODULE_SPEED_100G_R2:
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+		props->active_width = 2;
+		break;
+	case MODULE_SPEED_100G_R4:
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+		props->active_width = 2;
+		break;
+	case MODULE_SPEED_200G_R4:
+		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
+		props->active_width = 2;
+		break;
+	case MODULE_SPEED_200G_R8:
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+		props->active_width = 4;
+		break;
+	case MODULE_SPEED_400G_R8:
+		props->active_speed = XSC_RDMA_LINK_SPEED_50GB;
+		props->active_width = 4;
+		break;
+	case MODULE_SPEED_400G_R4:
+		props->active_speed = XSC_RDMA_LINK_SPEED_100GB;
+		props->active_width = 2;
+		break;
+	default:
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+		props->active_width = 1;
+		break;
+	}
+}
+
+static enum rdma_link_layer xsc_ib_port_link_layer(struct ib_device *ibdev, u32 port)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+int xsc_ib_query_port(struct ib_device *ibdev, u32 port,
+		      struct ib_port_attr *props)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibdev);
+	struct net_device *ndev = dev->netdev;
+	struct xsc_core_device *xdev = dev->xdev;
+
+	if (port < 1 || port > xdev->caps.num_ports) {
+		ibdev_warn(&dev->ib_dev, "invalid port number %d\n", port);
+		return -EINVAL;
+	}
+
+	memset(props, 0, sizeof(*props));
+
+	if (netif_running(ndev) && netif_carrier_ok(ndev))
+		props->state = IB_PORT_ACTIVE;
+	else
+		props->state = IB_PORT_DOWN;
+
+	props->max_mtu = is_support_8k_mtu(xdev) ? IB_MTU_8192 : IB_MTU_4096;
+	props->active_mtu = min(props->max_mtu, xsc_net_to_ib_mtu(ndev->mtu));
+	props->gid_tbl_len = XSC_IB_GID_TBL_LEN;
+	props->port_cap_flags = IB_PORT_CM_SUP | IB_PORT_OTHER_LOCAL_CHANGES_SUP;
+	props->max_msg_sz = SZ_1G;
+	props->bad_pkey_cntr = 0;
+	props->qkey_viol_cntr = 0;
+	props->pkey_tbl_len = 1;
+	props->lid = 0;
+	props->sm_lid = 0;
+	props->lmc = 0;
+	props->max_vl_num = 0;
+	props->sm_sl = 0;
+	props->subnet_timeout = 0;
+	props->init_type_reply = 0;
+	if (!is_support_rdma(xdev)) {
+		props->active_width = 1;
+		props->active_speed = XSC_RDMA_LINK_SPEED_25GB;
+	} else {
+		xsc_calc_link_info(xdev, props);
+	}
+
+	props->phys_state = netif_carrier_ok(ndev) ? XSC_RDMA_PHY_STATE_LINK_UP :
+				XSC_RDMA_PHY_STATE_DISABLED;
+	return 0;
+}
+
+static int xsc_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
+			     u16 *pkey)
+{
+	*pkey = 0xffff;
+	return 0;
+}
+
+int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx,
+			  struct ib_udata *udata)
+{
+	struct ib_device *ibdev = uctx->device;
+	struct xsc_ib_dev *dev = to_xdev(ibdev);
+	struct xsc_ib_alloc_ucontext_req req;
+	struct xsc_ib_alloc_ucontext_resp resp;
+	int err;
+
+	if (!dev->ib_active)
+		return -EAGAIN;
+
+	err = ib_copy_from_udata(&req, udata, sizeof(req));
+	if (err)
+		return err;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.qp_tab_size      = dev->xdev->caps.max_qp;
+	resp.cache_line_size  = L1_CACHE_BYTES;
+	resp.max_sq_desc_sz = dev->xdev->caps.max_sq_desc_sz;
+	resp.max_rq_desc_sz = dev->xdev->caps.max_rq_desc_sz;
+	resp.max_send_wqebb = dev->xdev->caps.max_wqes;
+	resp.max_recv_wr = dev->xdev->caps.max_wqes;
+	xsc_get_db_addr(dev->xdev, &resp.qpm_tx_db, &resp.qpm_rx_db,
+			&resp.cqm_armdb, &resp.cqm_next_cid_reg, NULL);
+	resp.send_ds_num = dev->xdev->caps.send_ds_num;
+	resp.recv_ds_num = dev->xdev->caps.recv_ds_num;
+	resp.cmds_supp_uhw |= XSC_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
+	resp.device_id = dev->xdev->pdev->device;
+
+	if (req.abi_ver >= ALLOC_UCONTEXT_VER_V1) {
+		xsc_get_multidb_info(dev->xdev, &resp.multidb_num, &resp.tx_multidb_base);
+		resp.rdma_proto_mode = dev->xdev->rdma_proto_mode;
+	}
+
+	if (is_support_cqe64(dev->xdev))
+		resp.hw_feature_flag |= XSC_HW_FEATURE_FLAG_SUPPORT_CQE64;
+
+	resp.num_ports = dev->xdev->caps.num_ports;
+
+	return ib_copy_to_udata(udata, &resp, min_t(int, udata->outlen, sizeof(resp)));
+}
+
+void xsc_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
+{
+}
+
+static int xsc_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibcontext->device);
+	struct xsc_core_device *xdev = dev->xdev;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	resource_size_t reg_base;
+	resource_size_t reg_size = vma->vm_end - vma->vm_start;
+	u64 tx_db = 0;
+	u64 rx_db = 0;
+	u64 cq_db = 0;
+	u64 cq_reg = 0;
+
+	xsc_get_db_addr(xdev, &tx_db, &rx_db, &cq_db, &cq_reg, NULL);
+	dev_dbg(&xdev->pdev->dev, "offset:0x%lx\n", offset);
+
+	if (offset == (tx_db & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (tx_db & PAGE_MASK);
+	else if (offset == (rx_db & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (rx_db & PAGE_MASK);
+	else if (offset == (cq_reg & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_reg & PAGE_MASK);
+	else if (offset == (cq_db & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) + (cq_db & PAGE_MASK);
+	else if (offset == (QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) +
+			(QPM_TX_MDB_BASE_REG_ADDR & PAGE_MASK);
+	else if (offset == (xdev->caps.mdb_base & PAGE_MASK))
+		reg_base = pci_resource_start(xdev->pdev, xdev->bar_num) +
+			(xdev->caps.mdb_base & PAGE_MASK);
+	else
+		return -EINVAL;
+
+	dev_dbg(&xdev->pdev->dev, "regbase:0x%llx", reg_base);
+
+	reg_base = (xsc_core_is_pf(xdev) && !is_pf_bar_compressed(xdev)) ?
+		reg_base - 0xA0000000 : reg_base;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	return remap_pfn_range(vma, vma->vm_start, reg_base >> PAGE_SHIFT,
+			       reg_size, vma->vm_page_prot);
+}
+
+static int xsc_port_immutable(struct ib_device *ibdev, u32 port_num,
+			      struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
+				    RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE * 2;
+
+	return 0;
+}
+
+static struct net_device *xsc_get_netdev(struct ib_device *ibdev, u32 port_num)
+{
+	struct xsc_ib_dev *xsc_ib_dev = to_xdev(ibdev);
+	struct net_device *dev = xsc_ib_dev->netdev;
+
+	if (dev)
+		dev_hold(dev);
+
+	return dev;
+}
+
+static void xsc_get_guid(const u8 *dev_addr, u8 *guid)
+{
+	u8 mac[ETH_ALEN];
+
+	/* MAC-48 to EUI-64 mapping */
+	memcpy(mac, dev_addr, ETH_ALEN);
+	guid[0] = mac[0] ^ 2;
+	guid[1] = mac[1];
+	guid[2] = mac[2];
+	guid[3] = 0xff;
+	guid[4] = 0xfe;
+	guid[5] = mac[3];
+	guid[6] = mac[4];
+	guid[7] = mac[5];
+}
+
+static void init_node_data(struct xsc_ib_dev *dev)
+{
+	strscpy(dev->ib_dev.node_desc, "xsc_node_desc",
+		sizeof(dev->ib_dev.node_desc));
+	xsc_get_guid(dev->netdev->dev_addr, (u8 *)&dev->ib_dev.node_guid);
+}
+
+static void xsc_ib_event(struct xsc_core_device *dev, void *context,
+			 enum xsc_dev_event event, unsigned long data)
+{
+	struct xsc_ib_dev *ibdev = (struct xsc_ib_dev *)context;
+	struct ib_event ibev;
+	u8 port = 0;
+
+	switch (event) {
+	case XSC_DEV_EVENT_SYS_ERROR:
+		ibdev->ib_active = false;
+		ibev.event = IB_EVENT_DEVICE_FATAL;
+		break;
+
+	case XSC_DEV_EVENT_PORT_UP:
+		ibev.event = IB_EVENT_PORT_ACTIVE;
+		port = *(u8 *)data;
+		break;
+
+	case XSC_DEV_EVENT_PORT_DOWN:
+		ibev.event = IB_EVENT_PORT_ERR;
+		port = *(u8 *)data;
+		break;
+
+	case XSC_DEV_EVENT_PORT_INITIALIZED:
+		/* not used by ULPs */
+		return;
+
+	case XSC_DEV_EVENT_LID_CHANGE:
+		ibev.event = IB_EVENT_LID_CHANGE;
+		port = *(u8 *)data;
+		break;
+
+	case XSC_DEV_EVENT_PKEY_CHANGE:
+		ibev.event = IB_EVENT_PKEY_CHANGE;
+		port = *(u8 *)data;
+		break;
+
+	case XSC_DEV_EVENT_GUID_CHANGE:
+		ibev.event = IB_EVENT_GID_CHANGE;
+		port = *(u8 *)data;
+		break;
+
+	case XSC_DEV_EVENT_CLIENT_REREG:
+		ibev.event = IB_EVENT_CLIENT_REREGISTER;
+		port = *(u8 *)data;
+		break;
+	}
+
+	ibev.device	      = &ibdev->ib_dev;
+	ibev.element.port_num = port;
+
+	if (ibdev->ib_active)
+		ib_dispatch_event(&ibev);
+}
+
+static void xsc_ib_get_dev_fw_str(struct ib_device *ibdev, char *str)
+{
+	struct xsc_core_device *dev = to_xdev(ibdev)->xdev;
+	u8 ver_major = dev->fw_version_major;
+	u8 ver_minor = dev->fw_version_minor;
+	u16 ver_patch = dev->fw_version_patch;
+	u32 ver_tweak = dev->fw_version_tweak;
+
+	if (ver_tweak == 0) {
+		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u",
+			 ver_major,  ver_minor, ver_patch);
+	} else {
+		snprintf(str, IB_FW_VERSION_NAME_MAX, "v%u.%u.%u+%u",
+			 ver_major, ver_minor, ver_patch, ver_tweak);
+	}
+}
+
+static void xsc_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
+{
+}
+
+static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
+{
+	dev->ib_dev.ops.owner		= THIS_MODULE;
+	dev->ib_dev.ops.uverbs_abi_ver	= XSC_IB_UVERBS_ABI_VERSION;
+	dev->ib_dev.ops.driver_id = RDMA_DRIVER_XSC;
+	dev->ib_dev.ops.disassociate_ucontext = xsc_ib_disassociate_ucontext;
+	dev->ib_dev.ops.query_device	= xsc_ib_query_device;
+	dev->ib_dev.ops.query_port	= xsc_ib_query_port;
+	dev->ib_dev.ops.query_pkey	= xsc_ib_query_pkey;
+
+	dev->ib_dev.ops.alloc_ucontext	= xsc_ib_alloc_ucontext;
+	dev->ib_dev.ops.dealloc_ucontext = xsc_ib_dealloc_ucontext;
+	dev->ib_dev.ops.mmap		= xsc_ib_mmap;
+
+
+	dev->ib_dev.ops.get_link_layer	= xsc_ib_port_link_layer;
+	dev->ib_dev.ops.get_netdev		= xsc_get_netdev;
+
+
+	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
+
+	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
+
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ucontext, xsc_ib_ucontext, ibucontext);
+}
+
+static void xsc_get_port_state(struct net_device *ndev, enum xsc_dev_event *ev)
+{
+	*ev = XSC_DEV_EVENT_PORT_DOWN;
+	if (netif_running(ndev) && netif_carrier_ok(ndev))
+		*ev = XSC_DEV_EVENT_PORT_UP;
+}
+
+static int xsc_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct xsc_ib_dev *ibdev = container_of(this, struct xsc_ib_dev, nb);
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	enum xsc_dev_event ev;
+	u8 port = 1;
+
+	if (ndev != ibdev->netdev)
+		goto done;
+
+	ibdev_dbg(&ibdev->ib_dev, "netdev notfiy event:%ld\n", event);
+	switch (event) {
+	case NETDEV_CHANGE:
+	case NETDEV_UP:
+	case NETDEV_DOWN:
+		xsc_get_port_state(ibdev->netdev, &ev);
+		xsc_ib_event(ibdev->xdev, ibdev, ev, (unsigned long)&port);
+		break;
+	default:
+		break;
+	}
+done:
+	return NOTIFY_DONE;
+}
+
+static int xsc_register_netdev_notifier(struct xsc_ib_dev *ibdev)
+{
+	ibdev->nb.notifier_call = xsc_netdev_event;
+	return register_netdevice_notifier(&ibdev->nb);
+}
+
+static int xsc_unregister_netdev_notifier(struct xsc_ib_dev *ibdev)
+{
+	return unregister_netdevice_notifier(&ibdev->nb);
+}
+
+static int init_one(struct xsc_core_device *xdev,
+		    struct xsc_ib_dev **ibdev)
+{
+	struct xsc_ib_dev *dev;
+	int err;
+
+	dev = (struct xsc_ib_dev *)ib_alloc_device(xsc_ib_dev, ib_dev);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->xdev = xdev;
+	dev->netdev = xdev->netdev;
+	strscpy(dev->ib_dev.name, "xscale_%d", IB_DEVICE_NAME_MAX);
+
+	memcpy(dev->xdev->priv.ibdev_name, dev->ib_dev.name, IB_DEVICE_NAME_MAX);
+
+	if (!xdev->caps.msix_enable)
+		dev->num_comp_vectors = 1;
+	else
+		dev->num_comp_vectors = xdev->dev_res->eq_table.num_comp_vectors;
+
+	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
+	dev->ib_dev.local_dma_lkey	= 0xFF;
+	dev->num_ports		= xdev->caps.num_ports;
+	dev->ib_dev.phys_port_cnt     = dev->num_ports;
+	dev->ib_dev.num_comp_vectors	= dev->num_comp_vectors;
+	dev->ib_dev.dev.parent = &xdev->pdev->dev;
+	xsc_ib_dev_setting(dev);
+	dev->xdev->priv.cm_dscp = DSCP_PCP_UNSET;
+	dev->xdev->priv.cm_pcp = DSCP_PCP_UNSET;
+	dev->xdev->priv.force_pcp = DSCP_PCP_UNSET;
+	dev->xdev->priv.force_dscp = DSCP_PCP_UNSET;
+	dev->xdev->rdma_proto_mode = RDMA_PROTO_ROCEV2;
+	dev->xdev->cm_udp_dst_port = ROCE_V2_UDP_DPORT;
+	dev->xdev->veroce_udp_dst_port = VEROCE_UDP_DPORT;
+
+	dev->ib_dev.uverbs_cmd_mask	=
+		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
+		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
+		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_AH)		|
+		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_REREG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
+		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
+		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)	|
+		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)	|
+		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+
+	init_node_data(dev);
+
+
+
+
+	err = ib_register_device(&dev->ib_dev, dev->ib_dev.name,
+				 dev->xdev->device);
+	if (err)
+		goto err_free;
+
+	rdma_roce_rescan_device(&dev->ib_dev);
+	dev->ib_active = true;
+	*ibdev = dev;
+
+	xsc_register_netdev_notifier(dev);
+
+
+
+	return 0;
+
+err_free:
+	ib_dealloc_device((struct ib_device *)dev);
+
+	return err;
+}
+
+static void remove_one(struct xsc_core_device *xdev, void *intf_ctx)
+{
+	struct xsc_ib_dev *dev = (struct xsc_ib_dev *)intf_ctx;
+
+	xsc_unregister_netdev_notifier(dev);
+	ib_unregister_device(&dev->ib_dev);
+	ib_dealloc_device(&dev->ib_dev);
+}
+
+static void init_iommu_state(struct xsc_ib_dev *dev)
+{
+	struct iommu_domain *domain;
+
+	dev->iommu_state = XSC_IB_IOMMU_MAP_DISABLE;
+	domain = iommu_get_domain_for_dev(dev->ib_dev.dma_device);
+	if (domain) {
+		if (domain->type & __IOMMU_DOMAIN_DMA_API)
+			dev->iommu_state = XSC_IB_IOMMU_MAP_NORMAL;
+	} else {
+		/* Try to allocate DMA memory; if the DMA address differs from
+		 * the physical address, an IOMMU maps it through an unknown
+		 * domain.
+		 */
+		dma_addr_t dma_addr;
+		void *tmp;
+
+		tmp = dma_alloc_coherent(dev->ib_dev.dma_device, PAGE_SIZE,
+					 &dma_addr, GFP_KERNEL);
+		if (tmp) {
+			if (virt_to_phys(tmp) != dma_addr)
+				dev->iommu_state = XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN;
+			dma_free_coherent(dev->ib_dev.dma_device, PAGE_SIZE,
+					  tmp, dma_addr);
+		}
+	}
+
+	ibdev_dbg(&dev->ib_dev, "iommu dma map state=%d\n", dev->iommu_state);
+}
+
+static int xsc_ib_probe(struct auxiliary_device *adev,
+			const struct auxiliary_device_id *adev_id)
+{
+	struct xsc_adev *xsc_adev = container_of(adev, struct xsc_adev, adev);
+	struct xsc_core_device *xdev = xsc_adev->xdev;
+	struct xsc_ib_dev *ibdev = NULL;
+	int ret;
+
+	ret = init_one(xdev, &ibdev);
+	if (ret) {
+		dev_err(&adev->dev, "failed to add RDMA device, ret = %d\n",
+			ret);
+		return ret;
+	}
+
+	init_iommu_state(ibdev);
+	auxiliary_set_drvdata(adev, ibdev);
+
+	return 0;
+}
+
+static void xsc_ib_remove(struct auxiliary_device *adev)
+{
+	struct xsc_ib_dev *ibdev = auxiliary_get_drvdata(adev);
+
+	if (!ibdev)
+		return;
+
+	remove_one(ibdev->xdev, ibdev);
+}
+
+static const struct auxiliary_device_id xsc_ib_id_table[] = {
+	{ .name = XSC_PCI_DRV_NAME "." XSC_IB_ADEV_NAME },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, xsc_ib_id_table);
+
+static struct auxiliary_driver xsc_ib_driver = {
+	.name = XSC_IB_ADEV_NAME,
+	.probe = xsc_ib_probe,
+	.remove = xsc_ib_remove,
+	.id_table = xsc_ib_id_table,
+};
+
+static int xsc_ib_reboot_event_handler(struct notifier_block *nb, unsigned long action, void *data)
+{
+	pr_info("xsc ib driver recv %lu event\n", action);
+
+	xsc_remove_rdma_driver();
+
+	return NOTIFY_OK;
+}
+
+struct notifier_block xsc_ib_nb = {
+	.notifier_call = xsc_ib_reboot_event_handler,
+	.next = NULL,
+	.priority = 2,
+};
+
+void xsc_remove_rdma_driver(void)
+{
+	auxiliary_driver_unregister(&xsc_ib_driver);
+}
+
+static int __init xsc_ib_init(void)
+{
+	int ret;
+
+	ret = auxiliary_driver_register(&xsc_ib_driver);
+	if (ret) {
+		pr_err("failed to register auxiliary driver\n");
+		return ret;
+	}
+
+	register_reboot_notifier(&xsc_ib_nb);
+
+	return 0;
+}
+
+static void __exit xsc_ib_cleanup(void)
+{
+	unregister_reboot_notifier(&xsc_ib_nb);
+	xsc_remove_rdma_driver();
+}
+
+module_init(xsc_ib_init);
+module_exit(xsc_ib_cleanup);
diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/xsc/xsc_ib.h
new file mode 100644
index 000000000..a2ae382e2
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/xsc_ib.h
@@ -0,0 +1,542 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_IB_H
+#define XSC_IB_H
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_pack.h>
+#include <rdma/ib_mad.h>
+#include "common/xsc_core.h"
+#include "common/driver.h"
+#include "common/cq.h"
+#include "common/srq.h"
+#include "common/qp.h"
+#include <linux/types.h>
+#include <linux/iommu.h>
+#include <linux/dma-direct.h>
+#include <linux/dma-mapping.h>
+#include <crypto/hash.h>
+#include <rdma/uverbs_ioctl.h>
+
+#define	XSC_PAGE_SHIFT_4K	12
+#define	XSC_PAGE_SHIFT_64K	16
+#define	XSC_PAGE_SHIFT_2M	21
+#define	XSC_PAGE_SHIFT_1G	30
+#define XSC_PAGE_SZ_4K		BIT(XSC_PAGE_SHIFT_4K)
+#define XSC_PAGE_SZ_64K		BIT(XSC_PAGE_SHIFT_64K)
+#define XSC_PAGE_SZ_2M		BIT(XSC_PAGE_SHIFT_2M)
+#define XSC_PAGE_SZ_1G		BIT(XSC_PAGE_SHIFT_1G)
+#define XSC_MR_PAGE_CAP_MASK	(XSC_PAGE_SZ_4K |	\
+				XSC_PAGE_SZ_64K |	\
+				XSC_PAGE_SZ_2M |	\
+				XSC_PAGE_SZ_1G)
+
+
+struct xsc_ib_ucontext {
+	struct ib_ucontext	ibucontext;
+};
+
+struct xsc_ib_pd {
+	struct ib_pd		ibpd;
+	u32			pdn;
+	u32			pa_lkey;
+};
+
+struct wr_list {
+	u16	opcode;
+	u16	next;
+};
+
+struct xsc_ib_wq {
+	u64		       *wrid;
+	u32		       *wr_data;
+	struct wr_list	       *w_list;
+	unsigned long	       *wqe_head;
+
+	/* serialize post to the work queue
+	 */
+	spinlock_t		lock;
+	int			wqe_cnt;
+	int			ds_cnt;
+	int			max_post;
+	int			max_gs;
+	int			offset;
+	int			wqe_shift;
+	unsigned int		head;
+	unsigned int		tail;
+	u32			cur_post;
+	u32			last_poll;
+	void		       *qend;
+	void		*hdr_buf;
+	u32			hdr_size;
+	dma_addr_t	hdr_dma;
+	int			mad_queue_depth;
+	int			mad_index;
+	u32			*wr_opcode;
+	u32			*need_flush;
+	atomic_t	flush_wqe_cnt;
+	int			*prev_ce_wqe;
+	int			last_comp_ce_wqe;
+	int			last_post_ce_wqe;
+};
+
+enum {
+	XSC_QP_USER,
+	XSC_QP_KERNEL,
+};
+
+struct xsc_ib_qp {
+	struct ib_qp		ibqp;
+	struct xsc_core_qp	xqp;
+	struct xsc_buf		buf;
+
+	struct xsc_ib_wq	rq;
+
+	u32			doorbell_qpn;
+	u8			sq_signal_bits;
+	struct xsc_ib_wq	sq;
+
+	struct ib_umem	       *umem;
+	int			buf_size;
+
+	/* serialize qp state modifications
+	 */
+	struct mutex		mutex;
+	u32			flags;
+	u8			port;
+	u8			alt_port;
+	u8			atomic_rd_en;
+	u8			resp_depth;
+	u8			state;
+	int			max_inline_data;
+	int			has_rq;
+
+	int			create_type;
+	u32			pa_lkey;
+	/* For QP1 */
+	struct ib_ud_header	qp1_hdr;
+	u32			send_psn;
+	struct xsc_qp_context	ctx;
+	struct ib_cq		*send_cq;
+	struct ib_cq		*recv_cq;
+	/* For qp resources */
+	spinlock_t		lock;
+
+	struct list_head	cq_recv_list;
+	struct list_head	cq_send_list;
+	bool		post_send_invalid;
+	bool		post_recv_invalid;
+	struct ib_recv_wr *srq_head_wr;
+	struct ib_recv_wr *srq_tail_wr;
+	bool has_trig_cq_comp_handle;
+};
+
+struct xsc_ib_cq_buf {
+	struct xsc_buf		buf;
+	struct ib_umem		*umem;
+	int			cqe_size;
+};
+
+enum xsc_ib_qp_flags {
+	XSC_IB_QP_BLOCK_MULTICAST_LOOPBACK     = 1 << 0,
+	XSC_IB_QP_SIGNATURE_HANDLING           = 1 << 1,
+};
+
+struct xsc_ib_cq {
+	struct ib_cq		ibcq;
+	struct xsc_core_cq	xcq;
+	struct xsc_ib_cq_buf	buf;
+
+	/* serialize access to the CQ
+	 */
+	spinlock_t		lock;
+
+	/* protect resize cq
+	 */
+	struct mutex		resize_mutex;
+	struct xsc_ib_cq_resize *resize_buf;
+	struct ib_umem	       *resize_umem;
+	int			cqe_size;
+	struct list_head	send_qp_list;
+	struct list_head	recv_qp_list;
+	struct list_head	err_state_qp_list;
+	u32			create_flags;
+	int			invalid;
+};
+
+enum xsc_srq_wr_per_qp {
+	XSC_SRQ_MIN_WR_NUM = 32,
+	XSC_SRQ_MAX_WR_NUM = 128,
+};
+
+enum {
+	XSC_SRQ_USER,
+	XSC_SRQ_KERNEL,
+};
+
+struct xsc_ib_srq {
+	struct ib_srq		ibsrq;
+	struct xsc_core_srq	xsrq;
+	u64		       *wrid;
+	/* protect SRQ hanlding
+	 */
+	spinlock_t		lock;
+	int			head;
+	int			tail;
+	struct ib_umem	       *umem;
+	/* serialize arming a SRQ
+	 */
+	struct mutex		mutex;
+	int			qp_num;
+	int			create_type;
+};
+
+void xsc_restore_cache_srq_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp);
+void xsc_free_one_cache_srq_wr(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp, u64 wr_id);
+void xsc_free_all_cache_wrs(struct ib_recv_wr *wr);
+void xsc_post_cache_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp, int wr_num, bool init);
+
+struct xsc_ib_mr {
+	struct ib_mr		ibmr;
+	struct xsc_core_mr	xmr;
+	struct ib_umem	       *umem;
+	int			npages;
+};
+
+#define MAX_OPCODE	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD
+
+struct xsc_ib_dev {
+	struct ib_device		ib_dev;
+	struct net_device	*netdev;
+	struct xsc_core_device *xdev;
+	int				num_ports;
+	int				num_comp_vectors;
+	u8				ib_active;
+	u32				crc_32_table[256];
+	int iommu_state;
+	struct notifier_block nb;
+	u32				opcode_map[MAX_OPCODE + 1];
+};
+
+union xsc_ib_fw_ver {
+	u64 data;
+	struct {
+		u8	ver_major;
+		u8	ver_minor;
+		u16	ver_patch;
+		u32	ver_tweak;
+	} s;
+};
+
+struct xsc_err_state_qp_node {
+	struct list_head	entry;
+	u32					qp_id;
+	bool				is_sq;
+};
+
+struct xsc_ib_ah {
+	struct ib_ah		ibah;
+	struct xsc_av		av;
+};
+
+/*
+ * Conversion helpers.
+ *
+ * The first group goes from a uverbs object to the private structure that
+ * embeds it; the second goes from the core object to the private structure
+ * that embeds that one.  Both directions exist for cq, qp and srq, so the
+ * names spell out which object is being converted.
+ */
+static inline struct xsc_ib_dev *to_xdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct xsc_ib_dev, ib_dev);
+}
+
+static inline struct xsc_ib_pd *to_xpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct xsc_ib_pd, ibpd);
+}
+
+static inline struct xsc_ib_mr *to_xmr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct xsc_ib_mr, ibmr);
+}
+
+static inline struct xsc_ib_ah *to_xah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct xsc_ib_ah, ibah);
+}
+
+static inline struct xsc_ib_cq *to_xcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct xsc_ib_cq, ibcq);
+}
+
+static inline struct xsc_ib_qp *to_xqp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct xsc_ib_qp, ibqp);
+}
+
+static inline struct xsc_ib_srq *to_xsrq(struct ib_srq *ibsrq)
+{
+	return container_of(ibsrq, struct xsc_ib_srq, ibsrq);
+}
+
+static inline struct xsc_ib_cq *core_to_xcq(struct xsc_core_cq *xcq)
+{
+	return container_of(xcq, struct xsc_ib_cq, xcq);
+}
+
+static inline struct xsc_ib_qp *core_to_xqp(struct xsc_core_qp *xqp)
+{
+	return container_of(xqp, struct xsc_ib_qp, xqp);
+}
+
+static inline struct xsc_ib_srq *core_to_xsrq(struct xsc_core_srq *xsrq)
+{
+	return container_of(xsrq, struct xsc_ib_srq, xsrq);
+}
+
+void build_opcode_map(struct xsc_ib_dev *dev);
+
+int xsc_ib_create_ah(struct ib_ah *ibah,
+		     struct rdma_ah_init_attr *init_attr,
+		     struct ib_udata *udata);
+int xsc_ib_destroy_ah(struct ib_ah *ibah, u32 flags);
+int xsc_ib_create_cq(struct ib_cq *ibcq,
+		     const struct ib_cq_init_attr *attr,
+		     struct uverbs_attr_bundle *attrs);
+int xsc_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int xsc_ib_destroy_qp(struct ib_qp *qp, struct ib_udata *udata);
+int xsc_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
+int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
+void xsc_ib_dealloc_ucontext(struct ib_ucontext *ibcontext);
+int xsc_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
+int xsc_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
+
+int xsc_ib_create_srq(struct ib_srq *ib_srq,
+		      struct ib_srq_init_attr *init_attr,
+		      struct ib_udata *udata);
+int xsc_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		      enum ib_srq_attr_mask attr_mask, struct ib_udata *udata);
+int xsc_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr);
+int xsc_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
+			 const struct ib_recv_wr **bad_wr);
+int xsc_ib_destroy_srq(struct ib_srq *srq, struct ib_udata *udata);
+
+int xsc_ib_query_port(struct ib_device *ibdev, u32 port,
+		      struct ib_port_attr *props);
+
+int xsc_ib_create_qp(struct ib_qp *ibqp,
+		     struct ib_qp_init_attr *init_attr,
+		     struct ib_udata *udata);
+
+void __xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 qpn);
+void xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 qpn);
+
+int xsc_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
+int xsc_ib_err_state_qp(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp,
+			enum xsc_qp_state cur_state, enum xsc_qp_state state);
+int xsc_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_udata *udata);
+int xsc_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
+		    struct ib_qp_init_attr *qp_init_attr);
+
+int xsc_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
+		     const struct ib_send_wr **bad_wr);
+int xsc_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
+		     const struct ib_recv_wr **bad_wr);
+
+void *xsc_get_send_wqe(struct xsc_ib_qp *qp, int n);
+int xsc_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int xsc_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
+struct ib_mr *xsc_ib_get_dma_mr(struct ib_pd *pd, int acc);
+struct ib_mr *xsc_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				 u64 virt_addr, int access_flags,
+				 struct ib_dmah *dmah,
+				 struct ib_udata *udata);
+int xsc_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset);
+void xsc_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
+		       int *ncont);
+void xsc_ib_populate_pas(struct xsc_ib_dev *dev, struct ib_umem *umem,
+			 int page_shift, __be64 *pas, int npages, bool need_to_devide);
+struct ib_mr *xsc_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
+					u64 length, u64 virt_addr,
+					int fd, int access_flags,
+					struct ib_dmah *dmah,
+					struct uverbs_attr_bundle *attrs);
+
+void xsc_ib_drain_rq(struct ib_qp *qp);
+void xsc_ib_drain_sq(struct ib_qp *qp);
+
+static inline u8 convert_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_ATOMIC ? XSC_PERM_ATOMIC       : 0) |
+	       (acc & IB_ACCESS_REMOTE_WRITE  ? XSC_PERM_REMOTE_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ   ? XSC_PERM_REMOTE_READ  : 0) |
+	       (acc & IB_ACCESS_LOCAL_WRITE   ? XSC_PERM_LOCAL_WRITE  : 0) |
+	       XSC_PERM_LOCAL_READ;
+}
+
+#define IB_MTU_8192	6
+
+static inline enum ib_mtu xsc_net_to_ib_mtu(unsigned int mtu)
+{
+	mtu = mtu - (IB_GRH_BYTES + IB_UDP_BYTES + IB_BTH_BYTES +
+		     IB_EXT_XRC_BYTES + IB_EXT_ATOMICETH_BYTES +
+		     IB_ICRC_BYTES);
+	if (mtu >= 8192)
+		return IB_MTU_8192;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
+		return IB_MTU_4096;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_1024))
+		return IB_MTU_1024;
+	else
+		return 0;
+}
+
+#define XSC_IB_IOMMU_MAP_DISABLE 0
+#define XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN 1
+#define XSC_IB_IOMMU_MAP_NORMAL 2
+
+static inline int xsc_ib_iommu_dma_map(struct ib_device *ibdev)
+{
+	return to_xdev(ibdev)->iommu_state;
+}
+
+static inline void *xsc_ib_iova_to_virt(struct ib_device *ibdev, dma_addr_t iova)
+{
+	phys_addr_t phyaddr;
+	struct iommu_domain *domain;
+
+	domain = iommu_get_domain_for_dev(ibdev->dma_device);
+	if (likely(domain)) {
+		phyaddr = iommu_iova_to_phys(domain, iova);
+		phyaddr |= iova & (PAGE_SIZE - 1);
+	} else {
+		phyaddr = dma_to_phys(ibdev->dma_device, iova);
+	}
+
+	return phys_to_virt(phyaddr);
+}
+
+struct ib_mad_list_head {
+	struct list_head list;
+	struct ib_cqe cqe;
+	struct ib_mad_queue *mad_queue;
+};
+
+#define IB_MAD_SEND_REQ_MAX_SG 2
+struct ib_mad_send_wr_private {
+	struct ib_mad_list_head mad_list;
+	struct list_head agent_list;
+	struct ib_mad_agent_private *mad_agent_priv;
+	struct ib_mad_send_buf send_buf;
+	u64 header_mapping;
+	u64 payload_mapping;
+	struct ib_ud_wr send_wr;
+	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
+	__be64 tid;
+	unsigned long timeout;
+	int max_retries;
+	int retries_left;
+	int retry;
+	int refcount;
+	enum ib_wc_status status;
+
+	/* RMPP control */
+	struct list_head rmpp_list;
+	struct ib_rmpp_segment *last_ack_seg;
+	struct ib_rmpp_segment *cur_seg;
+	int last_ack;
+	int seg_num;
+	int newwin;
+	int pad;
+};
+
+struct ib_mad_private_header {
+	struct ib_mad_list_head mad_list;
+	struct ib_mad_recv_wc recv_wc;
+	struct ib_wc wc;
+	u64 mapping;
+} __packed;
+
+struct ib_mad_private {
+	struct ib_mad_private_header header;
+	size_t mad_size;
+	struct ib_grh grh;
+	DECLARE_FLEX_ARRAY(u8, mad);
+} __packed;
+
+static inline void *xsc_ib_send_mad_sg_virt_addr(struct ib_device *ibdev,
+						 const struct ib_send_wr *wr,
+						 int sg)
+{
+	struct ib_mad_send_wr_private *mad_send_wr;
+	struct ib_mad_list_head *mad_list;
+	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
+
+	/* direct dma mapping */
+	if (!iommu_state)
+		return phys_to_virt(dma_to_phys(ibdev->dma_device, wr->sg_list[sg].addr));
+
+	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
+		return xsc_ib_iova_to_virt(ibdev, wr->sg_list[sg].addr);
+
+	mad_list = container_of(wr->wr_cqe, struct ib_mad_list_head, cqe);
+	mad_send_wr = container_of(mad_list, struct ib_mad_send_wr_private,
+				   mad_list);
+
+	/* sg_list[0] */
+	if (sg == 0)
+		return mad_send_wr->send_buf.mad;
+
+	/* sg_list[1] */
+	if (mad_send_wr->send_buf.seg_count)
+		return ib_get_rmpp_segment(&mad_send_wr->send_buf,
+					   mad_send_wr->seg_num);
+	return mad_send_wr->send_buf.mad + mad_send_wr->send_buf.hdr_len;
+}
+
+static inline void *xsc_ib_recv_mad_sg_virt_addr(struct ib_device *ibdev,
+						 struct ib_wc *wc,
+						 u64 sg_addr)
+{
+	struct ib_mad_private_header *mad_priv_hdr;
+	struct ib_mad_private *recv;
+	struct ib_mad_list_head *mad_list;
+	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
+
+	/* direct dma mapping */
+	if (!iommu_state)
+		return phys_to_virt(dma_to_phys(ibdev->dma_device, sg_addr));
+
+	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
+		return xsc_ib_iova_to_virt(ibdev, sg_addr);
+
+	mad_list = container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
+	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header, mad_list);
+	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
+	return &recv->grh;
+}
+
+struct xsc_ib_burst_info {
+	__u32       max_burst_sz;
+	__u16       typical_pkt_sz;
+	__u16       reserved;
+};
+
+struct xsc_ib_modify_qp {
+	__u32		reserved;
+	struct xsc_ib_burst_info  burst_info;
+	__u32		profile;
+};
+
+#endif /* XSC_IB_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/cq.h b/drivers/net/ethernet/yunsilicon/xsc/common/cq.h
new file mode 100644
index 000000000..5217000c5
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/cq.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_CORE_CQ_H
+#define XSC_CORE_CQ_H
+
+#include "common/xsc_core.h"
+
+enum {
+	XSC_CQE_OWNER_MASK	= 1,
+};
+
+enum {
+	CQE_SIZE_64 = 0,
+	CQE_SIZE_128 = 1,
+};
+
+enum {
+	XSC_CQ_DB_REQ_NOT_SOL		= 1,
+	XSC_CQ_DB_REQ_NOT		= 0,
+};
+
+void xsc_init_cq_table(struct xsc_core_device *xdev);
+int xsc_core_create_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq,
+		       struct xsc_create_cq_ex_mbox_in *in, int inlen);
+int xsc_core_destroy_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq);
+
+#endif /* XSC_CORE_CQ_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
new file mode 100644
index 000000000..b3e91c868
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_DRIVER_H
+#define XSC_DRIVER_H
+
+#include <linux/kernel.h>
+#include <linux/completion.h>
+#include <linux/pci.h>
+#include <linux/spinlock_types.h>
+#include <linux/semaphore.h>
+#include <linux/vmalloc.h>
+#include <linux/radix-tree.h>
+#include <rdma/ib_verbs.h>
+
+#include "common/xsc_device.h"
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "common/xsc_cmd.h"
+#include "common/xsc_hsi.h"
+#include "common/srq.h"
+
+struct rxe_bth {
+	u8			opcode;
+	u8			flags;
+	__be16			pkey;
+	__be32			qpn;
+	__be32			apsn;
+};
+
+struct rxe_deth {
+	__be32			qkey;
+	__be32			src_qp;
+};
+
+static inline void *xsc_vzalloc(unsigned long size)
+{
+	void *rtn;
+
+	rtn = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!rtn)
+		rtn = vzalloc(size);
+	return rtn;
+}
+
+static inline void xsc_vfree(const void *addr)
+{
+	if (addr && is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+
+int xsc_buf_alloc(struct xsc_core_device *xdev, unsigned long size,
+		  unsigned long max_direct, struct xsc_buf *buf);
+void xsc_buf_free(struct xsc_core_device *xdev, struct xsc_buf *buf);
+void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages);
+
+int xsc_core_create_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+int xsc_core_destroy_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+int xsc_core_register_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr,
+			 struct xsc_register_mr_mbox_in *in, int inlen);
+int xsc_core_dereg_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+void xsc_reg_local_dma_mr(struct xsc_core_device *xdev);
+
+int xsc_core_alloc_pd(struct xsc_core_device *xdev, u32 *pdn);
+int xsc_core_dealloc_pd(struct xsc_core_device *xdev, u32 pdn);
+
+int xsc_core_create_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq);
+int xsc_core_destroy_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq);
+
+int xsc_core_create_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq,
+		       struct xsc_create_cq_ex_mbox_in *in, int inlen);
+int xsc_core_destroy_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq);
+
+int xsc_core_create_qp(struct xsc_core_device *xdev,
+		       struct xsc_core_qp *qp,
+		       struct xsc_create_qp_mbox_in *in,
+		       int inlen);
+int xsc_core_destroy_qp(struct xsc_core_device *xdev,
+			struct xsc_core_qp *qp);
+int xsc_core_qp_modify(struct xsc_core_device *xdev, enum xsc_qp_state cur_state,
+		       enum xsc_qp_state new_state,
+		       struct xsc_modify_qp_mbox_in *in, int sqd_event,
+		       struct xsc_core_qp *qp);
+int xsc_core_qp_query(struct xsc_core_device *xdev, struct xsc_core_qp *qp,
+		      struct xsc_query_qp_mbox_out *out, int outlen);
+void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type);
+
+int xsc_vector2eqn(struct xsc_core_device *xdev, int vector, int *eqn,
+		   unsigned int *irqn);
+
+#endif /* XSC_DRIVER_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/qp.h b/drivers/net/ethernet/yunsilicon/xsc/common/qp.h
new file mode 100644
index 000000000..4855c97e4
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/qp.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_QP_H
+#define XSC_QP_H
+
+#include <linux/radix-tree.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "common/xsc_hsi.h"
+
+enum {
+	XSC_QP_PM_MIGRATED		= 0x3,
+	XSC_QP_PM_ARMED			= 0x0,
+	XSC_QP_PM_REARM			= 0x1
+};
+
+enum {
+	XSC_WQE_CTRL_CQ_UPDATE		= 2 << 2,
+	XSC_WQE_CTRL_SOLICITED		= 1 << 1,
+};
+
+struct xsc_av {
+	union {
+		struct {
+			__be32	qkey;
+			__be32	reserved;
+		} qkey;
+		__be64	dc_key;
+	} key;
+	__be32	dqp_dct;
+	u8	stat_rate_sl;
+	u8	fl_mlid;
+	union {
+		__be16	rlid;
+		__be16  udp_sport;
+	};
+	u8	reserved0[4];
+	u8	rmac[6];
+	u8	tclass;
+	u8	hop_limit;
+	__be32	grh_gid_fl;
+	u8	rgid[16];
+};
+
+struct xsc_qp_path {
+	u8			fl;
+	u8			rsvd3;
+	u8			free_ar;
+	u8			pkey_index;
+	u8			rsvd0;
+	u8			grh_mlid;
+	__be16			rlid;
+	u8			ackto_lt;
+	u8			mgid_index;
+	u8			static_rate;
+	u8			hop_limit;
+	__be32			tclass_flowlabel;
+	u8			rgid[16];
+	u8			rsvd1[4];
+	u8			sl;
+	u8			port;
+	u8			rsvd2[6];
+	u8			dmac[6];
+	u8			smac[6];
+	__be16		af_type;
+	__be32		sip[4];
+	__be32		dip[4];
+	__be16			sport;
+	u8			ecn_dscp;
+	u8			vlan_valid;
+	__be16			vlan_id;
+	u8			dci_cfi_prio_sl; /* not left moved yet. */
+};
+
+static inline struct xsc_core_qp *__xsc_qp_lookup(struct xsc_core_device *xdev, u32 qpn)
+{
+	return radix_tree_lookup(&xdev->dev_res->qp_table.tree, qpn);
+}
+
+int xsc_core_create_resource_common(struct xsc_core_device *xdev,
+				    struct xsc_core_qp *qp);
+void xsc_core_destroy_resource_common(struct xsc_core_device *xdev,
+				      struct xsc_core_qp *qp);
+void xsc_init_qp_table(struct xsc_core_device *xdev);
+void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type);
+
+int xsc_core_create_qp(struct xsc_core_device *xdev,
+		       struct xsc_core_qp *qp,
+		       struct xsc_create_qp_mbox_in *in,
+		       int inlen);
+int xsc_core_destroy_qp(struct xsc_core_device *xdev,
+			struct xsc_core_qp *qp);
+int xsc_core_qp_modify(struct xsc_core_device *xdev, enum xsc_qp_state cur_state,
+		       enum xsc_qp_state new_state,
+		       struct xsc_modify_qp_mbox_in *in, int sqd_event,
+		       struct xsc_core_qp *qp);
+int xsc_core_qp_query(struct xsc_core_device *xdev, struct xsc_core_qp *qp,
+		      struct xsc_query_qp_mbox_out *out, int outlen);
+
+#endif /* XSC_QP_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/srq.h b/drivers/net/ethernet/yunsilicon/xsc/common/srq.h
new file mode 100644
index 000000000..0a2e660e1
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/srq.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_SRQ_H
+#define XSC_SRQ_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include "common/xsc_core.h"
+
+struct ib_qp;
+struct ib_recv_wr;
+
+#define XSC_MAX_SRQ_NUM 8192
+#define XSC_MAX_SRQ_LOG_SIZE 13
+
+struct xsc_srq_qp_node {
+	struct list_head	entry;
+	u32			qp_id;
+	struct ib_qp		*ibqp;
+};
+
+struct xsc_srq_cache_wr {
+	int wr_num;
+	int max_wr_num;
+	struct ib_recv_wr *head_wr;
+	struct ib_recv_wr *tail_wr;
+};
+
+struct xsc_core_srq {
+	u32 srqn;
+	int max;
+	size_t max_gs;
+	size_t max_avail_gather;
+	int wqe_shift;
+	void (*event)(struct xsc_core_srq *srq, enum xsc_event e);
+
+	/* protect ctrl list */
+	spinlock_t		lock;
+	struct list_head	ctrl_list;
+	u16 uid;
+
+	struct list_head	srq_qp_list;
+	struct xsc_srq_cache_wr *cache_wr;
+};
+
+int xsc_core_create_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq);
+int xsc_core_destroy_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq);
+
+#endif /* XSC_SRQ_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index b01fca3ac..87481db3f 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o link.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/link.c b/drivers/net/ethernet/yunsilicon/xsc/pci/link.c
new file mode 100644
index 000000000..b991eddae
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/link.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+
+int xsc_get_link_speed(struct xsc_core_device *xdev)
+{
+	struct xsc_event_query_linkinfo_mbox_out out;
+	struct xsc_event_linkinfo linkinfo;
+	struct xsc_inbox_hdr in;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_LINK_INFO);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err || out.hdr.status) {
+		pci_err(xdev->pdev, "failed to get link info, err=%d, status=%d\n",
+			err, out.hdr.status);
+		return MODULE_SPEED_25G;
+	}
+
+	linkinfo = out.ctx;
+	linkinfo.linkspeed = be32_to_cpu(linkinfo.linkspeed);
+
+	return linkinfo.linkspeed;
+}
+EXPORT_SYMBOL_GPL(xsc_get_link_speed);
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 21f86cc7b..53fc99057 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -257,6 +257,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_ERDMA,
 	RDMA_DRIVER_MANA,
 	RDMA_DRIVER_IONIC,
+	RDMA_DRIVER_XSC,
 };
 
 enum ib_uverbs_gid_type {
diff --git a/include/uapi/rdma/xsc-abi.h b/include/uapi/rdma/xsc-abi.h
new file mode 100644
index 000000000..c4d0db30e
--- /dev/null
+++ b/include/uapi/rdma/xsc-abi.h
@@ -0,0 +1,295 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ABI_H__
+#define __XSC_ABI_H__
+
+#include <linux/types.h>
+#include <linux/if_ether.h>	/* For ETH_ALEN. */
+
+/* Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define XSC_IB_UVERBS_ABI_VERSION	1
+
+/* Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+enum {
+	XSC_QP_FLAG_SIGNATURE		= 1 << 0,
+	XSC_QP_FLAG_SCATTER_CQE	= 1 << 1,
+	XSC_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
+	XSC_QP_FLAG_BFREG_INDEX	= 1 << 3,
+	XSC_QP_FLAG_TYPE_DCT		= 1 << 4,
+	XSC_QP_FLAG_TYPE_DCI		= 1 << 5,
+	XSC_QP_FLAG_TIR_ALLOW_SELF_LB_UC = 1 << 6,
+	XSC_QP_FLAG_TIR_ALLOW_SELF_LB_MC = 1 << 7,
+	XSC_QP_FLAG_ALLOW_SCATTER_CQE	= 1 << 8,
+	XSC_QP_FLAG_RAWPACKET_TSO       = 1 << 9,
+	XSC_QP_FLAG_RAWPACKET_TX	= 1 << 10,
+	XSC_QP_FLAG_RAWPACKET_SNIFFER	= 1 << 11,
+	XSC_QP_FLAG_WORC		= 1 << 12,
+};
+
+#define ALLOC_UCONTEXT_VER_V1 1
+#define ALLOC_UCONTEXT_VER_V2 2
+
+#define CURRENT_UCONTEXT_ABI_VER	ALLOC_UCONTEXT_VER_V2
+
+struct xsc_ib_alloc_ucontext_req {
+	__u32	abi_ver;
+	__u32	rsvd1;
+};
+
+enum xsc_user_cmds_supp_uhw {
+	XSC_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+	XSC_USER_CMDS_SUPP_UHW_CREATE_AH    = 1 << 1,
+};
+
+enum {
+	XSC_HW_FEATURE_FLAG_SUPPORT_CQE64 = 1 << 0,
+};
+
+struct xsc_ib_alloc_ucontext_resp {
+	__u32	qp_tab_size;
+	__u32	cache_line_size;
+	__u16	max_sq_desc_sz;
+	__u16	max_rq_desc_sz;
+	__u32	max_send_wqebb;
+	__u32	max_recv_wr;
+	__u16	num_ports;
+	__u16	device_id;
+	__u64	qpm_tx_db;
+	__u64	qpm_rx_db;
+	__u64	cqm_next_cid_reg;
+	__u64	cqm_armdb;
+	__u32	send_ds_num;
+	__u32	recv_ds_num;
+	__u32   cmds_supp_uhw;
+	__u32	pad;
+	__u32	multidb_num;
+	__u32	tx_multidb_base;
+	__u32	rdma_proto_mode;
+	__u32	hw_feature_flag;
+	__u32	reserved[32];
+};
+
+struct xsc_ib_create_qp {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	sq_wqe_count;
+	__u32	rq_wqe_count;
+	__u32	rq_wqe_shift;
+	__u32	flags;
+
+	int	dmabuf_fd;
+	size_t	dmabuf_sz;
+};
+
+struct xsc_ib_create_qp_resp {
+	__u32	uuar_index;
+	__u32 reserved;
+};
+
+struct xsc_ib_create_srq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	flags;
+	__u32	reserved0;
+	__u32	uidx;
+	__u32	reserved1;
+};
+
+struct xsc_ib_create_srq_resp {
+	__u32	srqn;
+	__u32	reserved;
+};
+
+struct xsc_ib_create_cq {
+	__u64 buf_addr;
+	__u64 db_addr;
+	__u32	cqe_size;
+
+	int	dmabuf_fd;
+	size_t	dmabuf_sz;
+};
+
+struct xsc_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+struct xsc_ib_create_ah_resp {
+	__u32	response_length;
+	__u8	dmac[ETH_ALEN];
+	__u8	reserved[6];
+};
+
+struct xsc_ib_alloc_pd_resp {
+	__u32	pdn;
+};
+
+struct xsc_ib_tso_caps {
+	__u32 max_tso; /* Maximum tso payload size in bytes */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_UD
+	 */
+	__u32 supported_qpts;
+};
+
+/* RX Hash function flags */
+enum xsc_rx_hash_function_flags {
+	XSC_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
+};
+
+enum xsc_rdma_link_speed {
+	XSC_RDMA_LINK_SPEED_2_5GB	= 1 << 0,
+	XSC_RDMA_LINK_SPEED_5GB		= 1 << 1,
+	XSC_RDMA_LINK_SPEED_10GB	= 1 << 3,
+	XSC_RDMA_LINK_SPEED_14GB	= 1 << 4,
+	XSC_RDMA_LINK_SPEED_25GB	= 1 << 5,
+	XSC_RDMA_LINK_SPEED_50GB	= 1 << 6,
+	XSC_RDMA_LINK_SPEED_100GB	= 1 << 7,
+};
+
+enum xsc_rdma_phys_state {
+	XSC_RDMA_PHY_STATE_SLEEP	= 1,
+	XSC_RDMA_PHY_STATE_POLLING,
+	XSC_RDMA_PHY_STATE_DISABLED,
+	XSC_RDMA_PHY_STATE_PORT_CONFIGURATION_TRAINNING,
+	XSC_RDMA_PHY_STATE_LINK_UP,
+	XSC_RDMA_PHY_STATE_LINK_ERROR_RECOVERY,
+	XSC_RDMA_PHY_STATE_PHY_TEST,
+};
+
+/*
+ * RX Hash flags, these flags allows to set which incoming packet's field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ * Note: *IPV4 and *IPV6 flags can't be enabled together on the same QP
+ * and *TCP and *UDP flags can't be enabled together on the same QP.
+ */
+enum xsc_rx_hash_fields {
+	XSC_RX_HASH_SRC_IPV4	= 1 << 0,
+	XSC_RX_HASH_DST_IPV4	= 1 << 1,
+	XSC_RX_HASH_SRC_IPV6	= 1 << 2,
+	XSC_RX_HASH_DST_IPV6	= 1 << 3,
+	XSC_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	XSC_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	XSC_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	XSC_RX_HASH_DST_PORT_UDP	= 1 << 7,
+	XSC_RX_HASH_IPSEC_SPI		= 1 << 8,
+	/* Save bits for future fields */
+	XSC_RX_HASH_INNER		= (1UL << 31),
+};
+
+struct xsc_ib_rss_caps {
+	__aligned_u64 rx_hash_fields_mask; /* enum xsc_rx_hash_fields */
+	__u8 rx_hash_function; /* enum xsc_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
+enum xsc_ib_cqe_comp_res_format {
+	XSC_IB_CQE_RES_FORMAT_HASH	= 1 << 0,
+	XSC_IB_CQE_RES_FORMAT_CSUM	= 1 << 1,
+	XSC_IB_CQE_RES_FORMAT_CSUM_STRIDX = 1 << 2,
+};
+
+struct xsc_ib_cqe_comp_caps {
+	__u32 max_num;
+	__u32 supported_format; /* enum xsc_ib_cqe_comp_res_format */
+};
+
+enum xsc_ib_packet_pacing_cap_flags {
+	XSC_IB_PP_SUPPORT_BURST	= 1 << 0,
+};
+
+struct xsc_packet_pacing_caps {
+	__u32 qp_rate_limit_min;
+	__u32 qp_rate_limit_max; /* In kpbs */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+	__u8  cap_flags; /* enum xsc_ib_packet_pacing_cap_flags */
+	__u8  reserved[3];
+};
+
+enum xsc_ib_mpw_caps {
+	MPW_RESERVED		= 1 << 0,
+	XSC_IB_ALLOW_MPW	= 1 << 1,
+	XSC_IB_SUPPORT_EMPW	= 1 << 2,
+};
+
+enum xsc_ib_sw_parsing_offloads {
+	XSC_IB_SW_PARSING = 1 << 0,
+	XSC_IB_SW_PARSING_CSUM = 1 << 1,
+	XSC_IB_SW_PARSING_LSO = 1 << 2,
+};
+
+struct xsc_ib_sw_parsing_caps {
+	__u32 sw_parsing_offloads; /* enum xsc_ib_sw_parsing_offloads */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+};
+
+struct xsc_ib_striding_rq_caps {
+	__u32 min_single_stride_log_num_of_bytes;
+	__u32 max_single_stride_log_num_of_bytes;
+	__u32 min_single_wqe_log_num_of_strides;
+	__u32 max_single_wqe_log_num_of_strides;
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+	__u32 reserved;
+};
+
+enum xsc_ib_query_dev_resp_flags {
+	/* Support 128B CQE compression */
+	XSC_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
+	XSC_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
+};
+
+enum xsc_ib_tunnel_offloads {
+	XSC_IB_TUNNELED_OFFLOADS_VXLAN  = 1 << 0,
+	XSC_IB_TUNNELED_OFFLOADS_GRE    = 1 << 1,
+	XSC_IB_TUNNELED_OFFLOADS_GENEVE = 1 << 2,
+	XSC_IB_TUNNELED_OFFLOADS_MPLS_GRE = 1 << 3,
+	XSC_IB_TUNNELED_OFFLOADS_MPLS_UDP = 1 << 4,
+};
+
+struct xsc_ib_query_device_resp {
+	__u32	comp_mask;
+	__u32	response_length;
+	struct	xsc_ib_tso_caps tso_caps;
+	struct	xsc_ib_rss_caps rss_caps;
+	struct	xsc_ib_cqe_comp_caps cqe_comp_caps;
+	struct	xsc_packet_pacing_caps packet_pacing_caps;
+	__u32	xsc_ib_support_multi_pkt_send_wqes;
+	__u32	flags; /* Use enum xsc_ib_query_dev_resp_flags */
+	struct xsc_ib_sw_parsing_caps sw_parsing_caps;
+	struct xsc_ib_striding_rq_caps striding_rq_caps;
+	__u32	tunnel_offloads_caps; /* enum xsc_ib_tunnel_offloads */
+	__u32	reserved;
+};
+
+#endif /* __XSC_ABI_H__ */
