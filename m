Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC544E655
	for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2026 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787232314; cv=none; b=SNar45EeFJtHaQXaR2nu4Li0TNME53uZpmqEdEoN9p+9+ADK18NXiQ+gcQga7v/LhxxmJeZna+XHwFFmClnbzeLlZEwX3tk6jP9ifnSwNpW+ZCkmjTiSDYhlMvlpaIZM0bqthFnOggcyixpqIvFx1/ieD9WvNaZjOlrZ+ZtxKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787232314; c=relaxed/simple;
	bh=oodidHthKqnaocJR7FdH/865yN9AxJYR0G1qnoJ8P5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ko4N679dQS4GrvFFsA5uiIwubdwdvkYSTDBcbljxvgEwmn32gqRVlhR5B8FrfmwcD8GXR8l45XgVKTxJa/XYrT8AJ7dniQK/BbGHO88LkEssqmQa1vJSFaVFV75ZEFjBszCMSpUjSuDNIXEiw/pQ5no9mYHOmYQHVuh8zBAVkvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xr/SupHD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpSIZZEt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xr/SupHD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpSIZZEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787232311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/0v2ILIh5MBGsD0dXIHABcykS6dXc3s6xjBbGcHl2A=;
	b=Xr/SupHDrqDpEm7RdFwIOr5S5/2dYpOXAVQDItDSK4xPSiPR5rdVT9DTd+y5qOUIHmKrfH
	7uUoSN9HU6hkRcRQVaa6HQDdEsDhmXL92LIKkhBjxHSHOfHzTGsHU5R4xsUcnWM0Tc175p
	9xDyqTKkvQBHlsb8dcLUYfcHCULGJDw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-w5PUnguzPpOHcdL-nvqjJg-1; Thu, 20 Aug 2026 09:25:10 -0400
X-MC-Unique: w5PUnguzPpOHcdL-nvqjJg-1
X-Mimecast-MFC-AGG-ID: w5PUnguzPpOHcdL-nvqjJg_1787232309
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so1531482f8f.0
        for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2026 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787232309; x=1787837109; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a/0v2ILIh5MBGsD0dXIHABcykS6dXc3s6xjBbGcHl2A=;
        b=HpSIZZEtDm2WuTgE6YUUwteDAzT1GpcYXS/cUT13XnqIF3FfGYBUb1I48/va1XyRuw
         MOxbzs9lZW1uKtkpPQ8ytuz8x034VvlLH9pmvIpErWGTLn4HWCD9Q06YbgElca/8PxNS
         A8pi9I6It6dl64ThBcTCHCCsX4+Ie5F6l4NQ9+DWrfVuHM1k5qhC4Tz+nveBpGdSm7fn
         RP3TKQELNCqsORJ597Nf+ktjwj5PMKU0PVAmbmktyllab6vIuWJ+nFdKALviRg8hCU0c
         JkW0cMnZiQEZhDeCrVorpY/E6/ZIJU990ejsc7NOo9b2PA4SrX9peANovX+rDRJmB77u
         Hqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787232309; x=1787837109;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a/0v2ILIh5MBGsD0dXIHABcykS6dXc3s6xjBbGcHl2A=;
        b=luvrz1VHRUp04i7No/NtF6ZAnvDTtG5vbY5GSGemzE4pOd0pAvO9XSMdcQOyqRj0Fa
         PmVKJYq9FH6e3AVL44qq5CPhPCzqN665eiOAYtzxlxsyWda00symtEo/GmTlA+Fw2gtj
         QQp8/7s0v/vcgljOjWAOi8kdvbIdVed1XRPmbjhPBf+bNDYi2QJWNDtl+r7iQm8Rl8d1
         56zrWY975vq+1cWfECvf4u8+4mS0nlM5IcT8NvjrkBWTzSvW81lq7XPwi5MzKKxUfHYs
         jwXtodXaB9InMEfXG7JHccHohPxgVQFt9x9+PTpraNeOq1PuaqT0a3kFTr02l8AlGIdh
         mORA==
X-Forwarded-Encrypted: i=1; AHgh+RrEoOQFjTyJaQASglJahZdG4mkPndJX894vx/rKaTNaLyuE1UgugDp3AKy70oUxokYQrdalgCt1o9/6@vger.kernel.org
X-Gm-Message-State: AOJu0YwDTBNYy2e+AhPhSXkwE7EeazXna+X1nWZnsxVvz03XolpZOe95
	agNnFoi+5UOhRiE9WpuGBWaACcWBYy4FfAYINhOdzWHc7jSCgu4faGwzt6Lmt1G8J6r0AOI//pK
	Xj03C4fZ7UBbRVh6oqaxveh1cvruTCQlmzkETtqDi9wsmZ2k+wyoFfz0xMo+VHsE=
X-Gm-Gg: AR+sD12TpY6CKR9aK3WYn2j8qCOLpz645EFtIYmQHFmEQXJEdTUscUhIzIZOFUN7SrP
	ZITl7n77ZDBE7wzm+XjgIv9h9r8C4ALN7YCCZ7f6M2OmY7as4diXl1D5HN8uE/4i/JexhiA9tf6
	IshhoyJp8+XxCaKeW9PqOsZMd/XL98aYihqVwr7hyKY1ve1p8AXJBCztPnA/Ypy8MEIIRUMPDaq
	f3FjaHQ+fq4pqO5VJmTgoCI71U+1qx7YfbC+/udhdHZqHuJvynx4p6BT4N7ozfm2Gon5mgi0UPc
	YR3s06sSsFTs5Q+zUkDBTBhsSny/vLFo2v+quZWzSKZCaBMKeeOK2Tm/gNiBcG6UE2520jGrgVr
	tOvF+DU0i7GIBMyYTX/6RriAbmXQ5q2hQC9b1Yc55IY+9oILEYYRh0S7h20VKyJJONFnOv5zxzN
	Y=
X-Received: by 2002:a05:600c:a47:b0:499:726a:a017 with SMTP id 5b1f17b1804b1-499aa14a6ebmr196855375e9.1.1787232308899;
        Thu, 20 Aug 2026 06:25:08 -0700 (PDT)
X-Received: by 2002:a05:600c:a47:b0:499:726a:a017 with SMTP id 5b1f17b1804b1-499aa14a6ebmr196853915e9.1.1787232308364;
        Thu, 20 Aug 2026 06:25:08 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b212fc11sm30099185e9.1.2026.08.20.06.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 06:25:07 -0700 (PDT)
Message-ID: <840b8084-3ee8-457c-8717-f3c20cea45d6@redhat.com>
Date: Thu, 20 Aug 2026 15:25:04 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next, v3] net/mlx5: Use dma_wmb() for completion queue
 doorbell updates
To: lirongqing <lirongqing@baidu.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Boris Pismenny <borisp@nvidia.com>,
 Richard Cochran <richardcochran@gmail.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Kees Cook <kees@kernel.org>,
 Akiva Goldberger <agoldberger@nvidia.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816035605.1873-1-lirongqing@baidu.com>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260816035605.1873-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/26 5:56 AM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> dma_*() barriers are specifically for ordering writes to DMA
> coherent memory that is accessible to both the CPU and DMA capable
> devices.
> 
> The dma_wmb() barrier is lighter than wmb() on some architectures
> because it only ensures ordering for DMA writes, not for all writes
> including MMIO accesses.
> 
> In the MLX5 driver, completion queue (CQ) doorbell records are
> allocated as DMA coherent memory via mlx5_dma_zalloc_coherent_node().
> The CQ update pattern is:
>   1. Update CQ space (device reads via DMA)
>   2. Update doorbell record (device reads via DMA)
>   3. Memory barrier
>   4. Enable more CQEs
> Since only DMA coherent memory accesses are involved (no MMIO accesses
> follow), we can safely use dma_wmb() instead of wmb().
> 
> This change improves performance slightly on architectures where
> dma_wmb() is lighter than wmb().
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
## Form letter - net-next-closed

We have already submitted our pull request with net-next material for v7.3,
and therefore net-next is closed for new drivers, features, code refactoring
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after Aug 31st.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle

