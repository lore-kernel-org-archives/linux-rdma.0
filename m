Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705060;
	b=FruFJ6eqVNQYL4UGyqiQRpRDaTSJkYj8kZ+VjhDpMq3lnLbXyf267PJMZwfrGE5Of8P5
	 JiViayOeXpM5GQj8EACKogjcF6dGcIkdkyWLjr3xRFZTjrgZLyko4w127kVtDkPqtS6LS
	 Z5pq8fNi8ByhHMvSoNcc7yTzZSiZ1y4K162JCmFpmrwnFZnaNCb3eBPHnqgI0ViEuYZCw
	 MPL1oKwt0MdaY1MIxpDUTEd4K9pKU3Q92uNtIDqJ/JrCHkr08kQMM1Aos6lke5uiXuz1c
	 9Gtrup87Y0RcABnwjrFWekIjT2To/vs8YyipGFUpb9Kr1/yh3GQ5OtcQV0GS2pSIXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705060;
	h=DMARC-Filter:DKIM-Signature:From:Subject:Date:Message-Id:In-Reply-To:
	 X-Original-From:Content-Transfer-Encoding:Cc:X-Mailer:Received:
	 References:X-Lms-Return-Path:To:Content-Type:Mime-Version;
	bh=09jvi2ECuxOYY6qaMSn2lUKxfJuuuTxk8G/Fls2DjNo=;
	b=3C9/g3xSaPyeGP+x+ykkMnUSNcbv4Dw3I31bKbnf426e9HlArV9GoW5DlmwihO63N7kA
	 SKiDBdy2LLcpD7o66jeoW9nBjt/9rWFI7kBGYcJN0tO1dtzWerGXdgq1MYEbrpe+v6afi
	 OukvjNEI5j+ZSmO3+/3Vfc1uqmfond4JWJshW/hfXkpfYSUWOr2E6AI3UrafrSOCP8u4O
	 k/YRI0xDMy8NUuOQV88UcorWILS2pKHCuDoW56ShEdK/LssgYrC/6erw3AL4dakZL3NlX
	 IFcBkdKkprW70gIn1IHUgUy4al9fFsU/ej8wlJJY4Qyv9IRFubKoHj/aLRSvmhFgJJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=YuODINWe;
	arc=none smtp.remote-ip=209.127.231.47
Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA4606A32E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65AA4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=YuODINWe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705054; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=09jvi2ECuxOYY6qaMSn2lUKxfJuuuTxk8G/Fls2DjNo=;
 b=YuODINWef646lq1429HMEg/Jdds1YKZOvg+feIQFzCLP+tBdDCIZKbCsptO7w3+D3mXbYb
 r2yKLwlUrUtPnqdyhjoezuCT1/Ao9qP61jOEgQThFY2N+nRnAoR6t6jnCTBcS01IOmZWzk
 7bwZAaxRejkZF6lN886LmFFmgAw2SZILotsatpqV0sAOprY3NNl0sQ5B1uQOV1EAbJAdXx
 gjwJYxwt6nkrq9QEegIXhNtQvXiO5XgXghv9gF2rWnxXNdPk+7umnCl8lfIS3NgY6wxkl3
 +7rB26cyZhxzFNj1sLmKS6zAOxf3FLNyohyAqFAWOYacKhg5/ctegObeKlYPbg==
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH v2 07/11] net/xsc: add the ethernet netdev
Date: Thu, 26 Nov 2026 22:57:31 +0800
Message-Id: <20261126145730.70868-8-tianx@yunsilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.25.1
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:31 +0800
References: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b0848dc+54c07b+vger.kernel.org+tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

Register the ethernet auxiliary driver and set up the netdev: create the
device, program the MAC address and MTU, and wire up open/close. The
queue and data path are added in follow-up patches, so the interface is
created without a channel to move packets yet.

The netdev has no ndo_start_xmit until the transmit patch lands, so it
must not be brought up in this state.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/net/ethernet/yunsilicon/Kconfig       |   1 +
 drivers/net/ethernet/yunsilicon/Makefile      |   1 +
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  73 +++++
 .../net/ethernet/yunsilicon/xsc/net/Kconfig   |  17 ++
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   9 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 263 ++++++++++++++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_eth.h |  33 +++
 .../yunsilicon/xsc/net/xsc_eth_common.h       | 116 ++++++++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.h  | 150 ++++++++++
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   | 103 +++++++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/pci/adev.c    | 133 +++++++++
 .../net/ethernet/yunsilicon/xsc/pci/adev.h    |  14 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  10 +
 14 files changed, 924 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.h

diff --git a/drivers/net/ethernet/yunsilicon/Kconfig b/drivers/net/ethernet/yunsilicon/Kconfig
index ffdfdf4bf..231661a4a 100644
--- a/drivers/net/ethernet/yunsilicon/Kconfig
+++ b/drivers/net/ethernet/yunsilicon/Kconfig
@@ -22,5 +22,6 @@ config NET_VENDOR_YUNSILICON
 if NET_VENDOR_YUNSILICON
 
 source "drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig"
+source "drivers/net/ethernet/yunsilicon/xsc/net/Kconfig"
 
 endif # NET_VENDOR_YUNSILICON
diff --git a/drivers/net/ethernet/yunsilicon/Makefile b/drivers/net/ethernet/yunsilicon/Makefile
index b2924ccaf..54a3122fe 100644
--- a/drivers/net/ethernet/yunsilicon/Makefile
+++ b/drivers/net/ethernet/yunsilicon/Makefile
@@ -6,3 +6,4 @@
 #
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc/pci/
+obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc/net/
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 7a74f860c..74cd5b66f 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -7,6 +7,7 @@
 #define __XSC_CORE_H
 
 #include <linux/pci.h>
+#include <linux/auxiliary_bus.h>
 #include <linux/bitfield.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
@@ -31,6 +32,8 @@
 #define XSC_PAGE_SHIFT_4K		12
 #define XSC_PAGE_SIZE_4K		(_AC(1, UL) << XSC_PAGE_SHIFT_4K)
 
+#define XSC_INVALID_LKEY		0x100
+
 struct xsc_caps {
 	u32		max_cqes;
 	u32		send_ds_num;
@@ -47,6 +50,25 @@ enum {
 	XSC_MAX_IRQ_NAME	= 32
 };
 
+/* adev */
+#define XSC_PCI_DRV_NAME "xsc_pci"
+#define XSC_ETH_ADEV_NAME "eth"
+
+enum {
+	XSC_QUEUE_TYPE_RAW		= 2,
+	XSC_QUEUE_TYPE_RAW_TSO		= 6,
+};
+
+enum xsc_adev_idx {
+	XSC_ADEV_IDX_ETH,
+	XSC_ADEV_IDX_MAX,
+};
+
+struct xsc_adev {
+	struct auxiliary_device	adev;
+	struct xsc_core_device	*xdev;
+};
+
 /* alloc */
 struct xsc_buf_list {
 	void			*buf;
@@ -62,6 +84,54 @@ struct xsc_buf {
 	unsigned long		size;
 };
 
+struct xsc_frag_buf {
+	struct xsc_buf_list	*frags;
+	unsigned long		npages;
+	unsigned long		size;
+	u8			page_shift;
+};
+
+struct xsc_frag_buf_ctrl {
+	struct xsc_buf_list	*frags;
+	u32			sz_m1;
+	u16			frag_sz_m1;
+	u16			strides_offset;
+	u8			log_sz;
+	u8			log_stride;
+	u8			log_frag_strides;
+};
+
+/* wqe */
+struct xsc_send_wqe_ctrl_seg {
+	__le32		data0;
+	__le32		msg_len;
+	__le32		data2;
+	__le32		data3;
+};
+
+struct xsc_wqe_data_seg {
+	__le32		data0;
+	__le32		mkey;
+	__le64		va;
+};
+
+#define XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK	GENMASK(31, 1)
+
+/* cqe */
+struct xsc_cqe {
+	__le32		data0;
+	__le32		imm_data;
+	__le32		msg_len;
+	__le32		vni;
+	__le64		data2;
+	u8		placeholder2;
+	u8		rsv3;
+	__le16		rsv[1];
+	__le32		data1;
+};
+
+#define XSC_CQE_DATA1_OWNER			BIT(31)
+
 /* eq */
 struct xsc_eq {
 	struct xsc_core_device	*dev;
@@ -136,6 +206,9 @@ struct xsc_cmd;
 struct xsc_core_device {
 	struct pci_dev		*pdev;
 	struct device		*device;
+	int			adev_id;
+	struct xsc_adev		**xsc_adev_list;
+	void			*eth_priv;
 
 	/* async event plumbing, owned by the PCI layer */
 	struct work_struct	event_work;
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
new file mode 100644
index 000000000..7428b2629
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+# Yunsilicon driver configuration
+#
+
+config YUNSILICON_XSC_ETH
+	tristate "Yunsilicon XSC ethernet driver"
+	depends on YUNSILICON_XSC_PCI
+	depends on NET
+	select PAGE_POOL
+	help
+	  This driver provides ethernet support for
+	  Yunsilicon XSC devices.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called xsc_eth.
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
new file mode 100644
index 000000000..db289d974
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
+
+obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
+
+xsc_eth-y := main.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
new file mode 100644
index 000000000..b9e75d7e1
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/irq.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "xsc_eth_common.h"
+#include "xsc_eth.h"
+
+static void xsc_eth_build_nic_params(struct xsc_adapter *adapter)
+{
+	struct xsc_eth_params *params = &adapter->nic_param;
+
+	params->mtu = SW_DEFAULT_MTU;
+}
+
+static void xsc_eth_netdev_init(struct xsc_adapter *adapter)
+{
+	netif_carrier_off(adapter->netdev);
+}
+
+static void xsc_set_port_admin_status(struct xsc_adapter *adapter,
+				      enum xsc_port_status status)
+{
+	struct xsc_event_set_port_admin_status_mbox_out out;
+	struct xsc_event_set_port_admin_status_mbox_in in = {};
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_PORT_ADMIN_STATUS);
+	in.status = cpu_to_be16(status);
+
+	err = xsc_cmd_exec(adapter->xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		netdev_err(adapter->netdev,
+			   "failed to set port admin status %s, err=%d\n",
+			   status == XSC_PORT_UP ? "up" : "down", err);
+}
+
+static int xsc_eth_open(struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+
+	adapter->opened = true;
+
+	xsc_set_port_admin_status(adapter, XSC_PORT_UP);
+
+	return 0;
+}
+
+static int xsc_eth_close(struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+
+	adapter->opened = false;
+
+	netif_carrier_off(adapter->netdev);
+
+	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);
+
+	return 0;
+}
+
+static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
+			      u16 mtu, u16 rx_buf_sz)
+{
+	struct xsc_set_mtu_mbox_out out;
+	struct xsc_set_mtu_mbox_in in;
+	int err;
+
+	memset(&in, 0, sizeof(struct xsc_set_mtu_mbox_in));
+	memset(&out, 0, sizeof(struct xsc_set_mtu_mbox_out));
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_MTU);
+	in.mtu = cpu_to_be16(mtu);
+	in.rx_buf_sz_min = cpu_to_be16(rx_buf_sz);
+	in.mac_port = xdev->mac_port;
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(struct xsc_set_mtu_mbox_in), &out,
+			   sizeof(struct xsc_set_mtu_mbox_out));
+	if (err) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "failed to set hw_mtu=%u rx_buf_sz=%u, err=%d, status=%d\n",
+			   mtu, rx_buf_sz, err, out.hdr.status);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct net_device_ops xsc_netdev_ops = {
+	.ndo_open		= xsc_eth_open,
+	.ndo_stop		= xsc_eth_close,
+};
+
+static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	netdev->netdev_ops = &xsc_netdev_ops;
+
+	netdev->min_mtu = SW_DEFAULT_MTU;
+	netdev->max_mtu = SW_DEFAULT_MTU;
+	netdev->mtu = SW_DEFAULT_MTU;
+}
+
+static int xsc_eth_nic_init(struct xsc_adapter *adapter)
+{
+	xsc_eth_build_nic_params(adapter);
+	xsc_eth_netdev_init(adapter);
+	xsc_eth_build_nic_netdev(adapter);
+
+	return 0;
+}
+
+static int xsc_eth_get_mac(struct xsc_core_device *xdev, char *mac)
+{
+	struct xsc_query_eth_mac_mbox_out *out;
+	struct xsc_query_eth_mac_mbox_in in;
+	int err;
+
+	out = kzalloc_obj(*out, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_ETH_MAC);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
+	if (err || out->hdr.status) {
+		netdev_warn(xsc_dev_to_netdev(xdev),
+			    "get mac failed! err=%d, out.status=%u\n",
+			    err, out->hdr.status);
+		err = -ENOEXEC;
+		goto exit;
+	}
+
+	ether_addr_copy(mac, out->mac);
+	netdev_dbg(xsc_dev_to_netdev(xdev),
+		   "get mac %02x:%02x:%02x:%02x:%02x:%02x\n",
+		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+
+exit:
+	kfree(out);
+	return err;
+}
+
+static void xsc_eth_l2_addr_init(struct xsc_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	char mac[6] = {0};
+	int ret = 0;
+
+	ret = xsc_eth_get_mac(adapter->xdev, mac);
+	if (ret) {
+		netdev_warn(netdev, "get mac failed %d, generate random mac...",
+			    ret);
+		eth_random_addr(mac);
+		netdev->addr_assign_type = NET_ADDR_RANDOM;
+	} else if (!is_valid_ether_addr(mac)) {
+		netdev_warn(netdev, "invalid mac %pM from firmware, generate random mac...\n",
+			    mac);
+		eth_random_addr(mac);
+		netdev->addr_assign_type = NET_ADDR_RANDOM;
+	} else {
+		netdev->addr_assign_type = NET_ADDR_PERM;
+	}
+	eth_hw_addr_set(netdev, mac);
+}
+
+static int xsc_eth_nic_enable(struct xsc_adapter *adapter)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	xsc_eth_l2_addr_init(adapter);
+
+	return xsc_eth_set_hw_mtu(xdev, XSC_SW2HW_MTU(adapter->nic_param.mtu),
+				  XSC_SW2HW_RX_PKT_LEN(adapter->nic_param.mtu));
+}
+
+static int xsc_eth_probe(struct auxiliary_device *adev,
+			 const struct auxiliary_device_id *adev_id)
+{
+	struct xsc_adev *xsc_adev = container_of(adev, struct xsc_adev, adev);
+	struct xsc_core_device *xdev = xsc_adev->xdev;
+	struct xsc_adapter *adapter;
+	struct net_device *netdev;
+	int err;
+
+	netdev = alloc_etherdev(sizeof(struct xsc_adapter));
+	if (!netdev)
+		return -ENOMEM;
+
+	netdev->dev.parent = &xdev->pdev->dev;
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pdev = xdev->pdev;
+	adapter->dev = &adapter->pdev->dev;
+	adapter->xdev = xdev;
+	xdev->eth_priv = adapter;
+
+	err = xsc_eth_nic_init(adapter);
+	if (err) {
+		netdev_err(netdev, "xsc_eth_nic_init failed, err=%d\n", err);
+		goto err_free_netdev;
+	}
+
+	err = xsc_eth_nic_enable(adapter);
+	if (err) {
+		netdev_err(netdev, "xsc_eth_nic_enable failed, err=%d\n", err);
+		goto err_free_netdev;
+	}
+
+	err = register_netdev(netdev);
+	if (err) {
+		netdev_err(netdev, "register_netdev failed, err=%d\n", err);
+		goto err_free_netdev;
+	}
+
+	return 0;
+
+err_free_netdev:
+	xdev->eth_priv = NULL;
+	free_netdev(netdev);
+
+	return err;
+}
+
+static void xsc_eth_remove(struct auxiliary_device *adev)
+{
+	struct xsc_adev *xsc_adev = container_of(adev, struct xsc_adev, adev);
+	struct xsc_core_device *xdev = xsc_adev->xdev;
+	struct xsc_adapter *adapter = xdev->eth_priv;
+
+	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */
+	unregister_netdev(adapter->netdev);
+
+	free_netdev(adapter->netdev);
+
+	xdev->eth_priv = NULL;
+}
+
+static const struct auxiliary_device_id xsc_eth_id_table[] = {
+	{ .name = XSC_PCI_DRV_NAME "." XSC_ETH_ADEV_NAME },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, xsc_eth_id_table);
+
+static struct auxiliary_driver xsc_eth_driver = {
+	.name = "eth",
+	.probe = xsc_eth_probe,
+	.remove = xsc_eth_remove,
+	.id_table = xsc_eth_id_table,
+};
+module_auxiliary_driver(xsc_eth_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Yunsilicon XSC ethernet driver");
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
new file mode 100644
index 000000000..38c620f00
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ETH_H
+#define __XSC_ETH_H
+
+#include <linux/udp.h>
+
+#include "common/xsc_core.h"
+#include "xsc_eth_common.h"
+
+struct xsc_adapter {
+	struct net_device	*netdev;
+	struct pci_dev		*pdev;
+	struct device		*dev;
+	struct xsc_core_device	*xdev;
+
+	struct xsc_eth_params	nic_param;
+
+	struct xsc_channel	channel;
+
+	/* true between ndo_open and ndo_stop */
+	bool			opened;
+};
+
+static inline struct net_device *xsc_dev_to_netdev(struct xsc_core_device *xdev)
+{
+	return ((struct xsc_adapter *)xdev->eth_priv)->netdev;
+}
+
+#endif /* __XSC_ETH_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
new file mode 100644
index 000000000..a20ba7e62
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ETH_COMMON_H
+#define __XSC_ETH_COMMON_H
+
+#include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <net/page_pool/types.h>
+#include <net/page_pool/helpers.h>
+
+#include "xsc_queue.h"
+
+#define SW_DEFAULT_MTU		ETH_DATA_LEN
+
+#define XSC_HASH_IP_PORTS	(BIT(0) | BIT(2) | BIT(3) | BIT(4) | BIT(1))
+#define XSC_HASH_IP6_PORTS	(BIT(5) | BIT(6) | BIT(7) | BIT(8) | BIT(1))
+
+enum {
+	XSC_HASH_FUNC_TOP		= 1,
+};
+
+#define XSC_ETH_HW_MTU_SEND	9800
+#define XSC_ETH_HARD_MTU	(ETH_HLEN + VLAN_HLEN * 2 + ETH_FCS_LEN)
+#define XSC_SW2HW_MTU(mtu)	((mtu) + XSC_ETH_HARD_MTU)
+#define XSC_SW2HW_HLEN		(ETH_HLEN + VLAN_HLEN * 2 + ETH_FCS_LEN)
+#define XSC_SW2HW_FRAG_SIZE(mtu)	((mtu) + XSC_SW2HW_HLEN)
+#define XSC_ETH_RX_MAX_HEAD_ROOM	256
+#define XSC_SW2HW_RX_PKT_LEN(mtu)	\
+	((mtu) + ETH_HLEN + XSC_ETH_RX_MAX_HEAD_ROOM)
+
+#define XSC_QPN_SQN_STUB		1025
+
+#define XSC_SKB_FRAG_SZ(len)	(SKB_DATA_ALIGN(len) +	\
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
+#define XSC_RQCQ_ELE_SZ		32
+#define XSC_SQCQ_ELE_SZ		32
+
+#define XSC_LOG_RQCQ_SZ		0xb
+#define XSC_LOG_SQCQ_SZ		0xa
+
+#define XSC_RQCQ_ELE_NUM	BIT(XSC_LOG_RQCQ_SZ)
+#define XSC_SQCQ_ELE_NUM	BIT(XSC_LOG_SQCQ_SZ)
+
+enum xsc_port_status {
+	XSC_PORT_DOWN      = 0,
+	XSC_PORT_UP        = 1,
+};
+
+enum xsc_queue_type {
+	XSC_QUEUE_TYPE_RQCQ,
+	XSC_QUEUE_TYPE_SQCQ,
+	XSC_QUEUE_TYPE_RQ,
+	XSC_QUEUE_TYPE_SQ,
+};
+
+struct xsc_queue_attr {
+	u32 ele_num;
+	u32 ele_size;
+	u8  ele_log_size;
+	u8  q_log_size;
+};
+
+struct xsc_eth_rx_wqe_cyc {
+	DECLARE_FLEX_ARRAY(struct xsc_wqe_data_seg, data);
+};
+
+struct xsc_cq_param {
+	struct xsc_wq_param wq;
+	struct xsc_queue_attr cq_attr;
+};
+
+struct xsc_rq_param {
+	struct xsc_wq_param wq;
+	struct xsc_queue_attr rq_attr;
+	u32 frag_size;
+};
+
+struct xsc_sq_param {
+	struct xsc_wq_param wq;
+	struct xsc_queue_attr sq_attr;
+};
+
+struct xsc_channel_param {
+	struct xsc_cq_param rqcq_param;
+	struct xsc_cq_param sqcq_param;
+	struct xsc_rq_param rq_param;
+	struct xsc_sq_param sq_param;
+};
+
+struct xsc_eth_qp {
+	struct xsc_rq rq;
+	struct xsc_sq sq;
+};
+
+struct xsc_eth_params {
+	u32	mtu;
+	u32	sq_size;
+	u32	rq_size;
+};
+
+struct xsc_channel {
+	/* data path */
+	struct xsc_eth_qp	qp;
+
+	/* relationship */
+	struct xsc_adapter	*adapter;
+	struct net_device	*netdev;
+	int			cpu;
+} ____cacheline_aligned_in_smp;
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
new file mode 100644
index 000000000..35206ddf4
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd. All
+ * rights reserved.
+ * Copyright (c) 2013-2015, Mellanox Technologies, Ltd.  All rights reserved.
+ */
+
+#ifndef __XSC_WQ_H
+#define __XSC_WQ_H
+
+#include "common/xsc_core.h"
+
+struct xsc_wq_param {
+	int		buf_numa_node;
+	int		db_numa_node;
+};
+
+struct xsc_wq_ctrl {
+	struct xsc_core_device	*xdev;
+	struct xsc_frag_buf	buf;
+};
+
+struct xsc_wq_cyc {
+	struct xsc_frag_buf_ctrl fbc;
+	u16			sz;
+	u16			wqe_ctr;
+	u16			cur_sz;
+};
+
+struct xsc_cqwq {
+	struct xsc_frag_buf_ctrl fbc;
+	u32			  cc;
+};
+
+enum xsc_res_type {
+	XSC_RES_RQ,
+	XSC_RES_SQ,
+};
+
+u32 xsc_wq_cyc_get_size(struct xsc_wq_cyc *wq);
+
+int xsc_eth_cqwq_create(struct xsc_core_device *xdev,
+			struct xsc_wq_param *param,
+			u8 q_log_size,
+			u8 ele_log_size,
+			struct xsc_cqwq *wq,
+			struct xsc_wq_ctrl *wq_ctrl);
+
+int xsc_eth_wq_cyc_create(struct xsc_core_device *xdev,
+			  struct xsc_wq_param *param,
+			  u8 q_log_size,
+			  u8 ele_log_size,
+			  struct xsc_wq_cyc *wq,
+			  struct xsc_wq_ctrl *wq_ctrl);
+void xsc_eth_wq_destroy(struct xsc_wq_ctrl *wq_ctrl);
+
+static inline void xsc_init_fbc(struct xsc_buf_list *frags,
+				u8 log_stride, u8 log_sz,
+				struct xsc_frag_buf_ctrl *fbc)
+{
+	fbc->frags		= frags;
+	fbc->log_stride		= log_stride;
+	fbc->log_sz		= log_sz;
+	fbc->sz_m1		= (1 << fbc->log_sz) - 1;
+	fbc->log_frag_strides	= PAGE_SHIFT - fbc->log_stride;
+	fbc->frag_sz_m1		= (1 << fbc->log_frag_strides) - 1;
+	fbc->strides_offset	= 0;
+}
+
+static inline void *xsc_frag_buf_get_wqe(struct xsc_frag_buf_ctrl *fbc,
+					 u32 ix)
+{
+	unsigned int frag;
+
+	ix  += fbc->strides_offset;
+	frag = ix >> fbc->log_frag_strides;
+
+	return fbc->frags[frag].buf +
+		((fbc->frag_sz_m1 & ix) << fbc->log_stride);
+}
+
+static inline int xsc_wq_cyc_missing(struct xsc_wq_cyc *wq)
+{
+	return wq->sz - wq->cur_sz;
+}
+
+static inline void xsc_wq_cyc_push_n(struct xsc_wq_cyc *wq, u8 n)
+{
+	wq->wqe_ctr += n;
+	wq->cur_sz += n;
+}
+
+static inline void xsc_wq_cyc_pop(struct xsc_wq_cyc *wq)
+{
+	wq->cur_sz--;
+}
+
+static inline u16 xsc_wq_cyc_ctr2ix(struct xsc_wq_cyc *wq, u16 ctr)
+{
+	return ctr & wq->fbc.sz_m1;
+}
+
+static inline u16 xsc_wq_cyc_get_head(struct xsc_wq_cyc *wq)
+{
+	return xsc_wq_cyc_ctr2ix(wq, wq->wqe_ctr);
+}
+
+static inline void *xsc_wq_cyc_get_wqe(struct xsc_wq_cyc *wq, u16 ix)
+{
+	return xsc_frag_buf_get_wqe(&wq->fbc, ix);
+}
+
+static inline u32 xsc_cqwq_ctr2ix(struct xsc_cqwq *wq, u32 ctr)
+{
+	return ctr & wq->fbc.sz_m1;
+}
+
+static inline u32 xsc_cqwq_get_ci(struct xsc_cqwq *wq)
+{
+	return xsc_cqwq_ctr2ix(wq, wq->cc);
+}
+
+static inline u32 xsc_cqwq_get_ctr_wrap_cnt(struct xsc_cqwq *wq, u32 ctr)
+{
+	return ctr >> wq->fbc.log_sz;
+}
+
+static inline u32 xsc_cqwq_get_wrap_cnt(struct xsc_cqwq *wq)
+{
+	return xsc_cqwq_get_ctr_wrap_cnt(wq, wq->cc);
+}
+
+static inline void xsc_cqwq_pop(struct xsc_cqwq *wq)
+{
+	wq->cc++;
+}
+
+static inline u32 xsc_cqwq_get_size(struct xsc_cqwq *wq)
+{
+	return wq->fbc.sz_m1 + 1;
+}
+
+static inline struct xsc_cqe *xsc_cqwq_get_wqe(struct xsc_cqwq *wq, u32 ix)
+{
+	struct xsc_cqe *cqe = xsc_frag_buf_get_wqe(&wq->fbc, ix);
+
+	return cqe;
+}
+
+#endif /* __XSC_WQ_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
new file mode 100644
index 000000000..d89e62d93
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2015-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#ifndef __XSC_QUEUE_H
+#define __XSC_QUEUE_H
+
+#include <net/page_pool/types.h>
+#include <net/page_pool/helpers.h>
+
+#include "common/xsc_core.h"
+#include "xsc_eth_wq.h"
+
+struct xsc_channel;
+
+enum {
+	XSC_SEND_WQE_DS	= 16,
+};
+
+enum {
+	XSC_RECV_WQE_DS	= 16,
+};
+
+enum {
+	XSC_ETH_RQ_STATE_ENABLED,
+};
+
+enum {
+	XSC_ETH_SQ_STATE_ENABLED,
+};
+
+#define XSC_RX_FRAG_SZ_ORDER	0
+
+struct xsc_cq {
+	/* data path - accessed per cqe */
+	struct xsc_cqwq		wq;
+
+	struct xsc_core_cq	xcq;
+	struct xsc_channel	*channel;
+
+	/* control */
+	struct xsc_core_device	*xdev;
+	struct xsc_wq_ctrl	wq_ctrl;
+} ____cacheline_aligned_in_smp;
+
+struct xsc_dma_info {
+	struct page	*page;
+	dma_addr_t	addr;
+};
+
+struct xsc_rq {
+	struct xsc_core_qp	cqp;
+	struct {
+		struct xsc_wq_cyc	wq;
+		struct xsc_dma_info	*di;
+		u8			wqe_bulk;
+	} wqe;
+
+	struct page_pool	*page_pool;
+	struct xsc_wq_ctrl	wq_ctrl;
+	struct xsc_cq		cq;
+	u32			rqn;
+	u32			frag_size;
+
+	unsigned long		state;
+} ____cacheline_aligned_in_smp;
+
+struct xsc_tx_wqe_info {
+	struct sk_buff	*skb;
+	dma_addr_t	dma_addr;
+};
+
+struct xsc_tx_wqe {
+	struct xsc_send_wqe_ctrl_seg ctrl;
+	struct xsc_wqe_data_seg data[];
+};
+
+struct xsc_sq {
+	struct xsc_core_qp		cqp;
+	u16				cc;
+	u16				pc ____cacheline_aligned_in_smp;
+
+	struct xsc_cq			cq;
+
+	/* read only */
+	struct xsc_wq_cyc		wq;
+	struct xsc_tx_wqe_info		*wqe_info;
+	struct netdev_queue		*txq;
+	u32				sqn;
+	u16				stop_room;
+
+	unsigned long			state;
+	unsigned int			hw_mtu;
+
+	/* control path */
+	struct xsc_wq_ctrl		wq_ctrl;
+	struct xsc_channel		*channel;
+} ____cacheline_aligned_in_smp;
+
+#endif /* __XSC_QUEUE_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 552cd5f46..9cdc31f9d 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmd.o eq.o cq.o qp.o pci_irq.o alloc.o doorbell.o
+xsc_pci-y := main.o adev.o cmd.o eq.o cq.o qp.o pci_irq.o alloc.o doorbell.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
new file mode 100644
index 000000000..3376ed10b
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/idr.h>
+
+#include "adev.h"
+
+static DEFINE_IDA(xsc_adev_ida);
+
+static const char * const xsc_adev_name[] = {
+	[XSC_ADEV_IDX_ETH] = XSC_ETH_ADEV_NAME,
+};
+
+static void xsc_release_adev(struct device *dev)
+{
+	struct xsc_adev *xsc_adev =
+		container_of(dev, struct xsc_adev, adev.dev);
+
+	kfree(xsc_adev);
+}
+
+static int xsc_adev_add(struct xsc_core_device *xdev, int idx)
+{
+	struct auxiliary_device	*adev;
+	struct xsc_adev *xsc_adev;
+	int ret;
+
+	if (!xdev->xsc_adev_list)
+		return -ENODEV;
+
+	if (xdev->xsc_adev_list[idx])
+		return 0;
+
+	xsc_adev = kzalloc_obj(*xsc_adev, GFP_KERNEL);
+	if (!xsc_adev)
+		return -ENOMEM;
+
+	adev = &xsc_adev->adev;
+	adev->name = xsc_adev_name[idx];
+	adev->id = xdev->adev_id;
+	adev->dev.parent = &xdev->pdev->dev;
+	adev->dev.release = xsc_release_adev;
+	xsc_adev->xdev = xdev;
+
+	ret = auxiliary_device_init(adev);
+	if (ret) {
+		kfree(xsc_adev);
+		return ret;
+	}
+
+	ret = auxiliary_device_add(adev);
+	if (ret) {
+		auxiliary_device_uninit(adev);
+		return ret;
+	}
+
+	xdev->xsc_adev_list[idx] = xsc_adev;
+
+	return 0;
+}
+
+static void xsc_adev_del(struct xsc_core_device *xdev, int idx)
+{
+	struct xsc_adev *xsc_adev;
+	struct auxiliary_device *adev;
+
+	if (!xdev->xsc_adev_list)
+		return;
+
+	xsc_adev = xdev->xsc_adev_list[idx];
+	if (!xsc_adev)
+		return;
+
+	/* Clear the slot before teardown: the driver's remove callback runs
+	 * synchronously inside auxiliary_device_delete() and may re-enter
+	 * xsc_adev_add() for this index.
+	 */
+	xdev->xsc_adev_list[idx] = NULL;
+
+	adev = &xsc_adev->adev;
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+}
+
+int xsc_adev_init(struct xsc_core_device *xdev)
+{
+	struct xsc_adev **xsc_adev_list;
+	int adev_id;
+	int ret;
+
+	xsc_adev_list = kcalloc(XSC_ADEV_IDX_MAX,
+				sizeof(struct xsc_adev *),
+				GFP_KERNEL);
+	if (!xsc_adev_list)
+		return -ENOMEM;
+	xdev->xsc_adev_list = xsc_adev_list;
+
+	adev_id = ida_alloc(&xsc_adev_ida, GFP_KERNEL);
+	if (adev_id < 0) {
+		ret = adev_id;
+		goto err_free_adev_list;
+	}
+	xdev->adev_id = adev_id;
+
+	ret = xsc_adev_add(xdev, XSC_ADEV_IDX_ETH);
+	if (ret)
+		goto err_dalloc_adev_id;
+
+	return 0;
+
+err_dalloc_adev_id:
+	ida_free(&xsc_adev_ida, xdev->adev_id);
+err_free_adev_list:
+	kfree(xsc_adev_list);
+	xdev->xsc_adev_list = NULL;
+
+	return ret;
+}
+
+void xsc_adev_uninit(struct xsc_core_device *xdev)
+{
+	if (!xdev->xsc_adev_list)
+		return;
+
+	xsc_adev_del(xdev, XSC_ADEV_IDX_ETH);
+	ida_free(&xsc_adev_ida, xdev->adev_id);
+	kfree(xdev->xsc_adev_list);
+	xdev->xsc_adev_list = NULL;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
new file mode 100644
index 000000000..d5c2c940e
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ADEV_H
+#define __XSC_ADEV_H
+
+#include "common/xsc_core.h"
+
+int xsc_adev_init(struct xsc_core_device *xdev);
+void xsc_adev_uninit(struct xsc_core_device *xdev);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index e158dd2e9..c800cef3d 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -7,6 +7,7 @@
 
 #include "common/xsc_cmd.h"
 #include "common/xsc_core.h"
+#include "adev.h"
 #include "cq.h"
 #include "eq.h"
 #include "pci_irq.h"
@@ -173,8 +174,16 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 		goto err_cmd_cleanup;
 	}
 
+	err = xsc_adev_init(xdev);
+	if (err) {
+		pci_err(pdev, "xsc_adev_init failed: err=%d\n", err);
+		goto err_irq_eq_destroy;
+	}
+
 	return 0;
 
+err_irq_eq_destroy:
+	xsc_irq_eq_destroy(xdev);
 err_cmd_cleanup:
 	xsc_cmd_cleanup(xdev);
 err_io_unmap:
@@ -192,6 +201,7 @@ static void xsc_pci_fini(struct xsc_core_device *xdev)
 {
 	struct pci_dev *pdev = xdev->pdev;
 
+	xsc_adev_uninit(xdev);
 	xsc_irq_eq_destroy(xdev);
 	xsc_cmd_cleanup(xdev);
 	pci_iounmap(pdev, xdev->bar);
-- 
2.43.0
