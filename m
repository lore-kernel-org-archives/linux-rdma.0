From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Wed, 10 Aug 2016 13:19:27 +0300
Message-ID: <20160810101927.GK23921@leon.nu>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
 <20160809175801.GD23921@leon.nu>
 <20160810053549.GA32695@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810053549.GA32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2016 at 01:35:50AM -0400, ira.weiny wrote:
> On Tue, Aug 09, 2016 at 08:58:01PM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 09, 2016 at 11:17:18AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >=20
> > > The monitor values from bytes 22 through 81 of the QSFP memory space
> > > (SFF 8636) are dynamic and serving them out of the QSFP memory cache
> > > maintained by the driver provides stale data to the CableInfo SMA que=
ry.
> > > This patch refreshes the dynamic values from the QSFP memory on reque=
st
> > > and overwrites the stale data from the cache for the overlap between =
the
> > > requested range and the monitor range.
> > >=20
> > >=20
> >=20
> > Ira,
> > On all your patches, you have double line between commit message and
> > tags.
>=20
> Does this cause a problem?

Problem - no, inconvenience - yes.
It doesn't look good in git history.

>=20
> Ira
>=20
> >=20
> > > Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
>=20

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqv+vAAoJEORje4g2clinrgsP/3QuXk72NrcCGH68M2I6pBMP
J2ghhKPez45I02D4Z8VrD1t1n3MVuisAbQxP+BcJBJhygYk2pcFFJkR4LEIRIuAj
bZFKz10gYb4REiVdKBu2PWSYciKu0+W11y320LUwqQL3nB6bCNGMya4RUYwxLzo4
KbV1v9LeKW6RLUEHR8k+E/uL6iWijs4UhqJMxlZdjVAxzrRtN0dDZjJOY4N2i5NY
XwrwZfWU2YGm68MTSmjLLMvLr6NZ/uAcNhyN5/KfxjDekIR4/251zP4MgYBMCa1c
GzRGv7KuRmqESM26r7oEHiJakO4h8Z7UiaQQwZcBXjjcHtuAX/f3YCiA6xd7q0pc
Fjn6lWwEVheOPtOMXE7rTiGFtXkqKtgHHQpwgH4AKR58JyZnYpNlvqGtUmWcD0l6
UEBmJS9bbIkWB9NXPvJVC6pFIcgeOzHixj7UAHxRWREuCHpjcqfhtnP1y+8LFrjI
YvOdF2+jL6qRBgyACrk+jmj4l2jqeQt87wwTNfJkxwRhQ/os5IJXKPJ8nwitGXu8
ObW5s/SZ+avp+KwUgqREBJWV/Hl8/eykMg8KwUKnWVg9upn1iMnpcLxZhNyOQiyL
5Jg3oRiTiU6IQWEtOqXmIlEthOehbi1zITGnsvVMrh+UoLokmnbQSdCtpM8cfFTn
zsM7AbmhmclOW0FSCjH4
=8/dF
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
