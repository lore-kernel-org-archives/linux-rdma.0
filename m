Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA5E3A05E5
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784534108; cv=none; b=mWFzULH3NcnWJeozquSKBQOj+IPaE3W3hsqgIkPtVaMG9c8XseXl/IiyE4Y2slFexuVfbhb0KsIIPa2OzXBPrEzBW4suvPhfY1v5qeYM2mVC0ThApfv2/1caSe7B+qt5/hJg2XTd4/zeQTEJQfmuGFJjtsSWyav0Ugf7jdTUjKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784534108; c=relaxed/simple;
	bh=28WScuu0jfrswjHmNz9Ej4qAor4LPh1t63qt7U2UHWs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZV+oAye6FTxh+c/fy3poHSSwVXTpXhVp9eJHBaWIvUKLhGMYl/pLqwnLWKiwaCNda9aInhoNXxLG9JPmTo/LCy/GrwjyqEPff2unE8qyFZF1uyDD8PgmdjP9kiUx0968yreJVlfIt8OVavskYCaLQI20ai/WKtRp08f0IbFCh1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=aI0u6UAD; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="aI0u6UAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784534107; x=1816070107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/EtnZYie6oWuL34CTLKQIe18YHW/xsETw16pZaoDFDU=;
  b=aI0u6UADVUH+6hKl/+I8Af0bacgxoq7pF7kFDtrrVgrZMuAQjQ4fG58L
   70nSMsmWNQyOhUtJsYtpKXZCjUUosJNBPzXzM4ig1iXS4k0SLCSNcLEya
   uYgW0sVB52OXCrfDG8W9lg7dr242Ho5d1ydvauFEAFvicwpfokxl19RGD
   KMH3U7svFXYnObjnWtDc7NdCXGwx2AF5C42decWtitNFNDvtkfiFZHdRs
   2/DO7HgPKEsSJj1iHNmXmRG7GHtPz55CKnzNUkqCWG6X8dgQKuZh6AGsg
   InjBRypTbhMh2e3xW4rlTqbEjLDrRjKgdsMkYd9th5a41tUxNFQyYgtVt
   w==;
X-CSE-ConnectionGUID: kY66qEC9TpO9wuAIgH9n3w==
X-CSE-MsgGUID: Tv+HAMMiTvehxbTQtxPKdg==
X-IronPort-AV: E=Sophos;i="6.25,174,1779148800"; 
   d="scan'208";a="23986292"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 07:55:04 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:9829]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.177:2525] with esmtp (Farcaster)
 id d8c19cbf-e39e-4f9b-9f53-7bcc087e2573; Mon, 20 Jul 2026 07:55:04 +0000 (UTC)
X-Farcaster-Flow-ID: d8c19cbf-e39e-4f9b-9f53-7bcc087e2573
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 20 Jul 2026 07:55:03 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Mon, 20 Jul 2026
 07:55:02 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next v9 0/6] Introduce Completion Counters
Date: Mon, 20 Jul 2026 07:54:55 +0000
Message-ID: <20260720075501.7868-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
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
 .../core/uverbs_std_types_comp_cntr.c         | 168 +++++++++++++
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
 22 files changed, 1080 insertions(+), 8 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c

-- 
2.47.3

