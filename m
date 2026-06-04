Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252F1449EA9
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780579928; cv=none; b=KEMrGn6khN1C40wvI8sthvZmSZqBaiQNua/NUoF5IpOJkyugLJ76nZCyadF5fp4u1EqV2Ejxq/4ycb+sRkz9A8u11j0VzkI7qM4yc/UJsHDnHOi0CwwTwDanSaxpV3SKdxT42tqoZ7vrz+UuF3T0k9Fvtc5Iy9hISvafZPMe5MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780579928; c=relaxed/simple;
	bh=ZkQWGgFZCoFSBhFJf3coWEqHeUyuA2PzIM81IX4gGR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKMj9JTz83VaUj89HnXsqIG2RfIVUvFXLMMqI1fFIqAzCLGtJt4HewbT2SrDr0f2yPC1mzIdrc01W2QaU2KB8Ie5C/uvLzeZ/A5HBICv4MgZBAvn9IdinEiS4Um7SYhdaq0inBPwWMp5R15pf0rRex8OkwcaYaPzLjJ4LL1Yy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1iHIvJt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkORXdCY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1iHIvJt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkORXdCY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780579926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kP12h1LonZWRO930Aw/hrU8SVFS9Dh8cN/DqNFBNMzw=;
	b=R1iHIvJt4mJY0TxKFXNskQLZsrGu7Be3xF2/4GXWb3A9cKeQMjx2L/DixWq9NIaGEk60HB
	5+ub3daYTY0fMG79bczPoUoKrgzGTe0b6q88V6xsIqetOQuoe9y+xI3/Fa4M/h79q8BAvp
	U4c6KXI3HMnuqqgo3ToBgh9dDcW3s2M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-RyZAccAcO8CzmbXwAvWuOQ-1; Thu, 04 Jun 2026 09:32:02 -0400
X-MC-Unique: RyZAccAcO8CzmbXwAvWuOQ-1
X-Mimecast-MFC-AGG-ID: RyZAccAcO8CzmbXwAvWuOQ_1780579921
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490aadb1386so9097395e9.0
        for <linux-rdma@vger.kernel.org>; Thu, 04 Jun 2026 06:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780579921; x=1781184721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kP12h1LonZWRO930Aw/hrU8SVFS9Dh8cN/DqNFBNMzw=;
        b=OkORXdCYvmlXpYgTipIP5dCBW9WeIweyG9wTvVyNsa4ti1trnBMuKoeI1YXcoVc9lp
         v/zuuzBEjShXNWG0ydz8sfLK4TWX1+PBOMRxClD4M/E83lyU311Nh7CV26RVlOyQ/WQe
         EmTt+XZCYzxXvRG9+wXQH8nj8OdBWj0DkHbDY5TglJQbBYWa6Pp86MpV8K0zL1PZi97N
         4JgclbROIWua19OOASLxnARECcxQCJxIWbAT5FA1mGkYNuILivRjdTQwTFH/I7N+LAQs
         F82yrcaPuiHc55xy+SiVw1k04cPN1QK9RbHZDqkdKCGPuErfbmk8yp3TqgqFA6rYOHwP
         b+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780579921; x=1781184721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kP12h1LonZWRO930Aw/hrU8SVFS9Dh8cN/DqNFBNMzw=;
        b=Vcj2v8p0KGKRCmhrZytQKRiNYHIhkpjQG3Mjp824UJzAa8WfdJZH0DiGG5PMSPXxS/
         OtjiG4Dy+1OR9A+wjiZZ2WBXRsEVCcwtF1b101bmwWJYxC0QaDt8vE3BQW+DiKShNvDE
         retaeFpo/o4cS/zCMg1YaILo9Q5ME/Hbix27Cp1zV8VPcwlM9ZSgQ5yTz2rq7BtRR0BY
         /gjXQX1TnlDyNwOdOdA48EnFm8cnP6Y5AuOWFJPjIf8CasG/7+MIxF8GVjjmGQkPmHX2
         xMJtTOOCZ+LCZfeT1UHs+1n1Jpq1D/EnTXj+UGb43FfyMiN1nTvZyBscdMXqVIomLlkU
         ugnA==
X-Forwarded-Encrypted: i=1; AFNElJ+rpr88rD/onwD01v1n5nKDftpSbNZ5vcHKbvuZvKVa2NZJ4KySP5k4epzn69z3USw84NoRu4KsEQdl@vger.kernel.org
X-Gm-Message-State: AOJu0Yye+jnYuPXEP8nD/u82vKN0wiBa7Md/ny08w2VY8szofZlVIs/p
	zCw0hWLZand25y95FZ7iB1q9J6qc6uQ9DXmyyPz9Q5ImSDmTcRSgRP14pdk/gi51VD25RYa+nDd
	/CUt/ZqT5UTubtvA8VjAcWMHS4/VQNUJ8BSuVFfEx9mII3dQLmLDR42XF7ORqhuI=
X-Gm-Gg: Acq92OEvr/f+gihfdfJa72IYwZDJo3j+ijq+NqBJF0CCs1hAop7j5tCrGy2r7Jt3nbV
	YlGFIAxfZNekPahDQf7blPAiJnNgL3AYrpXmTLw/U18DdMuRJ/oSApLD1EiH2NdfP4MOcE0yC7/
	MQ80OvLbjKCwkjRFAG3gF6M6k0HzPBjzLxgtLGPHIRNWVu6NIRZZd8gAgzu9xIR4fL8Joqcy5Jg
	JPa+mBbXolPGV73WXX2WeYi0EjR+VUhjNXtEc2r5bOsGOl6VhlZVyMcr0qvRoLxTzOELZOk4p/U
	ARmBr5nlbnaZK7MzO5r28N5xw6BSBHim76H3VqcnaSx6nwSdYXvCdbfxugD7l4nAIrHFJxiW+wK
	Uq1KLgE60TpI9fuDIPUghuR6flRizmqjiAa7+vQahjzgibTTg712xRmCEQOOijZs0urk=
X-Received: by 2002:a05:600c:34d3:b0:490:b26c:64ad with SMTP id 5b1f17b1804b1-490bc4cf867mr58229715e9.5.1780579921525;
        Thu, 04 Jun 2026 06:32:01 -0700 (PDT)
X-Received: by 2002:a05:600c:34d3:b0:490:b26c:64ad with SMTP id 5b1f17b1804b1-490bc4cf867mr58229275e9.5.1780579921137;
        Thu, 04 Jun 2026 06:32:01 -0700 (PDT)
Received: from [192.168.88.32] ([212.105.155.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bda4fd52sm61620455e9.0.2026.06.04.06.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 06:32:00 -0700 (PDT)
Message-ID: <d9a23afc-6615-4fe8-a325-f3bde54ec6c2@redhat.com>
Date: Thu, 4 Jun 2026 15:31:59 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: convert miss_list allocation to
 kvmalloc_array()
To: William Theesfeld <william@theesfeld.net>,
 Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260601193758.626537-1-william@theesfeld.net>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260601193758.626537-1-william@theesfeld.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/26 9:37 PM, William Theesfeld wrote:
> dr_icm_buddy_init_ste_cache() allocates the per-buddy miss_list using
> the open-coded kvmalloc(n * sizeof(*p), ...) form.  The neighbouring
> allocations in the same function already use the kvcalloc()/
> kvzalloc_objs() forms; switch this last one to kvmalloc_array() for
> consistency and for the size_mul overflow check that kvmalloc_array()
> performs.
> 
> The semantics are unchanged: kvmalloc_array() returns a non-zeroed
> buffer, just like the previous kvmalloc() call.  Existing callers of
> buddy->miss_list initialise each list_head before use.
> 
> Signed-off-by: William Theesfeld <william@theesfeld.net>
> ---
>  .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c  | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> index 7a0a15822..fa4d24b3d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> @@ -239,7 +239,7 @@ static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
>  	if (!buddy->hw_ste_arr)
>  		goto free_ste_arr;
>  
> -	buddy->miss_list = kvmalloc(num_of_entries * sizeof(struct list_head), GFP_KERNEL);
> +	buddy->miss_list = kvmalloc_array(num_of_entries, sizeof(struct list_head), GFP_KERNEL);
>  	if (!buddy->miss_list)
>  		goto free_hw_ste_arr;

@Leon, @Tariq: the patch looks obviously correct to me, still an
explicit ack would be nice, I think.

Thanks,

Paolo

