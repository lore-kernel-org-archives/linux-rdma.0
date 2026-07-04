Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9BB38F659;
	Sat,  4 Jul 2026 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783153714; cv=none; b=pERLjYMGvkE8A6jY+3YVEsQ/omZce+T01XPA6DTC2h1g8I3h61Rm6m4WTQ043swSXhlDaR0mskEjm8nqmL6miXgytK0zjSPK0GxU0I8Oyp3p+WpJ8MXirlBlsgNGNZBTurhbsfwAuc9r06sqSzIrKMT8kwo8E5j90LaTygrH2oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783153714; c=relaxed/simple;
	bh=PjDNkH8eoFBuylPeDe62oalJHB5zr0PIJq/TEM+0ntA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qvcu0JxPWVlmzfZxdlsgfiIFeUHrOKazSgUjj6WA3DfmoFDtIPTfsXMdlq3aTazFZWOg/pnuBJMlpe6TwqHYfUwIEAZaXSpMa+01LavPxEMZU54u2kTdqQ6BNBv38Kxu8F86T7yvKU7RxWLAwqbl/cX/qfFIG4R1gduBk/c4Bms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gskKW591Sz5B101;
	Sat, 04 Jul 2026 16:28:31 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 6648SJg2046534;
	Sat, 4 Jul 2026 16:28:19 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 4 Jul 2026 16:28:21 +0800
X-Zmail-TransId: 3e816a48c40b008-bf8b0
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v4 0/2] Add ZTE DingHai Ethernet Protocol Driver for RDMA
Date: Sat,  4 Jul 2026 16:26:38 +0800
Message-ID: <20260704082640.664061-1-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 6648SJg2046534
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 04 Jul 2026 16:28:31 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A48C42F.000/4gskKW591Sz5B101

The driver provides RoCEv2 support for ZTE DingHai network adapters and has
been tested with perftest and rping utilities.

Changes in v4:
- Fixed Kconfig help text indentation (Julian Braha).
- Self-correction: Updated SPDX license tag and fixed Makefile
  indentation to strictly follow subsystem standards.

Changes in v3:
- Fixed missing handle release in zxdh_remove() as pointed out by Junxian
  on v1.
- Removed outdated reference to "auxiliary bus following hns pattern" from
  cover letter description (this was already corrected in v2; re-stating
  here since Junxian's comment was on v1).
- Addressed Junxian's indentation concern on v1: I verified the code against
  checkpatch.pl --strict and confirmed 8-character indentation is used
  throughout. This v3 was sent using a different email client/format to rule
  out MUA-induced formatting corruption. If the indentation still appears
  incorrect in your viewer, please review the updated series and let me know
  if the issue persists.

Changes in v2:
- Removed redundant 'depends on INFINIBAND' from Kconfig as it is already
  wrapped by the parent if-block (Julian Braha, v1 review).

Yanze Zhang (2):
  RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol Driver for RDMA
  RDMA/zrdma: Add hardware config code and improve driver init flow

 MAINTAINERS                              |   6 +
 drivers/infiniband/Kconfig               |   1 +
 drivers/infiniband/hw/Makefile           |   1 +
 drivers/infiniband/hw/zrdma/Kconfig      |   9 +
 drivers/infiniband/hw/zrdma/Makefile     |   6 +
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h | 248 +++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_defs.h |  37 ++++
 drivers/infiniband/hw/zrdma/zrdma_hw.c   | 135 ++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_hw.h   | 156 ++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_main.c | 157 ++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_main.h | 140 +++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_mem.h  | 105 ++++++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h | 110 ++++++++++
 drivers/infiniband/hw/zrdma/zrdma_uk.h   |  18 ++
 14 files changed, 1129 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/zrdma/Makefile
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_ctrl.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_defs.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_mem.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_type.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_uk.h

-- 
2.27.0

