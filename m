Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067760;
	b=EqEicuV2wwGeZkFt4nyTYbT4vxkQ+vFR+iQkHNmaQQOnlso7xbj8NUPl+o9SCXMtp/uC
	 JRTwkqWqkOeCuKLcuQKHsAgRyJn6D/suLh5HX2AiznX6O4Wjl9sNOzHcX5EscsdN7dgHD
	 3Cb3XRFakwTD9768a3fCpssfSvacQYNuZxKQlpuToderw0jcoIuKr3xtzANTHxbfmtt+u
	 ydtVLKZ8pUjSe1FqB8/dQFpABqhkSv8vLwcBnHSkSOvML+MD4VCoLcGCyGj1Vv8cZ8whC
	 loVo+zL8XqP3ZE5F3MRgqAr5z1GZyRsJU7wGwnbZK0NJM9O9neTBK0mL6A7j4LgeXpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067760;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:X-ZMAIL-USEORIGINALEMLTOOUTBOUND:
	 Content-Transfer-Encoding:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=T0u94vcyD+ewFknAQgXlOm/PXX1jnvOMryNcKljn7qk=;
	b=pkmEY1ENwf9QFgb0BQ0+fya9apZ6QE6yqUNe9wBrzPhB/Byy0VU8JNNpVPzjF3qiHGbF
	 5n96kAo/GckdcjUU4LkdShTkYzkYJsLHa8BrHyMfZg9/5yiR7xelPILO2FvSdog272o1a
	 0Aea0VKVaXatUpwKHWuzQWErC8JiPeqBLUD3vHpkH5q71EcvJOknKhnEPA5osabsdtBxc
	 Wcv5wXCshPMYePiyBD+G2Oi3crX4gz+oAs516Vqlhn5IN7YPfv4lU8hVKZxxxUGpbAnvg
	 +PkiWzLzkVIOpyGNXmolltWSRB/WDBnYBC200m6s4HhnH1EZ4NJUzvon7X23Ux3UVwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E807606A31E;
	Tue, 27 Oct 2026 02:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E807606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jDDmG0QXkz8XrrJ;
	Tue, 27 Oct 2026 10:22:38 +0800 (CST)
Received: from szxl2zmapp06.zte.com.cn ([10.1.32.108])
	by mse-fl2.zte.com.cn with SMTP id 69R2MQ7L099617;
	Tue, 27 Oct 2026 10:22:26 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 27 Oct 2026 10:22:27 +0800
X-Zmail-TransId: 3e816ae00aa0027-4bd54
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v7 0/7] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Tue, 27 Oct 2026 10:11:12 +0800
Message-ID: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 69R2MQ7L099617
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 27 Oct 2026 10:22:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE00AEE.000/4jDDmG0QXkz8XrrJ

Hi,

This is v7 of the ZTE DingHai (ZXDH) RDMA driver, providing RoCEv2
support for ZTE DingHai network adapters.

The DingHai Ethernet PF driver this RDMA driver attaches to is being
merged through net-next. The first batch, which introduces the DINGHAI
Kconfig symbol and the "dinghai10e" PF driver, is already in net-next
[1]; the second batch is still under review [2]. The auxiliary device
that this driver binds to is created by a patch that is still being
prepared and has not been posted yet; this series is therefore posted
for review ahead of that patch, and the driver will not probe on the
upstream baseline until it lands. This series is based on an
rdma/for-next baseline that already contains the first batch, so
"depends on DINGHAI" resolves. The driver registers as an auxiliary
driver and matches the auxiliary device by name only, so it cannot bind
to an unrelated PCI function.

v7 folds the review feedback on v6 [3] back into the patch that
introduced the affected code. Each change below was verified against
the reported issue before being applied:

 - Patch 2/7: tag the UAPI header with the Linux-syscall-note SPDX
   identifier, which is required for a header that is installed to
   userspace.
 - Patch 3/7: pass the name buffer length to zxdh_get_del_rdma_name()
   and use guard(spinlock_irqsave) in zxdh_free_rsrc(); zxdh_alloc_rsrc()
   keeps the explicit lock because of its multiple early exits.
 - Patch 4/7: keep zrdma_main.c in place. v6 removed it in the middle
   of the series, which broke both bisection and the build of that
   single commit; the probe implementation now modifies the file
   instead.
 - Patch 5/7: install the device ops right after ib_alloc_device(), so
   the dealloc_driver hook is in place before any resource is taken.
   The hook releases the pci function, the handler and the resource
   bitmaps, and it only destroys the ah_list_lock when it was actually
   initialised.
 - Patch 6/7: report the SRQ doorbell offset like the SQ and CQ
   doorbells, and extend the SRQ mapping so that it covers the whole
   doorbell area on 16K and 64K page systems. The size handed to
   userspace is the very same length that is registered, otherwise
   rdma_user_mmap_entry_get() rejects the mmap.
 - Patch 7/7: accept a NULL udata in query_device(), which is how the
   core calls it during registration; report the number of send and
   receive SGEs; parse the firmware version as unsigned values and
   keep the "N/A" placeholder when no version can be extracted; read
   the driver info with rtnl held, taking the lock only when the
   caller does not hold it already; take the port speed from
   ib_get_eth_speed() instead of caching a value that goes stale on a
   link change; fill in the immutable port information directly, so
   that it does not depend on the port query being run while the
   device is still being registered; pass the port number to
   rdma_protocol_roce() instead of hard coding it; drop the query_gid
   callback, as the RoCE GID cache is owned by the core.

In short, v7 additionally fixes:

 - The UAPI SPDX identifier, which headers_install rejected because the
   header is installed to userspace.
 - The probe error paths, which leaked the pci function, the handler and
   the hardware resource buffers because dealloc_driver was not
   registered early enough.
 - The deletion of zrdma_main.c in the middle of the series, which broke
   both bisection and the build of that single commit.
 - The NULL dereference of udata in query_device(), which
   ib_register_device() passes as NULL.
 - The missing max_send_sge and max_recv_sge, the SRQ doorbell page
   offset on 16K and 64K page systems, and the misuse of
   rtnl_trylock() in get_drvinfo().
 - The immutable port information, which was taken from the port query
   while the device was still being registered.

rmmod stress-testing also found a refcount_underflow in
ib_device.refcount: ib_unregister_device_and_put() performs an extra
put, but the auxiliary-bus probe path never takes a 'get'. The driver
uses plain ib_unregister_device(); ib_dealloc_device() still runs
.dealloc_driver via the normal refcount-release path. The issue was
reproduced before the fix, and the fix was verified with repeated
load/unload cycles on v6. v7 keeps the very same plain
ib_unregister_device() path, so the fix itself is unchanged.

Testing in this version focuses on the review fixes: the driver
builds, probes on DingHai hardware, and 'rdma link' / 'ibv_devinfo'
enumerate the device. The hardware testing was done with a PF driver
that already creates the auxiliary device, because the baseline that
this series is based on only has the first batch, which does not create
it yet. The build was tested with CONFIG_DINGHAI=y, because the Kconfig
now depends on it, and every commit of the series was built on its own
to make sure that the series stays bisectable. Perftest (QP/CQ/MR
creation and the data path) is covered by the parallel network driver
series, so we did not want to hold these review fixes on it. Functional
verbs testing will be reported once both series are merged.

Two items raised in review are deliberately left out because they
need input we do not have yet:

 - The common_func() opcode for the IRQ capability query: needs
   confirmation against the firmware interface document; the current
   opcode works on the tested firmware.
 - The shutdown-vs-quiesce semantics and the doorbell isolation
   mechanism: these need the hardware team's confirmation.

Two other points are noted for completeness. An __iomem annotation on
mem_rsrc is moot, since it is plain vzalloc'd memory rather than a BAR
mapping. Replacing the resource bitmaps with XArray/IDA is a cleanup
that does not change behaviour and will follow separately. Neither of
them affects probe/remove or the verbs that are implemented here.

[1] https://lore.kernel.org/netdev/178598040988.599522.8462097247667886071.git-patchwork-notify@kernel.org/
[2] https://lore.kernel.org/netdev/20261014151200489685SCIlolykW0NGfL5EtQ@zte.com.cn/
[3] https://lore.kernel.org/linux-rdma/20261024071539.2182864-1-zhang.yanze@zte.com.cn/

Yanze Zhang (7):
  RDMA/zrdma: Add build infrastructure and module skeleton
  RDMA/zrdma: Add core data structures and ABI definitions
  RDMA/zrdma: Add internal headers and hardware register definitions
  RDMA/zrdma: Add hardware resource initialization and verbs skeleton
  RDMA/zrdma: Add device probe and remove logic
  RDMA/zrdma: Implement context, PD, and mmap operations
  RDMA/zrdma: Implement device and port query operations

 MAINTAINERS                               |   6 +
 drivers/infiniband/Kconfig                |   1 +
 drivers/infiniband/hw/Makefile            |   1 +
 drivers/infiniband/hw/zrdma/Kconfig       |  11 +
 drivers/infiniband/hw/zrdma/Makefile      |   7 +
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h  |  22 +
 drivers/infiniband/hw/zrdma/zrdma_defs.h  |  19 +
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 118 ++++
 drivers/infiniband/hw/zrdma/zrdma_hw.h    |  21 +
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 305 ++++++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h  | 216 +++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h  |  86 +++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 697 ++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 134 +++++
 include/uapi/rdma/ib_user_ioctl_verbs.h   |   1 +
 include/uapi/rdma/zrdma_abi.h             |  80 +++
 16 files changed, 1725 insertions(+)
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

