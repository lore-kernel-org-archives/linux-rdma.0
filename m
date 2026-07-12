Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D17D39656D
	for <linux-rdma@vger.kernel.org>; Sun, 12 Jul 2026 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783863860; cv=none; b=F00C971LWVe39wuNLNjR919mytb3tN0GK5JtmNBywF3/ats8QzNljg6RyabOWgcS9kebJemcaCc3amSprHno3TrQ4OeJ5dtjXHaJZd6eM+9a9TUYHBSZZos/XcQNNCDsu2VGx/jlFJj0XYn8H9Fwu97B5vHtZCuinDbqH3k0XDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783863860; c=relaxed/simple;
	bh=KMrff/r7xAfLqJGtjtEEe+D7TvluO453zcqeQ/YFTUs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JJb3GVMirS4gALs2Y/W+ZxG1I0Q5gpfvHPhN8Ov6NLE3kIXCKlECEf8FdYJrHpaacAwJ3UzyG7ifFPd1cJ1rLOSZKhetMCcjzTPicfZPnMa4awMgRBS/47kaXUVutMrzeuxGI+QmIOI4ZoNW4a4BgtesKYUniiuU4y7OeUpCp6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=sNEJgkkT; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="sNEJgkkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783863859; x=1815399859;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y6CT9cuBen6IcdtNNPdnGn2sKcV3d+5ekhk6ovY2dlI=;
  b=sNEJgkkTOTr1Si1G+woFAZY5Te2hpQtdpXQqv/gEnV+XKQ4hqykNjsXw
   kphE3DAl/cwX5VW8QAGIJuyZhEdUwP4YrmWPBJiFQJ1x9pOYxAi1gHjXu
   qTUFWDWds7DuYjDAgkeu3HY4AIllkvOTKBMeuLkzhSfg6ylFLV/+0sHS2
   dc+uOeZkr/1zfIHS5C1qXdAGZvW9T2YhIF6/uZrEl9j8xRH/BAitO6XNe
   raFUug6LJgD60chjTXPRxHrvyJhrCvX/9tx7FD2Q1NSR384Dzm/rkczy7
   5W8aOlwVSDhThM+0/6i9goY0XKN4y8ExB0TSk9rMeetooY4hiBi54xErI
   Q==;
X-CSE-ConnectionGUID: ehcQMCAfTUOnG0oDbKY9Ag==
X-CSE-MsgGUID: yOWgq6qWRbemtQmkMtofrg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23305470"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2026 13:44:16 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:29775]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.68:2525] with esmtp (Farcaster)
 id d5b65652-e2b6-408f-9980-0dcc4c3a36ea; Sun, 12 Jul 2026 13:44:16 +0000 (UTC)
X-Farcaster-Flow-ID: d5b65652-e2b6-408f-9980-0dcc4c3a36ea
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Sun, 12 Jul 2026 13:44:16 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Sun, 12 Jul 2026
 13:44:14 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: [PATCH for-next 0/2] RDMA/efa: Add support for 0xefa4 devices
Date: Sun, 12 Jul 2026 13:44:11 +0000
Message-ID: <20260712134413.19226-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWB004.ant.amazon.com (10.13.138.57) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Make a minor device interface change needed for new EFA devices and
enable support for 0xefa4 PCI ID.

Anas Mousa (1):
  RDMA/efa: Add EFA 0xefa4 PCI ID

Michael Margolin (1):
  RDMA/efa: Extend page-shift field in MR registration

 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 6 +++---
 drivers/infiniband/hw/efa/efa_main.c            | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.47.3

