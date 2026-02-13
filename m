Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3283EBF24;
	Fri, 13 Feb 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997076; cv=none; b=ZmLFlG0pwupAcOPnJUf7uFOzhdFta66kDn4Z6OZFVBGJ8gY2aVah6wPCmgKUybBFwI5jb6Yp9Xw84rWR3frFpbbyMCCX4NYQ0RPIK5pvhQDiDK5IJ+nwh2SfPi9ExchEJADqvXzxMEaX+VHD3ugOF07LCo4mv+M7l9uaPdzW+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997076; c=relaxed/simple;
	bh=Nk3TQz5pVX2O7xFU2o0DMsQMEnfB14LghC0jDemI8ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoTpqsBAaKjZmzba6PncMS6/UHiwy1X6rSEYij7YII1TTzbNpmVDz6vUu/t7/l84263YkRhk/1H9JBFzbXRcDmesi6YZzIGbyTGOaf/3S/aLAilMsUKOEVoJ6zOKNjt36M8OwjqBBgxcgVM72Fr/KcRY00qLWFydcnG7mhnYSBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uONzJliK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uONzJliK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444DAC116C6;
	Fri, 13 Feb 2026 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997075;
	bh=Nk3TQz5pVX2O7xFU2o0DMsQMEnfB14LghC0jDemI8ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uONzJliKFrJ9BdwrkP2lOlnfejJgyB3RxYH8uIhKIZx5N9An1NCO5TK1OX8FSvnev
	 AM2mk2/6rQVhRpppIQYZSCEpET+eZ8HZRNreA/w6PlscFbWrysCNLe2Dw0AQ70WZPG
	 xvaSClE7pzs57v0IgK2tukY7c6jwELyCm+Ln2x6tFpsID5/Kuc2kxG+hTtTuPA6Axi
	 HTUIPWhMXYUN1GnxFuJyfKUULHNEi5H51GQ9o8fTIi5saMpAD/n355pPhixk18ieE5
	 sMl9USJjn0utzoFIaq/4etdEqnVqkLJ4jBLNm8Rpzg5i3/rMyOggl25luG2eBccG2H
	 FLoROZSAV/haA==
Date: Fri, 13 Feb 2026 17:37:39 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 03/10] RDMA: Add ib_respond_udata()
Message-ID: <20260213153739.GR12887@unreal>
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <3-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <20260213101053.GJ12887@unreal>
 <20260213124359.GD1218606@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213124359.GD1218606@nvidia.com>

On Fri, Feb 13, 2026 at 08:43:59AM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 13, 2026 at 12:10:53PM +0200, Leon Romanovsky wrote:
> > > @@ -3177,6 +3177,38 @@ static inline int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
> > >  		ret;                                                          \
> > >  	})
> > >  
> > > +static inline int _ib_respond_udata(struct ib_udata *udata, const void *src,
> > > +				   size_t len)
> > > +{
> > > +	size_t copy_len;
> > > +
> > > +	copy_len = min(len, udata->outlen);
> > 
> > Don't you need to check that udata->outlen is larger than zero?
> 
> As far as I can tell 0 works fine with copy_to_user()

My main concern that it is not clear what return value will be in that
case.

+       copy_len = min(len, udata->outlen);
+       if (copy_to_user(udata->outbuf, src, copy_len))
+               return -EFAULT; <--- this?
+       if (copy_len < udata->outlen) {
...
+       }
+       return 0; <- or this?

Thanks

> 
> Jason
> 
