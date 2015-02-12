From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19] IB/ipoib: make sure we reap all our ah on
 shutdown
Date: Thu, 12 Feb 2015 15:03:58 -0500
Message-ID: <1423771438.3387.7.camel@redhat.com>
References: <31ba9a1b4528599de17670083aad043b28eff755.1421964024.git.dledford@redhat.com>
	 <54DCEC9F.8030304@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DHTsOUmJ2rVzx4rie1kl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DCEC9F.8030304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-DHTsOUmJ2rVzx4rie1kl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-02-12 at 20:10 +0200, Or Gerlitz wrote:
> On 01/23/2015 12:02 AM, Doug Ledford wrote:
> > The introduction of garbage collection for neighbors in the ipoib stack
> > caused a leak of resources.  In particular, an ah can have a refcount
> > from a mcast struct, from a neigh struct, and from a path struct.  When
> > we put an ah ref, the ah gets moved to a dead list to be reaped later i=
f
> > the refcount goes to 0.
> >
> > During ipoib_ib_dev_stop we attempt to reap these ah entries, but since
> > that function does not force the neigh garbage collection to be run, it
> > can leak any entries held by a neighbor.  And even though the code
> > attempts to warn us that we will leak entries, that warning is broken
> > because the entries we are leaking will not yet be on the dead_ahs list
> > because they still have valid references held elsewhere.  It is during
> > shutdown, when we finally kill the neighbor garbage collection, that ou=
r
> > final ahs will get put on the dead_ahs list, but after the point at
> > which we run the neighbor garbage collection, no attempt is made to rea=
p
> > the newly added ahs, and because during ipoib_ib_dev_stop we killed the
> > ah_reap task, no timed attempt will be made to clear them either.
> >
> > Instead, create a an ipoib_flush_ah and ipoib_stop_ah routines to use a=
t
> > appropriate times to flush out all remaining ah entries before we shut
> > the device down.
> >
> > Additionally do one final flush of our priv->wq before we start tearing
> > down ib resources to make sure all possible queued work is done and
> > all possible resources freed.
> >
> > This is done to prevent resource leaks on shutdown, which manifest with
> > this message on ib_ipoib module remove:
> >
> > <ibdev>: ib_dealloc_pd failed
>=20
> Doug,
>=20
> If you make this bug fix apply-able before the rest of the series we can=
=20
> push it to stable
> kernels too, can you make it?

I'm not sure that's possible.  This patch relies upon the fact that we
have a per device workqueue to be able to flush safely.  Prior to the
rest of the patches, we still had one global ipoib_workqueue.  Depending
on the context in which the device is being downed, attempts to flush
might result in a deadlock.

> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> Please add above your signature a "Fixes:" line which specifies which=20
> commit you are fixing, is it this one?
>=20
> b63b70d87741 IPoIB: Use a private hash table for path lookup in xmit path

Yes, this is the one it fixes.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-DHTsOUmJ2rVzx4rie1kl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3QcvAAoJELgmozMOVy/dkUQP/2lWHCzQz+ly5wCJiKuA/h40
0LZ7uQgD5b0rMwuGkmaSU6sMmYrpqenhUrB18vMil/7g1mTFvVWA91KPhtyeh499
90MOepEVHWJqLLkRuKEsbP0E276e/7kB1mfl94wMC9NoQcHbfPpQJT7vgu4NDH6U
JdfpXVWAWm0guM+gpm0XB8pv9z8MWbLwHDyCCx9C9lx7xXlOiDR/c/UcveCM2Qho
80g0JmAF8R2x3FQ/uf2R/bmDIwiiUDjBLMstHwF7fxgXRKhChdshNxHji0P93+Fe
aibCFqLARn3Gd2y6m2aZyBYQfPoFxjnk/2LhfNfiGmch1DFyV3rwVTsoY5yzhX0m
j9+8FCmkZPeos0zk7e095KfWE+RgNcxzYqcbr/+/uk7HUCZFNxnw3PCKVD2J3Y33
ZOMZUkB7NjOQnKpjHHrMCTTFCVmT3OpRJOVFjmLBRljW2BpG1JVgSOeqls/wC31C
ZOf6leCDU6siICYFM2Un3ceIb6MyIjt16RyQHocpJ+khO5gCWJpPxWCrsr9O7sTK
i+elWv0WRmehWQBYGkQtSHWGC7R0sDegE9T9yCwb+yopqYkWWobWEfXQnF0zQLHI
QkngnWCGerlKCflLAP8YZyq2bXoequqMQMXk/ZblYo78TPEXUZ6oRWsx7yaT5xdq
7jO2EY9x7XKWtktTZa77
=NEls
-----END PGP SIGNATURE-----

--=-DHTsOUmJ2rVzx4rie1kl--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
