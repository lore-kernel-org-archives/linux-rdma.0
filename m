Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B445B352C5C;
	Fri, 13 Feb 2026 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770979228; cv=none; b=EIsH3FJMJtxvWsH4yiTRZ5iO5OZt4OjrNg1ntdVNmHuMoGMB3PpbX3k70C5COe2tLLd0DKy8pI4AQoO1d8BSSxvf37qMN9TLLI0UXQyloOIrxBntbpF8WOwgGjfZAuzTcgpDj2XcxB5fV23O8pQHwuhACchj9PsvzaB5y7UDgKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770979228; c=relaxed/simple;
	bh=Cixx3kK46m16Sxr4skPk+gdW3ag7+ixtcEhQ/EJS11I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfDwIfYLqLlqfD0fgM4PZP+ht91L1UBhkWkL0PCwUA1y4QOf1QVUOC6vDJqTRJOAiXMAH1/wHly8A37+vkLzBQBE/cybSj76lZmvnZQnQPvWsSzWfDeGa68MX5HoHhULXgTLLWyur7ZYiBZlGES6nsRD/FkkptWLPUi7Z1hCkFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fiEIwczq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fiEIwczq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EE2C116C6;
	Fri, 13 Feb 2026 10:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770979228;
	bh=Cixx3kK46m16Sxr4skPk+gdW3ag7+ixtcEhQ/EJS11I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fiEIwczqSB1qQUlnfNjKBC7mlt0NKPb5JG6Vd/hbSS7bTaGhe1XGythcsCWG0g+1H
	 W1bOuJbN2HBKjxw5SD4+C3Z749KWoVwZOTS65xTsPtucZX5XGMbvJV8HJQ5S2TXUiK
	 RoMCot8GQ7ApnpR/byxmvGtatFhFc3AsRav+sbdYJsGvt/ncctBCTefiIlgLfjlkYz
	 KB3t49TyMvzgnlIhKnom/Nf/dAfds3a/RQtfXqJJI5UapyAazbjGtfq9udZ26QH5ns
	 FHaeTdqp/uds5QI+xmcEqCwjO1aN2m5W2CK+DN69PtRzo8Hv8NDytAiYyEechRgaHk
	 honBsiMFHw4ww==
Date: Fri, 13 Feb 2026 12:40:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 09/10] RDMA/bnxt_re: Use ib_respond_udata()
Message-ID: <20260213104024.GN12887@unreal>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <9-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>

On Thu, Feb 05, 2026 at 09:45:43PM -0400, Jason Gunthorpe wrote:
> All the calls to ib_copy_to_udata() can use this helper safely.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 6ea03e1f6c23dd..9d1c31bb994218 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -748,7 +748,7 @@ int bnxt_re_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)

<...>

> -			rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
> +			rc = ib_respond_udata(udata, resp);
>  			if (rc) {
>  				ibdev_err(&rdev->ibdev, "Failed to copy QP udata");

<...>

> -		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
> +		rc = ib_respond_udata(udata, resp);
>  		if (rc) {
>  			ibdev_err(&rdev->ibdev, "SRQ copy to udata failed!");

<...>

> -		rc = ib_copy_to_udata(udata, &resp, min(sizeof(resp), udata->outlen));
> +		rc = ib_respond_udata(udata, resp);
>  		if (rc) {
>  			ibdev_err(&rdev->ibdev, "Failed to copy CQ udata");

<...>

> -	rc = ib_copy_to_udata(udata, &resp, min(udata->outlen, sizeof(resp)));
> +	rc = ib_respond_udata(udata, resp);
>  	if (rc) {
>  		ibdev_err(ibdev, "Failed to copy user context");

Should we move the error message into ib_respond_udata() and remove all
the corresponding prints from the drivers?

Thanks

> -- 
> 2.43.0
> 
> 
