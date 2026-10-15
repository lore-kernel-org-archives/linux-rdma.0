Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9557147F79B;
	Thu, 15 Oct 2026 08:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792051318; cv=none; b=NntjKcONKmzR9Kd8PQMVgOspGJKUPiYGn8hzonc6X4QV1onNGSwOA/AP/SOo7kh1FQogM3jYwH0vWP3SivH0IplvF3vSWeQgBf7MeoqsiVGVk5pxQc09SrDCYz0phpPGsr3fVJ8JC4mdqgtQ9ltbj2/p4NlfMJEbn8BtY+ngJf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792051318; c=relaxed/simple;
	bh=wo6NeKZojviEosBcJYtMLCfWwCFzXBGs5gykktT9OoY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TM43TDzU2TioHkXFBWenQXosc9+PWY2kX2vBgrfXM2Vcxl7VeFLcPRM4Ht3YKTH85QVvOs/E89gtHChCTtb1MXGUDDD/9DjaPGy0Zz2FpJb62L266cmp0NyPrGHq7OkcR4LKnkpeFtTTjOmP/EzRJa+Xdlp0ws7+RZ7WJtkHABU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=u2mCl7oy; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="u2mCl7oy"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 685AFA1544;
	Thu, 15 Oct 2026 10:01:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1792051306; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lVUttG8iRwcZ+EEkZGFkY8VCO4ZqOKXFF79fwhVmDpU=;
	b=u2mCl7oyCi8dyZxjmVyFnt8dJgiEPaEMIOtQGIeJPZSatiNCMbd3UKDKNqpes8pwee5u/F
	lbvZUwDtJIoRyCjQ/+cS3jNdZajXUjYoxOvqPHBqSmlR9BUNcynm2DieqAh4giytIEf2hk
	CEwrarokbGLOInTIARveF4YGWoW+66ac4BkojHGFTcV8lCZDnywS+oZHmodumC9PcXZoqa
	IbiLemW1IXQ5T9xu0JwDwPa61Pzc6ENAVMVimKSjQRHtU25i0FoGXF+Fu+X2WaJyFt68gY
	94Gh8P+/sVSBhjl1S9eV8VXeuhpqyGzyrpmP2Wq92Uk3tNqbLdWqCGVxCWhfuA==
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 10:01:41 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: netdev-bot+sashiko@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 o.rempel@pengutronix.de, andrew+netdev@lunn.ch, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, Jose.Abreu@synopsys.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, dtatulea@nvidia.com,
 alazar@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in the
 loopback receive hook
In-Reply-To: <cccfd292-6169-449e-a675-a9bb54ec4191@bootlin.com>
References: <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
 <179149509090.434549.9918598206439291164@kernel.org>
 <533b88ce917b59f4f59f52145d2f035f@tipi-net.de>
 <cccfd292-6169-449e-a675-a9bb54ec4191@bootlin.com>
Message-ID: <d28efab10f43a46d51cdfd978b0a1e90@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Maxime

On 15.10.2026 09:46, Maxime Chevallier wrote:

> [...]

>>> Could an IPv4 frame that arrives during ethtool -t make the hook read 
>>> up
>>> to about 64 bytes past skb->tail? Examples would be a minimum-size 
>>> TCP
>>> segment or a frame with ihl=15.
>>> 
>>> The over-read seems to stay inside the skb head allocation, because
>>> skb_shared_info follows skb->end. If so, the only effect is a 
>>> possibly
>>> wrong selftest result.
>> 
>> The length check is pre-existing, will address that in a follow-up 
>> patch.
> 
> I'm unsure about this, Can we instead assume that when one is running 
> the
> "ethtool -t" selftests on a machine, they are doing so in some 
> controlled
> conditions ?
> 
> IOW can we take the assumption that we won't get incoming traffic at 
> the same
> time as we run the selftests, and if we do get some and that triggers a 
> wrong
> result, this is expected ? ethtool selftests are very cheap to run, 
> only a
> handful of seconds, and don't require any extra dependency, it doesn't 
> cost
> much to re-run them if something unexpected happens during them.
> 
> ofc. getting a stray frame during the selftests mustn't crash :)
> 
> That's my take on these tests, but feel free to disagree :)

Also fine with me. A stray frame just fails the magic check and gets
dropped anyway, so the test result doesn't even change...

Two patches less to fight with Clashiko over :)

Regards
Nicolai
