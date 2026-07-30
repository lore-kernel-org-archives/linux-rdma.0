Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947CE2F39C7;
	Thu, 30 Jul 2026 05:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785390236; cv=none; b=YVa9WGhX4vFZDx15EKolY2p7M0zAP/F7GPuhsmo/JUAmNrVxOTv8200VCig6I+NgNfLM2Gi4esFl2dNzHTpzf/yLkD2QBDYbHEEb8FkdloFWFIH7oyB+xaI9K4B37Qd9ruZ7hRGyqn9E8RB6U5f318md7jDoJo05gAt9en2Xbto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785390236; c=relaxed/simple;
	bh=r67pZ/vOuOMEK045wV+jH6NC7RflH5Q1MUGdqlyGvSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKLpe7bEvL2PMXf8Og8SwCHl1nRRezl+ZZu8Is435/YatOfDOsvVAUf0UvsdVC5ZfsV2+QW7lG+NnlGM1KPbJ54VgHoHDE0ua99DEz+9BhoqQgYs3xc3x5FoZs3+DSI7KKNtM9l0ikc/UYlI1I5EENhfD/QXA8OU7Iswv+mvvQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bWmVau9z; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bWmVau9z"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785390224; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=wpE+mVKTeJAkeuJ9qronGd9HrTv1M9cJYsVrmp3yGDA=;
	b=bWmVau9z5gpxXrsP9SDECU0s3/p9VE0x9PLmCDCJrmwrMvJsQpZ39wEVPUUMSBOrxxYs1S+yx0emexxhhHN/ocdmTMteAGJk1IRCnUp6y1zTanhNSMATLekycF1h2VOeZuBorXWGYTGSycaX7q/sXq5XE5wAdXjSRPNgewf9Gd4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X84.V02_1785390223;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X84.V02_1785390223 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 13:43:43 +0800
Date: Thu, 30 Jul 2026 13:43:42 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
	wintera@linux.ibm.com, dust.li@linux.alibaba.com,
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com, kuba@kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
	sidraya@linux.ibm.com, jaka@linux.ibm.com,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
Message-ID: <20260730054342.GA116570@j66a10360.sqa.eu95>
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-4-alibuda@linux.alibaba.com>
 <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 22, 2026 at 05:17:15PM +0530, Mahanta Jambigi wrote:
> 
> 
> On 16/07/26 5:07 pm, D. Wythe wrote:
> > Performance Test: redis-benchmark with max 32 connections per QP
> > Data format: Requests Per Second (RPS), Percentage in brackets
> > represents the gain/loss compared to TCP.
> > 
> > | Clients | TCP      | SMC (original)      | SMC (cq_pool)       |
> > |---------|----------|---------------------|---------------------|
> > | c = 1   | 24449    | 31172  (+27%)       | 34039  (+39%)       |
> > | c = 2   | 46420    | 53216  (+14%)       | 64391  (+38%)       |
> > | c = 16  | 159673   | 83668  (-48%)  <--  | 216947 (+36%)       |
> > | c = 32  | 164956   | 97631  (-41%)  <--  | 249376 (+51%)       |
> > | c = 64  | 166322   | 118192 (-29%)  <--  | 249488 (+50%)       |
> > | c = 128 | 167700   | 121497 (-27%)  <--  | 249480 (+48%)       |
> > | c = 256 | 175021   | 146109 (-16%)  <--  | 240384 (+37%)       |
> > | c = 512 | 168987   | 101479 (-40%)  <--  | 226634 (+34%)       |
> > 
> > The results demonstrate that this optimization effectively resolves the
> > scalability bottleneck, with RPS increasing by over 110% at c=64
> > compared to the original implementation.
> 
> Thanks for the performance numbers — the scalability improvement at high
> client counts is striking. A few questions to help reproduce these results:
> 
> 1) Was net.smc.smcr_max_conns_per_lgr=32 the value used? The "max 32
> connections per QP" in the description suggests so, but the sysctl
> wasn't explicitly listed.
> 
> 2) Were net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr left at
> their defaults, or tuned? With per-link CQs the optimal WR counts may
> differ from the global-CQ case, so knowing whether these were touched
> would help interpret the numbers.
> 
> 3) Was this SMC-R v2? The v2 TX path (smc_wr_tx_get_v2_slot,
> wr_tx_v2_ib) has different concurrency characteristics, so confirming
> the version matters for the contention analysis in patch 2/3 as well.

In our tests, we set net.smc.smcr_max_conns_per_lgr=32 via sysctl. We
also tuned net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr from
their default to 64 to provide sufficient work request depth. 

All tests were run with SMC-R v2.

And the performance numbers do need a refresh: with recent improvements—including
thundering herd mitigation in earlier patches, the original SMC implementation’s
regression in the c=16–512 range is expected to be largely resolved.

> 
> 4) Was uperf tested for v4 as well, as we did for v1[1] in
> February-2026? uperf exercises a wider range of message sizes and thread
> counts, so its numbers would strengthen the case — particularly for the
> intermediate client counts (c=16 to c=64) where the original
> implementation regresses below TCP.

Of course uperf was tested. We’ll include a comprehensive uperf
evaluation in the next version. 

Given that this CQ-pooling patch may require additional review time, I
plan to send the first two patches of the series separately.
They’ve already been reviewed and are ready to merge. This patch
will follow as a standalone submission once the uperf results are
ready.

D. Wythe

> 
> [1]
> https://lore.kernel.org/netdev/20260202094800.30373-1-alibuda@linux.alibaba.com/
