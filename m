Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792540950;
	b=aSk8LF3a3RkM+qNXrnkTOFShkR3Yw3lV/l9bn1oKr/1mYy2Ye94C6iRn1IaPT67NfIhj
	 icxr+WclPzS3n28OUIBbtAVJp9lDuqQeKXgwOivBEW5HiY43FlTrA78mCniLkd09MnBJK
	 QAi/4Z09ItMaj2eEPnKOrkO5TOihcsncw/mV2GYlGs3Au+14B2rAYsEH7Pg3ksRhODcxK
	 8ZX9//8IUVrYVpmaBUHLGQ17CaAv7/Nx873ifvxXR78kw0K6nCsgul6Q8So48UR7GtXaO
	 tcrNUI/zKGbe37EbxB3PEy0LlZ6++oy+OriYsc5oUbSsf5loiRadXD13szgFnQkVbFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792540950;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=L/iXX1PKqJsgt5/W9CiPqOLhRee36XHrCszd+bo5MDc=;
	b=0FZ7JlGoNYGbudzrfnxbzWEwa/vrKVd6pll3lhSgXpIad9QvrqrnkWWvyUc+kHbVTEh7
	 0YQJbxdV+KX3ti2OsjpuFkydtXN54I1g7s8Qz2HodWKN0R3PmVJPHbM5Vu9eAPW+yi0cf
	 VSMM9tMO6a3gw/So5EPq8R3crgnx3i1EgZ72lecU9jyEYmIueT3lynnARg2omceyNIjdJ
	 77ssXhW+QIzsa+sAZUaA9Q+3AVq7bAQhChzP2eAiFjr6dALAp0erh2VPxZv0zozLt5UDc
	 hCNHNH3+KlfeHsG4uAVA9Cg4x9337XMVwWn9K3OmLm1+yuNHeImPdqryc+dm+386dGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DNhCiijw;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F55606A319;
	Wed, 21 Oct 2026 00:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58F55606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DNhCiijw
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792540945; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=L/iXX1PKqJsgt5/W9CiPqOLhRee36XHrCszd+bo5MDc=;
	b=DNhCiijw2Qhkm6O0SfsW+PRNH5zaSM1+up0Va9dsDb1uYCCofEoegYD24kGYr98YxSNAey+soKYgmKBxvfmpoDBKP90Qgm6qEuzczXppZJ/E1sEchSdDYmQsD9/SOmAgNA5ZBu89MoMx3U60rfAoeQG9+k1gHMsqSbNumu0bsl4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDERKvV_1792540943;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XDERKvV_1792540943 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 08:02:24 +0800
Date: Wed, 21 Oct 2026 08:02:23 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Jakub Kicinski <kuba@kernel.org>, alibuda@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: Chengfeng Ye <nicoyip.dev@gmail.com>, davem@davemloft.net,
	edumazet@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v3 0/3] net/smc: fix link group scheduling,
 registration and work lifetime
Message-ID: <atgBD0t0xHnMlwjX@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261020125849.67c40566@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020125849.67c40566@kernel.org>

On 2026-10-20 12:58:49, Jakub Kicinski wrote:
>On Tue, 13 Oct 2026 17:17:13 +0800 Chengfeng Ye wrote:
>> This revises the two-patch v2 series and adds a separate fix for the
>> running-free_work lifetime issue identified during review.
>
>SMC maintainers, please review.

Hi Jakub,

Since we usually require Sashiko's review comments to be addressed
before merging, and we now have many more patches than before, I prefer
to wait for its review before stepping in. That's why I always miss some
patches.

However, Sashiko doesn't send any notifications when no issues are
found. I was wondering if Sashiko could send us a signal (or
notification) when it passes without issues so that we know it's ready
for our review.

Are there any guidelines or mechanisms that can help with this?

Best regards,
Dust
