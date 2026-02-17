Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA98361DD4;
	Tue, 17 Feb 2026 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771334640; cv=none; b=SrFDDJxgFx9L5uIHKjyUXuzRaYJ5mrBMCZBanGUFwX14xVIveGC8f1SpxN/CKJZQ43xJ8YRoIlNuY+alrKv4en2a6ZzvDus59B1p3dU7DO8oICkh4sBNbgrouh74XmHazfqmkEoNQ2ObnwcfEbHVOTZj5xA8SrjeaU2fkf5j+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771334640; c=relaxed/simple;
	bh=s48bivWIOxdPQEbIORTIX484w1MulDACtphogfq9hMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0hU4KiAQw3ac4tq9NwOfs4rMWslAgysjj7kUx6OmJjaf40yKDTNW/awEw/QVhPGJYEJHWy2swup1hv2ez8NmJY+NELOjm6cf0LLwySWBK/7NR5jRMvqx1rixxe+FAbnE2NoYQ/B4i/PTnenF+DiAwzq0egZvQo4iD42ZPXA7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsMMppFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsMMppFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56B7C19423;
	Tue, 17 Feb 2026 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771334639;
	bh=s48bivWIOxdPQEbIORTIX484w1MulDACtphogfq9hMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NsMMppFryIkcBTrYHIxIVL1P/B8Z7u0/cWYXENdezei0rmn8GZhvqmhMhVbq0aZgs
	 lGZRdmDXEEzSbbrnuSGJBI/szLcpP6Q1G6gUk0i1RMb1vnxFmq0fvMa/i9DZOOXvBI
	 uYhM9GfftmIvr0wkB0U9cTQXuFI6HjqXnBXO5oPotKX/UoxgnikUzuYoUXxargewN0
	 B+sexrotqWbl3/ehBzjIluIR6JFMSiYSkBG2ecvzsLDf5npXxrn2fIHhw+71tfCYqK
	 73p8E4g6XedoKS7zuOdbvu+WRwmbBbAZOP2s+OW8BK6UBRFSS4AGcBDtCLRISIEWfg
	 +aud+12YQzitA==
Date: Tue, 17 Feb 2026 15:23:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	linux-rdma@vger.kernel.org, Michael Margolin <mrgolin@amazon.com>,
	Yossi Leybovich <sleybo@amazon.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Andrew Boyer <andrew.boyer@amd.com>,
	Gal Pressman <galpress@amazon.com>,
	Mustafa Ismail <mustafa.ismail@intel.com>, patches@lists.linux.dev,
	Roland Dreier <rolandd@cisco.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>, stable@vger.kernel.org,
	Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH rc 2/4] IB/mthca: Add missed mthca_unmap_user_db() for
 mthca_create_srq()
Message-ID: <20260217132356.GM12989@unreal>
References: <0-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com>
 <2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com>

On Mon, Feb 16, 2026 at 11:02:48AM -0400, Jason Gunthorpe wrote:
> Fix a user triggerable leak on the system call failure path.
> 
> Cc: stable@vger.kernel.org
> Fixes: ec34a922d243 ("[PATCH] IB/mthca: Add SRQ implementation")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/hw/mthca/mthca_provider.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
> index dd572d76866c2e..ae0c8024ad2310 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -428,6 +428,8 @@ static int mthca_create_srq(struct ib_srq *ibsrq,
>  
>  	if (context && ib_copy_to_udata(udata, &srq->srqn, sizeof(__u32))) {
>  		mthca_free_srq(to_mdev(ibsrq->device), srq);
> +		mthca_unmap_user_db(to_mdev(ibsrq->device), &context->uar,
> +				    context->db_tab, ucmd.db_index);
>  		return -EFAULT;
>  	}

The `mthca_destroy_srq()` implementation needs to be corrected as well.
Its resource release order is currently reversed.

Thanks

>  
> -- 
> 2.43.0
> 
