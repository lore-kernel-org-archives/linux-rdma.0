Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05005220F49
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484229; cv=none; b=UCbhfc7AFePE6svfkM7ELgHHJ3WQ83z0e6eFNmn+sznq8JEEiLV4PRPviTVU9dAdqAh3y6kGszbf9b6duOuXvzUDtOraUtHNy4vutaeIvG4ky8JtU2Ck8ThGyakrt/mOtPeWjLK1ioglezeFtt63nSLBd6UxOy11HxU4+CUDrh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484229; c=relaxed/simple;
	bh=t/XsJqhfMLj0RVDwlL8/mdVho6AefDcycUyXhFd8Jz4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tLWrSBPKaL+Ci7e6hNjU3OZ4ynHHsO9JFWYIp1azc6PXnRj4URKC5QCmIRQLfysI2xine9TKrAY9QQ5S+ct6sSDu6+UUTMEAoN09FTQH9pVWrG8xcMK8BaQCYfZUyFijjWCE0IJ6QthiSbkMmtjN8dluNt2yML9Wi71OaO5zeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=I3VQPlYL; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="I3VQPlYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785484228; x=1817020228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UJKn+eWNSNKR2LS2maqOJK6gbLImh4hkTCSWyO0oiAU=;
  b=I3VQPlYLdZi5A5dU/wOcNEitcDn+4S5nbtTQn8f0E1TipKOKkHr+IPyY
   ZGsyQF+SK35OS9rG2FiCDo3wteUhbCWSw3jyGtZ3IZHrfgcQXWop2z1eK
   KxADZo4r6qlQBeVn/aJyNRLBt+Da5O1k5pIYbyVWjg1/OR6A+iRWX2UE6
   dyNifldgzqfCRu2IaokDtWhx4O4ULR2mdynwMYe21f/D9ejmtLJPVKCZD
   uq6LdROgoSyeKB7slSNyZBgm3R70tAHFwY7t70xJ1i5eO3B9gtfhGFdwY
   SClQ93EWnnOnrBKSU76wRUKUVUGltd25rTGQq+6UVqDHWC7bC5XBA8C8N
   A==;
X-CSE-ConnectionGUID: GyrorTALSX+TWGstsdPEJg==
X-CSE-MsgGUID: cp62z0YVSliXbPt55tMPVA==
X-IronPort-AV: E=Sophos;i="6.25,196,1779148800"; 
   d="scan'208";a="24635295"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:50:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:23903]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.68:2525] with esmtp (Farcaster)
 id acec0eb8-aac5-4539-8ed0-a2679442d868; Fri, 31 Jul 2026 07:50:24 +0000 (UTC)
X-Farcaster-Flow-ID: acec0eb8-aac5-4539-8ed0-a2679442d868
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 31 Jul 2026 07:50:24 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Fri, 31 Jul 2026
 07:50:22 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v2 0/3] RDMA/efa: Add support for 128B admin v2 SQ entry
Date: Fri, 31 Jul 2026 07:50:04 +0000
Message-ID: <20260731075007.3878376-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Changelog:
v2:
 * Rebase on for-next branch instead of wip/leon-for-next.
v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/

-------------------------------------------------------------------------
Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
extends the v1 header with checksum and payload version fields, and
carries a larger inline payload.

The series first decouples admin command payloads from admin headers,
then generalizes the SQ ring to use a configurable entry size, and
finally adds the v2 entry format selection based on device API version.

Yonatan Nachum (3):
  RDMA/efa: Decouple admin command payload from admin header
  RDMA/efa: Generalize the admin SQ
  RDMA/efa: Add support for 128B admin v2 SQ entry

 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++--------
 drivers/infiniband/hw/efa/efa_admin_defs.h    |  33 ++-
 drivers/infiniband/hw/efa/efa_com.c           | 194 +++++++++++-------
 drivers/infiniband/hw/efa/efa_com.h           |  16 +-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 +++++----------
 5 files changed, 240 insertions(+), 289 deletions(-)

-- 
2.50.1

