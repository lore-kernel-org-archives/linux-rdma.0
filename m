From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Mon, 13 Nov 2017 16:19:21 -0500
Message-ID: <1510607961.3735.39.camel@redhat.com>
References: <20171106194847.GA5038@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/1R1NbctgHFlLOKfRZuO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106194847.GA5038-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-/1R1NbctgHFlLOKfRZuO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-06 at 11:48 -0800, Bryan Tan wrote:
> Add the required functions needed to support SRQs. Currently, kernel
> clients are not supported. SRQs will only be available in userspace.
>=20
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-/1R1NbctgHFlLOKfRZuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKDFkACgkQuCajMw5X
L92ClxAApy/19GbzpjjTkDMpcbUCClEU+RAsfhAU5SifvaD/06NAyQ9JcBhjsrHv
dGSGUf7hQqbaG727Oy6lPFJzZvHj5zYBTWtgehPuRQAjCewnIeMv3TVl+3uL7+iU
MpawRWzPBjo9yIBV/4AKpreGbbPhcbi2ejp+QGNkWKm5E/S2McESy/jUv9kRue3S
wAMb4kCDFi8hhUxpvlxHFiFqT0banPE31Q2Mk0fQKUyQ+MIixClHW2U8MO1GRjh7
qS/aVsbQh1w+LL9WN/pJkIKM8lkTQ8xJw3SpJZ1siQw8pzLoU8yIxnKNqv+TL4Kh
k3T/Eod/L+rQw5xDeE8JTYH8w9oGuQhCef17xeXLLTCE0rJtiq+MLZ3uiod1JLbn
tXKRAm/bCB4uETE/C4QH0rJlG2sIUJ4vaHwQBcQWhFiJOB759S1kzwDx/gLxf5Qb
Eg90aXVfdCUuZct8+C7rQCnU/O4mV7IzE2LUoEeUWqeKJ+UyBiSpShcOY2Bo5tAw
/mggZq/dAkMRHWZs1GvbRg7H1JsZivqQ0BDnHBIcFMlClzkMvvXNgTI+YyIoUTdo
cEt/qIiLvRosHWLkPa321MOBcq/LIEIkKPSNOwCOaxNxJmeGoDLlKn7J2bXTyBN4
6bq+qnMQjukgYaqKCt4scJCwBtHE3jPkwfzE3YGlmtum9bdLdFM=
=uRpL
-----END PGP SIGNATURE-----

--=-/1R1NbctgHFlLOKfRZuO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
