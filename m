Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946C842DFF4;
	Tue, 11 Aug 2026 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441384; cv=none; b=AotIuJDm+cELmMtufYGeLMuDuA1IPVxbyK7pIM7K3YZKhAaEhC+b7XdwXzHi1YyD7VJXXyJw1cCArHaXMtEwp/VoTd08pwYp9h6kwJsuevkqeO9bmdHM9OG3FOyx4gJd/6TCl4slL5cHIweIUas52xbmbJ84zW+zQ1yTmgo5oEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441384; c=relaxed/simple;
	bh=tPCof3ZcULJLr4RcwWZONiPVfcKIBtd1GwTP8mhVYxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vqb1oZml2Md8ssoZ+bkAY0Pg4eSj7BsnGiG7GjMNwIIaDVrmKAStW/XRS9YhZ19P9uFzbrISU4psBqj5n60S2n7arXJ5lqJzJswtfbJg3eIJfoaTG1L5LOYWaRvnq9f5o93wYKQTpFJTqZzLGf+LnbGcza8Ij6wsiIWcpNaF2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hK69p6Mlxz4yjG3;
	Tue, 11 Aug 2026 17:42:54 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hK69Z4rDJz58fdJ;
	Tue, 11 Aug 2026 17:42:42 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl2.zte.com.cn with SMTP id 67B9gV0p073667;
	Tue, 11 Aug 2026 17:42:31 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:33 +0800
X-Zmail-TransId: 3e816a7aee75013-443f6
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 0/7] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Tue, 11 Aug 2026 17:37:33 +0800
Message-ID: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 67B9gV0p073667
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 192.168.251.13 unknown Tue, 11 Aug 2026 17:42:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEE9E.000/4hK69p6Mlxz4yjG3

Hi Maintainers and Reviewers,

This is v5 of the ZTE DingHai (ZXDH) RDMA driver submission.
Thank you Leon Romanovsky, Zhu Yanjun, Julian Braha, and the kernel test
robot for their valuable feedback on previous versions.

The driver provides RoCEv2 support for ZTE DingHai network adapters. It
has been successfully tested with user-space utilities including 'rdma
link' and 'ibv_devinfo', confirming proper device registration and
attribute querying.

Note on Dependencies:
The corresponding ZTE DingHai Ethernet network driver is being submitted
to the Linux networking community in parallel [1]. Once merged, we will
update the Kconfig dependencies to explicitly require it. For now, the
driver relies on generic NETDEVICES and PCI subsystems.

Major changes in v5 compared to v4:

1. Granular Patch Splitting (< 300 lines each):
   - As requested by Leon Romanovsky, the driver has been split into 7
     smaller, logically independent patches to simplify review.
   - Each patch is strictly under 300 lines and independently compilable.

2. Functional Driver ID & Early Registration:
   - Added RDMA_DRIVER_ZRDMA to UAPI in Patch 1.
   - Implemented a minimal verbs skeleton in Patch 4, ensuring the driver
     registers with a valid driver_id and loads without errors, satisfying
     the requirement that "the driver must be functional".

3. Kconfig & Build System Improvements (Suggested by Zhu Yanjun):
   - Added explicit dependencies: depends on PCI, NETDEVICES.
   - Added proper selection: select AUXILIARY_BUS to ensure the auxiliary
     bus subsystem is enabled when this driver is selected.

4. Code Quality & Style Fixes:
   - Fixed build error for incomplete type 'struct msix_entry' by including
     <linux/msi.h> (Reported-by: kernel test robot).
   - Removed unused defines, functions, and dead code paths.
   - Ensured all new files follow Linux kernel coding style (checked with
     checkpatch.pl --strict).

Changes in v4:
- Fixed Kconfig help text indentation (Julian Braha).
- Self-correction: Updated SPDX license tag and fixed Makefile
  indentation to strictly follow subsystem standards.

Changes in v3:
- Fixed missing handle release in zxdh_remove() as pointed out by Junxian
  on v1.
- Removed outdated reference to "auxiliary bus following hns pattern" from
  cover letter description.
- Addressed Junxian's indentation concern on v1: verified code against
  checkpatch.pl --strict and confirmed 8-character indentation is used
  throughout.

Changes in v2:
- Removed redundant 'depends on INFINIBAND' from Kconfig as it is already
  wrapped by the parent if-block (Julian Braha, v1 review).

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
 drivers/infiniband/hw/zrdma/Kconfig       |  12 +
 drivers/infiniband/hw/zrdma/Makefile      |   7 +
 drivers/infiniband/hw/zrdma/zrdma_abi.h   |  78 +++
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h  |  22 +
 drivers/infiniband/hw/zrdma/zrdma_defs.h  |  19 +
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 103 ++++
 drivers/infiniband/hw/zrdma/zrdma_hw.h    |  21 +
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 282 +++++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h  | 214 +++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h  |  85 +++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 714 ++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 128 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h   |   1 +
 16 files changed, 1694 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/zrdma/Makefile
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_abi.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_ctrl.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_defs.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_type.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.h

Links:
[1] https://lore.kernel.org/netdev/178598040988.599522.8462097247667886071.git-patchwork-notify@kernel.org/

base-commit: <a12d9145145b21c50531afb6e3f711b1f34e1465>
-- 
2.27.0

