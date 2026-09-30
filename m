Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CE54C9E19
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 12:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771098; cv=none; b=KErEFooGlkfh4G6rXVlqVgObci4xLGymovga2dpiw6rR87sGNZ+sKiknjOP/iwDy+ZEXCrglNtey6d7/C9hRUvzFjuoatGt4d4Z8nnk9VCghz8ZzVBq3ilkNP4iBIhNMTSZ+NLZF4p3dKxOf8fc66e4m9rnjHqdSH2InADAC24s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771098; c=relaxed/simple;
	bh=2wvzOd5+KxzBTjEPqOcIxNZiQE3z5wKYze2rPE7TiDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uD8wObdDKYycytP+QSC05Vy0X53U3SUG0TtrFiaBUIwQd1HImXraLyjrK9GmnohkFP7ENHEV9T88RM2uKPW8aRqhyJxkQBKGwQKLd+qgBr7ELfGmW3cpj0uLNK0NP6BIZDnENH4ICsqb9/DFOdCeRwSFNFGmYZcSGvry1n/Z9BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM8y2Ksg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM8y2Ksg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FEA1F000FF;
	Wed, 30 Sep 2026 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771097;
	bh=V4wkvOzZA1iCxl0UJYHhTtFxuaKziSK+dmM3jTNSfrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EM8y2KsgADgAMKadpnEPqsOEwWXkF3rGqhhj2CwI5nG9/V/49Ps8Ym07A9iQGPrel
	 GTLEcM+GfOt/iPf8iVCHeJcw2bpEHb02mjVyHsSwC3+KCvm+egeZl8hIKmP8npnKPJ
	 PEwbyDMyrQhnOvowFfsAnYVnI8W0ZOp6OdNeaNwaecOUC0LpTxPmGpIAMPfJUsQoEJ
	 Sn54QSayE+2RgiUClMxsOSP6f5vuimQLK+Kd81ZvN1aBLGC2soVtFzsBelaE/z6QzR
	 6XB7jIF0cw+hCUryUM7MnL/vxAFR0CM2H8MO0yJEtsIjoqme5nk6orhDzf/Pgp67Sy
	 9Kcs9ppsqmB7g==
Date: Wed, 30 Sep 2026 15:24:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbPz8/Pw==?= =?utf-8?Q?=5D?= Re: [PATCH]
 RDMA/mlx5: Fix CQ resize destination index mask
Message-ID: <20260930122452.GE3401365@unreal>
References: <20260919100716.2221-1-lirongqing@baidu.com>
 <20260928183403.GY563127@unreal>
 <d1f012cd1d03428e9e104d77ddaabdc4@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1f012cd1d03428e9e104d77ddaabdc4@baidu.com>

On Tue, Sep 29, 2026 at 01:06:18AM +0000, Li,Rongqing wrote:
> > On Sat, Sep 19, 2026 at 06:07:16PM +0800, lirongqing wrote:
> > > From: Li RongQing <lirongqing@baidu.com>
> > >
> > > In copy_resize_cqes, the destination CQE index is computed as (i + 1)
> > > & cq->resize_buf->nent, but resize_buf->nent is the power-of-two entry
> > > count, so the mask only yields 0 or nent -- and nent is one past the
> > > last valid slot. The following memcpy then writes out of bounds.
> > >
> > > Use (nent - 1) as the wrap mask, consistent with get_sw_cqe which
> > > masks against cq->ibcq.cqe (the nent - 1 value).
> > >
> > > Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > >  drivers/infiniband/hw/mlx5/cq.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx5/cq.c
> > > b/drivers/infiniband/hw/mlx5/cq.c index b0b1177..5bd5227 100644
> > > --- a/drivers/infiniband/hw/mlx5/cq.c
> > > +++ b/drivers/infiniband/hw/mlx5/cq.c
> > > @@ -1319,7 +1319,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq
> > > *cq)
> > >
> > >  	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
> > >  		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
> > > -					     (i + 1) & cq->resize_buf->nent);
> > > +					     (i + 1) & (cq->resize_buf->nent - 1));
> > 
> > I think the original intent was to use `(i + 1) % cq->resize_buf->nent`.
> > 
> > Thanks
> 
> resize_buf->nent is guaranteed to be a power of two by roundup_pow_of_two(entries + 1), 
> and sw_ownership_bit()/get_sw_cqe() in the same path both rely on this invariant.
> Therefore & (nent - 1) and % nent are equivalent here; the bitwise form is kept for consistency
> with the surrounding code.

"Therefore & (nent - 1) and % nent are equivalent here"

So please use right engineering thing here and not what AI suggested.

Thanks

> 
> Thanks
> 
> [Li,Rongqing] 
> 
> 
> 
> > 
> > >  		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
> > >  		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
> > >  		memcpy(dcqe, scqe, dsize);
> > > --
> > > 2.9.4
> > >
