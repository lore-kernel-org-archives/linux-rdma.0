Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212041;
	b=ZtCICfeBIZmAGJQ9PgTkJH0qMiC4tPtWZQ2CBX6ckQsgL10gnwfH5GdOe1FZqmi10xbZ
	 gUo0Jm1LBFtyyUGFLHerFNt4J03MR1DOe5czuwYwcJJr7lB+K6YSS96OkQqQ9a2vtfEug
	 p9u5LX8ycadHIfL81+vbbxvUz2hS2QXDwVbnmo/W/24waZ9xewlzmh6Ai+f4VKJXNdQEG
	 poLCqvdYcioJ+CoOq+yAYohAQ8/LjpjLaWg/mBa6u4WVnExmaJs5ohD1sgmFZt2ITNY3Q
	 RS0yst+RsI/mj4+eux3EmiZ7hqCYsiQhgFITE6iMZosYECQ2834EtRtwjbSlAOJqejw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212041;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=iuN7VHsSP8og9e+IPQw1o42txzURheWEW1P0/Lbxnzc=;
	b=mxVHQPIFDG+vhqya5biIIQVzobcJvch+blFnnS6jPcSG716rS0ytGzP6QTQaiIAohQq+
	 Kj8HKNrsu+QZH6B1OPnKnJ19/MD/8YnaYzKMSWJex6BLv1qg0dpkhjQHgmgmMJIBBiIiU
	 ijrXEWe7Qs/RNE2O9OnXVXs96xxu7tovar2o7NTofWmc0LjqoBA+gUFplgcoj2p7P2nZa
	 KM4fq9eU89+9MtHYTgO8I9weKtNm5+JAyymJ9o9IrE4c8rNKlnJEmDZdvq568xp6P2jpU
	 TaEgu/IR4UUCB46in/YEQ3NUxMU5Q3dOuqXT2RqQXEjeJx0uu7Pcig5czqCaFS1haIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=HywTB8JM;
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E16606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13E16606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=HywTB8JM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794212041; x=1825748041;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iuN7VHsSP8og9e+IPQw1o42txzURheWEW1P0/Lbxnzc=;
  b=HywTB8JMALw7Z3pG+dMvlEiYejd5EZY3ktEN4lwM4C2RG9OS9FGefEm+
   O3oX5Y7fsKpNMvkyB2jA9xbgMoYoHQ2RLCk5IYYs7z2VcFnWDDLie1mqt
   rZ94+lG+C2x37SMECuBeNP8w+pjEAKpE/Pl7ety1PDQ6lLKtME2FZLJ/M
   j/D7gpLyFMrt6QeF62m8x3qbeocCcUJZIuqfDbTuYJxOPfGqQRjolk96t
   lSZcygdL7Dboht9kR1oW/Rhjo+jEn7SzzbNA4ETC8CTWhNX52VniHScg6
   JmVosB6R9itEDRNaOCXJLJV8s7wyK4LpV3kzvpgFJTUeJFWAVNg+3C6My
   A==;
X-CSE-ConnectionGUID: x3LqyfrbSs+Vqmppoijh1Q==
X-CSE-MsgGUID: MX3oQ69wTzG/i3pRSCbj/Q==
X-IronPort-AV: E=Sophos;i="6.27,203,1787011200"; 
   d="scan'208";a="33281727"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 08:13:58 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:19929]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id b68bec14-3f0d-4e5f-99c1-b2d9d8131f0e; Mon, 9 Nov 2026 08:13:58 +0000 (UTC)
X-Farcaster-Flow-ID: b68bec14-3f0d-4e5f-99c1-b2d9d8131f0e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 9 Nov 2026 08:13:58 +0000
Received: from dev-dsk-ikolomin-1a-673563de.eu-west-1.amazon.com
 (172.19.125.167) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 9 Nov 2026
 08:13:56 +0000
From: Ilia Kolominsky <ikolomin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Date: Mon, 9 Nov 2026 08:13:46 +0000
Message-ID: <20261109081349.27316-1-ikolomin@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

EFA Completion actions let an application observe work request
completions without polling a completion queue: when a work request
completes, locally or at the remote side, the device performs an action
that the work request names, such as writing a value to a user buffer.

This series adds the control path for memory completion actions:

Patch 1 updates the device interface definitions: the create and
destroy action admin commands, the supported action events mask in the
queue attributes, and the action descriptor and status codes in the
I/O definitions.

Patch 2 maps the admin RESOURCE_BUSY status to EBUSY, which the device
returns when a PD is deallocated while an action still references it.

Patch 3 adds the completion action uverbs object, the QP creation
attributes for the action descriptor block, and the capability, limit
and supported operation reporting through query device.

The user space counterpart (rdma-core efa provider) follows separately.

Ilia Kolominsky (3):
  RDMA/efa: Update device interface
  RDMA/efa: Report the admin RESOURCE_BUSY status as EBUSY
  RDMA/efa: Add Completion Actions support

 drivers/infiniband/hw/efa/efa.h               |   7 +
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 111 ++++++++-
 drivers/infiniband/hw/efa/efa_com.c           |  10 +
 drivers/infiniband/hw/efa/efa_com_cmd.c       |  73 ++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  31 +++
 drivers/infiniband/hw/efa/efa_io_defs.h       |  26 +-
 drivers/infiniband/hw/efa/efa_verbs.c         | 235 +++++++++++++++++-
 include/uapi/rdma/efa-abi.h                   |  56 ++++-
 8 files changed, 542 insertions(+), 7 deletions(-)

-- 
2.47.3

