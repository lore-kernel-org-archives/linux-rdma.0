Received: from mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D8356A38
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326450; cv=none; b=rB+VoMXHXKi3n1+cdFocmcSv2nAy3TiGd94fud+fVzIvbTzKD8jx1j9zAHbPUm7r7aSReS/dpF/2ObThGJrubEqEcGIY0MvHeZDICYM8zOzZ5L/YVipaxs0m9kuc66fAHmAe+ZOqBgA7kkRBdZ7402sTlUsnExmYchjTNg4ZqYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326450; c=relaxed/simple;
	bh=GDeDMRIC3+kjhHvLLSuvAC6o4f9Zw7dcUeF95As8YS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOqxNmq7EgnvIAGmtU6BHwDFWJfsebEhpDvKMZCeVQtOFl+p5bfw3s2sjM9iEytVXcZrt+dEEDzxnrC1kMmuavX7rj8SnXbqnCWRMQlTDGy5PoIrkhPktzJqyOYd9ivRWSd+WKK18AyczQpLibGWV1z0hIVyclyQ66KO7t4kP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FTB4hYH7; arc=none smtp.client-ip=95.215.58.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FTB4hYH7"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GDeDMRIC3+kjhHvLLSuvAC6o4f9Zw7dcUeF95As8YS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787326446; v=1; x=1787931246;
 b=FTB4hYH7agPgWOHEa8VTDxxYT//FMnqfdDdWTM/R4bnJnQKW4Gbf9WWryNSdl2mR8LXk/J3u
 KsBdGyriZVHyosBy7X3L0EDc025NI2fzCnuvpfF+iAtvfN8SuFGP9XEVCXzuyOe6KhVkX+6inx8
 QTJtNHKml0RFaP+DyM6JVYZ0=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2a04:ee41:4:15d4:8934:f21b:2683:d2a4] (2a04:ee41:4:15d4:8934:f21b:2683:d2a4)
	by smtp.migadu.com with ESMTPS id 401f72c286ba547a;
	Fri, 21 Aug 2026 15:34:06 +0000
X-Mizu-Trace-ID: 401f72c286ba547a
X-Migadu-Flow: FLOW_OUT
Message-ID: <51ecec6f-1a88-44a5-a089-951c757f95f3@linux.dev>
Date: Fri, 21 Aug 2026 17:34:05 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: Fix CEP reference race in siw_accept()
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, jgg@ziepe.ca,
 leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260816061353.4059242-1-shuangpeng.kernel@gmail.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260816061353.4059242-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.08.2026 08:13, Shuangpeng Bai wrote:
> siw_accept() associates a CEP with the selected QP while holding
> qp->state_lock. If the transition to RTS fails, the error path releases
> the lock before detaching that association.
> 
> The cleanup drops the QP association reference before clearing qp->cep.
> A concurrent QP destroy can acquire qp->state_lock in between, observe
> the stale pointer, and drop the same association reference again. This
> can free the CEP before siw_accept() releases its remaining reference,
> causing a use-after-free.

Do we have a stack trace for that use-after-free?>
> Serialize the error-side detachment with qp->state_lock and clear qp->cep
> before dropping the association reference. This ensures that either the
> accept cleanup or QP teardown removes the association, but not both.
> 
> This is a follow-up to commit a93949718259 ("RDMA/siw: Fix
> use-after-free in siw_accept()") and addresses a separate race in the
> same error path.
> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Link: https://patch.msgid.link/20260801213632.1086548-1-shuangpeng.kernel@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>   drivers/infiniband/sw/siw/siw_cm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index 0245b25e7271..da1b953f3fa3 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1751,11 +1751,13 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   	cep->state = SIW_EPSTATE_CLOSED;
>   
>   	siw_free_cm_id(cep);

What can destroy the QP at this point?
An appication QP destroy shall be serialized with this
accept call by the RDMA core.

A concurrent connection drop by peer side would affect
QP state, but is serialized at the cep using
siw_cep_set_inuse()/_free() I don't see other cases
which are not serialized...?
> +	down_write(&qp->state_lock);

>   	if (qp->cep == cep) {
> -		siw_cep_put(cep);
>   		qp->cep = NULL;
> +		siw_cep_put(cep);
>   	}
>   	cep->qp = NULL;
> +	up_write(&qp->state_lock);
>   	siw_qp_put(qp);
>   free_cep:
>   	siw_cep_set_free_and_put(cep);
> 
> base-commit: a9394971825933074032794a5feee5211509c774

