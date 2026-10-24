Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826763;
	b=HUJMiZGNfpS3JFRvzCxrLZKJTuJO8Plz/YhbHB+jrlL5X5iyHAki7XSnKaToEv+ZyxLG
	 nxR56mwZQp3G0sZ9SGW99byXue4bBqEc353xppbE49b1W779pO5c0/wG/wiB13DyMfpQ0
	 amd0tJABmpD8QaedGwAoCsvZyyGcSpb3jq0uUrC1vkrYRFXm0JZiBPq6Vhn9P/0EDV0xM
	 u3wnESryybj/pO0+0MocuKofMeyAEYIzk+IbW9XjNUOiUNz7aPUKwEN0BuURJMaXEEYJ9
	 Zjq+6VcISiuHVpodOtmbuzDpetVmTjv734U3S8kIuWw+u2ogSBIIiz8ESaOT/INWkng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826763;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:X-ZMAIL-USEORIGINALEMLTOOUTBOUND:
	 Content-Transfer-Encoding:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=xkc3b6HGWJInF4BQHxhXTl6CTBSGMxfVDbY3nD6nogc=;
	b=kY6GsBvGvXWsHliXFI2JzC5F25P+SwXpjH/D/G4/NAAP3ovEaeqrYVzahzkPRk8WFbik
	 JSmr53WqH5Fy2nb5tp9HL87P9isZMN+TyTTUb2V7qZlH2WumGlHJfzxO480UdA+d7BOlG
	 ipM/vAsEtcnPSX9iZh0BllILkWwHcTPJgH9fPf1qe/ZxwK7tlDtoxroNexcioGgx960ih
	 pm7++UcfA7mK0Cn62TgB+/ozvMH7lgYUocu5yxcyxW7lH2tySi2OTIiZ0ZJSepBzRQBXj
	 mLYbaSnL2xPnQvNkg345pD2HnFzzeB1zL+68mCqYSOuqE0UMq4+6m/aJYuZalgLdM7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F93606A31B;
	Sat, 24 Oct 2026 07:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5F93606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jBWdV2qLQz55y2L;
	Sat, 24 Oct 2026 15:25:50 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
	by mse-fl1.zte.com.cn with SMTP id 69O7PhtZ030406;
	Sat, 24 Oct 2026 15:25:43 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 24 Oct 2026 15:25:45 +0800
X-Zmail-TransId: 3e816adc5d66026-b7b58
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v6 0/7] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Sat, 24 Oct 2026 15:15:32 +0800
Message-ID: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 69O7PhtZ030406
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 24 Oct 2026 15:25:50 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADC5D7E.000/4jBWdV2qLQz55y2L

Hi,

This is v6 of the ZTE DingHai (ZXDH) RDMA driver, providing RoCEv2
support for ZTE DingHai network adapters.

The driver binds to the DingHai Ethernet function through the auxiliary
bus; the corresponding Ethernet network driver is being submitted in
parallel [1]. Because the auxiliary device is only created by that
network driver, the RDMA driver cannot probe unrelated PCI devices even
though Kconfig currently depends on generic NETDEVICES and PCI. We plan
to replace this with a direct dependency once the network driver is
merged, but the current dependency is intentional and safe at runtime.

v6 addresses the review feedback on v5 [2], folding each fix back into
the patch that introduced the affected code:

 - Patch 1/7: drop the ineffective .driver.name indirection in
   auxiliary_driver.
 - Patch 2/7: drop ZXDH_RDMA_TOOL_SHOW_RES_MAP (bit-5 collision with
   ZXDH_RDMA_TOOL_CFG_DEV_PARAM); move zrdma_abi.h to
   include/uapi/rdma/ and include <linux/types.h> so userspace can use
   the ABI directly.
 - Patch 3/7: pick up the new UAPI header location.
 - Patch 4/7: remove the now-unused SRQ_DB_OFFSET macro.
 - Patch 5/7: use .dealloc_driver for probe/remove cleanup; add a
   NULL guard in zxdh_del_handler; drop the duplicate
   ib_register_device retry; publish the handler only after
   ib_register_device succeeds; pass the name buffer length to
   zxdh_get_del_rdma_name() instead of strlen() on an output buffer;
   take the common_func() result as int so a negative errno is not
   mistaken for a capability; guard max_ceqs against msix_count == 0;
   free the leftover zxdh_rdma_list on module exit.
 - Patch 6/7: use kvfree for the vzalloc'd regions; rate-limit the
   PD-allocation warning; apply the page-offset mask to
   srq_db_bar_off like the SQ/CQ doorbells.
 - Patch 7/7: use rtnl_trylock instead of rtnl_lock when walking the
   bond's lower devices; add an ethtool_ops NULL guard; build
   sys_image_guid with addrconf_addr_eui48(); set ibdev_status before
   ib_register_device(); rewrite extract_version() to handle both
   "E310-V25.30.103.01" and "<ver> (<vendor>)" layouts.

rmmod stress-testing also found a refcount_underflow in
ib_device.refcount: ib_unregister_device_and_put() performs an extra
put, but the auxiliary-bus probe path never takes a 'get'. v6 uses
plain ib_unregister_device(); ib_dealloc_device() still runs
.dealloc_driver via the normal refcount-release path. This was
reproduced before the fix and verified with repeated load/unload
cycles after it.

Testing in this version focused on the review fixes above: the driver
builds and probes on DingHai hardware, and 'rdma link' / 'ibv_devinfo'
enumerate the device correctly. Functional verbs testing (QP/CQ/MR
creation and data path) is being run against the parallel network
driver submission and will be reported with that series; we did not
want to hold these review fixes on it.

The following items were raised in review and are deliberately not
part of this series. None of them affects the probe/remove path or the
verbs implemented here:

 - __iomem annotation: mem_rsrc is plain vzalloc'd memory, not a BAR
   mapping, so the annotation is moot until the access path changes.
 - XArray/IDA for resource tracking: current list-based tracking is
   bounded by the number of resources created per device; converting
   it is a cleanup we will do separately.
 - The common_func() opcode for the IRQ capability query: needs
   confirmation against the firmware interface document; the current
   opcode works on the tested firmware.
 - shutdown-vs-quiesce semantics, doorbell isolation mechanism, and
   the resource-pool name in the allocation failure log: these need
   input from the hardware/firmware team and will follow in a separate
   series.

[1] https://lore.kernel.org/netdev/178598040988.599522.8462097247667886071.git-patchwork-notify@kernel.org/
[2] https://sashiko.dev/#/patchset/20260811093740.2607476-1-zhang.yanze@zte.com.cn

 MAINTAINERS                               |   6 +
 drivers/infiniband/Kconfig                |   1 +
 drivers/infiniband/hw/Makefile            |   1 +
 drivers/infiniband/hw/zrdma/Kconfig       |  12 +
 drivers/infiniband/hw/zrdma/Makefile      |   7 +
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h  |  22 +
 drivers/infiniband/hw/zrdma/zrdma_defs.h  |  19 +
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 103 +++
 drivers/infiniband/hw/zrdma/zrdma_hw.h    |  21 +
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 299 +++++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h  | 216 +++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h  |  86 +++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 753 ++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 128 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h   |   1 +
 include/uapi/rdma/zrdma_abi.h             |  81 +++
 16 files changed, 1756 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/zrdma/Makefile
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_ctrl.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_defs.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_type.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.h
 create mode 100644 include/uapi/rdma/zrdma_abi.h

--
2.27.0
