Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF99282866;
	Fri, 19 Jun 2026 03:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781839608; cv=none; b=ulVam1e4U4OT6GuMM8MTJrM9qLvjPybdjv9eSOgx3GQpR1d7EO7BD+YPWLTSrEMcBfXXCpMm5HQaZNNc4JOmM04AVR9nwFu7/Cbt7+aWHX4H2Jy7DGXZfd2vdLo+XnWugcmVsILJTIomfTzCNBlC73WSEhm4vrTGPDInsKEvm/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781839608; c=relaxed/simple;
	bh=RhMF+a3ReSqjEpnlcOJmXCu8JxXZRKxHhEaO0ofoHdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNLnXG+v3Fxr9L0HKEQ2j3gzTdfPl7NGtPIn15mCHZp2fukvXJIZ8cmFLuxACAssL8wQsF46jY7Sx5F+LPysHHSV/5FaqaWrYRQ8FTknPGF0LBj7ozs7JYbltEXS/criEtkkGh9zr+JDKnTvu1xRVH/3KB+P58WPoELH4aRq6O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=g2x7iJB8; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="g2x7iJB8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781839602; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=P0imQdWNYfKihyd4X/Z8RiMP5Ap8CQYwmektOhkZ1mI=;
	b=g2x7iJB87dMcJqjfjSIa6GJOyffoXrDp4prOXPJaA7TRPb056nMRQ1RCAojopphN6PyDs/rI6d/Nl38ETtV7xJGelxHvEVjlevmOUabtCE7Ffei+uOxAYKYf3Ut0tY8BF2hdY13qxKYFOEVR8HsGhSCXdwZQtETuDXFrHY9AtJI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X58b8hQ_1781839600;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X58b8hQ_1781839600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Jun 2026 11:26:41 +0800
Date: Fri, 19 Jun 2026 11:26:40 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Wen Gu <guwen@linux.alibaba.com>, Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Stefan Raspl <raspl@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
Message-ID: <ajS28EYC-0zXvwbD@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me>
 <20260614-b4-disp-edd64be9-v3-1-551fa514257e@proton.me>
 <ajQAwBMzCJfO9SM1@linux.alibaba.com>
 <20260618221057.236673-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618221057.236673-1-hexlabsecurity@proton.me>

On 2026-06-18 22:11:05, Bryam Vargas wrote:
>On Thu, 18 Jun 2026 22:29:20 +0800, Dust Li wrote:
>> once we detect that the peer is misbehaving, I think the right action is
>> to abort the connection and record the event, rather than silently clamp.
>[...]
>>         u32 prod_count = ntohs(cdc->prod.count);
>> ...
>>             cdc->prod.wrap > 1 || cdc->cons.wrap > 1) {
>
>Thanks for taking a look, Dust. I'm on board with the direction for net-next --
>aborting and recording a bad CDC is cleaner than clamping something we already know
>we can't trust, and as you say, the clamp just papers over the peer bug. So: minimal
>clamp stays for -stable, and net-next gets the wire-boundary check + abort (through
>abort_work, with an smc_stats counter and a ratelimited warn).

That's greate. Then I think we can move on in this direction.

>
>A few things I ran into on the check itself, though:
>
>- count is __be32, so it wants ntohl() rather than ntohs() -- ntohs() ends up reading
>  the wrong half.

Right

>
>- I'd drop the wrap > 1 tests. wrap is a free-running counter (smc_curs_add does
>  wrap++), so a connection that legitimately wraps its RMB ends up with wrap > 1; and
>  since it's a __be16 read raw, on little-endian wrap==1 already reads as 0x0100 and
>  we'd abort on the very first wrap. I don't think there's a sane upper bound to put
>  on wrap.

Agree

>
>- the check is typed for SMC-R, but the SMC-D path hands a host-order smcd_cdc_msg to
>  smc_cdc_msg_recv() cast as smc_cdc_msg (smc_cdc.c:456), so ntohl/ntohs would
>  double-swap it there. The simplest thing I found is one check on the host cursor
>  right after smc_cdc_msg_to_host(), before the diff/atomic_add block -- that covers
>  SMC-R and SMC-D in one place.

Agree

>
>Minor: >= len rather than > len (count is an offset in [0,len)), and peer_rmbe_size
>is signed so worth guarding. The cons vs peer_rmbe_size bound looks right to me.

No problem

Best regards,
Dust

