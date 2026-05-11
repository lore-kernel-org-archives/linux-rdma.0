Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B984D90BF
	for <linux-rdma@vger.kernel.org>; Mon, 11 May 2026 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535359; cv=none; b=DhTfavYt51NTbag+xF8C1AE34S/uD2x7ZrNqb1cRTPrQaxaHHh4KI5efbcKxCU363oLfasSJHCBTkkbDKPNhrclEZJePQMO/5zi9JyNxFtUGmlBPVGm3uajlgKmFU1/CDzHTfjxlcB60XrBNy+mEkn6BnSRz7ojKTraCD/JA8T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535359; c=relaxed/simple;
	bh=2lh1JxscjI/JPNbzMJoehpwVuxBEBs4qwVyiuXN5x/I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aeCnhlTU8S5V0rTsJs1JM0m+qW16gCHv/tA0ZbvPsPQD6Owfm1dwmxI6EZf2DcLYow1kjTW/Zt4P41Cd3q2sKntZp29LfqZHp2MZPLE/lEJ4yEavV2syeat4eJZFX3UCmWj6tSSVfMksdkVKWxfnlr8tX0UTwSvUuKF7B8fa9CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=tywiAdkf; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="tywiAdkf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1778535357; x=1810071357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iskYTQm+jOW+tX+HPkah7bwFchJFvmgIplWxI91KJJk=;
  b=tywiAdkfFGyIi2tiEnBtLjtyDm8sF9qkvLjnvtpM27ZuGdq7zAGlsAVS
   GzWm5G2AvC6LwgL3U+ZT8aoBHEj34NmE6x2qoLhs5M20p/JPkE12s0sdl
   +PKQ1X3sqoJVrAF9I69cVNIpoDs59EntoXMQGAN+L5cmtfcsfeAU47SLn
   n8rSDAucAMO2jqKl3QMRmruNgc/7DwkwHL25PiCKTr/ojtOEBm1q4X0Ni
   VlbB5EjES4yNlJ01aVRZcM7G0F5dWU+QJf4TYICHS0dsogHYaZRbjMa3C
   5kZ1oD7yYDgTp3rWjjxOdLeOn7eODmre3S8vAkRuuZIDRLby+dVEZ9kgz
   w==;
X-CSE-ConnectionGUID: f+43HD/0S8KNsfWcCVsiWg==
X-CSE-MsgGUID: N1GuB8gsRbG3Nbe4Uc1Z4Q==
X-IronPort-AV: E=Sophos;i="6.23,229,1770595200"; 
   d="scan'208";a="19393964"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 21:35:55 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:23093]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.42:2525] with esmtp (Farcaster)
 id 60461f19-6965-4e79-8cbc-caab62cd2bac; Mon, 11 May 2026 21:35:55 +0000 (UTC)
X-Farcaster-Flow-ID: 60461f19-6965-4e79-8cbc-caab62cd2bac
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 11 May 2026 21:35:52 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 11 May 2026
 21:35:51 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next v3 0/5] Introduce Completion Counters
Date: Mon, 11 May 2026 21:35:39 +0000
Message-ID: <20260511213549.594-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add core infrastructure for Completion Counters, a light-weight
alternative to polling CQ for tracking operation completions. The
related rdma-core interface proposal is linked in [1].

Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
modify and read methods for both success and error counters. Add a QP
attach method on the QP object to associate a completion counter with a
queue pair.

Add EFA Completion Counters support as first implementer.

[1] https://github.com/linux-rdma/rdma-core/pull/1701

---
Changes in v3:
- Replaced inc and set commands by a single modify command
- Changed to passing buffers as EFA specific attributes using desc
  struct aligned with the suggested common method of passing and
  consuming umem in RDMA drivers
- Link to v2: https://lore.kernel.org/all/20260416212327.18191-1-mrgolin@amazon.com/
Changes in v2:
- United set, inc and read flows for successful and error completions
  counters
- Added comp_cntr usage count
- Minor cleanups
- Link to v1: https://lore.kernel.org/all/20260407115424.13359-1-mrgolin@amazon.com/

Michael Margolin (5):
  RDMA/core: Add Completion Counters support
  RDMA/core: Prevent destroying in-use completion counters
  RDMA/core: Add Completion Counters to resource tracking
  RDMA/efa: Update device interface
  RDMA/efa: Add Completion Counters support

 drivers/infiniband/core/Makefile              |   1 +
 drivers/infiniband/core/device.c              |   6 +
 drivers/infiniband/core/nldev.c               |   1 +
 drivers/infiniband/core/rdma_core.h           |   1 +
 drivers/infiniband/core/restrack.c            |   2 +
 drivers/infiniband/core/uverbs_cmd.c          |   1 +
 .../core/uverbs_std_types_comp_cntr.c         | 183 ++++++++++++++
 drivers/infiniband/core/uverbs_std_types_qp.c |  65 ++++-
 drivers/infiniband/core/uverbs_uapi.c         |   1 +
 drivers/infiniband/core/verbs.c               |   1 +
 drivers/infiniband/hw/efa/efa.h               |  17 +-
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 187 +++++++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 106 ++++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  36 +++
 drivers/infiniband/hw/efa/efa_io_defs.h       |  64 ++++-
 drivers/infiniband/hw/efa/efa_main.c          |   7 +-
 drivers/infiniband/hw/efa/efa_verbs.c         | 229 ++++++++++++++++++
 include/rdma/ib_verbs.h                       |  44 ++++
 include/rdma/restrack.h                       |   4 +
 include/uapi/rdma/efa-abi.h                   |  19 ++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  38 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h       |  19 ++
 include/uapi/rdma/ib_user_verbs.h             |   2 +-
 23 files changed, 1024 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c

-- 
2.47.3

