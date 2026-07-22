Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1B3E3C74
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709371; cv=none; b=XKksG223M4GtjILNCC92porw1/tFHQ3UnQHAEQHc9ez4j+2mE6RGCC+J/GwIHraR2gsZC7ECD1D4T8iooxcZsLYYRxg+ap8U1NdelQBGGDvVobEdGAX5hVkgLexTud759SxLcG7UySB+7yx5jRd6Qmab0gz7Ju9TtlcIIYBpXB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709371; c=relaxed/simple;
	bh=Xt9B6QT8Al3ToHLjyjVJWrMXsZ3aZEYKUxEaEI8KG5k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ilzqUvT9DAzKhH1AkYC02MuYk7Y4DNnaoxzNAQrxKVrOlGlu1cAif00eGSFINonCvhLDgJZ6zS4Vzl9UVDNzS83IZIYzOIfsF0aFW88sQ21vfX2P90uC4UvrScSZg251pkdCAJeTC6ZCH3iEWHDngt7Q2h1Nh9S9NV2N30ZinXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=q2Hz7qKx; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="q2Hz7qKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784709370; x=1816245370;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rdLbqkC4ORcjN6PBzewq0DypmoHr34MAzfgTCJmx/+Y=;
  b=q2Hz7qKxpG57qwTuFNpCSvc26HxriQu+8BAe4magwfvrSj2TbaCVd6Ul
   Kf908gNRnQfk+7zqoUWrK7n13gkSciVKUoVuzgw5+Qek8r9piSNav5XEa
   ri1r2pu0bikZb59h0AL867fEptAsv3b8ubPXRu8F7VvbxqG6x1RrEyYOk
   o3o0wLQNaHLtpdomNwaCeZAGGV7N1sE32fyIXpmP51pnNuAIv+kKVJGFu
   JeB2iOJTNwyYgR6BPdvlfywUmlxA2Y4OwT8g/gA7adr1u+1N38tlw0FXL
   h9k2me3WqqhyhrzxoyarUCVOOuWCwTSIS6LWP0TP3Cei9PIS82LBRo34P
   w==;
X-CSE-ConnectionGUID: CoGn0UeXSTqYP/G/1AhGbA==
X-CSE-MsgGUID: J17ffuhkSoWnOE0HZIT4tg==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="23640020"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:36:07 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:18106]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.147:2525] with esmtp (Farcaster)
 id da52b7bf-0b50-4694-93c7-4d091a01cd08; Wed, 22 Jul 2026 08:36:07 +0000 (UTC)
X-Farcaster-Flow-ID: da52b7bf-0b50-4694-93c7-4d091a01cd08
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 08:36:06 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 08:36:05 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next v11 0/6] Introduce Completion Counters
Date: Wed, 22 Jul 2026 08:35:57 +0000
Message-ID: <20260722083603.30334-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add core infrastructure for Completion Counters, a light-weight
alternative to polling CQ for tracking operation completions. The
related rdma-core support is linked in [1].

Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
modify and read methods for both success and error counters. Add a QP
attach method on the QP object to associate a completion counter with a
queue pair.

Add EFA Completion Counters support as first implementer.

[1] https://github.com/linux-rdma/rdma-core/pull/1701

---
Changes in v11:
- Moved restrack init to be prior to call to driver
- Link to v10: https://lore.kernel.org/all/20260720132221.2551-1-mrgolin@amazon.com/
Changes in v10:
- No changes, v9 email thread got corrupted
Changes in v9:
- Moved counter max value report from per counter create response to a
  new device level command that aggregates completion counter
  capabilities
- Exposed supported ops in QP attach as part of the above command
  response
- Link to v8: https://lore.kernel.org/all/20260707203427.6923-1-mrgolin@amazon.com/
Changes in v8:
- Added device event counter detach support and its use in attach error
  handling
- Prevented completion counters attach to wrapper QPs
- Added max completion counters report in nldev
- Link to v7: https://lore.kernel.org/all/20260701103448.17895-1-mrgolin@amazon.com/
Changes in v7:
- Rebased on latest rdma for-next
- Link to v6: https://lore.kernel.org/all/20260604114627.6086-1-mrgolin@amazon.com/
Changes in v6:
- Moved to using ib_umem_get_attr util
- Resolved additional Sashiko comments
- Link to v5: https://lore.kernel.org/all/20260526090712.17575-1-mrgolin@amazon.com/
Changes in v5:
- Fixed Sashiko findings
- Minor naming improvements
- Link to v4: https://lore.kernel.org/all/20260511223721.18365-1-mrgolin@amazon.com/
Changes in v4:
- Replaced inc and set commands by a single modify command
- Changed to passing buffers as EFA specific attributes using desc
  struct aligned with the suggested common method of passing and
  consuming umem in RDMA drivers
- Link to v2: https://lore.kernel.org/all/20260416212327.18191-1-mrgolin@amazon.com/
Changes in v3:
- Skipped this version because of a wrong patch list
Changes in v2:
- United set, inc and read flows for successful and error completions
  counters
- Added comp_cntr usage count
- Minor cleanups
- Link to v1: https://lore.kernel.org/all/20260407115424.13359-1-mrgolin@amazon.com/

Michael Margolin (6):
  RDMA/core: Add Completion Counters support
  RDMA/core: Prevent destroying in-use completion counters
  RDMA/core: Expose Completion Counter capabilities to userspace
  RDMA/core: Add Completion Counters to resource tracking
  RDMA/efa: Update device interface
  RDMA/efa: Add Completion Counters support

 drivers/infiniband/core/Makefile              |   1 +
 drivers/infiniband/core/device.c              |   7 +
 drivers/infiniband/core/nldev.c               |   8 +
 drivers/infiniband/core/rdma_core.h           |   1 +
 drivers/infiniband/core/restrack.c            |   2 +
 .../core/uverbs_std_types_comp_cntr.c         | 169 +++++++++++++
 .../infiniband/core/uverbs_std_types_device.c |  51 +++-
 drivers/infiniband/core/uverbs_std_types_qp.c |  67 ++++-
 drivers/infiniband/core/uverbs_uapi.c         |   1 +
 drivers/infiniband/core/verbs.c               |   8 +
 drivers/infiniband/hw/efa/efa.h               |  20 +-
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 186 +++++++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 136 ++++++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  45 ++++
 drivers/infiniband/hw/efa/efa_io_defs.h       |  20 +-
 drivers/infiniband/hw/efa/efa_main.c          |   8 +-
 drivers/infiniband/hw/efa/efa_verbs.c         | 237 ++++++++++++++++++
 include/rdma/ib_verbs.h                       |  50 ++++
 include/rdma/restrack.h                       |   4 +
 include/uapi/rdma/efa-abi.h                   |   6 +
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  43 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h       |  19 ++
 22 files changed, 1081 insertions(+), 8 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c

-- 
2.47.3

