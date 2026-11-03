Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711274;
	b=PnIS0e/5PKwwMwlv5mbnp1LBFjrAlo6IQ/02hbmQ3A19uAXBTZjMhdh+BVkFFMCT35dI
	 YXqkVjEvy4gQs6wch/+YBef/MGWMUdN/FyVCxqeWR61RrD1wKM+VmnmfKto2OtxQPY0Wb
	 h8vExfELus28zeDwUJ01DbNoVTYRxHY5XzKwzYUv9NoP2gEOB0bSxWakEvYKoK/Dcg2zD
	 4MyN4BrtA1C5BXA7tzWl0G6KzMAE/ECcgSXfpEgUpwdGAcPJvQHt+ZzcKwE5Q88d23+x3
	 CecYXaM/zgyEy3+8PeXjvLAJETQpF2urFZmmzNXU1fo/PrbZhENV4lgXG85+AikzT9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711274;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:X-ZMAIL-USEORIGINALEMLTOOUTBOUND:
	 Content-Transfer-Encoding:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=oOr1nDYvT/doa+VeM0wbzdZ7cLIVzJDj7MimKXzVUN8=;
	b=IrWD06leiADk3v1YyCh5ED2JOLFRTc7CU8TfHUcTMvYvdHRvyc1TK3TDN8qoxA0xZcQN
	 2IPX5B6IVPsZxEhtuBQz7KE8h5v8zQnndPyj204EqeF11LZxZVCLMKUTgbJC4P7FTTfDh
	 tu4+5d/2moDCp96gtovvdZw2cEijmKZbGMbDzdu/UkbcDtmHIMO1T3k6ohk9iIf4L+K6a
	 +i4vdnDJH06wKm+fmNc3AptboUfQpgb0bFH5xGCDsbT6k+QgAa+O+oS9HT92uK435aBF7
	 0+5+dIO2CyChckEH7OH0QGu9IGI3zsDsut0wXTkEad39XlKZ/4dDuYrkwLUTTRPfXBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B10606A326;
	Tue,  3 Nov 2026 13:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63B10606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJplV74MNz8Xrr9;
	Tue, 03 Nov 2026 21:07:50 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl1.zte.com.cn with SMTP id 6A3D7hWq004956;
	Tue, 3 Nov 2026 21:07:43 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 3 Nov 2026 21:07:46 +0800
X-Zmail-TransId: 3e816ae9dc90029-7eda2
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v9 0/7] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Tue,  3 Nov 2026 20:56:47 +0800
Message-ID: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 6A3D7hWq004956
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 21:07:51 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9DCA6.000/4jJplV74MNz8Xrr9

The ZTE DingHai (ZXDH) RDMA driver provides RoCEv2 support for ZTE DingHai
network adapters. It binds to the auxiliary device that the DingHai
Ethernet PF driver creates.

The PF driver is being merged through net-next: the first batch, which
introduces the DINGHAI and DINGHAI_PF Kconfig symbols and the
"dinghai10e" PF driver, is already in net-next [1], and the second batch
is still under review [2]. The patch that creates the auxiliary device
is still being prepared and has not been posted yet, so this series is
posted for review ahead of it and the driver does not probe on the
upstream baseline until it lands. The series is based on an rdma/for-next
baseline that already contains the first batch, so "depends on
DINGHAI_PF" resolves. The driver matches the auxiliary device by name
only, so it cannot bind to an unrelated PCI function.

This series covers the registration of the device, the device and the port
queries, the user context, the protection domains and the mapping of the
doorbell areas. The queue pair and completion queue data path is not part
of it and follows separately. Protection domains that the kernel
allocates are not supported either, because the driver does not provide
the memory registration of the core yet.

Testing: the driver builds, and every commit of the series was built on
its own to make sure that the series stays bisectable. The build was
tested with CONFIG_DINGHAI_PF=y, and the Kconfig dependency was
verified: with DINGHAI_PF disabled, the driver is not built at all.

The series was probed on DingHai hardware, with 'rdma link' /
'ibv_devinfo' enumerating the device. The hardware testing was done with
a PF driver that already creates the auxiliary device, because the
baseline that this series is based on only has the first batch, which
does not create it yet.

Two other points are noted for completeness. An __iomem annotation on
mem_rsrc is moot, since it is plain vzalloc'd memory rather than a BAR
mapping. Replacing the resource bitmaps with XArray/IDA is a cleanup
that does not change behaviour and will follow separately. Neither of
them affects probe/remove or the verbs that are implemented here.

Two review findings of the last round are deliberately not taken:

 - The module registration is kept as open coded init and exit
   functions, because the registration of the driver will grow more
   steps when the data path is added.
 - The structures of the auxiliary device are still in the private
   header of this driver. The DingHai PF driver does not create the
   auxiliary device yet, so the shared header between the two drivers
   will follow with the PF driver patch.

---
Changes in v9:
- The Kconfig depends on DINGHAI_PF instead of DINGHAI, because DINGHAI
  is only the boolean vendor guard and the PF driver is the one that
  creates the auxiliary device (Zhu Yanjun on v3).
- The declarations that were added and removed again within the series
  are gone, the auxiliary device names are used directly instead of
  macros, and so are the queue pair, completion queue and shared receive
  queue tables that were reserved in the resource memory but never used
  (Leon Romanovsky on v2, Sashiko on v8).
- The patches that introduced a piece of code now introduce it in its
  final form, so that the later patches only add to it and no patch
  rewrites what an earlier patch has added.
- The MTU is converted with ib_mtu_int_to_enum() of the core instead of
  a private copy of the same conversion (Sashiko on v8).
- The uverbs requests are validated with ib_copy_validate_udata_in() and
  the responses are copied with ib_respond_udata(), so that a truncated
  request is rejected and the trailing bytes of the response are zeroed
  (Sashiko on v8).
- The error messages that the user space can trigger are rate limited
  (Sashiko on v8).
- The MAINTAINERS entry covers the uapi header as well.
- Link to v8: https://lore.kernel.org/linux-rdma/20261102082026.2645777-1-zhang.yanze@zte.com.cn/

Changes in v8:
- The 8K index counter array is released with a cleared pointer on the
  probe error path, so that the dealloc hook does not free the same
  allocation twice.
- The number of completion vectors is no longer reported as zero.
- The driver info is read with the rtnl lock held unconditionally,
  because rtnl_is_locked() does not tell whether the current task holds
  it.
- The unused handler and name lists are gone.
- The device and port query operations moved ahead of the probe path,
  because ib_register_device() calls the query callbacks without
  checking them for NULL.
- Link to v7: https://lore.kernel.org/linux-rdma/20261027021119.2325798-1-zhang.yanze@zte.com.cn/

Changes in v7:
- Patch 2/7: the uapi header is tagged with the Linux-syscall-note SPDX
  identifier, which headers_install requires for a header that is
  installed to userspace.
- Patch 3/7: the name buffer length is passed to zxdh_get_del_rdma_name()
  and zxdh_free_rsrc() uses guard(spinlock_irqsave).
- Patch 4/7: zrdma_main.c is kept in place, because v6 removed it in the
  middle of the series, which broke both bisection and the build of that
  single commit.
- Patch 5/7: the device ops are installed right after ib_alloc_device(),
  so that the dealloc_driver hook is in place before any resource is
  taken.
- Patch 6/7: the SRQ doorbell offset is reported like the SQ and CQ
  doorbells, and the SRQ mapping covers the whole doorbell area on 16K
  and 64K page systems. The size handed to userspace is the very same
  length that is registered, otherwise rdma_user_mmap_entry_get()
  rejects the mmap.
- Patch 7/7: query_device() accepts a NULL udata, which is how the core
  calls it during registration; the number of send and receive SGEs is
  reported; the firmware version is parsed as unsigned values; the
  driver info is read with rtnl held; the port speed comes from
  ib_get_eth_speed() instead of a cached value that goes stale on a link
  change; the immutable port information is filled in directly, so that
  it does not depend on the port query running during the registration;
  the port number is passed to rdma_protocol_roce() instead of being
  hard coded; the query_gid callback is dropped, as the RoCE GID cache is
  owned by the core.
- Link to v6: https://lore.kernel.org/linux-rdma/20261024071539.2182864-1-zhang.yanze@zte.com.cn/

Changes in v6:
- Patch 1/7: the ineffective .driver.name indirection in
  auxiliary_driver is dropped.
- Patch 2/7: ZXDH_RDMA_TOOL_SHOW_RES_MAP is dropped, as bit 5 collides
  with ZXDH_RDMA_TOOL_CFG_DEV_PARAM; zrdma_abi.h moves to
  include/uapi/rdma/ and includes <linux/types.h>, so that userspace can
  use the ABI directly.
- Patch 5/7: .dealloc_driver is used for the probe/remove cleanup, the
  duplicate ib_register_device retry is dropped, the handler is published
  only after ib_register_device() succeeds, the common_func() result is
  taken as int, so that a negative errno is not mistaken for a
  capability, and max_ceqs is guarded against msix_count == 0.
- Patch 6/7: kvfree is used for the vzalloc'd regions, the PD allocation
  warning is rate limited, and the page-offset mask is applied to
  srq_db_bar_off like the SQ/CQ doorbells.
- Patch 7/7: rtnl_trylock is used when walking the bond's lower
  devices, the ethtool_ops NULL guard is added, sys_image_guid is built
  with addrconf_addr_eui48(), and extract_version() handles both the
  "E310-V25.30.103.01" and the "<ver> (<vendor>)" layouts.
- Link to v5: https://lore.kernel.org/linux-rdma/20260811093740.2607476-1-zhang.yanze@zte.com.cn/

Changes in v5:
- The driver is split into seven smaller, logically independent patches,
  each of them below 300 lines and independently compilable, as Leon
  Romanovsky asked for.
- The driver registers with a valid driver_id, so that it is functional
  and loads without errors, as Leon Romanovsky asked for.
- The Kconfig depends on PCI and NETDEVICES and selects AUXILIARY_BUS,
  as Zhu Yanjun suggested.
- The build error for the incomplete type 'struct msix_entry' is fixed
  by including <linux/msi.h> (kernel test robot).
- The unused defines, functions and dead code paths are removed, and all
  new files follow the kernel coding style (checkpatch.pl --strict).
- Link to v4: https://lore.kernel.org/linux-rdma/20260704082640.664061-1-zhang.yanze@zte.com.cn/

Changes in v4:
- Fixed Kconfig help text indentation (Julian Braha).
- Self-correction: Updated SPDX license tag and fixed Makefile
  indentation to strictly follow subsystem standards.
- Link to v3: https://lore.kernel.org/linux-rdma/20260702122256.569952-1-zhang.yanze@zte.com.cn/

Changes in v3:
- Fixed missing handle release in zxdh_remove() as pointed out by Junxian
  on v1.
- Removed outdated reference to "auxiliary bus following hns pattern" from
  cover letter description.
- Addressed Junxian's indentation concern on v1: verified code against
  checkpatch.pl --strict and confirmed 8-character indentation is used
  throughout.
- Link to v2: https://lore.kernel.org/linux-rdma/20260626165050955lBuUhmj0yLn5xCsQ-tbx4@zte.com.cn/

Changes in v2:
- Removed redundant 'depends on INFINIBAND' from Kconfig as it is already
  wrapped by the parent if-block (Julian Braha, v1 review).
- Link to v1: https://lore.kernel.org/linux-rdma/202606241644572798vwNbZEAtt3c2IHcJUtCs@zte.com.cn/

[1] https://lore.kernel.org/netdev/178598040988.599522.8462097247667886071.git-patchwork-notify@kernel.org/
[2] https://lore.kernel.org/netdev/20261014151200489685SCIlolykW0NGfL5EtQ@zte.com.cn/
---

Yanze Zhang (7):
  RDMA/zrdma: Add build infrastructure and module skeleton
  RDMA/zrdma: Add core data structures and ABI definitions
  RDMA/zrdma: Add internal headers and hardware register definitions
  RDMA/zrdma: Add hardware resource initialization and verbs skeleton
  RDMA/zrdma: Implement device and port query operations
  RDMA/zrdma: Add device probe and remove logic
  RDMA/zrdma: Implement context, PD, and mmap operations

 MAINTAINERS                               |   7 +
 drivers/infiniband/Kconfig                |   1 +
 drivers/infiniband/hw/Makefile            |   1 +
 drivers/infiniband/hw/zrdma/Kconfig       |  11 +
 drivers/infiniband/hw/zrdma/Makefile      |   7 +
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h  |  20 +
 drivers/infiniband/hw/zrdma/zrdma_defs.h  |  19 +
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 118 ++++
 drivers/infiniband/hw/zrdma/zrdma_hw.h    |  21 +
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 223 +++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h  | 177 +++++
 drivers/infiniband/hw/zrdma/zrdma_type.h  |  92 +++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 757 ++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 119 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h   |   1 +
 include/uapi/rdma/zrdma_abi.h             | 114 ++++
 16 files changed, 1688 insertions(+)
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


base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.43.5

