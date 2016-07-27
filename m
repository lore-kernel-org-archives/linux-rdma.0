From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB/mlx4: Use EAGAIN error code instead or EINVAL in function
 mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 15:34:10 +0300
Message-ID: <20160727123410.GI4628@leon.nu>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
 <20160727085800.GF4628@leon.nu>
 <20160727102640.GA3549@yuval-lap.uk.oracle.com>
 <20160727112329.GG4628@leon.nu>
 <20160727114238.GB3549@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wZdghQXYJzyo6AGC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727114238.GB3549-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wZdghQXYJzyo6AGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 02:42:39PM +0300, Yuval Shaia wrote:
> On Wed, Jul 27, 2016 at 02:23:29PM +0300, Leon Romanovsky wrote:
> > On Wed, Jul 27, 2016 at 01:26:41PM +0300, Yuval Shaia wrote:
> > > On Wed, Jul 27, 2016 at 11:58:00AM +0300, Leon Romanovsky wrote:
> > > > On Wed, Jul 27, 2016 at 01:24:51AM -0700, Yuval Shaia wrote:
> > > > > Please review the following two patches.
> > > > > First patch makes int-return function to a void one as it anyway =
returns 0.
> > > > > Second patch replace all EINVAL error codes returned from mlx4_ib=
_poll_one
> > > > > to EAGAIN.
> > > >=20
> > > > Thanks Yuval for taking time to do it.
> > > > After your's IPoIB patches, we prepared patch similar to these and
> > > > planned to send it after merge window will close.
> > >=20
> > > Great new!
> > > So, will you also take care of making the function use_tunnel_data vo=
id?
> >=20
> > No problem, I'll resubmit your use_tunnel_data patch.
> > Thanks
>=20
> With the surrounding {} please :)
> I can send v1 if needed.

There is no need, I already added correct version to our verification
system.

Thanks

>=20
> >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
> > > > > [PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_=
one
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in
> > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >=20
> > >=20
>=20
>=20

--wZdghQXYJzyo6AGC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmKpCAAoJEORje4g2clinX/YP/ReT4bhS2XUnNpPLWcS4mllV
9tP3Idy1TgqbYLENJJi0Q15V+NgOZeBPKOPv92tT4YghvCZUTe5lVPDPJdxgtGtp
oBfv7jvP1qtXaIRpiYiH53//9SB8bENZk81Tg9IQC8vI+6f1aAWeWtY2knWe1K+L
TEUZ5tblDf0fGaA/MMPgLHh5t/9INAZKJgwSAFQLkjiYhj7A7Ju0fv2D2lFTsOnp
cmCQZa1erkwmVrasO7meJyqRvjVZZ6H85Wd8Xv3vt7krl9lmdSTQaqERBv0Oa9Qi
NQZ8rvy8WRSVJRi1qAW1SQeFjTXET884lmV9VlmD1UOkmxHMrM45HLNcKuFOa2Yo
LYC/EvFLUOGvaw+m5D6TKwI0khE1T0rfkbx1lvEA8HIaPkoDtoMlDjYouuJ/qmd7
HSvtzk2zsVgFL5mgwOFhEhlwg5Yf1gScjF16Q71p4399bjQdg8tt+qDselxf22WJ
CMpG0jeOBxi1JCLmzbMxctwu2tGTU0EW858bCiB4S93Sin4/hAGg4rAnJgQlX5GC
AKQvEQt521gi60LYK9YgA4fYyRmFd5AtZ0yXqO3R9lBDH2W4K9qoYgmrzMkEf2lX
bjBjavC1AFWLswEed1vKOc280h6ukG2Mp7VWK3wdgRfgRUYv3U7Ya4XcmRFHW/Gy
K17sZFb6cYcq469Trx3q
=dpJi
-----END PGP SIGNATURE-----

--wZdghQXYJzyo6AGC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
