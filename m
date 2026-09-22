Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95586330B01;
	Tue, 22 Sep 2026 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039001; cv=none; b=QV1xIxPPRikkvdlCAXF4yF4bscaiPsRbuL0Zi5Ou8wymQjieNJEMaY4OCj/1qke2k81aPlZjiuBcfRKB+AzUsrfzz8sFuTwcuRT/PbIQ5qq3J8bzj99vuSSSm6YwSMbMItu8KvEjkRNWz2yHJz7YOuKEsjK1j9p2Kvq1MUlXA/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039001; c=relaxed/simple;
	bh=RMX2BtoalWorbOUIGHeZoTJxiqakz70l3i9k7m7168o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LWZuiMmXszvzna4EJHOOjf72NQ1Rvp+j23REQ/cPJbN2bkRDrPNaNvWPXBxcGwR+dv7yBsifG1UQczBKh1gDUu5yI3DJAp5qphg+emSEFEEjkOq5FA30ld/DTNQtdscxYpCt+X0TiEZlia3DOYWf3njs/BuiX3E79ce3EARfluI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAf3/7Om; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAf3/7Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B21F000FF;
	Tue, 22 Sep 2026 01:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790038999;
	bh=7l5tGN37YqQUwstwTuNH4JGCVfzTU1Qv8/o2HNqyXuU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YAf3/7OmyZPhWHS8TN9HNVgCMxhqq9luWetI+0P4NsUZPnskgPqUin62CLGAXilqc
	 xHvA2+6zx/q+1cm2gZwZMTARd+r50SDp8C7RgDUmDHqVZV8jSDpsw4kdhiv8f4KIUQ
	 EEmjifafidE0rQ3pzvNjU1nRw1OwnoUXit+Z5+22ixNSaST0IFgUqToWR1cZEVTmXH
	 /Ui4rlEsmmEwZGLb4YFMiA4Zymy8xwvFSdx7xN1jKLswNvA19e9aoNRMzHAowiXJxu
	 IUrUis/+BBHJfh+R1YLyWX/2/RFJ2+z87CU7nZfuR8X0vvplt8J0kF2W47+ayCLaoL
	 albsu7VY+0CHg==
Message-ID: <7f248beec60467591f9a25b2efe50b063cf8ccf5.camel@kernel.org>
Subject: Re: [PATCH net] rds: ib: Clear the sg list when mapping an MR fails
From: Allison Henderson <achender@kernel.org>
To: Simon Horman <horms@kernel.org>, Dongliang Qin
	 <cccccccccccc777777@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com,  linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Mon, 21 Sep 2026 18:03:17 -0700
In-Reply-To: <20260921165722.GY13925@horms.kernel.org>
References: <20260920063449.1594203-1-cccccccccccc777777@gmail.com>
	 <20260921165722.GY13925@horms.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-09-21 at 17:57 +0100, Simon Horman wrote:
> On Sun, Sep 20, 2026 at 02:34:49PM +0800, Dongliang Qin wrote:
> > rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
> > mapping and registration can fail. On failure, __rds_rdma_map() unpins
> > the pages and frees the scatterlist, but rds_ib_free_frmr() can still
> > return the MR to the pool with the stale pointer set.
> >=20
> > This leaves the pool with a dangling scatterlist and can lead to local
> > privilege escalation. KASAN detects the resulting use-after-free when t=
he
> > MR is later torn down:
> >=20
> > BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
> > Read of size 8
> >=20
> > Call Trace:
> >  __rds_ib_teardown_mr
> >  rds_ib_unreg_frmr
> >  rds_ib_flush_mr_pool
> >  rds_ib_flush_mrs
> >  rds_free_mr
> >  rds_setsockopt
> >=20
> > Clear the scatterlist fields before returning an error so the caller
> > retains sole ownership of the scatterlist and its pinned pages. Route a
> > zero-length DMA mapping through the same cleanup path, and skip unmap
> > when no mapping was created.
> >=20
> > Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registr=
ation mode")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
> > ---
> >  net/rds/ib_frmr.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> > index bd8611911..fea387952 100644
> > --- a/net/rds/ib_frmr.c
> > +++ b/net/rds/ib_frmr.c
> > @@ -213,7 +213,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rd=
s_ibdev,
> >  					 DMA_BIDIRECTIONAL);
> >  	if (unlikely(!ibmr->sg_dma_len)) {
> >  		pr_warn("RDS/IB: %s failed!\n", __func__);
> > -		return -EBUSY;
> > +		ret =3D -EBUSY;
> > +		goto out_unmap;
> >  	}
>=20
> Hi Dongliang,
>=20
> This approach leads to the complexity of a condition in the out_unmap
> label.  I wonder if a cleaner approach would be to, instead, only store t=
he
> scatterlist in the MR once mapping has succeeded.
>=20
> With such an approach I think that ibmr->sg and ibmr->sg_len would still
> need to be cleared in the error path. But neither the condition in the
> out_unmap label nor the hunk above would not be necessary. And I wonder
> if that would be a cleaner approach.

That sounds reasonable,=C2=A0the rds_ib_teardown_mr() at the top already le=
aves ibmr->sg
and ibmr->sg_len cleared.  So if we move the ib_dma_map_sg() below it and d=
o the check
and goto there, then we dont need the unmap in the out path.  Just clear ib=
mr->sg and
ibmr->sg_len.  I think that would be a lot simpler.

Thanks for working on this!
Allison

>=20
> > =20
> >  	frmr->sg_byte_len =3D 0;
> > @@ -261,9 +262,13 @@ static int rds_ib_map_frmr(struct rds_ib_device *r=
ds_ibdev,
> >  	return ret;
> > =20
> >  out_unmap:
> > -	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
> > -			DMA_BIDIRECTIONAL);
> > -	ibmr->sg_dma_len =3D 0;
> > +	if (ibmr->sg_dma_len) {
> > +		ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
> > +				DMA_BIDIRECTIONAL);
> > +		ibmr->sg_dma_len =3D 0;
> > +	}
> > +	ibmr->sg =3D NULL;
> > +	ibmr->sg_len =3D 0;
> >  	return ret;
> >  }
> > =20
> > --=20
> > 2.43.0
> >=20

