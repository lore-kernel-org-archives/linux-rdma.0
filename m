From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 03/17] IB/core: Release allocated memory in
 cache setup failure
Date: Sun, 18 Dec 2016 09:41:55 +0200
Message-ID: <20161218074155.GB1074@mtr-leonro.local>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
 <1478184265-9620-4-git-send-email-leon@kernel.org>
 <20161216034218.GA12582@phlsvsds.ph.intel.com>
 <20161216042743.GD3797@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161216042743.GD3797-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 09:27:43PM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 15, 2016 at 10:42:19PM -0500, ira.weiny wrote:
> > >  err:
> > >  	gid_table_cleanup_one(device);
> > > +free:
> > > +	kfree(device->cache.pkey_cache);
> > > +	kfree(device->cache.lmc_cache);
> >
> > Despite the fact that another thread said this is supposed to be ok because
> > ib_cache_release_one free's these I much prefer what you have done here.
> >
> > However, don't you need to NULL these out so that ib_cache_release_one can
> > safely call kfree again?
>
> Yes.
>
> I feel deja vue here, like I've pointed this out before and the
> resolution was to just rely on the release function so we don't have
> bugs like this.

I'm sure that I missed it, can you point me to that discussion?
Thanks

>
> Jason

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhWPcMACgkQ5GN7iDZy
WKcm1RAAhrYDyZC8/Qk7SSUMiCM+bJwz5HUF1uYV2jc50YyiN7loWOXvrbrvC8DO
oewZDZNpnll991SJIN49Oo7KvMe+LslOz8zU7wV5SMJvF9Fs8HhfK1MLcLbjWSPR
Wh1EdnQ2+mo+nB8Xci/FGGkMig9awtRIxudIUX0VFi1P1SK2dw7d91p6DbqNjFzA
9adNboKL026OiZ9jSUJ3CKDgE8NXp41EqM33bDQKcclWzqNiOKLThv4X4kbfiS8f
hxPmCI/xu9zph3aE1vNlwa1CfAcwzErh3ervV9y/3QGMkoOkgOFl5EbOaEGyIf17
Kmkotbig3ZInwW20N7VH19RNll+t195xGVZx8NqNCWboxYcn7ihHFc8A6ne+j1BQ
2uoFIrL8jKenLsPiXkUHPVpjgzkUVN9jO1UO9p00UfKzE1gnSDYhbMrgb+QwHTbr
TjLxgo40xpWHzceCG1nMYLg3T5FRxIxCC+i35QzJF3m5iTZF71OZRJGIQt8mnsqR
AUyL1KYcAV+eC19IugqwdRKlgPZ/AaaOJOb0oSeUF9jOvjnP7fy8bTfV5bEEcHr+
fIOp0tpxA67ZK6fWMfIgXFoy11oeOSuYik3RXu2YMZ64BcYLbp0SxxH8fktJig8X
F3xGZCtb9qymv00XagIt97atF5Xaczhs2Zf+yBJOt+uoSpfUCaM=
=YdcZ
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
