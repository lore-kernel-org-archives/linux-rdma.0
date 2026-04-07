Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33883DBA0
	for <linux-rdma@vger.kernel.org>; Tue,  7 Apr 2026 11:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775562873; cv=none; b=pKX8vUfICfP44KKBX+EeqGmpQbFAIj5D74U4/cMCk4z9sj5A0nJgMA6dSB1RQcNmuCwxJc3LAebD6bhIdGAp5qVVok8AgvGPANTTkITYPOVWL/nt3HkXvq0RPn9m0pMlOTV0Nm5qKwtIV9w41vP3o/HpRk85JBYIE/5znd/Q/0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775562873; c=relaxed/simple;
	bh=OAEG+odDFzq+B+ntzGsA9LcXP3gFhUsc6kVro/Y4rTM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pW6FyZfCTGLVrRH+VwWBzRtXwnDHcazNpRrV41qvyRpE3iEzw6rRYJTI/0uOueWXIy956REDHKAnP3vd0PnPqJhedGABdxjtiPzNAlHIM5w3z4pApzBfMXm4nCFozpXsoIJ6le8lZYY9oqdeYRsX3zYxzV1mUlYrA3MFMWwD52M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gMdYgZUl; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gMdYgZUl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775562871; x=1807098871;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+c80v/7gGFOyrtZ6m235KF+RHJqrJCgiQFmfOf4aXaA=;
  b=gMdYgZUlblvygV6R1d1u1z25wWbm0oNDJvr9DU9Z789NAvWDc8QaP7sb
   ET5+gFomlEczq/7AX0FLZOaXVjoSZt6ihCaQB6upGhI9HNxPkxS8q31od
   O2kZGR47UKfqtWMJ8U/dJf2A5erWNENflC/GkVb5qRADsg3c08cYbdmkE
   O1JW3rL+x6OomEoJm7f5037OJs434SBbVkRWC8n9twivPrX1MksuV2z/6
   ER+DQxptMBlAhq/BxnKsSTsBb/Z0Ig8qVKm3wez1LsMLkGDRvTa6lMv8y
   TxW0ah7XDu9Jwi1ZMNtMb6awmXs/qQfGFPsITfsK1yqa7lqK9ckM/v/qh
   A==;
X-CSE-ConnectionGUID: uafQbYEoQbunXinUSlSv+Q==
X-CSE-MsgGUID: C2pV5J67QZuJeax2nn366Q==
X-IronPort-AV: E=Sophos;i="6.23,165,1770595200"; 
   d="scan'208";a="16725590"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:54:29 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4853]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.131:2525] with esmtp (Farcaster)
 id 0ee80ad2-0689-4c25-ac28-99429a1df8d6; Tue, 7 Apr 2026 11:54:28 +0000 (UTC)
X-Farcaster-Flow-ID: 0ee80ad2-0689-4c25-ac28-99429a1df8d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 7 Apr 2026 11:54:28 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 7 Apr 2026
 11:54:26 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next 0/4] Introduce Completion Counters
Date: Tue, 7 Apr 2026 11:54:20 +0000
Message-ID: <20260407115424.13359-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add core infrastructure for Completion Counters, a light-weight
alternative to polling CQ for tracking operation completions. The
related rdma-core interface proposal is linked in [1].

Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
set, inc and read methods for both success and error counters. Add a
QP attach method on the QP object to associate a completion counter
with a queue pair.

Completion Counters can be backed by user-provided VA or dmabuf or by
internal device/driver memory. Common command infrastructure allows any
of the implementations to support the various device capabilities.

Add EFA Completion Counters support as first implementer.

[1] https://github.com/linux-rdma/rdma-core/pull/1701

Michael Margolin (4):
  RDMA/core: Add Completion Counters support
  RDMA/core: Add Completion Counters to resource tracking
  RDMA/efa: Update device interface
  RDMA/efa: Add Completion Counters support

 drivers/infiniband/core/Makefile              |   1 +
 drivers/infiniband/core/device.c              |  10 +
 drivers/infiniband/core/nldev.c               |   1 +
 drivers/infiniband/core/rdma_core.h           |   1 +
 drivers/infiniband/core/restrack.c            |   2 +
 drivers/infiniband/core/uverbs_cmd.c          |   1 +
 .../core/uverbs_std_types_comp_cntr.c         | 379 ++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_qp.c |  45 ++-
 drivers/infiniband/core/uverbs_uapi.c         |   1 +
 drivers/infiniband/hw/efa/efa.h               |  15 +
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 185 ++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 106 +++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  36 ++
 drivers/infiniband/hw/efa/efa_io_defs.h       |  62 ++-
 drivers/infiniband/hw/efa/efa_main.c          |   8 +
 drivers/infiniband/hw/efa/efa_verbs.c         | 177 ++++++++
 include/rdma/ib_verbs.h                       |  27 ++
 include/rdma/restrack.h                       |   4 +
 include/uapi/rdma/efa-abi.h                   |   1 +
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  65 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   9 +
 include/uapi/rdma/ib_user_verbs.h             |   2 +-
 22 files changed, 1131 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c

-- 
2.47.3

