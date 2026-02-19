Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840EA1EBFF7
	for <linux-rdma@vger.kernel.org>; Thu, 19 Feb 2026 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771462423; cv=none; b=oVmc/8Uq/3nqIU3/jhNsmVYAt1X0HUeo2uy5qzlDQtyLScvs2y74NcUaKhq1aBOtY9gQhUPISv+PXxSZGBC8ajMBWuMwlkbIT2Vq9UTSOTpeXFA82StgqOEnZTbmekaTXxWdYCRTNBbdwfSjlCyQ282xj5t/N6dR9ICsoo6LW5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771462423; c=relaxed/simple;
	bh=m6jU20WcnewWYKvUIp3/P1bCRaKEllC10X46P1g87r4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AHdg7yC03wJ53bqRM0NyoYFTIRuGtP1+NiKp/oiDBbO/dGv94+86koiQDmpZKEq0Y55JBSvkkn1N+w8jd9P48j/pypiSOyB1LcUKYUrgHwWlHYrxlyLeV4ty5RfLN4ljZJY9Df7msEuftCLn79RxONYnbQGwq0WHbB2QRHgdwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PStQ3nA3; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PStQ3nA3"
Message-ID: <392127ee-11ad-4517-bb72-91af64fd191e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771462409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrEmRGC944GsP7Yyeaksj64lgATVALEMxqI+i3nVu7M=;
	b=PStQ3nA3k1XjLI7RSZE66IuNbAuXdRUzufe4PePop166kxHT9aFwljBfEzjfU/UUvZUh6M
	h9XYYsbV2kpJBEA6myoP3f676UL3xdhJz52sqhqr5uiIDrWVtxX83Q2CknT03RjKzLxeOZ
	J+bxNzYtcLTcsOiqYXzNSb0XHbXT07g=
Date: Wed, 18 Feb 2026 16:53:00 -0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 02/10] rtc: prepare for struct device member groups
 becoming a constant array
To: Heiner Kallweit <hkall@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: driver-core@lists.linux.dev,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org
References: <5d0951ec-42c9-453f-9966-ecca593c4153@kernel.org>
 <95e5af90-ed53-4009-a4ea-19ed04499ecc@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <95e5af90-ed53-4009-a4ea-19ed04499ecc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/17/26 2:26 PM, Heiner Kallweit wrote:
> This prepares for making struct device member groups a constant array.
> The assignment groups = rtc->dev.groups would result in a "discarding
> const qualifier" warning with this change.
> No functional change intended.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/rtc/sysfs.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/sysfs.c b/drivers/rtc/sysfs.c
> index 4ab05e105a7..ae5e1252b4c 100644
> --- a/drivers/rtc/sysfs.c
> +++ b/drivers/rtc/sysfs.c
> @@ -308,7 +308,7 @@ const struct attribute_group **rtc_get_dev_attribute_groups(void)
>   int rtc_add_groups(struct rtc_device *rtc, const struct attribute_group **grps)
>   {
>   	size_t old_cnt = 0, add_cnt = 0, new_cnt;
> -	const struct attribute_group **groups, **old;
> +	const struct attribute_group **groups, *const *old;
>   
>   	if (grps) {
>   		for (groups = grps; *groups; groups++)
> @@ -320,9 +320,9 @@ int rtc_add_groups(struct rtc_device *rtc, const struct attribute_group **grps)
>   		return -EINVAL;
>   	}
>   
> -	groups = rtc->dev.groups;
> -	if (groups)
> -		for (; *groups; groups++)
> +	old = rtc->dev.groups;
> +	if (old)
> +		while (*old++)
>   			old_cnt++;

The change from for (; *groups; groups++) to while (*old++) is not 
functionally equivalent. In the while version, the post-increment old++ 
executes even when *old is NULL. This leaves the pointer old pointing 
one element past the NULL terminator. While old_cnt remains correct, 
this is a side-effect-heavy idiom that differs from standard kernel 
patterns and could be fragile if old is used later in the function.

Best Regards,
Zhu Yanjun

>   
>   	new_cnt = old_cnt + add_cnt + 1;

