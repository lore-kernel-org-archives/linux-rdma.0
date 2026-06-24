Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B743911B6;
	Wed, 24 Jun 2026 08:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782290706; cv=none; b=HrnmVhVWCGo8uCvWlkYD8oSJtb6n1gSQXj+HLq/B3wd2CaNoi5Uvo8ooQPBN7x3BgQ7lJPoYcbpeOSFV7AjVcvGBcZgnTHSRVpCugboRIlnMGzGFGE0scHZdAt9htcMq9inru1t6/lZhlLO0XV5qEI4t4IAXCUNGWXClvdqrf4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782290706; c=relaxed/simple;
	bh=6zJo2iIEkBCBtH4ceqs7lOHIhU4Y1WzDlV9siifn1wk=;
	h=Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type; b=q0/3H2NsWjWk6suDkOam1A5+Gxb1TYGFpOGkilkRAn4Q5FXO4Cqc2gcw7nacfeK9q+oOE92PD8tGrI63Y/jyeFP7JClYhsdEN+7Su8WlilmMSyBX+kyGwhumm0epjuygF3hE+VxBzfbLmhhfaJA8+UmdhkIhuHnVRaiNgEWOgkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4glb9B3mtMz5B0ny;
	Wed, 24 Jun 2026 16:45:02 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 65O8it8D063385;
	Wed, 24 Jun 2026 16:44:55 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
	by mapi (Zmail) with MAPI id mid14;
	Wed, 24 Jun 2026 16:44:57 +0800 (CST)
X-Zmail-TransId: 2b046a3b99091da-83b6b
X-Mailer: Zmail v1.0
Message-ID: <202606241644572798vwNbZEAtt3c2IHcJUtCs@zte.com.cn>
Date: Wed, 24 Jun 2026 16:44:57 +0800 (CST)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <zhang.yanze@zte.com.cn>
To: <jgg@ziepe.ca>, <leon@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <zhang.yanze@zte.com.cn>, <wei.quan@zte.com.cn>,
        <han.junyang@zte.com.cn>, <ran.ming@zte.com.cn>,
        <han.chengfei@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHJkbWEgdjEgMC8yXSBBZGQgWlRFIERpbmdIYWkgRXRoZXJuZXQgUHJvdG9jb2wgRHJpdmVyIGZvciBSRE1B?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65O8it8D063385
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 24 Jun 2026 16:45:02 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A3B990E.002/4glb9B3mtMz5B0ny

From: Yanze Zhang <zhang.yanze@zte.com.cn>

This series adds initial RoCEv2 support for the ZTE ZXDH RNIC,
a PCIe Gen5 adapter.

The driver implements core IB verbs (QP/CQ/MR/SRQ/AH) with async CQP
command path and DCQCN congestion control, using the auxiliary bus
framework following hns/bnxt_re patterns. It does not include Ethernet
network data plane support. Perftest shows ~395 Gb/s write bandwidth at
4KB message size over RoCEv2 RC/UD QPs.

Yanze Zhang (2):
RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol Driver for RDMA
RDMA/zrdma: Add hardware config code and improve driver init flow

MAINTAINERS | 6 +
drivers/infiniband/Kconfig | 1 +
drivers/infiniband/hw/Makefile | 1 +
drivers/infiniband/hw/zrdma/Kconfig | 10 +
drivers/infiniband/hw/zrdma/Makefile | 6 +
drivers/infiniband/hw/zrdma/zrdma_ctrl.h | 248 +++++++++++++++++++++++
drivers/infiniband/hw/zrdma/zrdma_defs.h | 37 ++++
drivers/infiniband/hw/zrdma/zrdma_hw.c | 135 ++++++++++++
drivers/infiniband/hw/zrdma/zrdma_hw.h | 156 ++++++++++++++
drivers/infiniband/hw/zrdma/zrdma_main.c | 156 ++++++++++++++
drivers/infiniband/hw/zrdma/zrdma_main.h | 140 +++++++++++++
drivers/infiniband/hw/zrdma/zrdma_mem.h | 105 ++++++++++
drivers/infiniband/hw/zrdma/zrdma_type.h | 110 ++++++++++
drivers/infiniband/hw/zrdma/zrdma_uk.h | 18 ++
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
