Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322744D685;
	Fri, 21 Aug 2026 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304021; cv=none; b=eayG/KUgPxFTiWBZtEucqI+mYtmgbNLZdwrZ4rhXr0QDGrt5rKf/tLHzodnyEn+GVqwhyV26QOZ6vyrpGfodi5EYLZU/nobZrZZpkueaCdzDPkxBnJUIx50GVJORZu2YUTbB7Z3Y4YIwnU1wbwj+VzMvO5pn37VVZ3L+C++VQTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304021; c=relaxed/simple;
	bh=uSYwvILXVXNQpISL+IuKJS1JgAFa48zavjmZQeM8LqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvZHd8or8jkoAXAoqm0Rabv0z2oleTsiO4++cAusUcgCnIH2dFxEm5C91xtIfVw038hpdH6ifETEIovYWBrVgXAc0NVjHIx9z1XMkTtAb25TvCFfwYk6yKl4lzJSCmlRM1i9NtLUi4oq1Eo5C4R+SXNPZ7hYmbF80j6WZSEKGlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pYUoxMBr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pYUoxMBr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787303999; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=wQ3iL2MITb+Yq7koLuTPc9/bt/hell0PC5ftKxvUGPo=;
	b=pYUoxMBrMPPIXHQgXReJV94FbX9fDAzn0xzJn8bk5H1K7s5he62A6OxXb7JFIr3UjpJI/7HXN2ZWVjmhYhgtg+PGXrlAPgnKkpzJl/Yx4m87s71WGtjPfHF8ep0HEt+fA4xHIyqcNU8cLO4yxfIRPruJi8CuCU7ZoLu/qQUcvyg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X9LvZ3E_1787303998;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X9LvZ3E_1787303998 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 17:19:58 +0800
Date: Fri, 21 Aug 2026 17:19:58 +0800
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
Subject: Re: [PATCH net-next v1 2/2] net/smc: reduce TX slot contention with
 exclusive wait
Message-ID: <20260821091958.GA21978@j66a10360.sqa.eu95>
References: <20260806064252.39180-1-alibuda@linux.alibaba.com>
 <20260806064252.39180-3-alibuda@linux.alibaba.com>
 <e16d16f1-029b-4d30-b393-2e9e525a2998@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16d16f1-029b-4d30-b393-2e9e525a2998@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Aug 07, 2026 at 11:15:22AM +0530, Mahanta Jambigi wrote:
> 
> 
> On 06/08/26 12:12 pm, D. Wythe wrote:
> > smc_wr_tx_get_free_slot() waits for a free TX slot with
> > wait_event_interruptible_timeout(). Since the wait_event family
> > enqueues waiters as non-exclusive, wake_up() may wake multiple
> > waiters even though only one can use the slot, causing
> > thundering-herd contention when slots are scarce.
> 
> Have you run any performance benchmarks (e.g. redis-benchmark or uperf)
> to quantify the benefit of this change?
> 
> Since the motivation is to reduce contention caused by multiple waiters
> being awakened for a single available TX slot, it would be helpful to
> see measurable results. Please share the baseline and patched throughput
> figures, and any observed throughput differences.

Yes, I ran uperf, and I have added the baseline vs patched figures to the commit
message of patch 2 in v2.

Best regards,
D. Wythe

