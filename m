From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND PATCH 1/1] rdma_cm: fail iwarp accepts w/o connection
 params
Date: Wed, 22 Feb 2017 15:36:13 -0500
Message-ID: <1487795773.86943.120.camel@redhat.com>
References: <20170221194805.03181E0BEF@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CC42XxlidTPmvA4dC6FY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221194805.03181E0BEF-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-CC42XxlidTPmvA4dC6FY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-21 at 11:21 -0800, Steve Wise wrote:
> cma_accept_iw() needs to return an error if conn_params is NULL.
> Since this is coming from user space, we can crash.
>=20
> Reported-by: Shaobo He <shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>
> Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-CC42XxlidTPmvA4dC6FY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYrfY9AAoJELgmozMOVy/dqWYQAJdaYnDH4XTJWGh6uJxfhBdW
wkDfVLuXigGo54lDVCNVh0HFdg1RF/L3EzVDsuIzoCrCi3OoMEwgL+taPdrP5KGZ
Nwa64C31qnsfFbYpY5ttjYRb+G9fKiAvMvND26VhVRaxDWkJnmWyQ2ADKiy/ZZQw
xRmojoWTHPGfsyOefWLs7YRNSrvzgO3ig5aj0pFBmyT4x6+F/cqgJS58LF4Tfa+c
CiwjJs1mRBnMqJH3yL6WJEK1A/YfHJuCdCiMwIxXor1DKori8/NfI0btHobaRljr
QTqp7rj8APl6KP+c6c/WhENIbeka/kYfonh6ePECkIXxCFQbOqqmXO81tUv5Iok+
o8AgMMmPrwKxZI0dEeYILm/Ww/ceCQvNKd3Ppa5cr8a9iyI0Ib3MG/bU6MQDWxN/
nrof11wB5gnZ8NNECvVX7Gcw5ux5aU1nXpRzg529iWDz6OkuBNt1tyzKFgG9fusi
gfKSwfgYANgYUsVZnmxffc2Sgz7XtXysydhrURzkalzBrh4re+DGMJkwUYj6GuW6
+D43ufuuMnDNpFZmjVLT/KEvlDG0GYDIBGwdKtqj67ApfSDjyHj7hGAW/IQAxEs7
megIS5bUueWlocB9hNaBpVAKzqJalaDFKvL2WfEWVbPWx+Rv0SKuvY+pFSSHmNEm
T0TQ9Vsj9ulQFPoixBft
=IOTE
-----END PGP SIGNATURE-----

--=-CC42XxlidTPmvA4dC6FY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
