From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: fix mlx5_get_vector_affinity to start from
 completion vector 0
Date: Mon, 05 Feb 2018 10:23:32 -0500
Message-ID: <1517844212.3936.64.camel@redhat.com>
References: <20180205142452.7630-1-sagi@grimberg.me>
         <64670132-9662-9bbe-9979-fd02260a7fb3@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-eqCiGvhm+GzQWJrQMP4v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <64670132-9662-9bbe-9979-fd02260a7fb3-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-eqCiGvhm+GzQWJrQMP4v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-02-05 at 16:28 +0200, Sagi Grimberg wrote:
> Sorry, now my .gitaliases updated with Jason's correct email.

Jason prefers jgg-uk2M96/98Pc@public.gmane.org for his upstream work, so might need to
update again ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-eqCiGvhm+GzQWJrQMP4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4dvQACgkQuCajMw5X
L90pIBAAtFnn8HdRnmF6pAdoSx6FyMeSQadR2m6r97SY1YYCFVwXw8OanN0o3VMQ
ofDX4IkPIRKE37d18EpD4Renb0YQgfH4R8GAlsAyhyYFKAVDW33e1n+jpIrC0OOY
v2LH3fvv/F4ow29PCAQHZoWQn52WH55IH/ET5BUTXKy55OsQDT9fQnlWdjhmy32y
e1VbTELsv6GaejsBcYuJC60UIQOwa45/mmD6Ts0coHztUe9vStMimeBcPRe7bqlk
y2/QvUgnUdC7qolBWitbKPDeDRD32qDKCa1SCwhgqpTFq8ZbN9lPMuVAt01D1UQV
uNQ87TO0Zm9VZbUPmgLNpYm0mW9yQd7Ctuxkb66rTfzGqAfmBjOtCm6PhcgjPoF1
fbbHtNbDB0BUSP6bkNeT60BrNCuvzb4tyzggJYPJ8awbPYeFdoLFkqZU0CVhOfBl
m3VqN5/EUU7cyZNnRnEhDYBkhwU9+sNVW1y7aSoAdNVAqruUzT5ImaGG2na3Gt5M
bKIFcfoZXt+XGrxwhT1BicBCyU+VwujYFnXnFBFJCZje7eyFaYlEgEC3EJUEVHHG
XiAWzxb0GiQkMJeF39lsY3BSZqv0f9e6Z0wJnR5f3sb/B3pGa7jnfDh2hL5JvRmd
B8ZBPV4kR2PovDTQhib8vIycr+WQ/222CkHEXBsBt1wCWtC9Cvk=
=M+2/
-----END PGP SIGNATURE-----

--=-eqCiGvhm+GzQWJrQMP4v--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
