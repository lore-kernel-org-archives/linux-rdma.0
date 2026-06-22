Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761FC337110
	for <linux-rdma@vger.kernel.org>; Mon, 22 Jun 2026 02:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782096545; cv=none; b=Id+KRcH6OTBmtFFhtkegd9DlicN20pal7NunuHuOwhtfk8b+TlR52LnDWQbtiaxfd154dpSnI6wy6EPyqYTidaNs1kGwv0zoR57Wse+UVNw4soOYaAunim58tMcFzvjB/i0gG0+EZYTbmVFazL+mwxo5H6Pw4/OgHx/Xa/6IOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782096545; c=relaxed/simple;
	bh=+ORRixjLnKppx9dnrbYbgn63F4Xoap3LaSTe+gHGDJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ADZntIje0NwcXqs6E2C8xOn/SDKiXfMCBZhXljqDa0ejZnFCMbmGFPzPlYAz5sR2XjsumBucMsAgG2zdbrj+ehIn2sr6dozD3t6PxbL0Pl1jkS8nyGrJJVJ+BRmDl9g43tCPiwAdFNZhLfLPjahVxYzlSzwIxlwDQU4H8Ld1OYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hZsERzrB; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hZsERzrB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782096541; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lbf0sR8BvqGVH7I+I2J6TcPj88hE6FxucrKaZfwKg3Y=;
	b=hZsERzrB5gdJ8RDyKCpsSeKtT47yK2mliu+PU2gSxvkt0bwxHnTLLacCZNduv6j+VFnoaBRJu8w/W0R++Jw8U8tt+9c8dTQmQohMf0ypD2fo1PIO9OhH5ZHqJSNkOIok8TnB1B4dxfbv9rDVtlYKzt61xj7w3eE85787Z0dic2I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5GhcBP_1782096540;
Received: from 30.221.101.45(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X5GhcBP_1782096540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 10:49:00 +0800
Message-ID: <2ab39704-bc44-6898-46ea-241496ab594d@linux.alibaba.com>
Date: Mon, 22 Jun 2026 10:48:59 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/2] RDMA/erdma: initialize ret for empty receive WR
 lists
To: Ruoyu Wang <ruoyuw560@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>
Cc: Kai Shen <kaishen@linux.alibaba.com>, linux-rdma@vger.kernel.org
References: <20260618041752.481193-1-ruoyuw560@gmail.com>
Content-Language: en-US
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20260618041752.481193-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>

On 6/18/26 12:17 PM, Ruoyu Wang wrote:
> erdma_post_recv() returns ret after walking the receive work request list.
> If the caller passes an empty list, the loop is skipped and ret is not
> assigned.
> 
> Initialize ret to 0 so an empty receive work request list returns success
> instead of stack data.
> 
> Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
> v2:
> - Split the erdma and mana_ib changes into separate patches.
> - Add a driver-specific Fixes tag.
> 
>  drivers/infiniband/hw/erdma/erdma_qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
> index 25f6c49aec779..e002343832f74 100644
> --- a/drivers/infiniband/hw/erdma/erdma_qp.c
> +++ b/drivers/infiniband/hw/erdma/erdma_qp.c
> @@ -734,7 +734,7 @@ int erdma_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *recv_wr,
>  	const struct ib_recv_wr *wr = recv_wr;
>  	struct erdma_qp *qp = to_eqp(ibqp);
>  	unsigned long flags;
> -	int ret;
> +	int ret = 0;
>  
>  	spin_lock_irqsave(&qp->lock, flags);
>  
