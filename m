Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807865;
	b=Ra3aApCC1r7bRF+bYCA3nbGFxmFMO3UNNcEgJLRaX1GXHzzvsEcAdpT6ESlTX0iiRqVa
	 W8gaTzHkpgBhXYlKrfISiQJnN+yIc0Pnzav0pk5Yw2QYFZJ96TDfxxM+iCBkyfxSQFADl
	 QkSsdxOofMhM4M3Xz2z3sC7CLEmLUFWhSiPsb/9PxtV8j3swWDRhljOj3h2xwGOWkj8q2
	 PFXKL7LbeYchpSg8PO/cy4j0+zbFCJYMVe56nhP9M8aqM0KmLxioZeATC3BLITyRvSFt1
	 YZxFqgnxyv0ZPfiXTQ1f93Zx3JHoBZz0HboVo6dp0Uom5i9t3OS6RlyKV+yMr6XYs8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807865;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:Cc:Date:
	 X-Mailer:From:X-Lms-Return-Path:Mime-Version:X-Original-From:To:
	 Subject:Content-Type:Message-Id:Received;
	bh=Cbvl4XrHqsS/gy9odxBDB3pH6rTMzMbXJj3Iel152dU=;
	b=Xp6eKs8zDsYEB8dROZ9lWoYU2v5FBHFZrYIjwG4cl+otxh8CQJIJjncd8mIYxeZ0H/aq
	 PbaQI1e3pjL6UnQ64XIiftq0rzGxdvmSP+tJ8RP7Wtp5BYjllUTAoV6+CHz5wAOpdQxuv
	 33Zn+g00RAfkSIXDUXdPi2U0okKIJUpDoA9TDrYDcQTeoJ6W9D7A94kNOY9ZEfs/m9dfp
	 UR/qSn21j7vGcqoOYgslPFF1HT0LHbp9tjeM9O6jbFdJubH62h7ECGM4WI/tV2r7jkvux
	 gWXbuwL2ir3FSkeMqydGy5LuCpzhVtnpzZ3G4hY6bn7H15mRIq7p9XQPWO1HdM/5VLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=AmKtp6af;
	arc=none smtp.remote-ip=209.127.231.37
Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EA6606EE9D
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85EA6606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=AmKtp6af
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807853; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Cbvl4XrHqsS/gy9odxBDB3pH6rTMzMbXJj3Iel152dU=;
 b=AmKtp6afnxVIM591mz831P1uJSLO/H91NEvO6f0Z9G87hN3XMeeg1G5PRZgSlBOdQE6VAQ
 yJEdtQrnfk1eEx//L1ePGiKsYG07m6Yzr4qUSozhgrZpGOXHt4kPQlIkP6UWdPVLEkG8Du
 XABbCqNDi+1QCl3F0G4GNcFZ0SGqy4Wm9J7n1k5h2AlNynKcGuHzd/hAU1Jg5uB1se/Mc5
 Wfn7AsV3njH15UepAcEbZmwOvmLJ7LoMDZRXEaYYKPNMFPEYL17by3BM53yFRr1LYtOGcV
 nPaE919kofSdIMOErvMK0kUDjPx9UUoHXsmG1/LeE5JFWMMlc17sQY47xTHLaw==
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Wed, 04 Nov 2026 23:57:31 +0800
X-Mailer: git-send-email 2.25.1
From: "Xin Tian" <tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26aeb55eb+a583c8+vger.kernel.org+tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Subject: [PATCH v1 00/15] Yunsilicon XSC ethernet and RDMA drivers
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261104155650.37053-1-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:31 +0800

Hi all,

This is a new submission from Yunsilicon to upstream our converged
network adapter driver.  The hardware is a dual-function PCIe device
(PCI vendor 0x1f67) that supports both ethernet and RDMA operations.

The series adds three drivers, which share the xsc prefix.  A shared PCI
core driver binds to the physical function, brings up the command queue,
the event queues and the interrupt handling, and publishes one auxiliary
device per function.  The ethernet and RDMA drivers bind to that
auxiliary device instead of driving the PCI function themselves, so the
two personalities share a single probe and resource set.

  1. xsc_pci - the PCI core driver (CONFIG_YUNSILICON_XSC_PCI).
     Owns the PCI function, the command queue, the event queues, the
     interrupt vectors, the register access layer and the CQ/QP/SRQ
     resource pools.  Patches 02-06.

  2. xsc_eth - the ethernet driver (CONFIG_YUNSILICON_XSC_ETH).
     Registers the netdev, implements the TX/RX packet paths with NAPI
     and page_pool, RSS, checksum offloads and statistics.  Patches
     07-09, on top of the core.

  3. xsc_ib - the RDMA driver (CONFIG_INFINIBAND_XSC).
     Registers the ib_device and provides the PD/MR, CQ/SRQ/AH and QP
     verbs including the send/receive data paths, plus RDMA counters and
     sysfs attributes.  Patches 10-15, on top of the core and the
     ethernet driver (the netdev supplies port state and GID).

Patch 01 adds the MAINTAINERS entry.

The series is split so that every commit builds: the core patches
introduce the register access, the command queue, the event queues and
the resource pools incrementally, and the ethernet and RDMA patches only
start creating queues once their dependencies are in place.  Patch 06
(core CQ/QP pools) is deliberately shared by both upper drivers; that is
why it precedes the ethernet patches.

The RDMA device is registered at patch 10, before all verbs exist, so
kverbs_provider stays false until the last mandatory verb (post_send)
appears in patch 14.  This keeps each intermediate tree compilable.

Please review.

Thanks,
Xin Tian

Changes since v0 (https://lore.kernel.org/netdev/20261012114352.2471317-1-tianx@yunsilicon.com/):
- Register access helpers take explicit u32 values instead of void *
  and memcpy (patch 3).
- Dropped the one-line xsc_free_cmd() wrapper (patch 4).
- Dropped the redundant memsets and comments in query_device, the
  redundant rdma_roce_rescan_device() call and stray blank lines
  (patch 10).
- Derived port state with ib_get_curr_port_state() and MTU with
  iboe_get_mtu() instead of open-coding both (patch 10).
- Replaced the driver's get_netdev op and netdevice notifier with
  ib_device_set_netdev() and the core's event handling (patch 10).
- Stopped replicating the core's private ib_mad structures (patch 10).
- Ran Sashiko locally and fixed or triaged the findings.

Xin Tian (15):
  MAINTAINERS: add the Yunsilicon XSC drivers
  net/xsc: add PCI core driver skeleton
  net/xsc: add the register HAL
  net/xsc: add the command queue
  net/xsc: add event queues, interrupts and the auxiliary bus
  net/xsc: add the CQ and QP resource pools
  net/xsc: add ethernet netdev registration
  net/xsc: add ethernet TX path
  net/xsc: add ethernet RX path and statistics
  RDMA/xsc: add RDMA device support
  RDMA/xsc: add RDMA PD/MR
  RDMA/xsc: add RDMA CQ/SRQ/AH
  RDMA/xsc: add QP verbs
  RDMA/xsc: add the RDMA send path
  RDMA/xsc: add RDMA counters and sysfs

 MAINTAINERS                                   |    9 +
 drivers/infiniband/Kconfig                    |    1 +
 drivers/infiniband/hw/Makefile                |    1 +
 drivers/infiniband/hw/xsc/Kconfig             |   17 +
 drivers/infiniband/hw/xsc/Makefile            |   10 +
 drivers/infiniband/hw/xsc/ah.c                |  144 +
 drivers/infiniband/hw/xsc/counters.c          |  134 +
 drivers/infiniband/hw/xsc/cq.c                |  954 +++++++
 drivers/infiniband/hw/xsc/main.c              |  801 ++++++
 drivers/infiniband/hw/xsc/mem.c               |  160 ++
 drivers/infiniband/hw/xsc/mr.c                |  335 +++
 drivers/infiniband/hw/xsc/qp.c                | 2347 +++++++++++++++++
 drivers/infiniband/hw/xsc/srq.c               |  462 ++++
 drivers/infiniband/hw/xsc/xsc_ib.h            |  489 ++++
 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c      |   50 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/yunsilicon/Kconfig       |   26 +
 drivers/net/ethernet/yunsilicon/Makefile      |    8 +
 .../net/ethernet/yunsilicon/xsc/common/cq.h   |   26 +
 .../ethernet/yunsilicon/xsc/common/driver.h   |   95 +
 .../net/ethernet/yunsilicon/xsc/common/qp.h   |  104 +
 .../net/ethernet/yunsilicon/xsc/common/srq.h  |   54 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmd.h  | 1025 +++++++
 .../yunsilicon/xsc/common/xsc_cmd_api.h       |   25 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmdq.h |  192 ++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  663 +++++
 .../yunsilicon/xsc/common/xsc_device.h        |   94 +
 .../ethernet/yunsilicon/xsc/common/xsc_hsi.h  |  123 +
 .../ethernet/yunsilicon/xsc/common/xsc_reg.h  |   28 +
 .../net/ethernet/yunsilicon/xsc/net/Kconfig   |   17 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |    9 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 1742 ++++++++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_eth.h |   43 +
 .../yunsilicon/xsc/net/xsc_eth_common.h       |  123 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_rx.c  |  556 ++++
 .../yunsilicon/xsc/net/xsc_eth_stats.c        |   40 +
 .../yunsilicon/xsc/net/xsc_eth_stats.h        |   35 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_tx.c  |  345 +++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         |  156 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         |   92 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.c  |   80 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.h  |  185 ++
 .../net/ethernet/yunsilicon/xsc/net/xsc_pp.h  |   38 +
 .../net/ethernet/yunsilicon/xsc/net/xsc_pph.h |   42 +
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   |  183 ++
 .../net/ethernet/yunsilicon/xsc/pci/Kconfig   |   15 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   10 +
 .../net/ethernet/yunsilicon/xsc/pci/adev.c    |  142 +
 .../net/ethernet/yunsilicon/xsc/pci/adev.h    |   17 +
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   |  237 ++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.h   |   17 +
 .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1244 +++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  |  319 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h  |   17 +
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  |  318 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h  |   39 +
 .../yunsilicon/xsc/pci/hal/andes_impl.c       |  629 +++++
 .../yunsilicon/xsc/pci/hal/andes_reg.h        |   43 +
 .../ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h |   60 +
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  316 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
 .../net/ethernet/yunsilicon/xsc/pci/link.c    |   34 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  350 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.c  |  202 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.h  |   18 +
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.c |  493 ++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.h |   18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.c  |   49 +
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.h  |   14 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c  |  355 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |   28 +
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.c |   92 +
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.h |   16 +
 .../net/ethernet/yunsilicon/xsc/pci/vport.c   |   36 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |    1 +
 include/uapi/rdma/xsc-abi.h                   |  290 ++
 77 files changed, 17502 insertions(+)
 create mode 100644 drivers/infiniband/hw/xsc/Kconfig
 create mode 100644 drivers/infiniband/hw/xsc/Makefile
 create mode 100644 drivers/infiniband/hw/xsc/ah.c
 create mode 100644 drivers/infiniband/hw/xsc/counters.c
 create mode 100644 drivers/infiniband/hw/xsc/cq.c
 create mode 100644 drivers/infiniband/hw/xsc/main.c
 create mode 100644 drivers/infiniband/hw/xsc/mem.c
 create mode 100644 drivers/infiniband/hw/xsc/mr.c
 create mode 100644 drivers/infiniband/hw/xsc/qp.c
 create mode 100644 drivers/infiniband/hw/xsc/srq.c
 create mode 100644 drivers/infiniband/hw/xsc/xsc_ib.h
 create mode 100644 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c
 create mode 100644 drivers/net/ethernet/yunsilicon/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/driver.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/qp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/srq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd_api.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_device.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_hsi.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_pp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/link.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/main.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/mr.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/mr.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pd.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/srq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/srq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/vport.c
 create mode 100644 include/uapi/rdma/xsc-abi.h

-- 
2.18.4
