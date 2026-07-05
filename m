Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65C3644A4
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260587; cv=none; b=mdt9vp2t6jl7wLh7P1M0Uhx1jS6aPgaTYEizL5uABtiEtzYd5pCE6oHtyYpZL4GOCvMFRYMzSZFHj88DHJOuXz1MYc63PXqior+dnGGanoG3JcOofJjLaBS1EoIQWfs8DjUGzhEUgDgnjajDmxaXQwg6j2SOEfXl+ZkbauJ1rsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260587; c=relaxed/simple;
	bh=9QnA86PjVwx/XfFrgmjKp12l68zJrBcvSGQzTC36iko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWOv7Kd4feJjedPYcw1qzfmkARdy3b32e5slJCtfEEkGIwf17zwWD1KdTrvHftVtTz5+gxJXxRdIg9iN0mwrwCowtI39Ex5ftmER1DlhpC2bR+/rOMyAm1InBgw1/x1Ld1LzT6PsGntZynhV3oqPF/BEv4GvlIV0b9q/tRMpQy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KN2QpTZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KN2QpTZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC21F000E9;
	Sun,  5 Jul 2026 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260586;
	bh=XpUz0K5izmcajqlrTfe9PZlBq7+dYA5eh9xrwlruDsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KN2QpTZBdDj3g7CjCkqUm4Za/kpP4hHwDsSH/JTl4cpNSKzrdtS2CMwT0eWX83I4C
	 C5bR7J8/8UoUltGMIGOp5Dhe3D+Qx4Oc8CumkNI2NpljRQccRcM6REq0muYaoYFlh7
	 0ef78S3BkTNgjN1FrdlIi+gzXEIlV1qCrtlkJWEgcoU8AH4ldDXSZmBnsE5hTrVwrM
	 NMKuUnjPNb32n9ffWc5uUviG6E2uz/BhY/ya7BlPWBifyUlJd3cf4YGjhF4C0crQMA
	 VYJry28ch8In3hqnaVfkvUsFkGpL5ohu1hto7LA7VpoXJ45rIioBz5cYjbv3Ag94uJ
	 YWmM2dGYNIPxA==
Date: Sun, 5 Jul 2026 17:09:40 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/irdma: Check for null udata during reg_user_mr
Message-ID: <20260705140940.GG15188@unreal>
References: <20260630154720.1647530-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630154720.1647530-1-jmoroni@google.com>

On Tue, Jun 30, 2026 at 03:47:19PM +0000, Jacob Moroni wrote:
> The irdma driver requires udata for reg_user_mr. Previously,
> it was assuming that it was always non-null, but it can actually
> be null if the user intentionally triggers the UVERBS_METHOD_REG_MR
> ioctl.
> 
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> index cb54c7c8fcd..3bcac68a612 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -3519,6 +3519,9 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
>  	if (dmah)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> +	if (!udata)
> +		return ERR_PTR(-EINVAL);

Is this check specific to iRDMA?

Thanks

> +
>  	if (len > iwdev->rf->sc_dev.hw_attrs.max_mr_size)
>  		return ERR_PTR(-EINVAL);
>  
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog
> 
