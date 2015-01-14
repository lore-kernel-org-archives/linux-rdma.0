From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 10:38:10 -0500
Message-ID: <1421249890.43839.243.camel@redhat.com>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>
	 <54B63CE9.3080205@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/OCpQ3Hn+YRIsaKUPAqC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B63CE9.3080205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/OCpQ3Hn+YRIsaKUPAqC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-14 at 11:54 +0200, Or Gerlitz wrote:
> On 1/14/2015 8:38 AM, Doug Ledford wrote:
> > The usage of IPOIB_MCAST_RUN as a flag is inconsistent.  In some places
> > it is used to mean "our device is administratively allowed to send
> > multicast joins/leaves/packets" [...]
> what? please tell which of these upstream hits (prior to any fix) has=20
> this semantics?

Actually, almost all of them.  I don't think they were originally
intended to be that way, but as a result of the mechanics of how
multicast joins are done, the net result is what it is.  But even more
importantly, this semantic is what we *want*.  For example, in
join_finish() where it tests IPOIB_MCAST_RUN before queueing delayed
work on a join failure, we *want* this to queue work whether the current
task thinks it is done or not as this is an async failure case and the
thread could have thought it was finished and cleared the flag before we
got our failure.  Treating this flag with the old semantic leaves this
situation with a dangling error condition that doesn't get retried until
something else restarts the mcast thread.  In fact, in almost all of the
places that this flag is checked, we really do want to run the thread
again unless we are in the middle of a mcast flush or we are downing the
dev.  In all other cases, we want to requeue the task.  So the semantic
I'm applying here, even if not what you or some other people had in
mind, is in fact closer to the truth of how the flag is used, and is
more in line with how we *want* the flag used.

> # git grep -n IPOIB_MCAST_RUN drivers/infiniband/ulp/ipoib
> drivers/infiniband/ulp/ipoib/ipoib.h:90: IPOIB_MCAST_RUN           =3D 6,
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:434: if=20
> (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:466:     if (status &&=20
> test_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:536: if=20
> (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:550:     if=20
> (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:576: if=20
> (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:634:=20
> clear_bit(IPOIB_MCAST_RUN, &priv->flags);
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:644:     if=20
> (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:658:=20
> clear_bit(IPOIB_MCAST_RUN, &priv->flags);
> drivers/infiniband/ulp/ipoib/ipoib_multicast.c:728: if=20
> (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-/OCpQ3Hn+YRIsaKUPAqC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUto1iAAoJELgmozMOVy/dTAsP/RHmzJfhrf7l2oQc7krE9X5u
RtBfBPcpIOkw2+nIxkXxDEM0WUYLyKTeZaPtJz4Se0e6DDXOD5wC/6K+j2a1RFeV
MVwnHHkks7Dz0gOm5FYIvARXsSKAUKb1aYyM7SL6FWRXuIeCVE4eJ10s1Gbdvga8
QbKsMsZMdh201AigWvDbgKTS6YKdUEfKBoucrs2Jk2eAqh7QfWfKI7bcyERA3VgE
Q9/+vJuxuepVYQXCscb82ChozmyknyXI4tohb1pegCQyhrgwSo+jBEu90vFP68li
Gr+qmYHgIC1eyTkt5LdWur2aBuGVKgOYt8odNFBXH5sLnG5pipXLtMhTXydjTjWM
GiFWz+uv0WMPyV4/rlTsWD+3V6kX2A3gm18qt5jLC0/FpT62VrHOrt8GvE3AJaaP
LvcHTCBBSQVINx66dSAeBMsJeRL4aoE5LO+m51NNuKM45AymkRvsJYTkDxDhfBKY
+xnC3KwBRtO03Pr/ZAVyo9A3Kl7bmqk9yLlvGRFuBf2B9HLLEQ7ZEqS9lcSwR1S9
GR8r2jWsZo/xZkPZ3m6igdvvRoZ5q/gYieIqT6zRxiOF25LgZFmCopZ0BTiT+64F
dr9QZZo4/mqYR3NHNeaKhbppzAFFGQvAE8fhlwa7iNCvdQfYdl+vj5PVqOh+wjDQ
WKoxyMurlD36ZmY2LkRD
=+VdU
-----END PGP SIGNATURE-----

--=-/OCpQ3Hn+YRIsaKUPAqC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
