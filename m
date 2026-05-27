Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8843254BB
	for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897004; cv=none; b=nLAF9Y+bGiObtdJuG9mOXzkqG7a2pWHW6zkuqSrjjC/7o48EqapI9dn0+6EQ7M+S6OkCf3WtnEfRCeiBUtvd7qquKZRnspypurJQWrotAeAetouU/wsbKuTHn9d7W7olh7wbQ0EHIq2ZDlcnHb7bfLYaQEmaODWF06htRTu8FFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897004; c=relaxed/simple;
	bh=UxCAV/kNFqiIsuWslRWfDoRxCeTyti2PNcB3TNef6mE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=edeh265gDU+sppBFA7wt8/+IzjhyGA5PY5YLxfrUxiGkObq96d/hZuk4CUWPuYcDwWVUbPXrdlffXeF1iCxy8hHCW+bQdqSSLwgTGkwkzrV82jAdX61AO48JmqK38s5s+/45OmHbS6t7szG6AiUQMa9CjlO6TkwtRPjcuIdPHuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YIklDY2W; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YIklDY2W"
Message-ID: <e510fa5b-3273-4db5-8e57-cf67a80a6369@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779897001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B9SfL8+TE9gnXQdcQOp94vKWr1sm3+R281RugqdVboA=;
	b=YIklDY2WelWOBrhmNvZfsXMJ3q+c/MRcQy1705pBidC018UTVjDBOrfZ7L4g3M0hFoq9xX
	QV8bh3hvVdQ5jRj7EhB+JtLnUnevKj87jzxs62ncb1E8W2hpIk7v6VUXteX8iUejYpOCUg
	zP/IO9i0JmOjIIWdmG/tS3qa3e80a8g=
Date: Wed, 27 May 2026 08:49:56 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: fix typos in comments
To: Purushothaman Ramalingam <purush.ramalingam@gmail.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 "open list:SOFT-ROCE DRIVER (rxe)" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260527104527.3222-1-purush.ramalingam@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260527104527.3222-1-purush.ramalingam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/5/27 3:45, Purushothaman Ramalingam 写道:
> Fix typos found by codespell in driver comments:
>
>    rxe.c:       s/mangagement/management/
>    rxe_param.h: s/interations/iterations/
>    rxe_resp.c:  s/recive/receive/

Thanks a lot. I am fine with this.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>
> No functional change.
>
> Signed-off-by: Purushothaman Ramalingam <purush.ramalingam@gmail.com>
> ---
>   drivers/infiniband/sw/rxe/rxe.c       | 2 +-
>   drivers/infiniband/sw/rxe/rxe_param.h | 2 +-
>   drivers/infiniband/sw/rxe/rxe_resp.c  | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index b0714f9ab..af39209d0 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -81,7 +81,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe, struct net_device *ndev)
>   	} else {
>   		/*
>   		 * This device does not have a HW address, but
> -		 * connection mangagement requires a unique gid.
> +		 * connection management requires a unique gid.
>   		 */
>   		eth_random_addr(rxe->raw_gid);
>   	}
> diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
> index 767870568..1cc77c46b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_param.h
> +++ b/drivers/infiniband/sw/rxe/rxe_param.h
> @@ -109,7 +109,7 @@ enum rxe_device_param {
>   	RXE_INFLIGHT_SKBS_PER_QP_HIGH	= 64,
>   	RXE_INFLIGHT_SKBS_PER_QP_LOW	= 16,
>   
> -	/* Max number of interations of each work item
> +	/* Max number of iterations of each work item
>   	 * before yielding the cpu to let other
>   	 * work make progress
>   	 */
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 9cb2f6fbf..d8d1b7f2f 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -1505,7 +1505,7 @@ static int flush_recv_wqe(struct rxe_qp *qp, struct rxe_recv_wqe *wqe)
>   	return err;
>   }
>   
> -/* drain and optionally complete the recive queue
> +/* drain and optionally complete the receive queue
>    * if unable to complete a wqe stop completing and
>    * just flush the remaining wqes
>    */

-- 
Best Regards,
Yanjun.Zhu

