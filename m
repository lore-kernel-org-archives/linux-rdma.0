Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D256D2D876F
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 05:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784699811; cv=none; b=EniC7+RAanQPBC+zz2cyY014WLa0ahdKpTzj20swXrffeEH1NMfrB9YXErXuNa2X2XYQ/wYmXedx0rFFbKjPwY1jFk9YCefdnh046yvYUlNgT9KIxdC8Fz+rwk5MQ3NNIWyBCa2CFlqoKBegSOzN/gPP/smFoULqiOovaV5TL28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784699811; c=relaxed/simple;
	bh=Ppt20ziDwRcXPcjAA4iGNiSJid6lJRASPxzX75sxEwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJUd62sf0aMydGQLIAeNMGX5q2U5zHaV495EPTZzN5ZSQ76BW1NoJqnFujI7IEElhzqROn4FBfqatHMv6UyJ241wMH2iXaJndhOkPBrrGfpz0XioKQ50lRWeeFG2tISrJrrvIvhhby9aRkpXXh6T6WEk3r5YU7Z9sSmzZU7+NTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X20w36RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X20w36RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1AC1F000E9;
	Wed, 22 Jul 2026 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784699810;
	bh=eEdvQy2Ydic5NNkhSxfJAay++WoPBPP0Jf5zS/wHW0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X20w36RFXK3sDx955Z49YxiLHgmf4vRGrPUY6pB7tCPIzBxDnkmWQSZszCVHvGW8o
	 es+d2oIogJL4s40UbJzCXCSGTMYDIDvOxmYteV0Rbt8ZD12YIaFuBuRMZjVr61qCQC
	 7MBLrMPolFKke1oaHISgAPzWMPLCu+V4jNZTmXEjq7QtD0Hb9tdlMDlAv0U/3htg04
	 uHn2RaM/bF98zcUgqpyyA7Px/3GS9QTIOZ0lm3pnYO60MLkqCu9VDxAwzwQZZzBSxT
	 xStLKnKniQpP/WjzUrwjIKbuk8Qk33xwr1y+YVmpp1Bhd+duMDBDVVJ3gOarq8enkP
	 rEVvxH9g89vsg==
Date: Wed, 22 Jul 2026 08:56:45 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next v10 4/6] RDMA/core: Add Completion Counters to
 resource tracking
Message-ID: <20260722055645.GR110966@unreal>
References: <20260720132221.2551-1-mrgolin@amazon.com>
 <20260720132221.2551-5-mrgolin@amazon.com>
 <20260721141659.GM110966@unreal>
 <20260721171453.GA19670@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721171453.GA19670@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Tue, Jul 21, 2026 at 05:14:53PM +0000, Michael Margolin wrote:
> On Tue, Jul 21, 2026 at 05:16:59PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 20, 2026 at 01:22:19PM +0000, Michael Margolin wrote:
> > > Track completion counter objects in the resource tracking database so
> > > they are visible through the rdma netlink interface. The rdma tool
> > > displays the comp_cntr count in the resource summary.
> > > 
> > > Add RDMA_RESTRACK_COMP_CNTR type, embed rdma_restrack_entry in
> > > ib_comp_cntr, and add the res_to_dev mapping. Register the resource
> > > on create and remove it on destroy.
> > > 
> > > Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> > > Signed-off-by: Michael Margolin <mrgolin@amazon.com>
> > > ---
> > >  drivers/infiniband/core/nldev.c                      | 8 ++++++++
> > >  drivers/infiniband/core/restrack.c                   | 2 ++
> > >  drivers/infiniband/core/uverbs_std_types_comp_cntr.c | 6 ++++++
> > >  include/rdma/ib_verbs.h                              | 1 +
> > >  include/rdma/restrack.h                              | 4 ++++
> > >  5 files changed, 21 insertions(+)
> > 
> > <...>
> > 
> > > @@ -48,7 +50,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_CREATE)(struct uverbs_attr_bun
> > >  	if (ret)
> > >  		goto err_free;
> > >  
> > > +	rdma_restrack_new(&cc->res, RDMA_RESTRACK_COMP_CNTR);
> > 
> > This is an unexpected location. I would expect restrack
> > initialization to occur before ops.create_comp_cntr.
> > 
> > Thanks
> 
> No problem, I'll move it.

Rest looks ok.

Thanks

> 
> Michael
> 
> > 
> > > +	rdma_restrack_set_name(&cc->res, NULL);
> > > +
> > >  	uobj->object = cc;
> > > +	rdma_restrack_add(&cc->res);
> > >  	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
> > >  	return 0;
