From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Fri, 26 Jan 2018 10:44:28 -0500
Message-ID: <1516981468.27592.200.camel@redhat.com>
References: <20180123205459.432-1-dave@stgolabs.net>
         <1516898063.27592.136.camel@redhat.com> <20180125175048.GG10706@ziepe.ca>
         <1516903584.27592.183.camel@redhat.com> <20180125185330.GH10706@ziepe.ca>
         <20180125192727.dkwuqel3xfut66wj@linux-n805>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IrJSZj5Btdbj6ipVG5gZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125192727.dkwuqel3xfut66wj@linux-n805>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-IrJSZj5Btdbj6ipVG5gZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-25 at 11:27 -0800, Davidlohr Bueso wrote:
> On Thu, 25 Jan 2018, Jason Gunthorpe wrote:
>=20
> > >=20
> > > Since the original post was referred to an ABBA deadlock, wouldn't we
> > > have to drop db_tab->mutex, then grab both in the proper order?
> >=20
> > I had understood that was only a concern because Davidlohr was having
> > trouble proving the callchain didn't include mmap_sem already..
> >=20
> > I can see the call chain all ends on verbs ops, and I know verbs ops
> > with ucontext's are never called under mmap_sem by the core code..
>=20
> Right. Ok so this simplifies things and we can just use gup_fast().
>=20
> Thanks,
> Davidlohr

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-IrJSZj5Btdbj6ipVG5gZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlprTNwACgkQuCajMw5X
L91b2A//R0K8QWltWlrcMP9gW0JVm8G/s5SrlCZAsR/S3X48ojiPG0tma9cZKrF5
Zj21/mUrL2m3deYF7qOHGyXYlADFy8Z/azHJDRMBK9/IbVsItoJ28sEDhjWbvhcx
YlGe3jjwO+PgEms6Z8Zlo5cRlOyMH4pL/w2Q8Rw53sv+KMbSvT0zqXjip2cMVNOQ
Wu9l6IhU48NwzTDnd5akp0wkaVi6W2GG88huEfvmSnBiB78wmZK0BN5UsviSvjFE
y8KgXvLioQ7Xev0DrfuauxPfqoTOvngGJYyE21/8N+08cSEB2jGKiaAphJC5iEyN
2Q9/dcvFZmdrrVS7oQt8maczuXLOqsakVgxRjApbaV4/MnKQsanrr8qMg+w0B/Py
QO/09AfufIeJ6ZpEJr57Tc2y8dmMKtTmWqGXgb7kLoXAPPgQeH4L/rkCcHmHIXro
W/1VomVCrOm9Y0L7pyFavuvjbtLjEul7TOx+EqgFz4gY79EIYytRt3wbhTLynrwh
JJgBDeWchgQQTGwuaPaEuhhwbU/JEJWUEM0nLOzZD/31GIyOXyKHxhDknr+86vIm
kKchYdkA1/oZHyjfxHuXaGG8/obvYyBzV2blsSjoP1uXJuXuo03psKU9TQRvHUiv
dPIj7KiHVl+InwIup7dyTcbTDAScFLh45239S1ly7NNJKQDcFxY=
=Gqkv
-----END PGP SIGNATURE-----

--=-IrJSZj5Btdbj6ipVG5gZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
