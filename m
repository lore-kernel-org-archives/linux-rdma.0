Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C694199E89
	for <linux-rdma@vger.kernel.org>; Fri, 13 Feb 2026 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770999541; cv=none; b=coV/vLkZ+NzS7V5UA42riwE+Dx7fYuy8zwkRHdzIPMLZkx/JQGj2i2Isl+Z+O8LvmbyzxUD+INwqrhCQRQXj6XEx6RsuHpzGUpfnnaICezsUqGAAu4lWtjWFvZoNaTm4m8yeOcZfebm67JmsZ/brXa+iM9s34DLisX3Mc+OlkXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770999541; c=relaxed/simple;
	bh=IXvLYcasHpFiwgAJkCUA5NnimGDQe1fDJ13W9Xgc5ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtNc/8eIaM+ogwjfDJ3nWS+RK9yZlr+iqBv8DQSwJVwY/Y1dLTNus9LCFEUcz1/qkGVnoKn+xRxHzOuo3M2KVWySs6+4vZt3Mu9FXq/SaGfCvk2GiIeYi+BSS/CMPEeHTVX5OooUYREtO+rjEaKeOU+SmBESun1hVWFqvluGVTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WO1qmnjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WO1qmnjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87022C116C6;
	Fri, 13 Feb 2026 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770999541;
	bh=IXvLYcasHpFiwgAJkCUA5NnimGDQe1fDJ13W9Xgc5ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WO1qmnjGiUHWXJf+faP0Cn6iJIkePeebbcgtS5GNti0tnqpxQlfcpmIkasBpK8KDo
	 dawG5TkrvHl4BGOWR1LTZLAs00qIobpkDdFbGTMvhNNzSE4Z48MHPlHgah8E162mtX
	 npZYBFsYwKnfxZGxPYT8bCg48nK0GbPTY4ZmjqjOkwYY1ozwEgEa30AcnCeQ5/A3Zz
	 P8rTRHDIFcQX5T9TOLijkmlGATvI2y4lxo76d3XQw4dl6IifpkhSYm9Gn54xStXQNH
	 J9Zaew5NuvQoL2PAGlHRSPuqCij94iK9P12Fs0mVW/GatweTVZ5zL8tVOOKhitKZl6
	 37uNWnthF5KYQ==
Date: Fri, 13 Feb 2026 18:18:55 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com, kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v12 5/6] RDMA/bnxt_re: Support dmabuf for CQ
 rings
Message-ID: <20260213161855.GW12887@unreal>
References: <20260211124927.57617-1-sriharsha.basavapatna@broadcom.com>
 <20260211124927.57617-6-sriharsha.basavapatna@broadcom.com>
 <20260213111256.GO12887@unreal>
 <20260213145425.GN750753@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213145425.GN750753@ziepe.ca>

On Fri, Feb 13, 2026 at 10:54:25AM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 13, 2026 at 01:12:56PM +0200, Leon Romanovsky wrote:
> > > +int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
> > > +		      struct uverbs_attr_bundle *attrs)
> > > +{
> > > +	return bnxt_re_create_cq_umem(ibcq, attr, NULL, attrs);
> > > +}
> > 
> > Please don't mix create_cq and create_cq_umem.
> > https://lore.kernel.org/linux-rdma/20260213-refactor-umem-v1-15-f3be85847922@nvidia.com/T/#u
> 
> Either we drop this one patch and put those 50 ahead of it, or we just
> take this one and rebase the above.. The above has the advantage that
> it enables all drivers to support cq dmabuf in one giant shot.

We don't need to take ALL patches now, it will be enough to take first 8
with core changes + bnge_re patch.

Thanks
