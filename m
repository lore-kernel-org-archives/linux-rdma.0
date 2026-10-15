Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717EA52CCFC
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073308; cv=none; b=LaIzpfMVa/wJz9n2K5a/W0mOPOB1shg3IoZcXLspG53KBXjU3e9haOQ9Wrmudxdal3vCFyKnKUV8109IA95BQTgOJmcwib8kx2JgP5a6h+sZCTxLXbMebpFeyklnTyGeHGOCQsw21UlGGjRGF10dUTHys7NKFFttOLPZBi/WWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073308; c=relaxed/simple;
	bh=QFpk+8sQmhCVU/moICNHTYP8N/ev3pN/k19hfrUS/8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adR9aIaflNy5DXWUmMaTsjNO70osKniEyzr792PTltqqmjltgtiJA3GzLlsZWiaPQ65xseupqoFf9N/jv//cB93Xcu1rNVpnt+H5CyDZpVSFBNeHs6q3+uLY8lkMrJ9Cci1QgxoNzMCenCr/fPl41O7ZCT4tl706w2SkQyj0+z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=QXe57afb; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="QXe57afb"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 5AE9E223B4;
	Thu, 15 Oct 2026 17:08:23 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=QFpk+8sQmhCVU/moICNH
	TYP8N/ev3pN/k19hfrUS/8g=; b=QXe57afbtSe1GE3BRLhBOWPMvGxmSuXHZL9Z
	7IC27ITefId9FeG6JJx5r1nBCmOdthn4u0I+817c8qengN80nq06wUSQxr0/cqnM
	/s7W2g5sdF969ezMnEdNVwLs/nV4Z62Y+OkZ/TB+beF2M3RoHaD4tEYuMYTbmyuR
	eBEvidA2feKM/RcGTn9ytwGTZOrgB2hoSMFtkJQreQm8zcAm+3h1Ri7ICbKdTKQ6
	qClbw/iP3n9v9FIs6tbVeHAermLMilH2uU+cM6Ftzb80UGUT6qBNRy9axQdbOcmR
	2XQWkGHVLKLpAEHF6LPiYtATkPgK/9mmnpkzUGdoSSrkXZhUHg==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 79522223B0;
	Thu, 15 Oct 2026 17:08:20 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 17:08:20 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: <linux-rdma@vger.kernel.org>
CC: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<sashiko-reviews@lists.linux.dev>
Subject: Re: [PATCH RFC 1/3] IB/iser: Post header-only PDUs inline
Date: Thu, 15 Oct 2026 17:08:20 +0300
Message-ID: <20261015170820.3064909-1-me@andrei-z.com>
In-Reply-To: <20261015163243.3011667-1-me@andrei-z.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-2-me@andrei-z.com>
 <sashiko-outbox-172888@kernel.org>
 <20261015163243.3011667-1-me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Li RongQing already posted this fix:
https://lore.kernel.org/all/20260921033949.1803-1-lirongqing@baidu.com/
I will leave it to that thread.

