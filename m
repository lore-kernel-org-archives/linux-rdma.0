Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E37E26B2CE
	for <linux-rdma@vger.kernel.org>; Sun, 29 Mar 2026 04:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774760188; cv=none; b=tkkRFMaGBuwk/rnxHoqkAPYhes/Fh4OCSGO1AcAfNOP+QArRMsEy7baZ9UQaMu6jeSzkUFDLUk1zAnlLMzC03rTQPMaslHDLlpDD572f/F7jfEPJ/CnJ+eeLkmw25qpzLXCynHyUuT2rEDGZ9+ZqDJhpPf0IptUrhbI0yCVDBm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774760188; c=relaxed/simple;
	bh=oU/a3RCot96VV4uM6XU9A8NLYqLpK7UszhxF4L5pzgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FbTi3WMjjalymR/q4k4Z/tas+XEiRbAA0dmP/gl5URm7P4wwvb4VQ7ra6jZrzNtteaeuynracKoTghzV9fSfJOVK6RfYrRfDxCi6I1u4iS4p4Vy0Z/7V7Pzx60Cs6nvBFwu9CHfDBFXpJGSJb7PiOOn9Mqn98ykDEJFgXWyJHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CQDMjPmF; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CQDMjPmF"
Message-ID: <3cb474cf-4610-4dc6-b87f-83a9d26122ed@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774760184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7pKeZZ5u0do+GeuidQwFc8oBGmigXH9HGGSIgG0Y2A=;
	b=CQDMjPmFf7AWGI5+3/SdBdCYmYiix6yFp32b00Zz9H40/58g2kaxz5Adrkft73p6J6KQwq
	/W4bWA7Q7RP5zZWOWnarNw9O1ldlYRAs4ULOdzBK6xpm9eWmxyWETUaG3ZgFU52wRZNBcK
	6voq9dXqyx8Y0htZ118kdiKPYohnM1w=
Date: Sat, 28 Mar 2026 21:56:19 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] RDMA/rxe: use rxe_counter_get
To: zhenwei pi <zhenwei.pi@linux.dev>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
References: <20260329025552.122946-1-zhenwei.pi@linux.dev>
 <20260329025552.122946-5-zhenwei.pi@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260329025552.122946-5-zhenwei.pi@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/3/28 19:55, zhenwei pi 写道:
> There is *rxe_counter_get* helper in RXE, use it instead of raw
> atomic64_read.

This commit can be merged with the commit "[PATCH v2 3/4] RDMA/rxe: 
support perf mgmt GET method"

Zhu Yanjun

> 
> Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
> ---
>   drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> index 17edaa9a9b9b..a612e96f7a88 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> +++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> @@ -37,7 +37,7 @@ int rxe_ib_get_hw_stats(struct ib_device *ibdev,
>   		return -EINVAL;
>   
>   	for (cnt = 0; cnt < ARRAY_SIZE(rxe_counter_descs); cnt++)
> -		stats->value[cnt] = atomic64_read(&dev->stats_counters[cnt]);
> +		stats->value[cnt] = rxe_counter_get(dev, cnt);
>   
>   	return ARRAY_SIZE(rxe_counter_descs);
>   }

