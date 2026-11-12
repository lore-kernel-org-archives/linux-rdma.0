Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794481595;
	b=V1OG10yov/idjUvqaxdlJYbnSntO1CDuKAyfDvnR9nUqAibdJKjGsTw5aU9JCG8ZNd4y
	 aQ/q/ASgBqtSes7Osraikxwru76zA37Z52LDTVFu26yEtm6r/7zPUHJ1KgODEoV7DxLwW
	 n/kBiO7uMYtQOo0u2n16dArnhB/nTQUZ0c9c2ZbYlpNHUmP3+LETNIgg9Sb4rgEetQQa+
	 18GLLlw5Dxb73vqviBEDVJ5e9PGdKht53t1IFhvuPTwDWW4nF5cyvWe4W9A5NXJ2cItbb
	 RkCNKULUZirwE3C6/g/67UphkGypkAXFNrjtG0AIexHPOXXQhTZtK34Mj/HDjcKgSKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794481595;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=U2avUcuoObfC15e2wpulGRQmTSkSpE6zv+IRtjwj1H4=;
	b=rdrJRfxW35hOQnWn6e6paAi4wt+jAGVSitNM+Ojl2D8cjO0AoMIDPa8qVcpuGUxhimMZ
	 X9R4SQNqxiCqpib/AwITbXt7jT8L9l2JPwU+cf9xlDW6wPNrO2psKIYgDO7550Z8AF5dm
	 5+D9JZOE86AHow/88jM/rW0dR8stMgJq5FxTaK6n3nXMjER00JY972jMaZfU1v5rZFlQH
	 6iX7LWFb8KdF2T1bi8GjOYuZw0pZtVgqgbGekKoW9UMLcHs9jnzbJQCKhXyy/8DWaHdri
	 nB1Nu9merVtGUyHn5VtD3prZa+V+QiLBpZZ63EuYFler3UJsf5KE9X3M5HVDYkYVTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=JqW+yN8c;
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BF606A323
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 11:06:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 468BF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=JqW+yN8c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794481595; x=1826017595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U2avUcuoObfC15e2wpulGRQmTSkSpE6zv+IRtjwj1H4=;
  b=JqW+yN8c08cSYY5P2DzNs5Y1bqcrUtC+LSItoYuz2Ek50e9fQW6DrtLu
   IxgjjJw+GWuek1QpsgmoM4vB6OH9Vg5i+eJLWGYS+n/J43o+kGEPJbXux
   TbeFQ17IY6ueEJGvc5I7VejT4/HMP5nf4YO7Q6FQkLYhx/4/rRu9MUjoz
   XvDuHHlkA587FvmNFnDiDymBedJlD/X5FI+Pt0jugRwljX10hN8NWD8G4
   e8fVEqRBcOalGt5TuiSH+58jPjjRp5eGFg4O+HX0PZOaHtDQId1FkZVe5
   j5ebLDbPwIvusUlnhPRuk1lShbZAhkTIToQbjl5wW2UiiD5l1/KnKJlFM
   A==;
X-CSE-ConnectionGUID: YFC7sQHJRrCbGaRBjYDjyw==
X-CSE-MsgGUID: mpNUeolFQGCQa8G6DrNoWA==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33595036"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 11:06:32 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:19019]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id c7b0e0d1-a745-46eb-82ed-7d04a74ee92e; Thu, 12 Nov 2026 11:06:32 +0000 (UTC)
X-Farcaster-Flow-ID: c7b0e0d1-a745-46eb-82ed-7d04a74ee92e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 11:06:32 +0000
Received: from dev-dsk-ikolomin-1a-673563de.eu-west-1.amazon.com
 (172.19.125.167) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 11:06:30 +0000
From: Ilia Kolominsky <ikolomin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Date: Thu, 12 Nov 2026 11:06:24 +0000
Message-ID: <20261112110624.19917-1-ikolomin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109081349.27316-1-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

The rdma-core counterpart is up for review:
https://github.com/linux-rdma/rdma-core/pull/1854

Thanks,
Ilia
