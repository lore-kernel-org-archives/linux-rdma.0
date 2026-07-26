Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428C36C0C8
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785069558; cv=none; b=RsUjXs/ddjQlSaSZBbQzYfHR0CP9HzC8VIsTEGxpSHMDBVg1HdQDUeEixYOw3J6senoWrU+Rj9s6bKlXDHE2lMNqaaswwTEcY9di2g8SAuCygc3jf3m/CPUfNUL8ytHukTeXPTWAK/cRAgxi/W2Z4GBmPES5EUSl/ffiF709eWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785069558; c=relaxed/simple;
	bh=hpSfywI9oPoFKNILUAy6A7/WAk3XMbSY3eCwiOmZSbo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=POpaGOJ4KUrom0KTydKsFEyoX37oa07CDD6wcSd9RuqU5bV8HBR5/c0dmLWG5/nMwUnbzOhF+b433zmwuFMnqjLpCCKC1PVT7F04Sjik7NCsyeQSxk5wilhQDelS4mg4AAKCsMAaY99g3WfBx/C/pcq17vUjA7LEzz+imJfHhJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RLh+eTig; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RLh+eTig"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785069557; x=1816605557;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ywtJJl6UhvtBXKxStr6wtbA7IjVpy54zORcuWK9ZwBU=;
  b=RLh+eTigm8hsN44nEdJ7fyNDvVfNUVgTFqVcckQvT08zvdDS3970/RuR
   fv0USNQiPOi2EPZ8eS167sepYmitk3YIA81I3oEoLxmIkQ2YueKR2w7VL
   LaE+g4lhOs8JAGxiMO5p1+ChuDWx8Ye96JqzCo5CLwebVVZ0q5YU9EqOU
   KFmllrbXDWasMPA0vR43TkUkbihO0OnyFxSzxf6MIEHApaNgbaK9bmvNo
   Xe2P3uQTiz9bSc17kQau9NjXDNqvY5mHpZJ3dXyWdNNBWIfh26MZEDODP
   xKj6OCuNjZYpcWGC3HfuKq7wY+vUxsRF3/QYxiEXWO4ji12hitWK6jwXF
   Q==;
X-CSE-ConnectionGUID: frM5T2hzRcCJdKXRmCY5uw==
X-CSE-MsgGUID: Qh8Do3A/S4S1jQBNZZD9dQ==
X-IronPort-AV: E=Sophos;i="6.25,186,1779148800"; 
   d="scan'208";a="24164056"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 12:39:13 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:25972]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.26:2525] with esmtp (Farcaster)
 id b5e378d1-256e-472d-913f-5542dda66a4c; Sun, 26 Jul 2026 12:39:13 +0000 (UTC)
X-Farcaster-Flow-ID: b5e378d1-256e-472d-913f-5542dda66a4c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Sun, 26 Jul 2026 12:39:13 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Sun, 26 Jul 2026
 12:39:11 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 0/3] RDMA/efa: Add support for 128B admin v2 SQ entry
Date: Sun, 26 Jul 2026 12:38:51 +0000
Message-ID: <20260726123854.638687-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

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

