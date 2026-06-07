Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719BB25F98A
	for <linux-rdma@vger.kernel.org>; Sun,  7 Jun 2026 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780849094; cv=none; b=aIkOhuaXzD4uPr5jLulFJGiE9f8NR23VOZmfy9/AY1mxctq8DU6Az6/lw1b95QYn7WnbcfXga9DZ4sWI8foB+L5UhN6MeQsgFT5LggSHpsG5386B0XvZ/BhgvAhv1jbnMt5zayQAOM3oV9F8DBPLhIucGhAdyRiyZj2BiWGNIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780849094; c=relaxed/simple;
	bh=NUPp+aLugADxgPcDfFBxyKtuxFkDkE3MZqilPhwUUSs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AvfH+xg94CDzEjiuoeGq18CXmUQz6CsjIn5HNn5ZxPkNBHxfkTDK1b4qRL7ebfZkJ61R4L9bjHWeXnUWTjKl+zhxyKEHBPbJ3DeLMyJ0atUWrGpwabOC5H6SLQc+wHdLXsc0A0I/wS2gZklT1YWkpAK2xmZ7nlnwgDRa/3sSK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=m1WKDEBm; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="m1WKDEBm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780849093; x=1812385093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7PhVs+Xio27XiO4/6SyCBM4uGT9BoTMsxiOTpP4Awr4=;
  b=m1WKDEBm3wWCVPTFE/yiB3Vg92C818ABi5jCldV2wmuksigDLMh3AWB7
   xNL7QxQ3eENhu+vvw/cy24BvqeP4ckoJ8TC5exOi/JPmUh/G3Xi8iIi9j
   VYNPmKf3okOv/yD77drL/Y91uVKcxER6KppslTv20EYlkKZO/AmSihPSV
   Z6CUUFDPCvNtRyiEMTSz2Xwtpn96H+HiSeU+0Q0+fA9UEn57F5svY/JPt
   NRx1UUnZi9TVvnmYNQ1qFH2oSvLzuc2G5zBh3M5CEvu5NjQmnzC/1/ySf
   B2nqunZGEXrVe8conzQ6vVTScYGwsdXkrPcx412dD39NoV7brED3ChOpl
   w==;
X-CSE-ConnectionGUID: s4ndHKI4SuOB0YoUfcEv7g==
X-CSE-MsgGUID: LS/NLnA0RRSoc88ZW7n30g==
X-IronPort-AV: E=Sophos;i="6.24,192,1774310400"; 
   d="scan'208";a="21267349"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2026 16:18:10 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:26876]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.226:2525] with esmtp (Farcaster)
 id ba36be60-33c5-4a99-8b93-03661a5f7d42; Sun, 7 Jun 2026 16:18:10 +0000 (UTC)
X-Farcaster-Flow-ID: ba36be60-33c5-4a99-8b93-03661a5f7d42
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 7 Jun 2026 16:18:10 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Sun, 7 Jun 2026
 16:18:08 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v3 0/2] RDMA/efa: Add AH cache for AH reuse
Date: Sun, 7 Jun 2026 16:17:51 +0000
Message-ID: <20260607161753.1607559-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Changelog:
v3:
 * Address Sashiko comments in:
   https://sashiko.dev/#/patchset/20260512061121.2177521-1-ynachum%40amazon.com
v2: https://lore.kernel.org/all/20260512061121.2177521-1-ynachum@amazon.com/
 * Zero-initialize AH cache key on cache lookup.
v1: https://lore.kernel.org/all/20260510083035.458081-1-ynachum@amazon.com/

-------------------------------------------------------------------------
New EFA devices don't support the creation of multiple AHs to the same
remote on the same PD. To overcome this limitation, introduce an AH
cache that manages AH reuse transparently.

The cache uses an rhashtable keyed by (PD, GID) to track active address
handles with refcounts. On create AH, the driver returns an existing AH
number if one is already cached, or creates a new one and caches it. On
destroy AH, the driver only issues the device destroy command when the
last reference is dropped.

A per-entry mutex serializes concurrent device commands on the same
cache entry, preventing create-before-destroy races on the device.

Yonatan Nachum (2):
  RDMA/efa: Add initialization of AH cache rhashtable
  RDMA/efa: Add AH cache handling on create and destroy AH

 drivers/infiniband/hw/efa/Makefile       |   4 +-
 drivers/infiniband/hw/efa/efa_ah_cache.c | 163 +++++++++++++++++++++++
 drivers/infiniband/hw/efa/efa_ah_cache.h |  42 ++++++
 drivers/infiniband/hw/efa/efa_com.c      |  12 +-
 drivers/infiniband/hw/efa/efa_com.h      |   3 +
 drivers/infiniband/hw/efa/efa_com_cmd.c  |  73 +++++++---
 drivers/infiniband/hw/efa/efa_com_cmd.h  |   1 +
 drivers/infiniband/hw/efa/efa_verbs.c    |   9 +-
 8 files changed, 281 insertions(+), 26 deletions(-)
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.c
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.h

-- 
2.50.1

