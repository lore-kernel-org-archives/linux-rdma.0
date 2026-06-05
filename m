Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D03E0251;
	Fri,  5 Jun 2026 03:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780630179; cv=none; b=iqxzds3Kwb+68olp0y8SMFFyXp6xz9rpbjt06aepiLxS7uIBH1yG8CcJfbJWMTFwYQrHawqWVauaffDjeEfn+5iY1DTi/sA2XxT+g7gDxnHGnGrOejP9U2Pe2HtxNG7Cx95q6EAvY8uxBanaKdjJ+Z3GWjdHGZEfl8LfUgR3/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780630179; c=relaxed/simple;
	bh=09OMGCXdgPxRIUIcs5HYAVa/yTG0nxi353C0a2eeW38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LunQNebmqJ1qdApCLjsoCV3YIVaA3cVf7CYYR+OXaE7AXKEldTFY3ffDqjj2M4IqJo61aicy2Aqg1vdL7E0vJJM2oC6ZQyopFbuW29b6zg1yjCFUEoBjcRR8vONn4oVBBw5s4uLri9GBDmme/M4bgzsz8lFQuZx4407VIRG8Bco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MF1Vxc1w; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MF1Vxc1w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780630167; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=v2zJHdDZm7IzZSlv+vooUHOvAPF8NoHwQA9KCee3Wkw=;
	b=MF1Vxc1w9OtvuLtROnpm5HMt11KH6r9p+wJOTpleDXpfvgMOgtBCXVwUmFjl5cORDYHuT4OSCi4XNBBLUFufqMbhqElL9u8OCfLpbLOHW+77RNpuFqivVL5a/S1RunZik2tz3wcQ7zFbl48GhcPO4plLpRBtKHeBHh5h4RTKKwA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X4BnY77_1780630165;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X4BnY77_1780630165 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Jun 2026 11:29:26 +0800
Date: Fri, 5 Jun 2026 11:29:25 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Jakub Kicinski <kuba@kernel.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, oliver.yang@linux.alibaba.com,
	pasic@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] net/smc: transition to RDMA core CQ pooling
Message-ID: <20260605032925.GA60671@j66a10360.sqa.eu95>
References: <20260528084819.6059-1-alibuda@linux.alibaba.com>
 <20260602140359.3b97d180@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260602140359.3b97d180@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jun 02, 2026 at 02:03:59PM -0700, Jakub Kicinski wrote:
> On Thu, 28 May 2026 16:48:17 +0800 D. Wythe wrote:
> > This series transitions SMC-R completion handling to RDMA core CQ pooling
> > via the ib_cqe API. The new completion model improves scalability by
> > allowing per-link completion processing across multiple cores and enables
> > DIM-based interrupt moderation.
> > 
> > As a side effect, the increased concurrency can amplify contention for TX
> > slots on the shared wait queue. Patch 2 addresses this by switching TX slot
> > allocation from non-exclusive wait_event() to prepare_to_wait_exclusive(),
> > which avoids thundering-herd wakeups under contention.
> > 
> > Patch 1 replaces the global per-device CQ and manual tasklet polling model
> > with RDMA core CQ pooling.
> > Patch 2 reduces TX slot contention by using exclusive wait queue entries
> > during allocation.
> 
> Sashiko reports a couple of issues on patch 1:
> https://sashiko.dev/#/patchset/20260528084819.6059-2-alibuda@linux.alibaba.com
> Are these legit?
> 
> Either way - would be good to get some reviews here from (ohter) SMC
> maintainers.

Thanks for the heads up. 

We’ve seen the Sashiko reports and are currently evaluating whether
they’re legit. So far it looks valid, though some of the issues may be
uncovering pre-existing problems. If needed, we may send extra patches
to fix them before applying this patch. The SMC maintainers are already
aware, and I expect more maintainers to join the review soon.

D. Wythe
