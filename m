Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795652222;
	b=kMSo3XGKMlPyzo/AUVty0Tw4a3oGoOCsSoFB1l5e9bHn0nLTjM00yrFmP9KDGwW5Xabi
	 D525FP6sjeJsro2eVpTse983B81J5yCZXjNpfIHMq4wAUkuoaanxU9039Oro1Dm/3Gvoh
	 DRNtjtntEwCnHQhRpHcnjb5UOch6giXjLoEWdzfGNnMMeA8zwz9ARZMEEeFMPsLYFHMu+
	 rWG5flcrvk32CD8K3r8SKEFsDyywHaAUJRsTs3y2Gd4Z+c+hZPZ1fJMYRM3y3uewFix9F
	 FVTsZpZzBKxIWEHYQWspglu97YxwNdDXaEjWspeHlyTTfGW34qf6W50inlJwdlVhDpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795652222;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=NJjDKjcR3y2MEVYEI6NpdcGn2af2AgvOjoZTpqMcRfE=;
	b=G8UXPvk4jdfkfl9Bahramsurzu9CxYRR/IHVuRkK1eemEbxOPi5VIFhFYQX9xuKaLrSm
	 xFWDAfX1vhdfcGUSQwRGY/bWzIYYl4oiKdYTE1A3YRXlb1w1kE7SI/pyWRkfRfDxLVgoc
	 swSbbmiMPENGw8l8T9lLhvFYXK8xCWCnDNdiNkoFYA0ap2a2ptNIENfeDqodPrrVQ7u3v
	 XIVntgbrzkZCR+gcVRc8q9xYfqn8GEoAokDcGMlL4g7GYVekM86Tt6B47NKFAH04cyWJT
	 SZAGZ7pPenBNM+/7W118jF5dvGZcd5uBjX66UCn2t/jk9UvkQ1nCjirmLFJTZi+O9eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=cukjlgCE;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CC606A321;
	Thu, 26 Nov 2026 00:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C31CC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=cukjlgCE
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jZcYH6PZxzLm0Y;
	Thu, 26 Nov 2026 01:16:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1795652211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJjDKjcR3y2MEVYEI6NpdcGn2af2AgvOjoZTpqMcRfE=;
	b=cukjlgCEF4cFyHFiW/XrSM87E4gFrCzAmsD+kxAyEUW+URhHfvkgrahTGy7nX6HbQDYE3q
	Tdb6Ytlr8pSCVl23gvxfYS1MMYNGz9DPnpK916sNG/D+zpae3EXKipIRbyd5rANaXsYaIt
	KNGjJAYvxoG2o5Xd5TXaRd0fv1fQAmwUVLECI1yujL7sUf2hpshJSQbAidTib3+zM9xUSd
	S6kjIWJgnR0gq4MsKhGB9Os0o36NlG5MnDUEVaXU4MLaUA+BhudTKp1E0fzPHe6h3qu7v8
	w4ZGxVjedMAsZkqoxio7/j1OZNA9TeD0GpHWo4rIDQ1G/LrYc/+G7lxL2vLhGg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <b201287c-002e-421b-880e-be1da8419e37@mandelbit.com>
Date: Thu, 26 Nov 2026 01:16:49 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides
 ahead in the linear MPWQE path
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, cratiu@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261104195241.1883539-1-antonio@mandelbit.com>
 <a31e1e60-7e31-4a14-a087-428d1e3627f2@nvidia.com>
 <674eb8ef-c93f-4926-a760-62df154ed3eb@mandelbit.com>
 <20261125215233.3422038-1-dtatulea@nvidia.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261125215233.3422038-1-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4jZcYH6PZxzLm0Y

Hi Dragos,

On 25/11/2026 22:52, Dragos Tatulea wrote:
> Overall I think these results are quite good. I was expecting to
> see some issues at scale but nothing really stands out to be
> honest.

Well, thank you for running all of this on hardware I can't get my hands
on!

> 
> I wondered how much each prefetch bings and gathered some data
> about that as well on the AMD system:
> 
>                            v2    without   without   without
>                                  page      headers   shinfo
>    UDP 64B flood          +7%     +7%       +3%       +7%
>    UDP 512B flood         +8%     +8%        0%       +8%
>    TCP 1 stream          +18%    +17%        0%      +18%
>    XDP_DROP read         +81%    +81%       -2%      +82%
>    XDP_DROP no-touch      -6%     -6%       -4%       -5%
>    XDP_TX               +106%   +106%       -1%      +108%
> 
> It does look like the big bulk of the advantage comes from
> the header fetch.

Agreed, for these tests.

The skb_shared_info prefetch pays off when the stack keeps each packet
in its own skb: with TCP through an ovpn UDP tunnel on my setup it
carries most of the gain (+34% with it, +4-5% without), while plain TCP
and pktgen were within 2% either way, which matches what you see.

> 
>> I'm also testing a small follow-up: v2 doesn't prefetch when the stride
>> 4 ahead is in the next WQE, so the first strides of every WQE are never
>> prefetched. Following the WQ list to the next WQE (only when
>> cur_sz >= 2, so it is posted and its pages are allocated) removes 26-32%
>> of the remaining DRAM demand fills on the RX CPU and adds 1.8-3.3%
>> throughput, measured with TCP inside an ovpn UDP tunnel (where the RX
>> CPU is the bottleneck); its latency is the "+next" column above.
>>
>> I had planned to send it as a follow-up patch, but I can also fold it in
>> a v3, whatever you prefer once you have your results.
>>
> Do you have some results for this?

Well... after running more extensive tests I came to the conclusion that 
my follow-up is not bringing any gain, despite what I anticipated.

Therefore I'd just keep v2 as is.

Thanks!

Regards,

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

