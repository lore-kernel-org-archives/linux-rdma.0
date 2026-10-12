Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785B5434408
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805458; cv=none; b=UErhOB5kdm5CfhD9lcf/P8fsDkPhVOaDsH96bVyYnQLO0gYG25PGeRUwO1e3RrR3Pd5V2O8nlHzZTvBn4niuogy6bItubdloBp8pn9QydYpA2uZhAOOcelOJZIJogER/1vBSo5e6Beuc2K4ka0o+v5rN2DgVGMwYaTB9CnGplpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805458; c=relaxed/simple;
	bh=oIphJ1q+vNXrqw1xs4Ehkss6J1io0eS/y1Fi0l04wc0=;
	h=Cc:Subject:Date:Message-Id:In-Reply-To:From:Content-Type:
	 References:To:Mime-Version; b=mjCJldcw7uot32rhK4CWOWTPintnefxcQsyCFWKJtUwcBMfiX0+hBo2AVfflmu4a/1jfPMGkxZjPVFNk2y+YQPHf+Y6UwskRmhMKOdT1RqGTAy8mJyxIVfuiGDmLLezw7DDXsGlyf5+e3BAPkQaLSvGsUWP7u+SighqrFOYCN1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=hK/PItuv; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="hK/PItuv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805449; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wBNpopXdHYx2gc8M1Eh4uy7cnyyB610zbtlGFNoClEI=;
 b=hK/PItuveJA0xVZmqf8K/wHZ8ipEhLjPswai+w+/yw16BntEcLCPbQYxw61lSelP/pYZSv
 ubcL9Alt0Ph1YtcjfMiwGdio1oHKzuTCXKWjkcJozgZq+uXd3v2pxBXWmjR/X65e+m2C87
 YaWlflPlRZNK5vFQJbRQFx3V9wq45J1P6vWO9BIW0W11buS7SzXoTM92I5gBK1jxksdjCC
 z9Xl34Uaq04JNtGvBTb/EYYQ6wkRZkPNA5bUKJIN4JyoLaZLWIb0/8UQ8UKA9u1ihsSmQn
 5FJ5R3mP+6O31kyeNY0qTYt0tyHmwxxf80Pj4y0B8pJy3xg9EpAdj60pWJNeMg==
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [PATCH 06/15] yunsilicon: add ethernet netdev registration
Date: Mon, 12 Oct 2026 19:44:06 +0800
Message-Id: <20261012114404.2471317-7-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:06 +0800
X-Mailer: git-send-email 2.25.1
X-Original-From: Xin Tian <tianx@yunsilicon.com>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26accc807+c7e6f4+vger.kernel.org+tianx@yunsilicon.com>

Add the ethernet auxiliary driver: allocate the netdev, program the MAC
address and the MTU, register it, and implement ndo_open/ndo_stop which
flip the port admin status and register the link event handler.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/net/ethernet/yunsilicon/Kconfig       |   2 +-
 drivers/net/ethernet/yunsilicon/Makefile      |   2 +-
 .../net/ethernet/yunsilicon/xsc/net/Kconfig   |  17 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   9 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 464 ++++++++++++++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_eth.h |  45 ++
 .../yunsilicon/xsc/net/xsc_eth_common.h       | 124 +++++
 .../yunsilicon/xsc/net/xsc_eth_stats.h        |  34 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         |  91 ++++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.c  |  80 +++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.h  | 185 +++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_pp.h  |  38 ++
 .../net/ethernet/yunsilicon/xsc/net/xsc_pph.h |  42 ++
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   | 185 +++++++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/pci/vport.c   |  34 ++
 16 files changed, 1351 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_pp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/vport.c

diff --git a/drivers/net/ethernet/yunsilicon/Kconfig b/drivers/net/ethernet/yunsilicon/Kconfig
index ffdfdf4bf..46af1fdd0 100644
--- a/drivers/net/ethernet/yunsilicon/Kconfig
+++ b/drivers/net/ethernet/yunsilicon/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
 # All rights reserved.
-#
 # Yunsilicon driver configuration
 #
 
@@ -21,6 +20,7 @@ config NET_VENDOR_YUNSILICON
 
 if NET_VENDOR_YUNSILICON
 
+source "drivers/net/ethernet/yunsilicon/xsc/net/Kconfig"
 source "drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig"
 
 endif # NET_VENDOR_YUNSILICON
diff --git a/drivers/net/ethernet/yunsilicon/Makefile b/drivers/net/ethernet/yunsilicon/Makefile
index b2924ccaf..a89a5ce24 100644
--- a/drivers/net/ethernet/yunsilicon/Makefile
+++ b/drivers/net/ethernet/yunsilicon/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
 # All rights reserved.
-#
 # Makefile for the Yunsilicon device drivers.
 #
 
+obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc/net/
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc/pci/
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
index 000000000..0e6249cec
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
+xsc_eth-y := main.o xsc_eth_wq.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
new file mode 100644
index 000000000..b92c3ed19
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -0,0 +1,464 @@
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
+#include "common/xsc_cmd_api.h"
+#include "common/xsc_device.h"
+#include "xsc_pp.h"
+#include "xsc_eth_common.h"
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+
+static const struct xsc_tirc_config tirc_default_config[XSC_NUM_INDIR_TIRS] = {
+	[XSC_TT_IPV4] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV4,
+				.l4_prot_type = 0,
+				.rx_hash_fields = XSC_HASH_IP,
+	},
+	[XSC_TT_IPV4_TCP] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV4,
+				.l4_prot_type = XSC_L4_PROT_TYPE_TCP,
+				.rx_hash_fields = XSC_HASH_IP_PORTS,
+	},
+	[XSC_TT_IPV4_UDP] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV4,
+				.l4_prot_type = XSC_L4_PROT_TYPE_UDP,
+				.rx_hash_fields = XSC_HASH_IP_PORTS,
+	},
+	[XSC_TT_IPV6] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV6,
+				.l4_prot_type = 0,
+				.rx_hash_fields = XSC_HASH_IP6,
+	},
+	[XSC_TT_IPV6_TCP] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV6,
+				.l4_prot_type = XSC_L4_PROT_TYPE_TCP,
+				.rx_hash_fields = XSC_HASH_IP6_PORTS,
+	},
+	[XSC_TT_IPV6_UDP] = {
+				.l3_prot_type = XSC_L3_PROT_TYPE_IPV6,
+				.l4_prot_type = XSC_L4_PROT_TYPE_UDP,
+				.rx_hash_fields = XSC_HASH_IP6_PORTS,
+	},
+};
+
+static int xsc_get_max_num_channels(struct xsc_core_device *xdev)
+{
+	return min_t(int, xdev->dev_res->eq_table.num_comp_vectors,
+		     XSC_ETH_MAX_NUM_CHANNELS);
+}
+
+static void xsc_build_rss_param(struct xsc_rss_params *rss_param)
+{
+	enum xsc_traffic_types tt;
+
+	for (tt = 0; tt < XSC_NUM_INDIR_TIRS; tt++) {
+		rss_param->rx_hash_fields[tt] =
+			tirc_default_config[tt].rx_hash_fields;
+	}
+	rss_param->rss_hash_tmpl = XSC_HASH_IP_PORTS | XSC_HASH_IP6_PORTS;
+}
+
+static void xsc_eth_build_nic_params(struct xsc_adapter *adapter, u32 ch_num)
+{
+	struct xsc_eth_params *params = &adapter->nic_param;
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	params->mtu = SW_DEFAULT_MTU;
+
+	params->comp_vectors = xdev->dev_res->eq_table.num_comp_vectors;
+	params->max_num_ch = ch_num;
+	params->num_channels = ch_num;
+
+	xsc_build_rss_param(&adapter->rss_param);
+}
+
+static int xsc_eth_netdev_init(struct xsc_adapter *adapter)
+{
+	unsigned int node, nch;
+
+	nch = adapter->nic_param.max_num_ch;
+	node = dev_to_node(adapter->dev);
+	adapter->txq2sq = kcalloc_node(nch,
+				       sizeof(*adapter->txq2sq),
+				       GFP_KERNEL, node);
+	if (!adapter->txq2sq)
+		return -ENOMEM;
+
+	netif_carrier_off(adapter->netdev);
+
+	return 0;
+}
+
+static bool xsc_eth_get_link_status(struct xsc_adapter *adapter)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+	u16 vport = 0;
+	bool link_up;
+
+	link_up = xsc_core_query_vport_state(xdev, vport);
+
+	return link_up ? true : false;
+}
+
+static int xsc_eth_change_link_status(struct xsc_adapter *adapter)
+{
+	bool link_up;
+
+	link_up = xsc_eth_get_link_status(adapter);
+
+	if (link_up && !netif_carrier_ok(adapter->netdev)) {
+		netdev_info(adapter->netdev, "Link up\n");
+		netif_carrier_on(adapter->netdev);
+	} else if (!link_up && netif_carrier_ok(adapter->netdev)) {
+		netdev_info(adapter->netdev, "Link down\n");
+		netif_carrier_off(adapter->netdev);
+	}
+
+	return 0;
+}
+
+/*
+ * Registered with the PCI layer, which runs it on its own workqueue for
+ * every XSC_CMD_EVENT_RESP_CHANGE_LINK event.
+ */
+static void xsc_eth_link_event_handler(void *arg)
+{
+	struct xsc_core_device *xdev = arg;
+	struct xsc_adapter *adapter = xdev->eth_priv;
+	int err;
+
+	if (!adapter || !adapter->opened)
+		return;
+
+	err = xsc_eth_change_link_status(adapter);
+	if (err)
+		netdev_err(adapter->netdev, "failed to change linkstatus, err=%d\n",
+			   err);
+}
+
+static void xsc_set_default_xps_cpumasks(struct xsc_adapter *adapter)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+	int num_comp_vectors, irq;
+
+	num_comp_vectors = adapter->nic_param.comp_vectors;
+	cpumask_clear(xdev->xps_cpumask);
+
+	for (irq = 0; irq < num_comp_vectors; irq++) {
+		cpumask_set_cpu(cpumask_local_spread(irq, xdev->numa_node),
+				xdev->xps_cpumask);
+		netif_set_xps_queue(adapter->netdev, xdev->xps_cpumask, irq);
+	}
+}
+
+static int xsc_set_port_admin_status(struct xsc_adapter *adapter,
+				     enum xsc_port_status status)
+{
+	struct xsc_event_set_port_admin_status_mbox_out out;
+	struct xsc_event_set_port_admin_status_mbox_in in = {};
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_PORT_ADMIN_STATUS);
+	in.status = cpu_to_be16(status);
+
+	return xsc_cmd_exec(adapter->xdev, &in, sizeof(in), &out, sizeof(out));
+}
+
+static int xsc_eth_open(struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	if (adapter->opened) {
+		netdev_err(adapter->netdev, "ndo_open on an already opened device\n");
+		return 0;
+	}
+	xsc_irq_event_register(xdev, xsc_eth_link_event_handler);
+
+	if (xsc_eth_get_link_status(adapter))	{
+		netdev_info(netdev, "Link up\n");
+		netif_carrier_on(adapter->netdev);
+	} else {
+		netdev_info(netdev, "Link down\n");
+	}
+
+	adapter->opened = true;
+
+	xsc_set_default_xps_cpumasks(adapter);
+
+	xsc_set_port_admin_status(adapter, XSC_PORT_UP);
+
+	return 0;
+}
+
+static int xsc_eth_close(struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	if (!adapter->opened)
+		return 0;
+	adapter->opened = false;
+
+	netif_carrier_off(adapter->netdev);
+
+	xsc_irq_event_unregister(xdev);
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
+	/* Set up network device as normal. */
+	netdev->netdev_ops = &xsc_netdev_ops;
+
+	netdev->min_mtu = SW_DEFAULT_MTU;
+	netdev->max_mtu = SW_DEFAULT_MTU;
+	/*mtu - macheaderlen - ipheaderlen should be aligned in 8B*/
+	netdev->mtu = SW_DEFAULT_MTU;
+
+	netdev->features = NETIF_F_HIGHDMA;
+}
+
+static int xsc_eth_nic_init(struct xsc_adapter *adapter, u32 ch_num)
+{
+	int err;
+
+	xsc_eth_build_nic_params(adapter, ch_num);
+
+	err = xsc_eth_netdev_init(adapter);
+	if (err)
+		return err;
+
+	xsc_eth_build_nic_netdev(adapter);
+
+	return 0;
+}
+
+static void xsc_eth_nic_cleanup(struct xsc_adapter *adapter)
+{
+	kfree(adapter->txq2sq);
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
+	memcpy(mac, out->mac, ETH_ALEN);
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
+	}
+	eth_hw_addr_set(netdev, mac);
+
+	if (!is_valid_ether_addr(netdev->perm_addr))
+		memcpy(netdev->perm_addr, netdev->dev_addr, netdev->addr_len);
+}
+
+/*
+ * Program the MAC address and the MTU into the hardware. Called once from
+ * probe(), before the netdev is registered: the netdev layer marks the
+ * device present itself in register_netdevice(), so there is nothing to
+ * attach here and no need to take the rtnl lock.
+ */
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
+	int num_chl;
+	int err;
+
+	num_chl = xsc_get_max_num_channels(xdev);
+
+	netdev = alloc_etherdev_mqs(sizeof(struct xsc_adapter),
+				    num_chl, num_chl);
+	if (!netdev) {
+		pr_err("alloc_etherdev_mqs failed, txq=%d, rxq=%d\n",
+		       num_chl, num_chl);
+		return -ENOMEM;
+	}
+
+	netdev->dev.parent = &xdev->pdev->dev;
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pdev = xdev->pdev;
+	adapter->dev = &adapter->pdev->dev;
+	adapter->xdev = xdev;
+	xdev->eth_priv = adapter;
+
+	err = xsc_eth_nic_init(adapter, num_chl);
+	if (err) {
+		netdev_err(netdev, "xsc_eth_nic_init failed, err=%d\n", err);
+		goto err_free_netdev;
+	}
+
+	err = xsc_eth_nic_enable(adapter);
+	if (err) {
+		netdev_err(netdev, "xsc_eth_nic_enable failed, err=%d\n", err);
+		goto err_nic_cleanup;
+	}
+
+	adapter->stats = kvzalloc_obj(*adapter->stats, GFP_KERNEL);
+	if (!adapter->stats) {
+		err = -ENOMEM;
+		goto err_nic_cleanup;
+	}
+
+	err = register_netdev(netdev);
+	if (err) {
+		netdev_err(netdev, "register_netdev failed, err=%d\n", err);
+		goto err_free_stats;
+	}
+
+	xdev->netdev = netdev;
+
+	return 0;
+
+err_free_stats:
+	kvfree(adapter->stats);
+err_nic_cleanup:
+	xsc_eth_nic_cleanup(adapter);
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
+	struct xsc_adapter *adapter;
+
+	if (!xdev)
+		return;
+
+	adapter = xdev->eth_priv;
+	if (!adapter)
+		return;
+
+	/* Stop link events reaching this adapter and wait out one already in
+	 * flight, which would otherwise touch the memory freed below.
+	 */
+	xsc_irq_event_unregister(xdev);
+
+	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */
+	unregister_netdev(adapter->netdev);
+
+	/* Must precede free_netdev(): the adapter lives in the netdev priv. */
+	xsc_eth_nic_cleanup(adapter);
+	kvfree(adapter->stats);
+	free_netdev(adapter->netdev);
+
+	xdev->netdev = NULL;
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
index 000000000..4d9f92e09
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
@@ -0,0 +1,45 @@
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
+#include "common/xsc_device.h"
+#include "xsc_eth_common.h"
+#include "xsc_eth_stats.h"
+
+#define XSC_INVALID_LKEY	0x100
+
+struct xsc_rss_params {
+	u32	rx_hash_fields[XSC_NUM_INDIR_TIRS];
+	u32	rss_hash_tmpl;
+};
+
+struct xsc_adapter {
+	struct net_device	*netdev;
+	struct pci_dev		*pdev;
+	struct device		*dev;
+	struct xsc_core_device	*xdev;
+
+	struct xsc_eth_params	nic_param;
+	struct xsc_rss_params	rss_param;
+
+	struct xsc_eth_channels	channels;
+	struct xsc_sq		**txq2sq;
+
+	/* true between ndo_open and ndo_stop */
+	bool			opened;
+
+	struct xsc_stats	*stats;
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
index 000000000..be476f31f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ETH_COMMON_H
+#define __XSC_ETH_COMMON_H
+
+#include "xsc_queue.h"
+#include "xsc_pph.h"
+
+#define SW_DEFAULT_MTU		ETH_DATA_LEN
+
+#define XSC_ETH_HW_MTU_SEND	9800
+#define XSC_ETH_HARD_MTU	(ETH_HLEN + VLAN_HLEN * 2 + ETH_FCS_LEN)
+#define XSC_SW2HW_MTU(mtu)	((mtu) + XSC_ETH_HARD_MTU)
+#define XSC_SW2HW_HLEN		(ETH_HLEN + VLAN_HLEN * 2 + ETH_FCS_LEN + \
+				 XSC_PPH_HEAD_LEN)
+#define XSC_SW2HW_FRAG_SIZE(mtu)	((mtu) + XSC_SW2HW_HLEN)
+#define XSC_ETH_RX_MAX_HEAD_ROOM	256
+#define XSC_SW2HW_RX_PKT_LEN(mtu)	\
+	((mtu) + ETH_HLEN + XSC_ETH_RX_MAX_HEAD_ROOM)
+
+#define XSC_RX_MAX_HEAD			(256)
+
+#define XSC_QPN_SQN_STUB		1025
+
+#define XSC_ETH_MAX_NUM_CHANNELS	256
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
+	struct xsc_rq_frags_info frags_info;
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
+	u16	num_channels;
+	u16	max_num_ch;
+	u32	mtu;
+	u32	comp_vectors;
+	u32	sq_size;
+	u32	rq_size;
+	u32	rq_frags_size;
+};
+
+struct xsc_channel {
+	/* data path */
+	struct xsc_eth_qp	qp;
+	struct napi_struct	napi;
+	int			chl_idx;
+
+	/*relationship*/
+	struct xsc_adapter	*adapter;
+	struct net_device	*netdev;
+	int			cpu;
+
+	/* data path - accessed per napi poll */
+	const struct cpumask	*aff_mask;
+} ____cacheline_aligned_in_smp;
+
+struct xsc_eth_channels {
+	struct xsc_channel	*c;
+	unsigned int		num_chl;
+	u32			rqn_base;
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h
new file mode 100644
index 000000000..a391afe97
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_EN_STATS_H
+#define __XSC_EN_STATS_H
+
+#include "xsc_eth_common.h"
+
+struct xsc_rq_stats {
+	u64 packets;
+	u64 bytes;
+};
+
+struct xsc_sq_stats {
+	u64 packets;
+	u64 bytes;
+	u64 dropped;
+};
+
+struct xsc_channel_stats {
+	struct xsc_sq_stats sq;
+	struct xsc_rq_stats rq;
+} ____cacheline_aligned_in_smp;
+
+struct xsc_stats {
+	struct xsc_channel_stats channel_stats[XSC_ETH_MAX_NUM_CHANNELS];
+};
+
+void xsc_eth_fold_sw_stats64(struct xsc_adapter *adapter,
+			     struct rtnl_link_stats64 *s);
+
+#endif /* XSC_EN_STATS_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
new file mode 100644
index 000000000..8d14f943e
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_RXTX_H
+#define __XSC_RXTX_H
+
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+#include "xsc_eth.h"
+
+enum {
+	XSC_ETH_WQE_NONE_CSUM,
+	XSC_ETH_WQE_INNER_CSUM,
+	XSC_ETH_WQE_OUTER_CSUM,
+	XSC_ETH_WQE_INNER_AND_OUTER_CSUM,
+};
+
+void xsc_cq_notify_hw_rearm(struct xsc_cq *cq);
+void xsc_cq_notify_hw(struct xsc_cq *cq);
+int xsc_eth_napi_poll(struct napi_struct *napi, int budget);
+bool xsc_eth_post_rx_wqes(struct xsc_rq *rq);
+void xsc_eth_handle_rx_cqe(struct xsc_cqwq *cqwq,
+			   struct xsc_rq *rq, struct xsc_cqe *cqe);
+void xsc_eth_dealloc_rx_wqe(struct xsc_rq *rq, u16 ix);
+struct sk_buff *xsc_skb_from_cqe_linear(struct xsc_rq *rq,
+					struct xsc_wqe_frag_info *wi,
+					u32 cqe_bcnt, u8 has_pph);
+struct sk_buff *xsc_skb_from_cqe_nonlinear(struct xsc_rq *rq,
+					   struct xsc_wqe_frag_info *wi,
+					   u32 cqe_bcnt, u8 has_pph);
+int xsc_poll_rx_cq(struct xsc_cq *cq, int budget);
+
+netdev_tx_t xsc_eth_xmit_start(struct sk_buff *skb, struct net_device *netdev);
+
+static inline void xsc_tx_dma_unmap(struct device *dev, struct xsc_sq_dma *dma)
+{
+	switch (dma->type) {
+	case XSC_DMA_MAP_SINGLE:
+		dma_unmap_single(dev, dma->addr, dma->size, DMA_TO_DEVICE);
+		break;
+	case XSC_DMA_MAP_PAGE:
+		dma_unmap_page(dev, dma->addr, dma->size, DMA_TO_DEVICE);
+		break;
+	default:
+		break;
+	}
+}
+
+static inline struct xsc_sq_dma *xsc_dma_get(struct xsc_sq *sq, u32 i)
+{
+	return &sq->db.dma_fifo[i & sq->dma_fifo_mask];
+}
+
+static inline bool xsc_wqc_has_room_for(struct xsc_wq_cyc *wq,
+					u16 cc, u16 pc, u16 n)
+{
+	return (xsc_wq_cyc_ctr2ix(wq, cc - pc) >= n) || (cc == pc);
+}
+
+static inline struct xsc_cqe *xsc_cqwq_get_cqe_buff(struct xsc_cqwq *wq, u32 ix)
+{
+	struct xsc_cqe *cqe = xsc_frag_buf_get_wqe(&wq->fbc, ix);
+
+	return cqe;
+}
+
+static inline struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
+{
+	u32 ci = xsc_cqwq_get_ci(wq);
+	u8 cqe_ownership_bit;
+	struct xsc_cqe *cqe;
+	u8 sw_ownership_val;
+
+	cqe = xsc_cqwq_get_cqe_buff(wq, ci);
+
+	cqe_ownership_bit = !!(le32_to_cpu(cqe->data1) & XSC_CQE_OWNER);
+	sw_ownership_val = xsc_cqwq_get_wrap_cnt(wq) & 1;
+
+	if (cqe_ownership_bit != sw_ownership_val)
+		return NULL;
+
+	/* ensure cqe content is read after cqe ownership bit */
+	dma_rmb();
+
+	return cqe;
+}
+
+#endif /* XSC_RXTX_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
new file mode 100644
index 000000000..b69a4e373
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd. All
+ * rights reserved.
+ * Copyright (c) 2013-2015, Mellanox Technologies, Ltd.  All rights reserved.
+ */
+
+#include "xsc_eth_wq.h"
+#include "xsc_eth.h"
+
+u32 xsc_wq_cyc_get_size(struct xsc_wq_cyc *wq)
+{
+	return (u32)wq->fbc.sz_m1 + 1;
+}
+
+static u32 wq_get_byte_sz(u8 log_sz, u8 log_stride)
+{
+	return ((u32)1 << log_sz) << log_stride;
+}
+
+int xsc_eth_cqwq_create(struct xsc_core_device *xdev,
+			struct xsc_wq_param *param,
+			u8 q_log_size,
+			u8 ele_log_size,
+			struct xsc_cqwq *wq,
+			struct xsc_wq_ctrl *wq_ctrl)
+{
+	u8 log_wq_stride = ele_log_size;
+	u8 log_wq_sz     = q_log_size;
+	int err;
+
+	err = xsc_core_frag_buf_alloc_node(xdev,
+					   wq_get_byte_sz(log_wq_sz,
+							  log_wq_stride),
+					   &wq_ctrl->buf,
+					   param->buf_numa_node);
+	if (err) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "xsc_core_frag_buf_alloc_node failed, %d\n", err);
+		return err;
+	}
+
+	xsc_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, &wq->fbc);
+	wq_ctrl->xdev = xdev;
+	return 0;
+}
+
+int xsc_eth_wq_cyc_create(struct xsc_core_device *xdev,
+			  struct xsc_wq_param *param,
+			  u8 q_log_size,
+			  u8 ele_log_size,
+			  struct xsc_wq_cyc *wq,
+			  struct xsc_wq_ctrl *wq_ctrl)
+{
+	struct xsc_frag_buf_ctrl *fbc = &wq->fbc;
+	u8 log_wq_stride = ele_log_size;
+	u8 log_wq_sz = q_log_size;
+	int err;
+
+	err = xsc_core_frag_buf_alloc_node(xdev,
+					   wq_get_byte_sz(log_wq_sz,
+							  log_wq_stride),
+					   &wq_ctrl->buf,
+					   param->buf_numa_node);
+	if (err) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "xsc_core_frag_buf_alloc_node failed, %d\n", err);
+		return err;
+	}
+
+	xsc_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, fbc);
+	wq->sz = xsc_wq_cyc_get_size(wq);
+	wq_ctrl->xdev = xdev;
+	return 0;
+}
+
+void xsc_eth_wq_destroy(struct xsc_wq_ctrl *wq_ctrl)
+{
+	xsc_core_frag_buf_free(wq_ctrl->xdev, &wq_ctrl->buf);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
new file mode 100644
index 000000000..01cee9fd1
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
@@ -0,0 +1,185 @@
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
+	__be32			  *db;
+	u32			  cc; /* consumer counter */
+};
+
+enum xsc_res_type {
+	XSC_RES_RQ,
+	XSC_RES_SQ,
+};
+
+u32 xsc_wq_cyc_get_size(struct xsc_wq_cyc *wq);
+
+/*api for eth driver*/
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
+static inline void xsc_init_fbc_offset(struct xsc_buf_list *frags,
+				       u8 log_stride, u8 log_sz,
+				       u16 strides_offset,
+				       struct xsc_frag_buf_ctrl *fbc)
+{
+	fbc->frags      = frags;
+	fbc->log_stride = log_stride;
+	fbc->log_sz     = log_sz;
+	fbc->sz_m1	= (1 << fbc->log_sz) - 1;
+	fbc->log_frag_strides = PAGE_SHIFT - fbc->log_stride;
+	fbc->frag_sz_m1	= (1 << fbc->log_frag_strides) - 1;
+	fbc->strides_offset = strides_offset;
+}
+
+static inline void xsc_init_fbc(struct xsc_buf_list *frags,
+				u8 log_stride, u8 log_sz,
+				struct xsc_frag_buf_ctrl *fbc)
+{
+	xsc_init_fbc_offset(frags, log_stride, log_sz, 0, fbc);
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
+static inline u32
+xsc_frag_buf_get_idx_last_contig_stride(struct xsc_frag_buf_ctrl *fbc, u32 ix)
+{
+	u32 last_frag_stride_idx = (ix + fbc->strides_offset) | fbc->frag_sz_m1;
+
+	return min_t(u32, last_frag_stride_idx - fbc->strides_offset,
+		     fbc->sz_m1);
+}
+
+static inline int xsc_wq_cyc_missing(struct xsc_wq_cyc *wq)
+{
+	return wq->sz - wq->cur_sz;
+}
+
+static inline int xsc_wq_cyc_is_empty(struct xsc_wq_cyc *wq)
+{
+	return !wq->cur_sz;
+}
+
+static inline void xsc_wq_cyc_push(struct xsc_wq_cyc *wq)
+{
+	wq->wqe_ctr++;
+	wq->cur_sz++;
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
+static inline u16 xsc_wq_cyc_get_tail(struct xsc_wq_cyc *wq)
+{
+	return xsc_wq_cyc_ctr2ix(wq, wq->wqe_ctr - wq->cur_sz);
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
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pp.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pp.h
new file mode 100644
index 000000000..cc9eec866
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pp.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_PP_H
+#define __XSC_PP_H
+
+enum {
+	XSC_HASH_FIELD_SEL_SRC_IP	= BIT(0),
+	XSC_HASH_FIELD_SEL_PROTO	= BIT(1),
+	XSC_HASH_FIELD_SEL_DST_IP	= BIT(2),
+	XSC_HASH_FIELD_SEL_SPORT	= BIT(3),
+	XSC_HASH_FIELD_SEL_DPORT	= BIT(4),
+	XSC_HASH_FIELD_SEL_SRC_IPV6	= BIT(5),
+	XSC_HASH_FIELD_SEL_DST_IPV6	= BIT(6),
+	XSC_HASH_FIELD_SEL_SPORT_V6	= BIT(7),
+	XSC_HASH_FIELD_SEL_DPORT_V6	= BIT(8),
+};
+
+#define XSC_HASH_IP		(XSC_HASH_FIELD_SEL_SRC_IP	|\
+				XSC_HASH_FIELD_SEL_DST_IP	|\
+				XSC_HASH_FIELD_SEL_PROTO)
+#define XSC_HASH_IP_PORTS	(XSC_HASH_FIELD_SEL_SRC_IP	|\
+				XSC_HASH_FIELD_SEL_DST_IP	|\
+				XSC_HASH_FIELD_SEL_SPORT	|\
+				XSC_HASH_FIELD_SEL_DPORT	|\
+				XSC_HASH_FIELD_SEL_PROTO)
+#define XSC_HASH_IP6		(XSC_HASH_FIELD_SEL_SRC_IPV6	|\
+				XSC_HASH_FIELD_SEL_DST_IPV6	|\
+				XSC_HASH_FIELD_SEL_PROTO)
+#define XSC_HASH_IP6_PORTS	(XSC_HASH_FIELD_SEL_SRC_IPV6	|\
+				XSC_HASH_FIELD_SEL_DST_IPV6	|\
+				XSC_HASH_FIELD_SEL_SPORT_V6	|\
+				XSC_HASH_FIELD_SEL_DPORT_V6	|\
+				XSC_HASH_FIELD_SEL_PROTO)
+
+#endif /* __XSC_PP_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h
new file mode 100644
index 000000000..cc544df2c
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_PPH_H
+#define __XSC_PPH_H
+
+#define XSC_PPH_HEAD_LEN	64
+
+#define OUTER_L3_BIT	BIT(3)
+#define OUTER_L4_BIT	BIT(2)
+#define INNER_L3_BIT	BIT(1)
+#define INNER_L4_BIT	BIT(0)
+#define OUTER_BIT		(OUTER_L3_BIT | OUTER_L4_BIT)
+#define INNER_BIT		(INNER_L3_BIT | INNER_L4_BIT)
+#define OUTER_AND_INNER	(OUTER_BIT | INNER_BIT)
+
+#define PACKET_UNKNOWN	BIT(4)
+
+#define EPP2SOC_PPH_EXT_TUNNEL_TYPE_OFFSET (6UL)
+#define EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_MASK (0XF00)
+#define EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_OFFSET (8)
+
+#define EPP2SOC_PPH_EXT_ERROR_BITMAP_OFFSET (20UL)
+#define EPP2SOC_PPH_EXT_ERROR_BITMAP_BIT_MASK (0XFF)
+#define EPP2SOC_PPH_EXT_ERROR_BITMAP_BIT_OFFSET (0)
+
+#define XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(PPH_BASE_ADDR)	\
+	((*(u16 *)((u8 *)(PPH_BASE_ADDR) +	\
+	EPP2SOC_PPH_EXT_TUNNEL_TYPE_OFFSET) &	\
+	EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_MASK) >>	\
+	EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_OFFSET)
+
+#define XSC_GET_EPP2SOC_PPH_ERROR_BITMAP(PPH_BASE_ADDR)	\
+	((*(u8 *)((u8 *)(PPH_BASE_ADDR) +	\
+	EPP2SOC_PPH_EXT_ERROR_BITMAP_OFFSET) &	\
+	EPP2SOC_PPH_EXT_ERROR_BITMAP_BIT_MASK) >>	\
+	EPP2SOC_PPH_EXT_ERROR_BITMAP_BIT_OFFSET)
+
+#endif /* __XSC_PPH_H */
+
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
new file mode 100644
index 000000000..49c3229e8
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
@@ -0,0 +1,185 @@
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
+enum {
+	XSC_SEND_WQE_DS	= 16,
+	XSC_SEND_WQE_BB	= 64,
+};
+
+enum {
+	XSC_RECV_WQE_DS	= 16,
+	XSC_RECV_WQE_BB	= 16,
+};
+
+enum {
+	XSC_ETH_RQ_STATE_ENABLED,
+};
+
+#define XSC_SEND_WQEBB_CTRL_NUM_DS	1
+
+/* each ds holds one fragment in skb */
+#define XSC_MAX_RX_FRAGS        4
+#define XSC_RX_FRAG_SZ_ORDER    0
+#define XSC_RX_FRAG_SZ          (PAGE_SIZE << XSC_RX_FRAG_SZ_ORDER)
+#define DEFAULT_FRAG_SIZE       (2048)
+
+enum {
+	XSC_ETH_SQ_STATE_ENABLED,
+};
+
+struct xsc_cq {
+	/* data path - accessed per cqe */
+	struct xsc_cqwq	wq;
+
+	/* data path - accessed per napi poll */
+	u16			event_ctr;
+	struct napi_struct	*napi;
+	struct xsc_core_cq	xcq;
+	struct xsc_channel	*channel;
+
+	/* control */
+	struct xsc_core_device	*xdev;
+	struct xsc_wq_ctrl	wq_ctrl;
+} ____cacheline_aligned_in_smp;
+
+struct xsc_wqe_frag_info {
+	struct xsc_dma_info *di;
+	u32 offset;
+	u8 last_in_page;
+	u8 is_available;
+};
+
+struct xsc_dma_info {
+	struct page	*page;
+	dma_addr_t	addr;
+};
+
+struct xsc_rq_frag_info {
+	int frag_size;
+	int frag_stride;
+};
+
+struct xsc_rq_frags_info {
+	struct xsc_rq_frag_info arr[XSC_MAX_RX_FRAGS];
+	u8 num_frags;
+	u8 log_num_frags;
+	u8 wqe_bulk;
+	u8 wqe_bulk_min;
+	u8 frags_max_num;
+};
+
+struct xsc_rq;
+typedef void (*xsc_fp_handle_rx_cqe)(struct xsc_cqwq *cqwq, struct xsc_rq *rq,
+				     struct xsc_cqe *cqe);
+typedef bool (*xsc_fp_post_rx_wqes)(struct xsc_rq *rq);
+typedef void (*xsc_fp_dealloc_wqe)(struct xsc_rq *rq, u16 ix);
+typedef struct sk_buff * (*xsc_fp_skb_from_cqe)(struct xsc_rq *rq,
+						struct xsc_wqe_frag_info *wi,
+						u32 cqe_bcnt,
+						u8 has_pph);
+
+struct xsc_rq {
+	struct xsc_core_qp		cqp;
+	struct {
+		struct xsc_wq_cyc	wq;
+		struct xsc_wqe_frag_info	*frags;
+		struct xsc_dma_info	*di;
+		struct xsc_rq_frags_info	info;
+		xsc_fp_skb_from_cqe	skb_from_cqe;
+	} wqe;
+
+	struct {
+		u16	headroom;
+		u8	map_dir;	/* dma map direction */
+	} buff;
+
+	struct page_pool	*page_pool;
+	struct xsc_wq_ctrl	wq_ctrl;
+	struct xsc_cq		cq;
+	u32	rqn;
+	int	ix;
+
+	unsigned long	state;
+	struct xsc_rq_stats *stats;
+
+	u32 hw_mtu;
+	u32 frags_sz;
+
+	xsc_fp_handle_rx_cqe	handle_rx_cqe;
+	xsc_fp_post_rx_wqes	post_wqes;
+	xsc_fp_dealloc_wqe	dealloc_wqe;
+} ____cacheline_aligned_in_smp;
+
+enum xsc_dma_map_type {
+	XSC_DMA_MAP_SINGLE,
+	XSC_DMA_MAP_PAGE
+};
+
+struct xsc_sq_dma {
+	dma_addr_t	addr;
+	u32		size;
+	enum xsc_dma_map_type	type;
+};
+
+struct xsc_tx_wqe_info {
+	struct sk_buff *skb;
+	u32 num_bytes;
+	u8  num_wqebbs;
+	u8  num_dma;
+};
+
+struct xsc_tx_wqe {
+	struct xsc_send_wqe_ctrl_seg ctrl;
+	struct xsc_wqe_data_seg data[];
+};
+
+struct xsc_sq {
+	struct xsc_core_qp		cqp;
+	/* dirtied @completion */
+	u16                        cc;
+	u32                        dma_fifo_cc;
+
+	/* dirtied @xmit */
+	u16                        pc ____cacheline_aligned_in_smp;
+	u32                        dma_fifo_pc;
+
+	struct xsc_cq            cq;
+
+	/* read only */
+	struct xsc_wq_cyc         wq;
+	u32                        dma_fifo_mask;
+	struct xsc_sq_stats     *stats;
+	struct {
+		struct xsc_sq_dma         *dma_fifo;
+		struct xsc_tx_wqe_info    *wqe_info;
+	} db;
+	void __iomem              *uar_map;
+	struct netdev_queue       *txq;
+	u32                        sqn;
+	u16                        stop_room;
+
+	__be32                     mkey_be;
+	unsigned long              state;
+	unsigned int               hw_mtu;
+
+	/* control path */
+	struct xsc_wq_ctrl        wq_ctrl;
+	struct xsc_channel         *channel;
+	int                        ch_ix;
+	int                        txq_ix;
+} ____cacheline_aligned_in_smp;
+
+#endif /* __XSC_QUEUE_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 5c947da2a..b01fca3ac 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o alloc.o eq.o pci_irq.o adev.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c b/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c
new file mode 100644
index 000000000..5118ff36b
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+
+u8 xsc_core_query_vport_state(struct xsc_core_device *xdev, u16 vport)
+{
+	struct xsc_query_vport_state_out out;
+	struct xsc_query_vport_state_in in;
+	u32 val = 0;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_VPORT_STATE);
+	val |= FIELD_PREP(XSC_QUERY_VPORT_VPORT_NUM_MASK, vport);
+	if (vport)
+		val |= XSC_QUERY_VPORT_OTHER_VPORT;
+	in.data0 = cpu_to_be32(val);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev, "failed to query vport state, err=%d, status=%d\n",
+			err, out.hdr.status);
+		return err;
+	}
+
+	return out.state;
+}
+EXPORT_SYMBOL_GPL(xsc_core_query_vport_state);
