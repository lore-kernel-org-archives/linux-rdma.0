Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6205F4A2A5D
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789642290; cv=none; b=gSJiTRNJpcozpjDg92Wud27npOiIxi+Nqa9Mkj2NKTbsTOCz31Oj3Jdzv4YbQVF3sneaHjFqRFOhDXEsMO3tOfaHQlJsnm/KLdX57qZ/ehBXrehXdhUPL7lHPTm3OysSejQTb1MDgphv3drFCAywUXc9XilTWv36yYFKEHdYglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789642290; c=relaxed/simple;
	bh=RADAKZRXwFa/zD8svMRzsi68prJPe/XkzYJz486wmsE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a5rHQ08xcFmfwgUpjaxKYgRgChQc/jo0nxmMTkOAhkwk1E7+U4yaKGW4DCMY4iqdnbrSfGwhDERfaS57+MCvPskLz3jZ3gs3RrBzUoV0N8w3dJIwoKNL8HZMaT1QWSLJ/sVAN+FOfYeX1lj8jsgxSi1slLymwZqWwxqI4wz1kP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=loRJMa6c; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="loRJMa6c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1789642269; x=1821178269;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3LDhyuOQsOstB5BYkfGQuNUg8q8wp1YyjFmxdUg6ikc=;
  b=loRJMa6cGXMufUNRx0vbbnoRqySFqbqtR3elNn4SPa0qqkeHWNROsy8u
   PY+CCWqTozFxmh8QXuU5F0JGAlDqimVfNHJKDBUhPr5Ke3b1S38NMttEd
   gt+fSN4VkiSJJZejlwcbWvNSIjhHJAQ8S2iIyzns2xFMc3kqSP0IzCWQw
   OSZSrhRCj/QlM4NkDIjBra3US8tdXWW2jfYYhnjGYOD88i/HI86Z079RA
   mJ0JeE19x7CbK8syHFE1qm8ZdGhEJsl3GHl+KJU2EVV15gd0jPEAobW+f
   5pQ5vFsMhs81guqQUrQ95iWt+Joma/9jDji7JcT1Yfg0Wu3vZS0SmNyxz
   Q==;
X-CSE-ConnectionGUID: 1J5pCHKsSbqRfI0QCy0fXQ==
X-CSE-MsgGUID: jP4ihKkqRBGDGQQeFM2RYA==
X-IronPort-AV: E=Sophos;i="6.27,103,1787011200"; 
   d="scan'208";a="28920310"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 10:51:04 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:7999]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.10:2525] with esmtp (Farcaster)
 id 888effc9-99f2-4784-b300-de00b49ab8dc; Thu, 17 Sep 2026 10:51:04 +0000 (UTC)
X-Farcaster-Flow-ID: 888effc9-99f2-4784-b300-de00b49ab8dc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 17 Sep 2026 10:51:04 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 17 Sep 2026
 10:51:02 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Firas
 Jahjah" <firasj@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring allocations
Date: Thu, 17 Sep 2026 10:51:01 +0000
Message-ID: <20260917105101.9365-1-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

RQ and CQ ring buffers require physically contiguous memory. On
systems under memory pressure, high-order allocations can fail
even when sufficient free memory exists because the allocator
gives up after a single reclaim and compaction attempt for
costly-order requests that lack __GFP_RETRY_MAYFAIL.

Add __GFP_RETRY_MAYFAIL to the GFP flags in efa_zalloc_mapped()
to allow retries with escalating compaction priority and release
of highatomic reserves before giving up.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 2d28d68efe77..0b0396e190f2 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -190,7 +190,7 @@ static void *efa_zalloc_mapped(struct efa_dev *dev, dma_addr_t *dma_addr,
 {
 	void *addr;
 
-	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
+	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL);
 	if (!addr)
 		return NULL;
 
-- 
2.47.3

