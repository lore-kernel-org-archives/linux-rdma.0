Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB824306B37;
	Thu, 16 Jul 2026 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784223475; cv=none; b=bD7C1iDhHhBQcNwWthEL1BGHW4UcbcSEhDnmPDUxCuUw1JvcW8tH0QmcAM+1SX0s2KG4YnIbydbnvMl0xa4CyCwBL+REPm6OcADfbjZjt2AZcIhknll4oVxhiTopKuh9UL2h3gSs+fbdfS9lcMJ+fZ7pyzKGiSFjoH0F/JO8c9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784223475; c=relaxed/simple;
	bh=nYk/RulYtCUH6zIrQ/RSJwZZ6DnoMfJiUTsSvMWnvlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNOp+lMR4UuWjii12awZtlS+qxUeyzPxD0TWkJLsW5ssNH32IBwT6F8pes95lFLXsybgWPGhgZfC5VJgvvarqK49QNPJfaRQ+tpdBf1xn7h1Oy9k8BdSvTttgsAylvtqUfpGIpDvQi/ALrPp99lgq2/jljo2MAOK8Iy7faGPsIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XzX1m0Sg; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XzX1m0Sg"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1Kxl2r6kz1XM0ty;
	Thu, 16 Jul 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784223463; x=1786815464; bh=gV7ZLvf9b67kEMWO5uk0AzDv
	7GV2quIxYkYOj3NlAko=; b=XzX1m0Sg3PLA8IG+ym2TEfdWtczjfEIyvC8TMEcz
	5MIB5wLMGxCmumWtUeFhJI5claS7T0FRLW/O45/AB/CrxdR5Ha3ynSEt7/K0jSjZ
	9IicVDeM50OTdtQyqtjNWz+xsbY05FvjxhMSJiK8nUYr9fqzFrXvOYezqy/3q8wR
	moqLPE8pN9hqf2MVfO9tIv2jKtqBYrHr9iOPAjMo7QOw5DlyE/Dx0RrqW4ZeJdex
	YufYVkjxzByd3tzzvg1+PU2m6helLlLor/lz8jO9bq75jIpcn6VCz1V4Xc+HAONi
	enVYSXBz1auusPkEjs7JaJTVFG0JyxbcD/yG6LzA+8lZeA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NTHPCRuiYSWJ; Thu, 16 Jul 2026 17:37:43 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1Kxc6xQGz1XM6Hv;
	Thu, 16 Jul 2026 17:37:40 +0000 (UTC)
Message-ID: <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
Date: Thu, 16 Jul 2026 10:37:39 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
To: kensanya@163.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
References: <20260715101550.45345-1-kensanya@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260715101550.45345-1-kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 3:15 AM, kensanya@163.com wrote:
> From: TanZheng <tanzheng@kylinos.cn>
> 
> When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
> descriptor, the unwind path destroys RDMA contexts but leaves stale
> n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
> sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
> can then subtract the wrong number of send queue credits.
> 
> Reset the counters and clear rw_ctxs after freeing the heap
> allocation before returning an error.
> 
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
> Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> ---
> v2:
> - After kfree(), set rw_ctxs to NULL instead of &s_rw_ctx
>    (Leon Romanovsky)
> 
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index f66cfd70c263..a9c4995af7a3 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1014,8 +1014,12 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
>   				ctx->sg, ctx->nents, dir);
>   		target_free_sgl(ctx->sg, ctx->nents);
>   	}
> -	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
> +	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx) {
>   		kfree(ioctx->rw_ctxs);
> +		ioctx->rw_ctxs = NULL;
> +	}
> +	ioctx->n_rw_ctx = 0;
> +	ioctx->n_rdma = 0;
>   	return ret;
>   }

The above looks wrong to me. In the error path ioctx->n_rw_ctx should be
restored to the value it had at the start of the function instead of
resetting it to zero.

Bart.
