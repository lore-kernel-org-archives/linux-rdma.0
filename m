Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB50C366DD6
	for <linux-rdma@vger.kernel.org>; Wed, 18 Mar 2026 06:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773817025; cv=none; b=PQvrdBHLOPYLhHp3tVDIFZbYkwzifubSWB1JC4TCsHtVdXfpA4RWvAQccSNTRJ6TH3nuJFHNhjWg4Ic+8gIdtKlbeskztAZ7azGrcIcb6l7DFTvCDBDlSfd4N1rZ5KNE3b5CaXylOYGSSW5KBMdzcI0sskX4Asx+oCFNV88FnUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773817025; c=relaxed/simple;
	bh=7r4rREtYzS7RIetKkZulZVWY3SE/VEUInHC+Z2dAQvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A0wHo4Vy+BxcwjNtJCyvXtXaPdMd2YtDwqaAYo9k7G3HLv4+TkwM6XDHX6DA34mCa61E/RQu8n9E1XY1CobAsFNJDGMcB+kQ+d5bN3DxHhG87XRkLQTGk58vDcKrVFAhvV4DO8FxBh9K3ijFHagdbaERomEK5t77xN+jgv3QU84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBVem5NL; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBVem5NL"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486b9675d36so11715435e9.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Mar 2026 23:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773817022; x=1774421822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qa/Moz62O8GLwDrNRnV6Ehz/SbUCQeDPfbe/JKDh9Kk=;
        b=OBVem5NLU+wZfXPDmkuM9wk/8hMQoKCfCNmHITK1vm/P838MWtbeAqdN/1TQWbeigL
         jI1/0ojicAr77i4relxMd3kHMQ634Q6XmDjLLVvBZiXphx8qngHpaqYMB5IlVT31nXjH
         UftlylWb9Vlr1GXQsGrGtK9MxdOsAMn2mbA6F5BvXISOZJpDcOuxrjAp0iqBcZljRPg3
         6jGaEad4YI6e8saxlrzMpMd/EozqHz86gkFcOd+0FTmHlZyhpil+1dxXSMsfE33l7Xdy
         Ydk7LgxyS9xaZRbYE7RAi9U8VCD2z8NUpsGKOOIU9kN5YjAWWPJjMGbxkgkchqg9cBm7
         g8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773817022; x=1774421822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qa/Moz62O8GLwDrNRnV6Ehz/SbUCQeDPfbe/JKDh9Kk=;
        b=fvtxAzCXhc2goGUqEBuIIhzke8Wm2+LVZFl/1CbdSU41wAiT5UaO+hNLxj0YLuR8NN
         XV8pSfJNZbOP7lBeIcYy/kv+wJfXDRWmHjqay2yn3iOWzcCD4M9AcD0jlMRUsl/1cfKG
         PLSH4ovamELZyxKVM7Qsw5NUe4VsXrshaOUOvz1h1OAmA/RTYePWFKI58QV4fc7Tbb63
         ocUUqkEnzdAewsV+aqxWwUzyiqVK2gPbi2KrRYVW1KrxICWyN8ZDe0/ovn082/YSZyF3
         LvIq5VyMLuqeu9dQXYbOCcaBy5OtCQtQDSwxvkKcwn83k3IGTq0zv9Pfjzm0vtHAdf0J
         zybw==
X-Forwarded-Encrypted: i=1; AJvYcCWmyzUyWNcsKLH+bkh5OeO9fLWf2K0LZhdb4jYcd3EbD1FiC2BmDzq2BfFucHkunI8MXvSjBgucNbMr@vger.kernel.org
X-Gm-Message-State: AOJu0YxpYW5zaixOQ4V3mIYtaSIimn22LkhJGwP4U35UTBYgT3jkEBcm
	7fnb27fC0meqcE/4HjZRAEwXRDDtzvDH+1LgiAqMpRL0BnJxpNhE8fAh
X-Gm-Gg: ATEYQzxK0Pry0QQWV+FKD92zfhF2dK8rl5HJCLG/JqkAEnymKjfMrx2keUFcdMpIpT5
	NPRsJPCsKpu7KAHZVJsTzRGsbNZfk7FQCLO1XUtBhq+mP3Gbj9te03DU2WSach8yhCK/aep9k4O
	y2HjrJjoHlYjBknqOV5hm2+zfo8Rc3fW+eZScwp+sOmbaxLGWsJ6BP5S0xe2aHUpqVIuaJ0TLfD
	LClvki7z5CcwAe0T7qjnRnnXFbpOdbJDGBncxWfUoj+ROqMke+s4dTo9eJjQMIn8aW9QiE8+6vZ
	fMGN/liJUjWwGLV7fWG87o0ccuXm7wW746SVSZRQfZEA2zTmXF58WCjTPwQmRwuQwHA976qHtsM
	6RQatHy//EQIESTpE3x0sfPYYlxwu5Lg3J6RnsPoFsKRlGtcTXiszdb9dkZq7nRwXkvvnpCv6/1
	4hWEdFtpEtC7NiWvSdetdCszmj0+EP0wOOOfMx9ECV4qg/QA==
X-Received: by 2002:a05:600c:1d10:b0:485:3d3e:167b with SMTP id 5b1f17b1804b1-486f441fc5bmr36391095e9.5.1773817021929;
        Tue, 17 Mar 2026 23:57:01 -0700 (PDT)
Received: from [10.125.203.73] ([165.85.126.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f442d5d0sm39444455e9.9.2026.03.17.23.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 23:57:01 -0700 (PDT)
Message-ID: <fe0ed720-f246-427d-8b47-3a273fb53eca@gmail.com>
Date: Wed, 18 Mar 2026 08:57:00 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][net-next v2] net/mlx5: Expedite notifier unregistration
 during device teardown
To: lirongqing <lirongqing@baidu.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: liyongkang <liyongkang01@baidu.com>
References: <20260317003544.2583-1-lirongqing@baidu.com>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20260317003544.2583-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 17/03/2026 2:35, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> During device hot-unplug, the mlx5 driver expects quickly unregister
> notification chains. The standard atomic_notifier_chain_unregister()
> calls synchronize_rcu(), which introduces significant latency and
> can become a bottleneck during mass resource cleanup.
> 
> Introduce atomic_notifier_chain_unregister_expedited() to leverage
> synchronize_rcu_expedited(), and use it significantly reducing wait
> times in the following paths:
>   - Event Queue (EQ) notifier chain
>   - Firmware event notifier chain
>   - IRQ notifier chain
> 
> On x86-64 with HZ=1000, 64 networking channels:
> - Average teardown time: 3.59s -> 1.9s (47% reduction)
> On x86-64 with HZ=250, 64 networking channels:
> - Average teardown time: 5.5s -> 1.9s (65% reduction)
> 
> Co-developed-by: liyongkang <liyongkang01@baidu.com>
> Signed-off-by: liyongkang <liyongkang01@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> Diff with v1: fix doc warning and add detailed example
> 

Hi, thanks for your patch.

Direction looks okay overall, nice improvement.
I'd split into 2 patches in a series, though.

This is the kind of patches that should go through our regression tests. 
I'm taking it for testing and will update.

Regards,
Tariq

