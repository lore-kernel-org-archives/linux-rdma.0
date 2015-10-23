From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Fri, 23 Oct 2015 11:52:11 -0400
Message-ID: <562A57AB.4000702@redhat.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
 <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
 <56266C4B.1060000@redhat.com>
 <CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w@mail.gmail.com>
 <CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XDU7Waib8J1Hu9eeh29OraEPDB8rN4gFL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XDU7Waib8J1Hu9eeh29OraEPDB8rN4gFL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/23/2015 02:46 AM, Or Gerlitz wrote:
>> On Tue, Oct 20, 2015 at 7:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>=20
>>> [...] Next I'll be pulling simple for-next items, then I'll be review=
ing the
>>> RoCE GID cadche usage in verbs/cma v2 patchset, then the Add RoCE v2
>>> support v1 patchset, then the New fast registration API v5 set.
>=20
> Doug, there are few singleton patches to mlxN drivers, just to make
> sure they are not left behind (thanks)
>=20
> a small mlx5 enhancement, Signed by Eli C. the driver maintainer
> https://patchwork.kernel.org/patch/7454641
>=20
> two small mlx4 fixes, acked by me...
> https://patchwork.kernel.org/patch/7348911/
> https://patchwork.kernel.org/patch/7348871/

Yes, I know.  There are quite a few different things for mlx5.  I was
waiting on all of them until I knew that RoCEv2 was in as that gates
whether or not mlx5 RoCE can go in.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--XDU7Waib8J1Hu9eeh29OraEPDB8rN4gFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKlerAAoJELgmozMOVy/dgvUQALAT8R/pfAi6KlXMMyLQtUG+
LVHn3k4ArM2vfj5cEDkCErQEceo10w5Lg3h/jq2jMfgv3oUsxk7iV5IZLEyPUZ4C
beEGvNcHEFL63Lkp8RoPT0v/Bhs569BGux8YHJIgbI1yJTi1evIGmOmEl0ljccef
Dwt835oQd0KBACcA6X8Ve7NaWkUfMbunKiXoDCGH6vMmcFX3qYi+bFfneM8z5NFD
Hax/2aJEjmwCVpKeXeb37zC+Ux80CvJQ8ATNcwZC7BcYBCTn7pulfg+eoGHDVjs/
Gl7L3jzBDfLIMP+oBmMBnXiWgOglbuB390L1zAZHhqbKHVZDQAYeu6Bxk2vY+94C
TqHfWvpsteOqf4SbpzxmkUSNJNIxC9KFK/EL3mfo2LMAo1q9vI6pX0zJHc5oqvKi
QZUZ3Lx6gsGf+x3jYKO8fmBxFkBGB9BEth9tXbSBOE6euOprh0cVsTsDKZMQku5G
ufXyBFW4PWQ09HvY8fZ8CU97ao3TkL2UvqMzTdRKgix5HsxVSf+Gw0gc9YLWc0eZ
az+svMQ32Cc0ROFbEf6U2le2/AGTnQodA68SggpTY5Svdz37hF5DsIzjf6iGqkEZ
xFZO8dzlyROTPPF6CCU6wlzeVD62/nUxfOxfK+7qW5ZU631VYJka0yAqGhBCxFC6
qBm9q7MUIbYWBNgFFfdx
=Ka/J
-----END PGP SIGNATURE-----

--XDU7Waib8J1Hu9eeh29OraEPDB8rN4gFL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
