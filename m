Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83B10E3;
	Wed, 18 Feb 2026 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405589; cv=none; b=QjxwlJ2k+Z8f95ELFuWW3MZ+owvjZFxDntrZ8TuUemTtovBrr3KXNXMsiEVa2O6c1oNy2INeNcvYywl3C0vUowBIeudd01hAZoY4xEqJj3TuxfmQaceCuewF7uWGaPxe39/LAxe8VMsSjArJzCJuQ7BsJwQU/Iv3jAlZ6qb4XK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405589; c=relaxed/simple;
	bh=052lPPcR3y3wJ3e+SHhoN19jjGp8ed5pK8BFPm20qTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLAyCmDYbQbPN0vO8VrpKTdeb04VcmtfeiZTEl8XLNpelGMQDsK/l1LXJrb3RjPyv7d/zhBgrCGasJYZ5bzBoUjFFcR6uavFNFfykahCQ3TYf9/r83TvexE5VBdg3HcHIYPA7gkPgURbM9gD+dKZTCB6Kl3V+Ho6hPYBwVTfAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4WiSS7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4WiSS7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC95C2BCAF;
	Wed, 18 Feb 2026 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771405589;
	bh=052lPPcR3y3wJ3e+SHhoN19jjGp8ed5pK8BFPm20qTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4WiSS7NdhrjjG2n/cILDQjcxN3AD+6gBbowMSY2mgZmEnDczx6qlplHUWzNEydYX
	 iHt+IlVWhJW7FbH8p0uLcb+a8IaT6B5nAJuVLQSKNh1gNO3oHqXiOg26zCn8QGpowf
	 SsD/FoGOpgE8vQde4aUntSNMbsr9buw5tbcMP2sYopIzJi6R30eBy2cCorqoj2+Ckr
	 GteZo8FklKCAHE0grH4hQ1/V3d5ScRWSPVpM3ZdBzBG/qrB5IPR50/dRLcnAdtcNNG
	 sYbkH3MNWtrYvGID4MRP1re6mRezhhRBkIlNZiD3jGcnvsMNH+rzo/yQCB3PIip1R+
	 GtII7J0wWP+Xw==
Date: Wed, 18 Feb 2026 11:06:26 +0200
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
Message-ID: <20260218090626.GE10368@unreal>
References: <0-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com>
 <2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com>
 <20260217132356.GM12989@unreal>
 <20260217234627.GB3804671@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217234627.GB3804671@nvidia.com>

On Tue, Feb 17, 2026 at 07:46:27PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 17, 2026 at 03:23:56PM +0200, Leon Romanovsky wrote:
> > > @@ -428,6 +428,8 @@ static int mthca_create_srq(struct ib_srq *ibsrq,
> > >  
> > >  	if (context && ib_copy_to_udata(udata, &srq->srqn, sizeof(__u32))) {
> > >  		mthca_free_srq(to_mdev(ibsrq->device), srq);
> > > +		mthca_unmap_user_db(to_mdev(ibsrq->device), &context->uar,
> > > +				    context->db_tab, ucmd.db_index);
> > >  		return -EFAULT;
> > >  	}
> > 
> > The `mthca_destroy_srq()` implementation needs to be corrected as well.
> > Its resource release order is currently reversed.
> 
> Er, that looks OK, this is probably in the wrong order, let's should swap
> it, though I'm not sure it is even order sensitive..

Yes, mthca_destroy_srq() in the wrong order.

Thanks

> 
> Jason
