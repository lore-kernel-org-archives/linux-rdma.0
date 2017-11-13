From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] bnxt_re: Bug fixes
Date: Mon, 13 Nov 2017 15:55:37 -0500
Message-ID: <1510606537.3735.34.camel@redhat.com>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FdDm7m2C45Erb4tD5GaR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509984452-18336-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FdDm7m2C45Erb4tD5GaR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-06 at 08:07 -0800, Selvin Xavier wrote:
> Includes few bug fixes for bnxt_re. Adds memory barriers before
> processing the HW completions and fixes race conditoins
> in QP destroy path.
>=20
> Doug,
>  Please apply.
>=20
> Thanks,
> Selvin Xavier

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-FdDm7m2C45Erb4tD5GaR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKBskACgkQuCajMw5X
L917+A//eJ+7XHRufQls5jEW2EVH1MfFB73+fT0g8J3T5vN7xoZs0OyVtWWmP2ou
T0NaqBOz6lvoolLPl7uLW8hXHhmcZpdwZmqEgqMRU0GNp0hgZBpOBDZIbz2kevcS
Pzc43mpg94aaN379l5T/2Vr3zqWtz00hN5qfQpMKqaxa4MZ6K3PjAX7Ln1QTiPa+
X6C3q0QezVhEv0rkApLXxg+yQHIhR7XrOPlZlSrjqvcX8vGR+7jDL8TyfevCr8/U
D92pXp4hGRNdWEBZsovU8PaUr1I04hRSuszq+WaefrVoHMlPPCpMbnSkXi/IsOq2
5/p1ZdoCsuRO9rlXqpGt3h887iu7DC80pkvo/Om8bjeLTzSMpZRCDg3AR1ecrHkf
mS/KLhlHKEFVj1kfbwzl3EF4k8bCBcqB2nII6IF+sDfl3izOZ+HpJXc55NLyDq9+
cLpAXoHmOGATIx1VcGVcWVRQ3KI+CXUcM8inKwU0Saai3SFztAJOBKelXrH9mY20
eYS+GexuCBJqf4YKMaq8gwbt5YskXw9sXkGATxYk6WO19rPi5a5MSTxWzxt0x3+O
JCh2tOMyIEg9ZcoJ8gnNvsGWy+XkLqvHa4CdYKKBI4cNvNnbdI8dbhIAP74ZyYLd
KZUG1e8/j70S0VNonbtC5sJHYBy3Z0j7H0fkKr6DJfLn2ggZIJM=
=qPXc
-----END PGP SIGNATURE-----

--=-FdDm7m2C45Erb4tD5GaR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
