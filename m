Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7BE5012AE
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897686; cv=none; b=C3To5Yde6TTmF+EbDeiHh0GTb1GCcaBANBvrpg0MHwZ7zXfg8qanR4wDClq0VEYwtvMw0Ke7Mz8zWcHZoBcrGAAKqtansI0Txg1XjoGArASJx5XeKM5p/Azgp7oFtFUaGkI+UcLEQ8TLwSXXke6Cs9xHbXqOuUUJBf1Xj9edCj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897686; c=relaxed/simple;
	bh=BvtaUtFdbiCNkaXYcZhsgNSTf2dCycJmgGtA7X8OnbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8pg2yWKaQQuWzrpd8OxAGmXeXZ+TM/+iQ76slSzEH1EU3lMF5XUOUaR+a/2oHenB8hVIFZkXbocqGaymEB4+GgQzB6ASbsBhyzGX5ObwW6AujnBsFuzOI0x5sBLmCN6/KIfY3lEaHJnvtzUxcT3BqUN9mQc3VKXJpd//cMAbwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0a4BZ5w; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nTR+HIxA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0a4BZ5w";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nTR+HIxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791897684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06m+m/LRJ65UZtLEQP5684UhWN/mRM6P8E+bPSuZSJM=;
	b=W0a4BZ5wCunuBDqYWKxtnd8bfenDS8axc5PMWyXBag4lzxIVVZBWY3DAiq/bIjFleCnxsn
	76mppcntlWe8uIJqxbJgsKfwq8+Majm09wvY3LYeg+SIQ4bnwzZp/fPMTgownaRwN4h80g
	Iu9+5rqZHL35SIL2VSBUuOLqBzc4ZK4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-5-g1oCy_NJWpAtsWFwdjHw-1; Tue, 13 Oct 2026 13:21:23 +0000
X-MC-Unique: 5-g1oCy_NJWpAtsWFwdjHw-1
X-Mimecast-MFC-AGG-ID: 5-g1oCy_NJWpAtsWFwdjHw_1791897682
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49cdc4080ddso22865245e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 06:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791897682; x=1792502482; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=06m+m/LRJ65UZtLEQP5684UhWN/mRM6P8E+bPSuZSJM=;
        b=nTR+HIxAnDQkQx2yZA4GdxkpVow1IRDHmjZ7wSLW8+XW7ZslimvebufklWJLzeGK1L
         Oz/ltT3i04zvXBNkTNz+PxYk1Xtn3kic1JActk7sDDdaQgA95172vNVAVIAw+CoWbEmC
         Pn7yPWsU9MtGrzkw9ab7lKnCR624aj8WVsy8W9tlSGhSc6eTWI3bezzVU2HAolJqfTqf
         TT/jQAZa56q3DhWIni5ueEAZSpWVqBU9RjGvCme0VehkjLoURG3WWeR18hJ71dPmcGfs
         6RaaGJ1W4uYcpTJ2pjjsGvC343VZjCBwBAZL0RgHVkjwsKu7eTl4rWKPFI4YTjmBWyyw
         Y/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791897682; x=1792502482;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=06m+m/LRJ65UZtLEQP5684UhWN/mRM6P8E+bPSuZSJM=;
        b=Cb6Gq9L8RHtY0ageG1V6lBlRmLxpjxWJ4yCAp0a4wCYHBiE7muimkszQdTlM8DLxCd
         lPGyrJX7y8DODMamjClWKU9QZe7tQbYSDmXl4RsFFk2grYigQyymAdekSh7SONzr5ZEt
         NXQkQxMqhKBIBBBQW/jbq/4CBqZ0JBgEbQAgjLO+38Kvg8ieTZ88lCQutwaoy3ed0YL+
         gW6f8o8LNt+UqPLhqJEagUeO2iE2eE5OmZ3UKNoM8Jo6fs34Y4y5S2NfmOevImLWBC6x
         RVYel2lF/WhZ/O9OW67UJp+CnCbGCyqCngs4CtMlsj5T2ZDdw/v+s9qYo8ButEf3mS6p
         VdIw==
X-Forwarded-Encrypted: i=1; AKwUvByPSpRFJVTJX6FvrMaJzC6pcVWX+0H+juO/v/vJ4r+fvP5e4LNgvihIm420DOPMSlgtqwX1gHD+pt2F@vger.kernel.org
X-Gm-Message-State: AFq9FYLsrr8zsmFY/o3K73NVJ8j/M7psrkBADsMV+uhRDyU2cUhFdjhW
	1w+Y3frLADrZeP0XFrZz5jHHgJc0/U5k18cHXsVCi40nOszoek0U2OpT/LVPuyZYcvlnBL0l7yy
	IV4IL2p1AuxRR0oodXhXdAcqKnrzzYy+gHrGVUf9ntRJ2heclczxu2eoSycjF6gA=
X-Gm-Gg: AYBFou2rmPiwEv9Wql/q9OsapvPyB/My+DCmg80HEuZBetN2wVkkvQQQyyUgb6QoxKr
	PDbR/ra9THOVxl++6Xwc3EsdR9MbAocmHBiuS+GPfJEKtZp1LHOCHPsfv6OF7cVMxxnjepoHOf0
	VZClRsQX7WZicvSQWNT2xCf+an+TrbhaNqpLm+UCvLI4Trt5fIKe9Synufhj0oTViA/h1/uNSMv
	eLPWW9kZCqm9zMCz4HqLJAzi7xGJL2c4qAOTva0PXGpmIUixJNKVMqj2Vx9+nbkbcn1e9Qns8ab
	Pn5HBQV2rqhTbeKLCOg4xAfk8p3772u6trjoCI7mG3FATrdRGTajzwwUbgmoum2RiLZ76i1U50+
	KwtSsXrBH4sPduB5UcXA2TYHTVjZEiNljOKMd/8HGWiYD9PdqWMESADrdHd+hLlKrxcBQFMm2ug
	==
X-Received: by 2002:a05:600c:3146:b0:4a0:34a:588c with SMTP id 5b1f17b1804b1-4a18e4a7cb9mr247571935e9.14.1791897681814;
        Tue, 13 Oct 2026 06:21:21 -0700 (PDT)
X-Received: by 2002:a05:600c:3146:b0:4a0:34a:588c with SMTP id 5b1f17b1804b1-4a18e4a7cb9mr247571485e9.14.1791897681195;
        Tue, 13 Oct 2026 06:21:21 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1ae0c9fadsm65215725e9.4.2026.10.13.06.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 06:21:20 -0700 (PDT)
Message-ID: <f55e07d9-3b47-4f74-b458-9a841234c681@redhat.com>
Date: Tue, 13 Oct 2026 15:21:18 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/2] net/mlx5: HWS, fix reformat release and meter
 offset
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <d19cbf9f-a5af-4fe5-9c20-eac1365afb92@redhat.com>
 <25a7141a-7c98-4678-8f17-374e920aad6b@corp.free.fr>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <25a7141a-7c98-4678-8f17-374e920aad6b@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 14:04, Alexandre Cassen wrote:
> On 10/13/26 12:39, Paolo Abeni wrote:
>> On 10/7/26 16:38, Alexandre Cassen wrote:
>> The actual impact is not clear to me
> 
> Both bugs only affect HW steering mode (opt-in). I found them on a ConnectX-7 while offloading multiple tc rules, each with its own encap and meter.
> 
> Patch 1 is a leak. In an add/del loop of an L2 to L3 tunnel encap, every iteration after the first leaks a bulk of 64K entries. That is about 2 MB of host memory and 4 MB of device memory.
> 
> Patch 2 is more serious. Every tc police action past the second one runs on the meter of another action, so its traffic gets the wrong rate... (my use-case is mobile network where counters accuracy is truly important)
Ok, looks indeed net worthy, thanks!

/P

