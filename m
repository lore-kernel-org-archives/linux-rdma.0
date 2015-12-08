From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 8 Dec 2015 17:01:14 -0500
Message-ID: <5667532A.1070202@redhat.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
 <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
 <56266C4B.1060000@redhat.com>
 <CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w@mail.gmail.com>
 <CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog@mail.gmail.com>
 <562A57AB.4000702@redhat.com>
 <CAJ3xEMj397H-9Jrfk3K+MX92d6Q4gNA8w2tkKM6LytodPSbP-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xnBqMxbVbixT3qBuP6O5e41JQH7RLrcJ7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj397H-9Jrfk3K+MX92d6Q4gNA8w2tkKM6LytodPSbP-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xnBqMxbVbixT3qBuP6O5e41JQH7RLrcJ7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 04:07 PM, Or Gerlitz wrote:
> On Fri, Oct 23, 2015 at 5:52 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 10/23/2015 02:46 AM, Or Gerlitz wrote:
>=20
>>> Doug, there are few singleton patches to mlxN drivers, just to make
>>> sure they are not left behind (thanks)
>=20
>>> a small mlx5 enhancement, Signed by Eli C. the driver maintainer
>>> https://patchwork.kernel.org/patch/7454641

I originally had bumped this one to 4.5.  As you say, it's an
enhancement.  But, the particular issue is so simple, and can be
considered buggy behavior (hogging the CPU when you shouldn't), that
just adding a need_resched check I'll take.

>>> two small mlx4 fixes, acked by me...
>>> https://patchwork.kernel.org/patch/7348911/
>>> https://patchwork.kernel.org/patch/7348871/

I took these two.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xnBqMxbVbixT3qBuP6O5e41JQH7RLrcJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZ1MqAAoJELgmozMOVy/dvPcP/RnvNlub/cboNQVxe786y43g
97qskRwT6wzE7rWcVi1EwZDR/E2IWB4mOrTkoNFHJBPmqVfm9Byt+BLEsnoZINwI
6Wbwe3sbfYGkDtiWMZ4WqxxJC5ZqYcLdAPTPnAbUQLpQk/ZWkdDbU8sqQoSAl/eU
S7qcVp1+8yUDDnXq31vA/rAOm3gqYgyfFigSb01tHt/ACk/7/pYRPq96BgIj7vu4
p70ZZ8rlc2DxtS35qVlbKhOPHT0ULXq/kg9n1VBAOVcFLvItiWzvz5u2lVFCaivG
dII0kxYEGScBeL9UmgcN7h/rRp/R+uYOhjKPiDvCryWdre/prbAuxdhXqIv5IZyb
OA5beHNRGwDivLKn9ZzTXenxvAW2F0poAVOVJG28+cumbcuFrP4lTq2dmB/kX35d
2wpzrtwP760tvQqXotmtjIdKm5i4UQMndhU51DZbCcTKti2KcClaUy2g8GpZFzmK
XL21BDLAELtoVw90bm2Rq0yPBVqiFu8KcYlH+BcfXqc6zbZqQLWj5wIJFih6VDkn
NsBKNVRZBDulUomD+pT/yZvTUySRE4cEOu5ql4lLI+OUkkv5o17qS6ODp3t0TOB/
sPsBhWeV7jYdiCj8IUMzcVdgbITKLBIFduqOidjDdkG/4048iIj90h0nRMECzGWj
iJ0CdQDeKvgM6sOFEnm4
=Y1nJ
-----END PGP SIGNATURE-----

--xnBqMxbVbixT3qBuP6O5e41JQH7RLrcJ7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
