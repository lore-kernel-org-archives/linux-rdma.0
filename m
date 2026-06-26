Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F28770836;
	Fri, 26 Jun 2026 08:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463868; cv=none; b=uXAPiDYljyw7uGZZS/+CWSNtKL75HS6j/jY0N2xXh1faaoW10QM/V4rc2kxjFBsLcEvQ9nH5gWWMit06uevRUQZ9GnQP7nJ3FwFZqLBLyDhxHWFatOgLJGw2Uj42HaFa1yj/kWANSUfxF0Axe3qUBnGICorQLk8zlbS3tnTMjwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463868; c=relaxed/simple;
	bh=2AdsBFzDgQC64R9iYg6GXrqm4RJccMBdKhE9okKjxdU=;
	h=Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type; b=g/55CwVpyOgRIWZvICq9UkO0zFje6a6mY7YQBoWKy8VGdqVNVIEBEF28KZnBd+ta4T7mAEL84DCk1GCXBmy9+VEZRbbY8SXAyYnumYxtzlNmaDMnh5n5/puBwLLpqYu/46tIdiBxvyp6tyJRXDsiL2aKJ7ahEit+vpAalH2cUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gmqC82fgMz57KTq;
	Fri, 26 Jun 2026 16:51:00 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 65Q8oOJj065527;
	Fri, 26 Jun 2026 16:50:48 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from mapi (szxl2zmapp07[null])
	by mapi (Zmail) with MAPI id mid14;
	Fri, 26 Jun 2026 16:50:50 +0800 (CST)
X-Zmail-TransId: 2b096a3e3d6a1de-82f8a
X-Mailer: Zmail v1.0
Message-ID: <20260626165050955lBuUhmj0yLn5xCsQ-tbx4@zte.com.cn>
Date: Fri, 26 Jun 2026 16:50:50 +0800 (CST)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <zhang.yanze@zte.com.cn>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <julianbraha@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <zhang.yanze@zte.com.cn>, <wei.quan@zte.com.cn>,
        <han.junyang@zte.com.cn>, <ran.ming@zte.com.cn>,
        <han.chengfei@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHJkbWEgdjIgMC8yXSBBZGQgWlRFIERpbmdIYWkgRXRoZXJuZXQgUHJvdG9jb2wgRHJpdmVyIGZvciBSRE1B?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65Q8oOJj065527
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 26 Jun 2026 16:51:00 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A3E3D74.001/4gmqC82fgMz57KTq

From: Yanze Zhang <zhang.yanze@zte.com.cn>

Hi maintainers and reviewers,

This is v2 of the ZTE DingHai (ZXDH) RDMA driver submission.
Thank you Julian Braha for the review on v1.

Changes in v2:
- Removed redundant 'depends on INFINIBAND' from Kconfig as it is already
  wrapped by the parent if-block (Julian Braha).

The driver provides RoCEv2 support for ZTE DingHai network adapters and has
been tested with perftest and rping utilities.

Best regards,
Yanze Zhang

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
drivers/infiniband/hw/zrdma/zrdma_main.c | 156 ++++++++++++++
drivers/infiniband/hw/zrdma/zrdma_main.h | 140 +++++++++++++
drivers/infiniband/hw/zrdma/zrdma_mem.h  | 105 ++++++++++
drivers/infiniband/hw/zrdma/zrdma_type.h | 110 ++++++++++
drivers/infiniband/hw/zrdma/zrdma_uk.h   |  18 ++
14 files changed, 1128 insertions(+)
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
