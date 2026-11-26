Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705066;
	b=ULM3sa3npsoPRFI4TICPLdBnIA4tLHcijdsqWhyHY0FKARVqSe0JB25gFnweUgYrcFjm
	 zLOloKoL1pCt//kvkW3vyCSxog5aavl7yQTmzCIxQrKOoAryWNmNL6c0VP2WXePSOxO4r
	 vyxvHNTsNAq7HrvC2jGxOQpZGZWhGy3+t28H8cBSH5+RZpUPluztTkh5cUxVT27lrVYFv
	 IXnjo0ahwdsDvVbMZXJN54Id9h4Q7YpQ7DAYMD1mm6EtuIsk+G1iZBPAP2hdDrgCMOjpU
	 RrRstXraaHuEdvz+9kIdWMT+Guh52Qu66QK+zvQzQuN06FoaG1DbdzSfxkUBqrCrPVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705066;
	h=DMARC-Filter:DKIM-Signature:Cc:To:Content-Type:X-Mailer:
	 X-Lms-Return-Path:In-Reply-To:Date:X-Original-From:Received:
	 Content-Transfer-Encoding:Subject:Message-Id:Mime-Version:References:
	 From;
	bh=w7QMPRrq3Tkm7OtoVlb9KjCf8cUPPCW4ovIiVQuCYPQ=;
	b=ZDqQplDETomEV/iwmKSgqmn3IHv9waKtoVttWJCfIA0Y8mFcDJp2E45MrfEevkoCP4A2
	 s0SiAmhQKWR9ge/4hD61g1txPEHyoCv6Yg7hu3OJ2UwPzStDoWqCveslHSlJqEo7O25FJ
	 u+ycvNz/MZGgsT0+F+Zl8tdgb7t6cxQ5Bul6Ev+XENL72ZMHovKQFlP4rgFMbHcQioOZ6
	 of2ckTC8axuZ+Gqyv7XzcGupUW9V2qKk3K5e9oWc1l60r38ARamO/gxYpuKESGBL3t8i8
	 t61TEU5A4Zpbnn/nPpu/hqWzUY1FZHIRtV4V3znzoW/+QaPQPx5rY6eBCM6bLWRNb2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=doILHAet;
	arc=none smtp.remote-ip=209.127.231.53
Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DD3606A333
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08DD3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=doILHAet
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705061; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=w7QMPRrq3Tkm7OtoVlb9KjCf8cUPPCW4ovIiVQuCYPQ=;
 b=doILHAetcvmaEAnoSKjOwlieP8Y6EQX0gnUEePJcqLQl3vOlswCTmrATpS1wnUyBn520Fu
 9iXlrnQUBactIQSQsGWBlL5LF9qT7Tpdql8IcGYiwhuWHCwQc6nRhSTdNcdFnsYI9RCg6K
 cH+xFcA7JqwJt1+6BBt82vlE4mXcRGxgJRGOTU9yuKeCDIK6bG8vrkcdkt58JFnvOv6/1a
 vJeaSQtne1PdVyCa8VhsYG3jpKG3tXUX5+ou27JtKVjLB0twnNnurXNVbVrvSElmIEpTS+
 aYM3hVN50yz+OmXVgjdILUql14Gu+p6+ihz7B9WJvhvaorESTZekD/ldopJvMA==
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.25.1
X-Lms-Return-Path: <lba+26b0848e3+37459a+vger.kernel.org+tianx@yunsilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Date: Thu, 26 Nov 2026 22:57:38 +0800
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:38 +0800
Content-Transfer-Encoding: 7bit
Subject: [PATCH v2 09/11] net/xsc: report link state changes
Message-Id: <20261126145736.70868-10-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261126145711.70868-1-tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>

Query the virtual port state and reflect it in the netdev carrier.
Register for the PCI layer's link change event and re-query the port on
each one so carrier tracks the physical link.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  3 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 78 ++++++++++++++++++-
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |  2 +-
 .../net/ethernet/yunsilicon/xsc/pci/vport.c   | 36 +++++++++
 4 files changed, 117 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/vport.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index a72143ae6..cca1fafc8 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -270,6 +270,9 @@ int xsc_core_eth_create_cq(struct xsc_core_device *xdev,
 int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
 			    struct xsc_core_cq *xcq);
 
+int xsc_core_query_vport_state(struct xsc_core_device *xdev, u16 vport,
+			       u8 *state);
+
 /*
  * Link event callback registration. The events are dispatched from the PCI
  * layer's own workqueue; unregister detaches the callback and waits for one
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index 1c7bbc27d..75a6abd6e 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -721,6 +721,62 @@ static void xsc_eth_sw_deinit(struct xsc_adapter *adapter)
 	xsc_eth_close_channels(adapter);
 }
 
+static int xsc_eth_get_link_status(struct xsc_adapter *adapter, bool *link_up)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+	u8 state;
+	int err;
+
+	err = xsc_core_query_vport_state(xdev, 0, &state);
+	if (err)
+		return err;
+
+	*link_up = state;
+	return 0;
+}
+
+static int xsc_eth_change_link_status(struct xsc_adapter *adapter)
+{
+	bool link_up;
+	int err;
+
+	err = xsc_eth_get_link_status(adapter, &link_up);
+	if (err) {
+		netdev_err(adapter->netdev, "failed to query link status, err=%d\n",
+			   err);
+		return err;
+	}
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
 static bool xsc_get_pct_drop_config(struct xsc_core_device *xdev)
 {
 	return (xdev->pdev->device == XSC_MC_PF_DEV_ID) ||
@@ -813,6 +869,7 @@ static void xsc_set_port_admin_status(struct xsc_adapter *adapter,
 static int xsc_eth_open(struct net_device *netdev)
 {
 	struct xsc_adapter *adapter = netdev_priv(netdev);
+	bool link_up;
 	int ret;
 
 	ret = xsc_eth_sw_init(adapter);
@@ -823,6 +880,16 @@ static int xsc_eth_open(struct net_device *netdev)
 	if (ret)
 		goto err_sw_deinit;
 
+	ret = xsc_eth_get_link_status(adapter, &link_up);
+	if (ret) {
+		netdev_warn(netdev, "failed to query link status, err=%d\n", ret);
+	} else if (link_up) {
+		netdev_info(netdev, "Link up\n");
+		netif_carrier_on(adapter->netdev);
+	} else {
+		netdev_info(netdev, "Link down\n");
+	}
+
 	adapter->opened = true;
 
 	xsc_set_port_admin_status(adapter, XSC_PORT_UP);
@@ -1005,14 +1072,18 @@ static int xsc_eth_probe(struct auxiliary_device *adev,
 		goto err_free_netdev;
 	}
 
+	xsc_irq_event_register(xdev, xsc_eth_link_event_handler);
+
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register_netdev failed, err=%d\n", err);
-		goto err_free_netdev;
+		goto err_unregister_event;
 	}
 
 	return 0;
 
+err_unregister_event:
+	xsc_irq_event_unregister(xdev);
 err_free_netdev:
 	xdev->eth_priv = NULL;
 	free_netdev(netdev);
@@ -1026,6 +1097,11 @@ static void xsc_eth_remove(struct auxiliary_device *adev)
 	struct xsc_core_device *xdev = xsc_adev->xdev;
 	struct xsc_adapter *adapter = xdev->eth_priv;
 
+	/* Stop link events reaching this adapter and wait out one already in
+	 * flight, which would otherwise touch the memory freed below.
+	 */
+	xsc_irq_event_unregister(xdev);
+
 	/* Runs ndo_stop(), so the queues and the HCA are shut down first. */
 	unregister_netdev(adapter->netdev);
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 9cdc31f9d..8b22decb4 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o adev.o cmd.o eq.o cq.o qp.o pci_irq.o alloc.o doorbell.o
+xsc_pci-y := main.o adev.o cmd.o eq.o cq.o qp.o vport.o pci_irq.o alloc.o doorbell.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c b/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c
new file mode 100644
index 000000000..8272383b3
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/vport.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+
+int xsc_core_query_vport_state(struct xsc_core_device *xdev, u16 vport,
+			       u8 *state)
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
+	*state = FIELD_GET(XSC_QUERY_VPORT_STATE_MASK, out.state);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_query_vport_state);
-- 
2.43.0
