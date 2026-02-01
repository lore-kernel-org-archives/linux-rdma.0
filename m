Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C88133C53B
	for <linux-rdma@vger.kernel.org>; Sun,  1 Feb 2026 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769950291; cv=none; b=imJrKmy877wvo7xpALhSQLQOz2U/5HV1FEtCZ3wjMeYwrduPCPitE3+3O7w/NcOTESBJI0GlomTfbvcGpMm6vpQD/lAoEIwXX3lNGvdjcqSfAVEfh4UtzhQY6u55ZV2tURiKQPasQ5lECF9Qah4azECKpknLFiPewaJzA5e2oJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769950291; c=relaxed/simple;
	bh=KlgO1s0+gkQ4qhWE5VNCRgIfBL+Jg9C5GP4+Qt8VPzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfGC+RMmMShb+U05KvslImbOdr3mktpRjQalRIUXurTtri//2LGk7f22C3E0JeOGMFZCpsswBLdMJtcrT7H76cFauTOcAmqw1aJhNBfcNHuurko5jKlzjd4lzJtyhIsSGVGL/CCGcgJmaccfJ6qnJtWUSdhPin1ctjc03M0WxTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIfxR9Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIfxR9Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C395DC4CEF7;
	Sun,  1 Feb 2026 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769950291;
	bh=KlgO1s0+gkQ4qhWE5VNCRgIfBL+Jg9C5GP4+Qt8VPzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WIfxR9Yp/1PMZX0P9sHFLcWV/IexSjvKqT5jupPQU+rRVG14BERuweUikzknXkMiG
	 8R3p/fJ3c5l6Grh28F6xbMWxzBIMYl2MTP1f5p9TmiSXIgdubmuyGqVPR58TvbH/tA
	 Yq3irX7xHnN0yRozurXQuBN8x1Ftmb1/cNv8Oetdl4vJFvuz9UJBx/O+ca//wrNX2l
	 tNOM8DqlKHjkFDdB1ir49WvxD4uejTAEf9Eg4n2w7rIv2s0/F6KPt4fC0tYEpcwHAa
	 4OCUo8ZVu5Zq7ASuCTzeHaaLTgS0gMTLgpUKxByKWIyMVowemQ8mTIR+waUoN5Q92I
	 BfNwlzn5IBzLw==
Date: Sun, 1 Feb 2026 14:51:25 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Subject: Re: [PATCH rdma-rext V2 1/5] IB/core: Extend rate limit support for
 RC QPs
Message-ID: <20260201125125.GB34749@unreal>
References: <20260129102133.2878811-1-kalesh-anakkur.purayil@broadcom.com>
 <20260129102133.2878811-2-kalesh-anakkur.purayil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129102133.2878811-2-kalesh-anakkur.purayil@broadcom.com>

On Thu, Jan 29, 2026 at 03:51:29PM +0530, Kalesh AP wrote:
> Broadcom devices supports setting the rate limit while changing
> RC QP state from INIT to RTR, RTR to RTS and RTS to RTS.
> 
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
> ---
>  drivers/infiniband/core/verbs.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

This patch should be the last in the series. We must first add driver
support, then address the required fixes in the mlx5 driver, and only
after that expose this functionality to users.

Thanks

> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 8b56b6b62352..02ebc3e52196 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1537,7 +1537,8 @@ static const struct {
>  						 IB_QP_PKEY_INDEX),
>  				 [IB_QPT_RC]  = (IB_QP_ALT_PATH			|
>  						 IB_QP_ACCESS_FLAGS		|
> -						 IB_QP_PKEY_INDEX),
> +						 IB_QP_PKEY_INDEX		|
> +						 IB_QP_RATE_LIMIT),
>  				 [IB_QPT_XRC_INI] = (IB_QP_ALT_PATH		|
>  						 IB_QP_ACCESS_FLAGS		|
>  						 IB_QP_PKEY_INDEX),
> @@ -1585,7 +1586,8 @@ static const struct {
>  						 IB_QP_ALT_PATH			|
>  						 IB_QP_ACCESS_FLAGS		|
>  						 IB_QP_MIN_RNR_TIMER		|
> -						 IB_QP_PATH_MIG_STATE),
> +						 IB_QP_PATH_MIG_STATE		|
> +						 IB_QP_RATE_LIMIT),
>  				 [IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
>  						 IB_QP_ALT_PATH			|
>  						 IB_QP_ACCESS_FLAGS		|
> @@ -1619,7 +1621,8 @@ static const struct {
>  						IB_QP_ACCESS_FLAGS		|
>  						IB_QP_ALT_PATH			|
>  						IB_QP_PATH_MIG_STATE		|
> -						IB_QP_MIN_RNR_TIMER),
> +						IB_QP_MIN_RNR_TIMER		|
> +						IB_QP_RATE_LIMIT),
>  				[IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
>  						IB_QP_ACCESS_FLAGS		|
>  						IB_QP_ALT_PATH			|
> -- 
> 2.43.5
> 
