From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/uverbs: Use an unambiguous errno for method not
 supported
Date: Thu, 25 Jan 2018 11:18:44 -0500
Message-ID: <1516897124.27592.131.camel@redhat.com>
References: <20180125025834.GA25674@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vyuEkX2Du0P4+RlNeXhH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125025834.GA25674-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-vyuEkX2Du0P4+RlNeXhH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 19:58 -0700, Jason Gunthorpe wrote:
> Returning EOPNOTSUPP is problematic because it can also be
> returned by the method function, and we use it in quite a few
> places in drivers these days.
>=20
> Instead, dedicate EPROTONOSUPPORT to indicate that the ioctl framework
> is enabled but the requested object and method are not supported by
> the kernel. No other case will return this code, and it lets userspace
> know to fall back to write().
>=20
> grep says we do not use it today in drivers/infiniband subsystem.
>=20
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-vyuEkX2Du0P4+RlNeXhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqA2QACgkQuCajMw5X
L91wjA//fa7NL931tqRP1mYIWGCY89zF/tWnzbCIcg/yvFAqZ8aBC7oUhvnDv5Zy
/am1dSmHrJE2YTqUVlVpTTboy6mUeNJAAMs+qM5YbQkd2xBmX2cLbaDIJfOFDmxS
SqzU5TJ7WQG3lChnk73lDikb09jJXbNsBevpxoK5FhCqXsyku5k5ipguWEwDitK/
1NsZfz1OTmDXEi7hourpuEEvvCZo0tnFo1HwFgsN13fnAVCwj7T+zTB465q7GteI
BPjMsuwJCmSsquALnHL1IdN3Q8BC+RIYf2GjmpSJk3oL6Vq92mKFjXrxOfMJuR6K
AjEIrCfLRQrlQ9/cFewNiTxhUZxvwmU2SrVw52MIhS2bOyXSC5GoIO+2ATXAmzjc
GmlTdMCgvdLMJZWavG/I7pw6xbVDysBqyqDTTMDNav72gjgDYq0rCc7euiKJdQV0
eMXJ8MwmHayl1uJt4gqKMNsdP1wWx2KJY/LYE6Kn3ojJtRrDiBjWv+rjxZcqV5DY
SkTi4cywYCTfciJy7XNtYnvd1Dj9fpO2ezPBlOteVkNEDG/dKoLosFc+H2Dj8sOS
aMiDFUDrp7ip1GU0Jdfr4aEW8RBgtrAhLSgY2K+8HPBHwHKxHj5y7hbyHZcwT4bK
suYXKzn5km0PTj2IEDMP1Rq6N2VxovNeNC6XcVqcvyUrdb9DET0=
=axGR
-----END PGP SIGNATURE-----

--=-vyuEkX2Du0P4+RlNeXhH--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
