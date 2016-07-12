From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 3/8] RDMA/core: Refactor IDR to be per-device
Date: Tue, 12 Jul 2016 22:48:56 +0300
Message-ID: <20160712194856.GC10079@leon.nu>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-4-git-send-email-matanb@mellanox.com>
 <20160712192933.GD8206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160712192933.GD8206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 01:29:33PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 30, 2016 at 04:39:26PM +0300, Matan Barak wrote:
> > =20
> > +static int ib_device_allocate_idrs(struct ib_device *device)
> > +{
> > +	spin_lock_init(&device->idr_lock);
> > +	idr_init(&device->idr);
> > +	return 0;
> > +}
> > +
>=20
> > +	ret =3D ib_device_allocate_idrs(device);
> > +	if (ret) {
> > +		pr_warn("Couldn't allocate IDRs device %s with driver model\n",
> > +			device->name);
> > +		ib_cache_cleanup_one(device);
> > +		goto out;
>=20
> Eh? Can't happen, don't over design stuff like this. Return void from
> ib_device_allocate_idrs

Right,
I'll do.

>=20
> > +static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *co=
ntext,
> > +					int nested)
>=20
> What chance is there to get rid of 'nested' ? If you want to use a new
> locking model, I'm wondering if we should trial it with uverbs???

It is removed in our next version.

>=20
> > +struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
> > +{
> > +	return idr_read_obj(pd_handle, context, 0);
> > +}
>=20
> All this stuff needs a type check. Something needs to confirm that
> 'pd_handle' is in fact a pd. This was being done before with the split
> IDRs.
>=20
> I'd also suggest that the uobj restructuring be completed a dedicated
> series.
>=20
> It looks like all approaches require this sort of stuff, and perhaps it c=
ould be
> merged??
>=20
> I didn't look at the locking in any of this stuff, maybe once you finish
> it up.

I think that the best way will be to wait for the next version, because we
reworked locking approach and removed all these idr_read.../idr_write..
calls.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhUmoAAoJEORje4g2clinaUMP/RbknIBT4tMtLfi3qIVdD9qC
OpzOSGCdlc6dHqy0y3wxe/PtsIYfHJFwnd0cNEs7EwIQTLzPG5QsnSzmxUfV0+pG
JO3WeL2YwWrEN5P4WjkCNN/sxU24K+BJpmw7LpiVen+icM6RjABiHk3oKfIdnEng
yvOPiWKJSdfQMK5j/CO8oIwvEJUagcFLfdg+i/0WT2dT99MLbSolLBhsGGyCDbH9
HyeKRT6dCVhponCFJLS5LapKjHvPClbt6PdqsjUzZUs8/7yo7Rd/dZfw8ZVLsVW2
+29fOKiimV3bSkrixw1h1sgpX+TkSdg017rcgyjBgryr5/gC9jK5DAq7L75O+Uqt
glmEWN1mNMNWO5x+1MmH3Og/fC/QaW73EWaOvZDky1uN+LSriUpKLWM0Eqe5fgBk
f0ZYQ3oYivsepKDLgxktN+bH4RYuEv//ziHOmErGYyzrF0OoBsPopKFrUfDcjtSR
BE/DTOn1k65MrNzdQ/7VrD+7jaerp08234dzP/RoT4bf8RY/3kjpSzl5oQsLgXvm
1qtOxT81LPdOGwDdegFGW6JvKre2gvBBaTOgNBovwzgW60hgLjzU2tT/BuqRskZ7
qQvbVLxlYBqFwRaQ8pOy/rQgrKUjzFzp3RXdHV9hxD2jgmLcmaEih+eqMjrH1baR
Kx3kr1E3XQSnls2D7DrN
=MsNr
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
