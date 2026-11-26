Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705074;
	b=YbCvHTNQjepfwn70wWcG/cHO4P1etNPD5nhW8DV96wDx+j+HFB2hi6KgSqaAt52BQUsu
	 yfQ4vTcmP6HHCCQSiAnqgWBIYmF/8dn/C+A9b+EMo9CxnQQPKmFX3rgwCS8k0ScIyZybj
	 YYsZ8F3kcJusRkt5mGLDtd+nXHEbpvf1+lfe7yZhb1z1Z0gFmLXaVMXEgJjk2GaiWgzlY
	 rWbiY5Qu+YVvsRQxr3XbCT1x2nFef2dv8AsxsuMiLEgfJrX0aP8Hd+O+RRGK8J1E9+AN6
	 d8cbvyaFglJ1TgmqUFEuY8Da2RTArZ9vZ+Lmg9quf4JsFn0aA0a3/998CYs/g8xvf/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705074;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:Received:Date:
	 Content-Transfer-Encoding:Cc:From:Subject:Content-Type:
	 X-Lms-Return-Path:X-Mailer:To:Message-Id:X-Original-From;
	bh=0LTdOK9tx9CP0JabyqH2MvjVufp0ukif7P+g3Z1t9wM=;
	b=g1APnEA4tcLR2C6FcZGDkGR361ed9tZROUq++BTw3XHbCfO+jleT4tdEx059z8Wud1WC
	 T8ujcbUDu126NSGNAhgpknl+FqA/ulJUkx9k1QuhNMuNUiUJkf7BmonQNRn8xhIGoo4Cm
	 Kw0ktZG0XPPOEekiRXDq+fdQHv3pdq7UpchVSRzBUoV2YtZCYYBrkrRtkbytgwAL36LHW
	 sqgY/EFIAR9y++lQhDbB3LXN1/KkgIPGqgZHHy63NuzqDDgMG29BmBIiDocsXzcEJ2b24
	 pZA/0VskEmFdq4vtnzrQTx6qu37w0tr1J2N3W0Ctvjnf95iIxf/r1GqwnzQ3deOdTLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=XTNpCxVO;
	arc=none smtp.remote-ip=209.127.231.57
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D460A3809
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A1D460A3809
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=XTNpCxVO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705069; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0LTdOK9tx9CP0JabyqH2MvjVufp0ukif7P+g3Z1t9wM=;
 b=XTNpCxVOBjAzB6VIUnxipHJxJn8BE+EP+r2qmsBXQX4H/BYNa8poeC8Ro4hFHmFQntldFg
 /QzmeU7yN96hs/d/WB/tsQv4ScaXPfE/Wv56hu6oxiD5oKN7jAfJZ44+HW5CfrkH3rbJwG
 xo0VFx0tQQ3b5id4kCrGKa6+nAjTrCqPCTxne7lHsGKkBUqYrgQmRVZiqPnwfZrWDD0vkB
 ry8XIpJ7IvEjKbkmpbZcquMr4Q+bBDzkdLY7MiF/o1/7qP6P+A3P1mQoB0UCIR1ZiNPxr1
 tkgUobN8q5s61teXcRSj7R8B9WZRIiNs7aSs6ttPrhgcla4pRKqzwFrVvQ02Lg==
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:47 +0800
Date: Thu, 26 Nov 2026 22:57:47 +0800
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH v2 00/11] net/xsc: add the Yunsilicon XSC ethernet driver
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26b0848eb+18bc7a+vger.kernel.org+tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Message-Id: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>

This is the first series of v2 for the Yunsilicon XSC converged network
adapter (PCI vendor 0x1f67).  Responding to the review of v1, this is a
much smaller, self-contained ethernet-only driver: about 5.7k added
lines, down from the combined ethernet and RDMA driver in v1.

The driver is split into the same two modules as before, which share the
xsc prefix and talk over the auxiliary bus:

  1. xsc_pci (CONFIG_YUNSILICON_XSC_PCI) - the PCI core driver.  Owns the
     PCI function, the command queue, the event queues, MSI-X and the
     CQ/QP resource pools, and publishes one auxiliary device per PF.
     Patches 01-06.

  2. xsc_eth (CONFIG_YUNSILICON_XSC_ETH) - the ethernet driver.  Binds to
     the auxiliary device, registers the netdev, brings up a single TX/RX
     queue pair with NAPI and page_pool, and tracks the link state from
     the port events.  Patches 07-11.

Patch 01 adds the MAINTAINERS entry together with the Kbuild plumbing.

To keep the series within the requested size, this first series
deliberately omits RDMA, statistics, offloads (TSO/checksum), RSS and the
configuration interfaces (ethtool, module parameters, ndo_change_mtu).
Only the compressed-BAR PF form of the hardware is supported.  These will
be submitted as follow-up series once the base driver is accepted.

The series is split so that every patch builds cleanly with GCC 8.3.1 and
W=1.  The core patches add the command queue, capabilities, event queues
and resource pools incrementally, and the ethernet patches register the
netdev first, then add the channel and link handling, and finally the TX
and RX data paths.

Changes since v1:
- Split the combined ethernet+RDMA driver into a minimal ethernet-only
  first series, about 5.7k added lines instead of 10k, as requested.

Addressing the netdev review of the v1 netdev patch:
- Register the link event handler before register_netdevice(), keying the
  interface off xdev->eth_priv which is set before registration.
- Use ether_addr_copy() to copy the firmware MAC address.zaizuo
- Drop the unreachable NULL checks in the remove path.
- Move xsc_cqwq_get_cqe() out of the header into xsc_eth_txrx.c.
- Drop the unreachable "already opened"/"not opened" branches in
  ndo_open()/ndo_stop(); the netdev core serialises these via rtnl.
- Keep xsc_set_port_admin_status() void: it runs after open/close, a
  rejected call is legitimate (VF, port_link_en, multi-function
  arbitration, old firmware), and the real carrier comes from the link
  events and QUERY_VPORT_STATE, so we log and carry on.

Xin Tian (11):
  net/xsc: add Yunsilicon XSC ethernet PCI driver skeleton
  net/xsc: add doorbell and cmdq MMIO accessors
  net/xsc: add the command queue
  net/xsc: query HCA capabilities and reset function resources
  net/xsc: add event queues and MSI-X
  net/xsc: add CQ and QP helpers
  net/xsc: add the ethernet netdev
  net/xsc: add the single TX/RX channel
  net/xsc: report link state changes
  net/xsc: add the transmit path
  net/xsc: add the receive path

 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/yunsilicon/Kconfig       |   27 +
 drivers/net/ethernet/yunsilicon/Makefile      |    9 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmd.h  |  560 ++++++++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  311 +++++
 .../ethernet/yunsilicon/xsc/common/xsc_reg.h  |   23 +
 .../net/ethernet/yunsilicon/xsc/net/Kconfig   |   17 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |    9 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 1161 +++++++++++++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_eth.h |   33 +
 .../yunsilicon/xsc/net/xsc_eth_common.h       |  117 ++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_rx.c  |  210 +++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_tx.c  |   87 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         |   95 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         |   36 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.c  |   80 ++
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.h  |  150 +++
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   |  103 ++
 .../net/ethernet/yunsilicon/xsc/pci/Kconfig   |   16 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    9 +
 .../net/ethernet/yunsilicon/xsc/pci/adev.c    |  133 ++
 .../net/ethernet/yunsilicon/xsc/pci/adev.h    |   14 +
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   |  225 ++++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.h   |   18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c |  708 ++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h |   87 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  |  130 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h  |   13 +
 .../ethernet/yunsilicon/xsc/pci/doorbell.c    |  148 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  |  300 +++++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h  |   38 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  282 ++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.c |  345 +++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.h |   16 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c  |  180 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |   14 +
 .../net/ethernet/yunsilicon/xsc/pci/vport.c   |   36 +
 39 files changed, 5749 insertions(+)
 create mode 100644 drivers/net/ethernet/yunsilicon/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/doorbell.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/vport.c

-- 
2.43.0
