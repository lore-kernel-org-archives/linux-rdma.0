From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 08:15:07 +0300
Message-ID: <20160629051507.GF3584@leon.nu>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <20160628211858.GB5786@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160628211858.GB5786-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2016 at 03:18:58PM -0600, Jason Gunthorpe wrote:
> On Tue, Jun 28, 2016 at 08:05:49PM +0300, Leon Romanovsky wrote:
>=20
> > > But at the end of the day, the message to users must be to use the
> > > new polling API, the old one is deprecated, and apps should never
> > > include fallback code because the new API always works.
> >=20
> > Please put aside Yishai's patches, I'm not taking about them.
>=20
> Well, I am, I don't know what you are talking about.
>=20
> > We are talking about the total number of other vendors who will
> > be ready to implement new features exposed in libibverbs.
>=20
> Who cares?
>=20
> Mellanox has been pushing dpdk centric HW features that no other
> vendor has an interest in. So it is understandable there is not much
> activity.

I see it differently, I don't see any activity from other vendors,
because there are no vendors who interest in developing new features in
libibverbs.

Currently all vendors can be categorized into three groups:
* Interested in legacy code - a couple of vendors
* Struggling from identity problem (verbs/non-verbs architecture) and
  has proprietary library - one vendor
* Interested in developing new features in libibverbs - one vendor

>=20
> However this is an all-vendor software only feature that all HW can
> support right now today, it is fundamentally different than the prior
> HW entangled patches.
>=20
> Consider the kAPI work to add the new MR stuff that Christoph
> did. That would have been a total disaster if they didn't update all
> the drivers to work with it at the same time.
>=20
> Userspace is no different, and the responsibility falls with the patch
> author to oversee that process and get it done before merging.

Again, my response is related to your expectations to see "other
vendors". Please don't drag me to the discussion of Yishai's patches.

Thanks.

>=20
> Jason

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXc1lbAAoJEORje4g2clinU8wP/3vAmj8/Mk8hfO8eAOEASU9p
bLqpB2g47Os3iDc38yZhLAVMxrfM4oV8z1QXGcffGDE+X7UGshanTR0Xw9yOECnY
teVapIlOyCCkfB/Mu66MIz7lWofNgYpLw6lf3/0yq6c3jn3okgTSNfTEJ0edUksJ
H0p0lGUggCMpsZsu997z1ZA96huqcH2zO+B5y6Picr60KdQeF6xxMhN8rZ8YjHBu
GtaRvizu2AcLJOezHegQzUIUerPs4p+TC9jmIyQW4YWct2JzyEV8I3scDjFfRRtN
O/craJ+vMkAS57OZ+P1ZGZ3kfBYLsah6ghalWaBBXgqR7FdAG6Aycz5oMq0w0Z4b
SK0hcnWxLt+AXk2pqojoc/eau3SKVGNyyBKa8IGH9w5Pa3CMaJ5I8S+DocamfXFN
k+7fs4yuWy98u7H2s705MV45LCsyCOFxq/HPdHNFcK0hBwO07t8dmBXI+5Br8cza
3/4VEDKiWiIFf9PCS3lQpEf/dWz4FKhLkZNtnRVjzavbzrSHKrv7HT9L9TZTqaRp
RvUc3DWenIdhVgsMFEQBI7EI/EcN9FBwgr92ukuJFg3m+AfFNn3ik753jAJPPgK7
FTyRpVShYKNFOQ1pW4IYj9+HDP0ritMu9RdnbikmC20tFdFaoQxwTvjVCMGeM3W8
aFR7k7t8tqk4orFUNj49
=XVUs
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
