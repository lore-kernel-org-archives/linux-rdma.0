From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 16:27:20 -0500
Message-ID: <1517261240.27592.245.camel@redhat.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
         <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
         <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
         <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
         <1516904022.27592.187.camel@redhat.com>
         <679C11A4-744C-4574-9F50-2D2C3B0F08B0@oracle.com>
         <92367a43-4c2e-887f-35ff-38fa05d47c49@grimberg.me>
         <EFFF4091-3CBA-474B-B9D7-FF7EDA3B1613@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pRltywajjkSW9O03rl4x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EFFF4091-3CBA-474B-B9D7-FF7EDA3B1613-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-pRltywajjkSW9O03rl4x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-29 at 15:11 -0500, Chuck Lever wrote:
> > On Jan 29, 2018, at 3:01 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> >=20
> > Hi Chuck,
> >=20
> > > For NFS/RDMA, I think of the "failover" case where a device is
> > > removed, then a new one is plugged in (or an existing cold
> > > replacement is made available) with the same IP configuration.
> > > On a "hard" NFS mount, we want the upper layers to wait for
> > > a new suitable device to be made available, and then to use
> > > it to resend any pending RPCs. The workload should continue
> > > after a new device is available.
> >=20
> > Really? so the context is held forever (in case the device never
> > comes back)?
>=20
> I didn't say this was the best approach :-) And it certainly can
> change if we have something better.

Whether it's the best or not, it's the defined behavior of the "hard"
mount option.  So if someone doesn't want that, you don't use a hard
mount ;-)

Hard mounts are great for situations where you have a high degree of
faith that even if they server disappears, it will reappear soon.  They
suck when the server totally dies though, because now all the hard mount
clients are stuck :-/.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-pRltywajjkSW9O03rl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpvkbgACgkQuCajMw5X
L93NORAApqZKsDsBzbdgLCyTwNSBQ0sOOkkv4534ID5dWf2XVdwNdfYgzSH4l6Tf
tkhVQC9UXdxRyWDBezmW88CJJkwbst3tZmNPM+G9Y14eJ1FeM6p3v2I8up4yuBat
8uFeBJHot1P6cPnJZg6Frp+OtzOxD0/8KnKjQE0cNDrWSUy2ffxGxfdK+8ilWZ0t
K5+GkJpgqppqAVL2uE5WoogSBDr2yJKAjEup+cglkinTDBVdx74JP7r3W9GiTPVE
NuJ54tkVtUw5oR21jX1NJslkAAUWmKCelSFmMB7ZOaRtlwerXmL/X7QcGSd8TqwP
rp0ioj9/ig69utBkYmMZaamXGe6M7yTRMM6HQBFbtk6L4KNGFt043AcDC633e+Gy
LN2vmMZxtud8XODBp7GBL2fWW8WdPypJXWuGzDQG46jwXQjSNDKK4QOeFqcrHh6F
WqmQYdN9sNG6y8yjsBMW0OjJ9M88X7aQGDrN4mrpSH9SLsRHSQFHlET+e6P2ptVZ
ovnyjkZLR4RxWkMOuadgVm7TtR7UNgpKdcNMHkYH81iaxmGl6i1zav6RyqwaiIof
hwu+bjCkseBLHH/Ik3sjUv1PvfsJl9kARIAMOCxZF2T2x9wTwUJIzwdMH9oCamP6
I6lRqpOwMtm74gxZCRiXsfyBAW8H/LPSQPDzb/iXbvzeIDYotQ0=
=wPo0
-----END PGP SIGNATURE-----

--=-pRltywajjkSW9O03rl4x--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
