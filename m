Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350833B8D75;
	Fri, 16 Oct 2026 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792185814; cv=none; b=aKRPUol7/fi+y+e8kmo5pXrWid4Ff2KaimEhPtsiL3i5M5H9jOva9GGPokE1vuaAxngQfWq0h6gsVyysQyQs/mr083go95jakE/nyJ8KE8Urd0zgz8J/ZnT62eka/CHGHW8wdnSHv+kAdfZJfGNJlLet/iWMR09HCntLPRa30C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792185814; c=relaxed/simple;
	bh=k5eU+AjNArslt6WuvCUs8UEbPBssuDqAe3sbA1Z6Oyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B07/RhYpBWz4gqMpOqVi8GCU+KfObymoHK4FxrGIuqM+8paVRRVCCvCz5kctvqvuZ0dj+qPfT/obdfBzkTZNAzFKcZ29WcI5hyF+0BioVbDkaMouEYyuELfSqgOtB8VqgVarhoZsbXcCKyuHgpzZVlNs6rYi/6WUyfMjKUHLiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X1zGMhek; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X1zGMhek"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5ybm4Bnyz1XM5kD;
	Fri, 16 Oct 2026 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792185810; x=1794777811; bh=HV+jRSuqzDBxLc4yaHalPU93
	tFmgNglrsaZOJU57dPU=; b=X1zGMhek+yjWkwlrVLzh41607ejjTY6wZetSCafi
	3Z2eecW86fLKo26PLkejxBw1v2CcqJBSBbK+hEGER8NyefjQZG2RvINPovTPC8to
	gxpukUZxA4A/udyo2g52wkEe6/O3Fo3daHjwdzuv9DdEakSogxTKx7V/KS0C1OBK
	Qy0Lul8izUT3XrE0oeSL6GD6nQaQAJlgoFejJxqYG03TyLexqz5Rxu1+8sQbZqRz
	t33TQ4wcEpwAj4lBgeJRNdVz00P1BtYk6gSL+MpzA0S38xOtcJZjVSUF9J2Tbe4x
	znKwaYlvn28sZrsDw6fyWyJRF61x+pzvtH9rDAdziZilZQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id waklk95cT94Q; Fri, 16 Oct 2026 21:23:30 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:6ddd:e233:4f5d:d6fa] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5ybk03SDz1XM4Tl;
	Fri, 16 Oct 2026 21:23:29 +0000 (UTC)
Message-ID: <6bf686e3-ee95-4055-9912-a77262716450@acm.org>
Date: Fri, 16 Oct 2026 14:23:29 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: Avoid reading uninitialized has_port on
 srp_parse_in() failure
To: Serhat Kumral <serhatkumral1@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261016211509.12973-1-serhatkumral1@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261016211509.12973-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/26 2:15 PM, Serhat Kumral wrote:
> srp_parse_in() returns -ENOMEM without initializing *has_port if
> kstrdup() fails. Only check has_port when srp_parse_in() succeeds.
> 
> Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
> found by smatch:
> - drivers/infiniband/ulp/srp/ib_srp.c:3502 srp_parse_options() error: uninitialized symbol 'has_port'.
> 
>   drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 955f36efeebd..5811f02df980 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3499,7 +3499,7 @@ static int srp_parse_options(struct net *net, const char *buf,
>   			}
>   			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
>   					   &has_port);
> -			if (!has_port)
> +			if (ret == 0 && !has_port)
>   				ret = -EINVAL;
>   			if (ret < 0) {
>   				pr_warn("bad dest parameter '%s'\n", p);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
