Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8555D886
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092885; cv=none; b=E9UO4ZccTiEZpwSIkMMDbpoPLr2OBw+dDP0ZfWmjWUoWBt+YwmVOVnK6cnzFh/xrQfz4lH3yJpcpGlgneExos89nIe7NS3TeF4Z1qy0QQHDiDTB55WDqJ07nllNd5ijEwCsECTxlYjYSkMiAS0pEYvZapclQcPLrpbcMhp15At4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092885; c=relaxed/simple;
	bh=fmOq75za4TWaPhy4bxNoDrJZugXXq9I6BpIoeX0CIUU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GoXm9G8wFUivmzU8SrmhmcbKqeGH2lykLHIDo71G3zJVvHlGuHeTY4xDPP+Z98c1h+7VhtmoGGeM25uLjd5WonSPzybJ/YZ6OnC3QC4uDvm1Gb3c53jL24zEgf0/pf9xmJHbi5vWseK4Kl7bxcN9goaQcNLtgagN/l/L6AIGOUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ilKyCr3M; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ilKyCr3M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790092884; x=1821628884;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4fAlYf6bai8dX7TH8zpvtcif5Qs6ObPrKtmEx4imNiU=;
  b=ilKyCr3M6rU4UQ7P2cbMR/iiWNvz6ZjHUDQyHv76OqHzvnBUq4XxGDa2
   J0L6xKRUsRF7bpHHsiwLkDlraaN27RqRiQn4Cn5Hn6TXMR4heWANUdC89
   9hVdjp0lleuqDb0QpdMdBRAcMnKNoZdkUdG0a2beWKMleLuLjhzqQQ1AU
   7GG9Pe/RaSOmHGlGmq45WGl2aroSzE+wurYKh9Gi5+Y0+J3zsYas2TDXA
   Bry4XhI/nLDczSMZzR0sFC9UnFR+v/U4tTTPt1q7pXzszCg1NziT3pZ6j
   wFP3W5VGaEop0u5P5SqICOBdslgoEPBTFUfn3mYeJi/zIQaiQ/oooR0eq
   w==;
X-CSE-ConnectionGUID: X+qMzKa2SZ+U3gcCc9+Xug==
X-CSE-MsgGUID: CCPH80+xQd27bOKFfixGHw==
X-IronPort-AV: E=Sophos;i="6.27,116,1787011200"; 
   d="scan'208";a="29146766"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:01:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:22633]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.70:2525] with esmtp (Farcaster)
 id 27c602c0-18ed-4d96-bef9-d6218d9abc4e; Tue, 22 Sep 2026 16:01:21 +0000 (UTC)
X-Farcaster-Flow-ID: 27c602c0-18ed-4d96-bef9-d6218d9abc4e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 22 Sep 2026 16:01:21 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Tue, 22 Sep 2026
 16:01:20 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next v3 0/2] RDMA/efa: Add support for MR relaxed ordering
Date: Tue, 22 Sep 2026 16:01:16 +0000
Message-ID: <20260922160118.990-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add support for MR relaxed ordering access flag, allowing userspace to
create PCIe relaxed ordering MRs.

-------------------------------------------------------------------------
Changelog:
v3:
 * No changes, just resend
 * Link to v2: https://lore.kernel.org/all/20260824073057.1046630-1-ynachum@amazon.com/
v2:
 * Remove the relaxed ordering device capability.
 * Link to v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/

Dana Malachi (2):
  RDMA/efa: Use device ABI MR permissions instead of verbs flags
  RDMA/efa: Pass relaxed ordering flag to device

 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
 drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
 drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
 4 files changed, 21 insertions(+), 6 deletions(-)

-- 
2.47.3

