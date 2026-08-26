Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D02D3EA968;
	Wed, 26 Aug 2026 12:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787748168; cv=none; b=mKYG+t5CRj7D0Ek+67echUz8TJ8J+ZUZfdCpohVzCTZHtujklYy4Ylxuux96Q00WDh6TM6k/vJBraOVwRwzyXPYwWxnjXH3UZQ45sST/3nVvZH2BzuvWsNc2Rh4k+o1gUfCWxTyoLKciVO/vgHTA2UDLgLmDVtA9vDxTC4NwYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787748168; c=relaxed/simple;
	bh=RykpmzM8VP8N4jPqmzJi7NQdEiXLFd6KA86mNzmsUac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMPVwRWsl7XVxc1ySgnZgOly1sUInH3G9SnpN964YsVZvtLWxo7uF0XFUhbv+LTo1ZzksEydeX85bD0pUCY4Q8IrYvdohwFOp+G1+H3iKG3AQCu7+8RgWIYunYeR+PpadJtS5xbdFthRgUBsawH2KjSuev/J7UqEzhlTCc8B8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=LemI+t6G; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="LemI+t6G"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 2D1F94E413C4;
	Wed, 26 Aug 2026 12:42:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D5886604EC;
	Wed, 26 Aug 2026 12:42:42 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8DC8D11C78133;
	Wed, 26 Aug 2026 14:42:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787748157; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Bp6YGE+7SBR9E9ISCb4FnjJrUlmaJNlhCUdcBy6XW0M=;
	b=LemI+t6Gl02EuLwgM4WqthJR9G5PUktBl8kNfwXcMV/8nWLGaa2BsOt44Vkqbz6oplPPdt
	DdiFqkVnwrNOHgjAaAr+CQDy6hQkmyDyH6LTPU5Svvm0eAsmnUWvJ27Xoj8ZVtMsOKkcL9
	zwxXv6cLhzf/Sz1O8GC0laJQ2eQbQu4BMBYgQF6Ukfz2vQWZOWB++dpksI7MVgMoTnLmuJ
	H88vYk7W5+a6djiGjPyrDCVHfikhMaaTq3TnFkitjzKdmvtfnNu5wc6mtLZb7jn1Zo2BlH
	QDI6oFmvvQq6J6gn4zSGjlPCfxFPYeHU6IUHO5nEld/ScdEG1t1LeIcnXVgXyg==
Message-ID: <dc2ccb14-c7c0-402b-93b3-afba52df78fa@bootlin.com>
Date: Wed, 26 Aug 2026 14:42:25 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 3/3] net: stmmac: document oversized AF_XDP frame
 handling
To: Jakub Kicinski <kuba@kernel.org>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com,
 andrew+netdev@lunn.ch, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com,
 sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, guoren@kernel.org, dtatulea@nvidia.com,
 witu@nvidia.com, martin.lau@kernel.org, yoong.siang.song@intel.com,
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 linux-csky@vger.kernel.org, leon@kernel.org
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-4-sdf@fomichev.me> <aoceSoSFMx69Z9up@boxer>
 <aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com> <aogpDsa8hz6CPpD3@boxer>
 <aoiIarzdjk92RkCN@devvm7509.cco0.facebook.com>
 <20260824111443.34bffe04@kernel.org>
Content-Language: en-US
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
In-Reply-To: <20260824111443.34bffe04@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3



On 8/24/26 20:14, Jakub Kicinski wrote:
> On Fri, 21 Aug 2026 10:28:47 -0700 Stanislav Fomichev wrote:
>>>> I do agree that a better idea is to probably do these checks during control
>>>> paths, but it's a bit more involved (and not sure if it's possible? if we
>>>> have a bunch of xsk sockets and we change that max_sdu, do we go over all
>>>> sockets on the system somehow?). My main motivation with this patch was
>>>> to make our LLM reviewers less chatty about preexisting issues.  
>>>
>>> I hear you, however I feel like we do not know this driver too much and
>>> probably we don't have a HW to test out such changes, so maybe let us try
>>> to fix existing behavior?  
>>
>> Let's definitely fix it properly if you have better ideas. But since we
>> don't have HW, I'm not super confident doing anything sophisticated
>> myself :-D
> 
> Let me take the first 2 patches and leave the stmmac for later.
> I don't think anyone involved care particularly deeply here.
> 
> Maxime said he bought a bunch of relevant HW. If we finally wrap 
> the AF_XDP tests into driver runtime he should be able to help us...

Indeed, I haven't started looking into the AF_XDP (and XDP in general) on
stmmac, lots of fixes lately on the subject so I'll get there eventually :)

I'm currently plumbing the driver selftest on my setup (ethtool -t) and just
runnign this uncovers lots of issues al lover the place, once this
passes I'll get on the kselftests and see what we can do on this.

Maxime
