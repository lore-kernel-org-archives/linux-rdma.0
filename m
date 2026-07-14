Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE183624B2
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 02:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783997761; cv=none; b=crUv8sQRDkJB0jjguz+UVdBnIPn+oiEpojfi2+of1labOF+fbjYMBvStr+l5YM2NyUV9R+iawfggBzLWwoN8q99KS0r1Q1j9IUg7tw8GP9aedvxdOi/zdZ7NzPFlwSrFMSJLyC9fykYGCyMksItwgVv84ELmnzWXzlQ6wA10DG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783997761; c=relaxed/simple;
	bh=s6cO1MOngcabjINj+1cmLqjuL8ZRAjLhnkD7LW/xaAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BI319Cjm9vzgAVr1EdBkbLPfBgTgjvj4DcDLAIAPvQUzwUxWQe5kfVUdWuk75hv0lOmHuN9PSEB5m6G0JIzBf+jvTdlDCq4UNGxZq3SNrYXOducLkHC5QFMSAogdD9tYoG79GngQu2ew9MxGlzRjVAEDE/l9k2mIzc6ERklhfIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tUXg1u7/; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tUXg1u7/"
Message-ID: <99a613bd-8f32-4a7c-828f-b30097075e76@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783997757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DFCEBM2O2w+Tfp2mxhFX9m4Mz1xH2m+AAHhFF8XbM7w=;
	b=tUXg1u7/T4ctaPSMpNLC7jHzNLNXc/iXyHDK+PWwnX+O7wGxyNaAB8aYtgehMF9cHfmMvI
	dELKymLYPrvFPbX82hHGMLAupYkCofntk84KdEBgZer7uiW1kq4P6MZYiXQvTeDJLFUtzU
	S5fPGrWZ2VNqLacCCoAWVWt/S27WLL8=
Date: Mon, 13 Jul 2026 19:55:37 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Reject unimplemented implicit ODP cleanly
To: weimin xiong <15927021679@163.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: jgg@nvidia.com, xiongweimin <xiongweimin@kylinos.cn>
References: <20260713010439.331054-1-15927021679@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260713010439.331054-1-15927021679@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/7/12 18:04, weimin xiong 写道:
> From: xiongweimin <xiongweimin@kylinos.cn>
> 
> rxe advertises ODP but not IB_ODP_SUPPORT_IMPLICIT. The reg_user_mr path
> still contained a dead branch that checked the implicit capability and
> could never succeed.
> 
> Return -EOPNOTSUPP for the implicit ODP address range up front so the
> intent is obvious and the unreachable code is gone.
> 
> Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
> Cc: linux-rdma@vger.kernel.org
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> ---
> 
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -87,14 +87,9 @@
>   
>   	rxe_mr_init(access_flags, mr);
>   
> -	if (!start && length == U64_MAX) {
> -		if (iova != 0)
> -			return -EINVAL;
> -		if (!(rxe->attr.odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
> -			return -EINVAL;
> -
> -		/* Never reach here, for implicit ODP is not implemented. */
> -	}

It seems that the above are for implicit ODP. However the implicit ODP 
is not implemented currently. I am fine with removing this.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun


> +	/* Implicit ODP (start=0, length=U64_MAX) is not implemented. */
> +	if (!start && length == U64_MAX)
> +		return -EOPNOTSUPP;
>   
>   	umem_odp = ib_umem_odp_get(&rxe->ib_dev, start, length, access_flags,
>   				   &rxe_mn_ops);
> 

