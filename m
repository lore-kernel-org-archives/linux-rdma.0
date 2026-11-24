Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795556513;
	b=Ci897pmN+5IfguNKe/m/R4/gq+bAYQfinNwhFhcOwyt3E2yUsG/9i2FlP9PM7B9ymDWK
	 5q1C+2jm+wkWrLdEAmZmFb+X8rbycvPkzjbu0YDxq14qcCEbHVXr71ugR90hc3x30mmNd
	 EW2vlqCrPCEBg5HpEiAO3o/U+XxlmlPW0x5c3NlDMHA9bIwYQC4rVQ7vOfEviBYjS6rSC
	 ZGplbe0Pf4IJvnuHGXMZoZcRc9WyRGoEmbd5REJOcF+NIed8uvE5RTmP1Otci6f1ARNeD
	 X1ewzlRflDizIKpmr75VaROw+Ct9gFSZlm28BN9kO6XhN3mEjKAwG3Z3wMdONkwhU4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556513;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fBw34VjXI6FKTwxvy5vlUkGqsFf2i9HgNV7OD3Q/bFw=;
	b=GOMcZl7lh3u/mvVew/zZkvsPOMEk/8RsC+7Lilqq8dLAm1BX5MZIj6ViD5fGtrtVPKxe
	 VvOBpIEqoUMW9w4K9lvxi9Q7R/XEK40VWBmTD74CqA/HQO30KYkU3d8cGBX6Y1h9SLwm1
	 Lnn26bPuduZdo9AtbCZBiSPCNhpxzk0sHNcTX3+kYzkZGbDTkRnaAIWoN8bJmgD3mHto/
	 wfaB8kUUTIJzKiJPFgAbgWmwDW4F14a+OvDY5iFAe+2IZEU8ICJULmGLnAaXmHwq7rMba
	 d1Sv3DoEEmBLea8j74dyt8rWquoRoDs/pk7oFWv8rrdnS2JmwwT0k+wL5q0TV40Wp/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1P+u2VA;
	arc=none smtp.remote-ip=95.215.58.228
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C0E606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 21:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00C0E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1P+u2VA
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pG0pbDPXEhb0Uhnakajn47AzZb55mJKGr0OFmmS5OzE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795556510; v=1; x=1796161310;
 b=p1P+u2VATRwgRgeGPdN/T4L65GhO+KXASRlFnAJHxZGoRcnQh7BoHo6fZFq8cr/hB/Sw/zGW
 f2au4ccDguJj2DXcySz/qJf0gtEALrvcsPoDFwF5HSVeRX9uqNF6kqpwTP92ARPzXOJTCgONblp
 W3kuuFp1y17okGB9F7Floxb4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbd3aa9428031233;
	Tue, 24 Nov 2026 21:41:49 +0000
X-Mizu-Trace-ID: cbd3aa9428031233
X-Migadu-Flow: FLOW_OUT
Message-ID: <cc93cdad-7458-488f-9a29-de24f364f1b1@linux.dev>
Date: Tue, 24 Nov 2026 13:41:42 -0800
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
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero struct rxe_mmap_info on allocation
To: Andrew Stellman <astellman@stellman-greene.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261123140620.64393-1-astellman@stellman-greene.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261123140620.64393-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/11/23 6:06, Andrew Stellman 写道:
> rxe_create_mmap_info() allocates the structure with kmalloc_obj() and
> does not set info.pad. do_mmap_info() copies ip->info to userspace with
> copy_to_user(), so the 4 pad bytes of struct mminfo come from
> uninitialized kernel heap memory.
> 
> On x86_64 v7.4-rc3 under QEMU with init_on_alloc=0, an unprivileged
> user (CapEff 0) issued 300 CQ_CREATE ioctls on rxe0 and read the driver
> response. After the guest had run ls -lR on /proc and /sys and read
> /proc/*/status and /proc/*/stat, 101 of the 300 pads were nonzero. In a
> separate boot with slub_debug=P, all 300 pads were 0x6b6b6b6b. With
> this patch, all 300 pads were zero in both configurations.
> 
> Allocate the structure with kzalloc_obj() so the pad is zero.
> 
> The issue was found by Claude Opus 5.5 running Quality Playbook, an LLM-driven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with Claude Sonnet 5.5 and reviewed by me.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> ---
> A reproducer is available on request.
> 
>   drivers/infiniband/sw/rxe/rxe_mmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
> index a4ead89cc..ac851f245 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mmap.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
> @@ -102,7 +102,7 @@ struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *rxe, u32 size,
>   	if (!udata)
>   		return ERR_PTR(-EINVAL);
>   
> -	ip = kmalloc_obj(*ip);
> +	ip = kzalloc_obj(*ip);

Nice catch, thanks a lot. Could you also check for other unzeroed memory 
allocations like this and fix them?

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>   	if (!ip)
>   		return ERR_PTR(-ENOMEM);
>   

