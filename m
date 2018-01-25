From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Thu, 25 Jan 2018 13:06:24 -0500
Message-ID: <1516903584.27592.183.camel@redhat.com>
References: <20180123205459.432-1-dave@stgolabs.net>
         <1516898063.27592.136.camel@redhat.com> <20180125175048.GG10706@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MfhINExRB/p9KXW47Ibv"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180125175048.GG10706@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Davidlohr Bueso <dave@stgolabs.net>, roland@purestorage.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org


--=-MfhINExRB/p9KXW47Ibv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-25 at 10:50 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2018 at 11:34:23AM -0500, Doug Ledford wrote:
> > > - Should I be wrong about no callers already holding mmap_sem,
> > >   I still think calling gup without the mutex makes sense for
> > >   improved paralellism. Now, if callers can hold the mmap_sem,
> > >   it's wrong to do copy_from_user right before calling mthca_map_user=
_db.
> >=20
> > So, if I understand you correctly, we (well, you and Al would be more
> > correct, we haven't looked into the situation yet, so Mellanox people
> > that worked on this in the day might now, or someone taking the time to
> > research it could find out) don't have a clear understanding of all the
> > conditions this function is called under, and so we actually don't know
> > what the best way forward is to fix it?
>=20
> I looked at it enough to be confident that mthca_map_user_db is never
> called with mmap_sem held.
>=20
> Also pretty confident that mthca_unmap_user_db is never called with
> mmap_sem.
>=20
> So how about just grabbing mmap_sem around the call to get_user_pages
> and no other changes?

Since the original post was referred to an ABBA deadlock, wouldn't we
have to drop db_tab->mutex, then grab both in the proper order?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-MfhINExRB/p9KXW47Ibv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqHKAACgkQuCajMw5X
L93PMxAAt1Z2i2YGiDziKaWivoDg3b7O5olASdhV6CbCYPBm2XrBWBCixJ95baBl
ZSNVGGd+GGWFsoSPO6aKDWDwVoFl6zxIYI93C6YNQQIo2uoX+h8HzQSCb1UN2EPW
a1G5oZ2ZwB4lc/wEs9fBCMxa7Tou8BWAOC47btI5KtdQvxkKGrPLYIhNyl02MNVc
M/NU1vyNyKvuab6uPZDxZF6x8f2pJsQIenXZftpcAHfeuVxukmcyBC+fguGuOs2v
OfLsDTisZl8n2wKEXXzRLmYjv+k5/FuFUpdgFPIh0t4XGNeu4wbYswMAnOuZTiQk
zmqkYLXDk8y3PsDtzK2LVvqKrHQmCMmRevx1zB87JjndmcQ/RUmiYWrPrWjqKjSP
POr+IZ4XxEDVq4vBAQtd/xwJuSsrB0/hVpbd10CzUgPBrQ/YBcxb8hs42H6N/R0x
/YYiNaLnoGeu+H9Pun9nG3EYpdWZQKmAV/9j6ybTQAUaDyVIdRmFqxp7wSsK1Rng
2z7P/uYdIH5F8QpQgm8cycwMoPkZUUGUdLQk/G5GYjMtbelCiD/NhqeN4hK/yb3N
XS2rxlhcXNd6FArOf5Pf8oGM+JOxIszVZPvOIwRzYwB1hJZOuHSQusNBqqoX+5sH
H5fIJ6iB+whPjVhaZ8hK4pA9XIhTo2kMz6ILindS6oulrWAQwlI=
=HSyc
-----END PGP SIGNATURE-----

--=-MfhINExRB/p9KXW47Ibv--
