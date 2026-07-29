Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ABA1D95A3
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 23:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785368790; cv=none; b=Gc0/PX0TlXUoag3PUm05B8xrul6yQUyLk1ju2ePos08xd82lpRngzzQy5fXHULT7MGeHuuFa674lOC6PHYkATzzISZaKcb3FMV/SdzoQJhx+dCSGnUNY7v82hpSkncZnopkIgo1Ov1gEGzDsoRQlrmEaFHI/v5SLphTWlFyGmHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785368790; c=relaxed/simple;
	bh=8atLDkvAtM91jCEIe7cKro5IUYCrnp+OVUxyqeKwISg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qor/1cr/H1yT6ZpPOVn0nd1zDWThDyJrBHv8JXPOsYwNRhsiEMUjxiTiwryYPlit/NQNW3sFbmDHuLF+tykNshsaXClqpkubrBHHzgMlRjIdYd0t49TfjrHrweKf2aVnyt9JK9p34qbc8I2qViyVJlTqe5SoOnpb61tzSwohHFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UF8z0NYG; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UF8z0NYG"
Message-ID: <86153a83-a234-4afb-82da-6ac7e4cc2ef9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785368776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyBkNkdrosmtPSRrBP/qEyOiL2qgvOckO8JtJ/aH4fA=;
	b=UF8z0NYGPjzcMJ+5EzIqDhfNMUF+y18cFwXGKxoiofFZs3TPiEbEAPR3+XNkkeB6FE6oa9
	5072+HfqEi8Nd4qCZaUU4YjYLPu+kLdEEo28M+p6q/BQuYXwrqVpwiMZBT4S2DMuIAXvbZ
	G425Xlkf6lcdU4ySDQkeUZXmOKC7teA=
Date: Wed, 29 Jul 2026 16:46:02 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Fix OOB in free_rd_atomic_resources()
To: Peiyang He <peiyang_he@smail.nju.edu.cn>, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 pandit.parav@gmail.com, dledford@redhat.com
References: <33A3A239F88659D0+20260729073644.2834066-1-peiyang_he@smail.nju.edu.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <33A3A239F88659D0+20260729073644.2834066-1-peiyang_he@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/29/26 12:36 AM, Peiyang He wrote:
> free_rd_atomic_resources() iterates using qp->attr.max_dest_rd_atomic.
> Updating max_dest_rd_atomic before freeing the old array can make the
> free path walk past the old allocation and trigger a slab out-of-bounds
> write.
> 
> Fix the OOB by moving the assignment after free_rd_atomic_resources()
> so the old array is freed using the old bound. This matches the original
> ordering in commit 8700e3e7c485 ("Soft RoCE driver").
> 
> Fixes: b6bbee0d2438 ("IB/rxe: Properly honor max IRD value for rd/atomic.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>

Thanks a lot. I am fine with this commit. If you can post the mentioned 
OOB in the commit log, it is better.

But without the OOB, this commit still seems OK.

Wait for the feedback from Leon and Jason.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe_qp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
> index f3dff1aea96a..1fffe3c6685d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -707,10 +707,10 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
>   		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
>   			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
>   
> -		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
> -
>   		free_rd_atomic_resources(qp);
>   
> +		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
> +
>   		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
>   		if (err)
>   			return err;

