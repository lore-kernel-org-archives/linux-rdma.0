Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA92376A04
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003108; cv=none; b=HbKENi4z+uv44A03sVcx9GXeA0JXCmPorOAIaBLIEy7RTHItqQwjsE434p0bCV67/xhlSg7vgDk9YwerCU/WMgr1S9Wj/PGdx9gwCRLZ3pWp962MEbsM5nH72F2y+h6OrdHEKj7eXnvftPM3Z9VyM0R1g4VDgac4Evv4dn/6Svo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003108; c=relaxed/simple;
	bh=2FaAj8b8F8tPnFyqr5rjSNFo6ABlhZtMTs7IpX13/bY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iFmAWYiEglDYU45rUEhHormPJxtK2SchDS99QqHTQU3FQjVOl5N2bb4CHlkzvt0aB3uvTq8sR7s2ANypZY/9SdXE+tmEb/z575OAMD8qw1gmZ2i+kIYwr5wkmyk1iS5HllsMTsUiBOHHggupK1l5yx7dYw3TSXVzNBLXvs3AcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VanWTxrq; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VanWTxrq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786003107; x=1817539107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5cM84qLenHgRsYM/+qt36SqzSaIcP4Iu2rqH2L7Bryo=;
  b=VanWTxrqSunATw3iqPRpmLYvgWRHCdFrs5qVLNTTgfXp5ufhM9JIot7C
   /yZ23yt9NvsOQjORYQMUzBhEzXBkBiBn31FwvszEWvYSrBwq7CB7Ioe9z
   IiBEFghwpGih1fI8KVRMb7xpNFs4VS81JLhFzbRaHBuNZXqHau+gdVB6G
   iqwk/7lFcWHno4BK2eDnADHgZ1ffVEvBxkmspqUDGyP8vjyaYd/1SnUDu
   WKwjtLBq9qcgdy491Iyx5aJcXWuEVank/6hptERGXPVO5WcF1drANcrMe
   XBImzewb1YlDbOsEUlw3MFCZhl9ZkkYDOAS5c5k+NnUaJjaBNEBiekOcG
   g==;
X-CSE-ConnectionGUID: YgkSpxIFTQKixEdjRsh7eQ==
X-CSE-MsgGUID: 3x1arNHQRrSIFcQRKtK/kQ==
X-IronPort-AV: E=Sophos;i="6.25,208,1779148800"; 
   d="scan'208";a="25049626"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 07:58:25 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:6635]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.97:2525] with esmtp (Farcaster)
 id b4cbb50e-a9f4-49e7-904b-fed7346fb4ef; Thu, 6 Aug 2026 07:58:15 +0000 (UTC)
X-Farcaster-Flow-ID: b4cbb50e-a9f4-49e7-904b-fed7346fb4ef
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 6 Aug 2026 07:58:15 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Thu, 6 Aug 2026
 07:58:13 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>, Yonatan Nachum
	<ynachum@amazon.com>
Subject: [PATCH for-next 0/2] RDMA/efa: Add support for MR relaxed ordering
Date: Thu, 6 Aug 2026 07:57:56 +0000
Message-ID: <20260806075758.3476667-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add support for MR relaxed ordering access flag, allowing userspace to
create PCIe relaxed ordering MRs, and report device support through a
new query device capability bit.

Dana Malachi (2):
  RDMA/efa: Use device ABI MR permissions instead of verbs flags
  RDMA/efa: Pass relaxed ordering flag to device

 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 10 +++++++---
 drivers/infiniband/hw/efa/efa_com_cmd.c         |  9 ++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.h         |  8 ++++++--
 drivers/infiniband/hw/efa/efa_verbs.c           | 11 ++++++++++-
 include/uapi/rdma/efa-abi.h                     |  1 +
 5 files changed, 32 insertions(+), 7 deletions(-)

-- 
2.50.1

