Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DC4718DF
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805489; cv=none; b=qDKbPvWqVd5+HZB1xyldUsWTqgW9XcQy3DFLDfn6+h0u5R8oOsBJjMABXTXOlZ1ujqM2ujYjIPBH4yJzL0EyTjV8Q8LYvn9d4QZ4TluH3jNMBvkAYqqyKi3GCwcJXvOILdcI0zVHs/AdJ2OC3QWtf1b0UeL/FSxSxy4Fp+Ejax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805489; c=relaxed/simple;
	bh=HToLxxu0WzbsMpSA8kp/jcY9OVKb88lCh+F/zvSnpGY=;
	h=To:Content-Type:Cc:Date:Mime-Version:Subject:Message-Id:From; b=URG5Eav58KnSMDzFjtq5cwPG+2dVLdWvQNTS70L4Sg2kctKC+TRDzE2cSgV+/BMoMebyQcyNd9ryuer7kZjW5QMyw3AbrAGuTKbcZkbjqzIfWIG7DYl7oXk8KsfDOyvwCddiNQfT/CV/Egfp7wKDeL2+zfc7+yuBOzM9iRBS7mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=ON5EVqXV; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="ON5EVqXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805474; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=fly9DHH9Krk5wGnL+DaOoC0lr9tfXVWa7+uz0rxSomU=;
 b=ON5EVqXVJmldZ7l0Z+3ib0y3h8Q2MRrjh1W2BbRmadP4XGZsBBNmbKhhpmfqCqJqF7NRdD
 nj03OfKz83p137u1NzLu+Z+DAYEM7nUwADNVShQ2g1ah7UxKwoFsdQuFrfFFtRhxbfDogL
 PUxmWBBIyA5/SxIKwV7O6ggNj92gRVfDDXV26XCGYEtBE2ru5HeSicTrZOrKWpZ/lLP3B+
 TqtZUeKWkRavjwsSv8BU43h4xo4qVWw+x6kMm0TjAtGm9nD2QxzsMB7Jqps8E+FKZ850AH
 DS/6CNpniYijjWYzhgPi4fIHMoXfOvqKoZSoxKb+OVehR4y5R36vN0GvA6BanQ==
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
X-Lms-Return-Path: <lba+26accc820+ffcb22+vger.kernel.org+tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:32 +0800
Content-Type: text/plain; charset=UTF-8
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Mon, 12 Oct 2026 19:44:32 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00/15] Yunsilicon ethernet and RDMA drivers
Message-Id: <20261012114352.2471317-1-tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>

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
     resource pools.  Patches 01-05.

  2. xsc_eth - the ethernet driver (CONFIG_YUNSILICON_XSC_ETH).
     Registers the netdev, implements the TX/RX packet paths with NAPI
     and page_pool, RSS, checksum offloads and statistics.  Patches
     06-08, on top of the core.

  3. xsc_ib - the RDMA driver (CONFIG_INFINIBAND_XSC).
     Registers the ib_device and provides the PD/MR, CQ/SRQ/AH and QP
     verbs including the send/receive data paths, plus RDMA counters and
     sysfs attributes.  Patches 09-14, on top of the core and the
     ethernet driver (the netdev supplies port state and GID).

Patch 15 adds the MAINTAINERS entry.

The series is split so that every commit builds: the core patches
introduce the register access, the command queue, the event queues and
the resource pools incrementally, and the ethernet and RDMA patches only
start creating queues once their dependencies are in place.  Patch 05
(core CQ/QP pools) is deliberately shared by both upper drivers; that is
why it precedes the ethernet patches.

The RDMA device is registered at patch 09, before all verbs exist, so
kverbs_provider stays false until the mandatory verbs appear in patches
10-13.  This keeps each intermediate tree compilable.

Please review.

Thanks,
Xin Tian

Xin Tian (15):
  yunsilicon: add PCI core driver skeleton
  yunsilicon: add the register HAL
  yunsilicon: add the command queue
  yunsilicon: add event queues, interrupts and the auxiliary bus
  yunsilicon: add the CQ and QP resource pools
  yunsilicon: add ethernet netdev registration
  yunsilicon: add ethernet TX path
  yunsilicon: add ethernet RX path and statistics
  yunsilicon: add RDMA device support
  yunsilicon: add RDMA PD/MR
  yunsilicon: add RDMA CQ/SRQ/AH
  yunsilicon: add RDMA QP verbs
  yunsilicon: add the RDMA send path
  yunsilicon: add RDMA counters and sysfs
  MAINTAINERS: add the Yunsilicon XSC drivers

 MAINTAINERS                                   |    9 +
 drivers/infiniband/Kconfig                    |    1 +
 drivers/infiniband/hw/Makefile                |    1 +
 drivers/infiniband/hw/xsc/Kconfig             |   17 +
 drivers/infiniband/hw/xsc/Makefile            |   10 +
 drivers/infiniband/hw/xsc/ah.c                |  144 ++
 drivers/infiniband/hw/xsc/counters.c          |  422 +++
 drivers/infiniband/hw/xsc/counters.h          |   31 +
 drivers/infiniband/hw/xsc/cq.c                |  895 +++++++
 drivers/infiniband/hw/xsc/main.c              |  887 +++++++
 drivers/infiniband/hw/xsc/mem.c               |  161 ++
 drivers/infiniband/hw/xsc/mr.c                |  313 +++
 drivers/infiniband/hw/xsc/qp.c                | 2251 +++++++++++++++++
 drivers/infiniband/hw/xsc/srq.c               |  426 ++++
 drivers/infiniband/hw/xsc/xsc_ib.h            |  542 ++++
 drivers/infiniband/hw/xsc/xsc_ib_sysfs.c      |   64 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/yunsilicon/Kconfig       |   26 +
 drivers/net/ethernet/yunsilicon/Makefile      |    8 +
 .../net/ethernet/yunsilicon/xsc/common/cq.h   |   30 +
 .../ethernet/yunsilicon/xsc/common/driver.h   |   95 +
 .../net/ethernet/yunsilicon/xsc/common/qp.h   |  104 +
 .../net/ethernet/yunsilicon/xsc/common/srq.h  |   54 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmd.h  | 1022 ++++++++
 .../yunsilicon/xsc/common/xsc_cmd_api.h       |   25 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmdq.h |  192 ++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  707 ++++++
 .../yunsilicon/xsc/common/xsc_device.h        |   94 +
 .../ethernet/yunsilicon/xsc/common/xsc_hsi.h  |  123 +
 .../ethernet/yunsilicon/xsc/common/xsc_reg.h  |   28 +
 .../net/ethernet/yunsilicon/xsc/net/Kconfig   |   17 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |    9 +
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 1724 +++++++++++++
 .../net/ethernet/yunsilicon/xsc/net/xsc_eth.h |   45 +
 .../yunsilicon/xsc/net/xsc_eth_common.h       |  124 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_rx.c  |  551 ++++
 .../yunsilicon/xsc/net/xsc_eth_stats.c        |   39 +
 .../yunsilicon/xsc/net/xsc_eth_stats.h        |   34 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_tx.c  |  309 +++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         |  159 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         |   91 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.c  |   80 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.h  |  185 ++
 .../net/ethernet/yunsilicon/xsc/net/xsc_pp.h  |   38 +
 .../net/ethernet/yunsilicon/xsc/net/xsc_pph.h |   42 +
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   |  185 ++
 .../net/ethernet/yunsilicon/xsc/pci/Kconfig   |   15 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   10 +
 .../net/ethernet/yunsilicon/xsc/pci/adev.c    |  142 ++
 .../net/ethernet/yunsilicon/xsc/pci/adev.h    |   17 +
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   |  237 ++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.h   |   17 +
 .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1247 +++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  |  316 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h  |   17 +
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  |  320 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h  |   39 +
 .../yunsilicon/xsc/pci/hal/andes_impl.c       |  708 ++++++
 .../yunsilicon/xsc/pci/hal/andes_reg.h        |   43 +
 .../ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h |   85 +
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  310 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
 .../net/ethernet/yunsilicon/xsc/pci/link.c    |   35 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  348 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.c  |  212 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.h  |   18 +
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.c |  498 ++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.h |   18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.c  |   55 +
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.h  |   14 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c  |  356 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |   28 +
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.c |   92 +
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.h |   16 +
 .../net/ethernet/yunsilicon/xsc/pci/vport.c   |   34 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |    1 +
 include/uapi/rdma/xsc-abi.h                   |  295 +++
 78 files changed, 17877 insertions(+)
 create mode 100644 drivers/infiniband/hw/xsc/Kconfig
 create mode 100644 drivers/infiniband/hw/xsc/Makefile
 create mode 100644 drivers/infiniband/hw/xsc/ah.c
 create mode 100644 drivers/infiniband/hw/xsc/counters.c
 create mode 100644 drivers/infiniband/hw/xsc/counters.h
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
