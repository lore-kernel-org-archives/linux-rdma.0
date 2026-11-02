Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608296;
	b=nO08PVQWXXaEH5ntXEwjW1DxhWxGqNqZAdZneAx2eO6FQxpJLhuRFv2xAVZSLVFvG2rf
	 7mnS4ZLsUtOKc/x8AJFAp/npKX7kZv8T5+3MfwWW55LaXExmRjjg77rnZUlw5AX+wro4g
	 KLmI2hPCoHERQ7sokRfiXZJG8bGduRMbSdnb0TinBNRWr0fmz6DlO4Kf7MMTAlSPdxY1+
	 Ymbut24x2P83rLOqesjvNrAnZ3/9QnTdpBXXbBnXiELOA0UErE2/f6BqCbwRpRaJKokzA
	 x7OH7bxStwbsknESsbXGL0OkKvkT0j0cTT0gZ88JdfAN9IOFUOWqsvr2fQ4gJdLdyUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608296;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:X-ZMAIL-USEORIGINALEMLTOOUTBOUND:
	 Content-Transfer-Encoding:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=I1Jnxph38MNK8i5fn2OjPXPYSGUxtZdLpFxLvyzlArI=;
	b=Y/3EkbUkYBWHHPcb97556VYyBzWhUr66c8Wh0wE60Cuk/Ntjt/X5je1U12iShKSmx4kg
	 aSny678HCIpnv54yKdWSH43Ct3dgC26Z2t9NS4ngnODLiEkQE5wuKpoWIhoLZlCZkvPWc
	 NwWe1JpRVuJ8lh2uU58KoMVqQF3dz13cQTcz+hMS2Hqh7bQSHo4Kdz1whZjiERWqxjlqX
	 RTADt6Fq6vn+re+bJkZVABS+7g2mpt5Y8NkFvQ9L5VHSTZI+HamYqtb52yWpfdHjO7WeM
	 0mXNvTfd3SzzSGdyB34DmKhZrYD3iRLf1zYeBkXEY2K+p1gk4CX8wtJZexpRhA9P3+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C1A606A329;
	Mon,  2 Nov 2026 08:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0C1A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJ4fz5F6kz5B14n;
	Mon, 02 Nov 2026 16:31:23 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl2.zte.com.cn with SMTP id 6A28VCJg034385;
	Mon, 2 Nov 2026 16:31:12 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Mon, 2 Nov 2026 16:31:15 +0800
X-Zmail-TransId: 3e816ae84a47028-fc597
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev,
        Markus.Elfring@web.de
Cc: lkp@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v8 0/7] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Mon,  2 Nov 2026 16:20:19 +0800
Message-ID: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 6A28VCJg034385
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 02 Nov 2026 16:31:23 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE84A5B.001/4jJ4fz5F6kz5B14n

Hi,

This is v8 of the ZTE DingHai (ZXDH) RDMA driver, providing RoCEv2
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

This series covers the registration of the device, the device and the
port queries, the user context, the protection domains and the mapping
of the doorbell areas. The queue pair and completion queue data path is
not part of it and follows separately. Protection domains that the
kernel allocates are not supported either, because the driver does not
provide the memory registration of the core yet.

v8 folds the review feedback on v7 [3] back into the patch that
introduced the affected code: the 8K index counter array is released
with a cleared pointer on the probe error path, the number of completion
vectors is no longer reported as zero, the driver info is read with the
rtnl lock held unconditionally, the unused handler and name lists are
gone, and the device and port query operations moved ahead of the probe
path, because ib_register_device() calls the query callbacks without
checking them for NULL.

Testing in this version focuses on the review fixes: the driver builds,
probes on DingHai hardware, and 'rdma link' / 'ibv_devinfo' enumerate
the device. The hardware testing was done with a PF driver that already
creates the auxiliary device, because the baseline that this series is
based on only has the first batch, which does not create it yet. The
build was tested with CONFIG_DINGHAI=y, because the Kconfig depends on
it, and every commit of the series was built on its own to make sure
that the series stays bisectable. Perftest (QP/CQ/MR creation and the
data path) is covered by the parallel network driver series, so we did
not want to hold these review fixes on it. Functional verbs testing
will be reported once both series are merged.

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
[3] https://lore.kernel.org/linux-rdma/20261027021119.2325798-1-zhang.yanze@zte.com.cn/

Yanze Zhang (7):
  RDMA/zrdma: Add build infrastructure and module skeleton
  RDMA/zrdma: Add core data structures and ABI definitions
  RDMA/zrdma: Add internal headers and hardware register definitions
  RDMA/zrdma: Add hardware resource initialization and verbs skeleton
  RDMA/zrdma: Implement device and port query operations
  RDMA/zrdma: Add device probe and remove logic
  RDMA/zrdma: Implement context, PD, and mmap operations

 MAINTAINERS                               |   6 +
 drivers/infiniband/Kconfig                |   1 +
 drivers/infiniband/hw/Makefile            |   1 +
 drivers/infiniband/hw/zrdma/Kconfig       |  11 +
 drivers/infiniband/hw/zrdma/Makefile      |   7 +
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h  |  20 +
 drivers/infiniband/hw/zrdma/zrdma_defs.h  |  19 +
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 129 ++++
 drivers/infiniband/hw/zrdma/zrdma_hw.h    |  21 +
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 217 +++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h  | 211 +++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h  |  92 +++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 735 ++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 134 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h   |   1 +
 include/uapi/rdma/zrdma_abi.h             | 114 ++++
 16 files changed, 1719 insertions(+)
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
2.43.5

