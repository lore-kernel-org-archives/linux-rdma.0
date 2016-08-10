From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Wed, 10 Aug 2016 08:51:38 +0300
Message-ID: <20160810055138.GH23921@leon.nu>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
 <20160809175801.GD23921@leon.nu>
 <20160810053549.GA32695@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810053549.GA32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZPDwMsyfds7q4mrK
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
It doesn't look pretty in git history.

>=20
> Ira
>=20
> >=20
> > > Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
>=20

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqsDqAAoJEORje4g2clin6Y4P/3GRI3FYm393uLpjEll4+1zo
iLm2Y50hghcqqpHtYEm0uXaNO8nLHbi2RsqqGqSRONmKtpkGOlqtR0xD0uF3D4Uo
rTWiqWkd5muqIvSithPi6dHmdAq2KfJaKV+7n4RpD3xABa30d6UuRXYPy18JGWSS
EujnJZ7OTDYqYezVTeYTVZT33a0kDE5VOyTLaJ7lx47m1B2E3UhDhBYOoBQzzpqa
d01wo+nZ+m9ILNCDJKeABZfeLti+dT6bIaZjQkqmcxwVb/GWCFPGVyN0ivooZ51c
vxXeouNRrYnCmFO8EcKLQPnhnUjOg9IzeyB7Kq4Qu5U691nqryx4akxXykaIMdkK
QdsdtIUhBfnUPZ94onJXbvA/+AO3+Rml+RRS/UCErodyFMOR+b5k8t6I2c6HVAvK
PMuvDwj9q7y2w1W+wPAzx7lYG0ueBiXwBJxrYsY7L0RKJitB22FOXjWc8dJ+6uEM
ht9sUHBO9CGQOfi5yWux5BCU46VpoQ4pWIdNXABfqcak4A87Zsgn5oT06+Jp1CyM
F+K8Ij4ZK7lN5vPvgy/XdDhUpYsHQiS1Gljs9BrWt4FSm6xMNs6UqHDdWsbI1aYr
J4B2g6btzFmZ4MxnX5TzdHFdJVWP2sy5EYHWJoJoFzEUqfli+TdLiW5KSilKuLy6
C+wyeHumrvYFKQDc2Sz0
=Wnla
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
