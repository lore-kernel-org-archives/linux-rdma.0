Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0BA379960;
	Thu, 23 Jul 2026 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795764; cv=none; b=aq2FBznVOHUYP0eNBUWLG8VVOEonOYpmkpumcmcwcItL2jYpeEVgwvmeIFz0ErvLsHeOLeJbUWVMGUj9TbXmolvFS8N8Hs4DY4UwubJisLFLuPBgGXlCb7lNNqGA+tUAghf6qeVwMr4wNbG3DAmsGdjw5oZm+VdIlmRYPoP0W8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795764; c=relaxed/simple;
	bh=YFAkAdGiCpQ+jo8nUHhEwd7r3qwGs38lZvxF6pmD/2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaeCU4XhauBkIY7fK6mTcYcLb446OXIlvCkwAg1dAtKSt1VRRyAsEntG7ODsBy8MYnx2ROy8XS8CanO7kt8ocMk8QNLCY7MFOy5eKYsX8jBOc2K1dYXxyldW5MgmcOaBNA9rzEVCOZgj8C9rjpdIQkqThCT2tS5D63AX8VwoL30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHOTGE/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHOTGE/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09541F000E9;
	Thu, 23 Jul 2026 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784795762;
	bh=N8+vl9TdODjbJh8USSG5bhl2MLBz1Ogqw1ejS4dZ5Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iHOTGE/CRHn86AOWuAZZkBuleVyxxaGjA+jJPdOoOYMkRdrUElJGZZOHwcZoPvnGx
	 u3AwalkELpu4W4JRipwsXySAmLo38fDWjvAapifX7wM6bVlQRBVVIdTbcNz5yLTtgB
	 qMy+ypgIASUyf02B4kx2CGct91JpbOntE+CluhkXTB6Szz8x1g3/XIsJiHtjLD8H9O
	 Dm28eGjDIWyIkkvKz6DfXtf0cw2rEeACH/Op9bjsHkt8vSfNHGRkwAyn2IXLMngBXZ
	 zTT7HIVsaH37uzAREMjk4hwkKXn+xokRdMb3DjyVQwHRpO/WxsKumsGc+71cDEmfzS
	 0zyK/lgCN9RAw==
Date: Thu, 23 Jul 2026 11:35:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Make sure that UMR page is aligned
 to PAGE_SIZE
Message-ID: <20260723083555.GD110966@unreal>
References: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
 <amEczxLd_WnHzj5M@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amEczxLd_WnHzj5M@ziepe.ca>

On Wed, Jul 22, 2026 at 04:41:03PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2026 at 02:41:13PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The UMR XLT buffer needs to be aligned to PAGE_SIZE.
> 
> Why? It goes into a sgl? The device certainly does not work on
> PAGE_SIZE, so if there is some alignment here it should be the MLX5
> adaptor alignment

We need an alignment to 2Kb as a minimum here.

In our case, we got the following assert:
 ‘mlx5_post_send_umr: assertion failed (MLX5_GET64(umr_pointer_desc_argument, data, address) & 0×7ff == 0)’

Thanks

> 
> Jason
> 
