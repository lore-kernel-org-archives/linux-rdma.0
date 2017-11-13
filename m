From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] bnxt_re: fix a crash in qp error event processing
Date: Mon, 13 Nov 2017 15:13:39 -0500
Message-ID: <1510604019.3735.30.camel@redhat.com>
References: <20171031092917.18933-1-sriharsha.basavapatna@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Klw7jP/3hV4Gv6DinMXc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171031092917.18933-1-sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Klw7jP/3hV4Gv6DinMXc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-10-31 at 14:59 +0530, Sriharsha Basavapatna wrote:
> In bnxt_qplib_process_qp_event(), for qp error events we look up the
> qp-handle and pass it for further processing. But we don't check if the
> handle is NULL. This could lead to a crash in the called functions when
> that qp-handle is dereferenced, if the qp is destroyed in the meantime.
> Fix this by checking for a valid qp-handle in that function.
>=20
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Klw7jP/3hV4Gv6DinMXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ/PMACgkQuCajMw5X
L902aA/6A25Q3/lwcgEFIrTt0AEjp03h1C2eizvGOAYURKI5axHd10cEAo0S135Y
2/o0ICZCebU2mpZcheTqOYh574unbUk79YtBYUeJHdRLUqdK4HyM58viQp45CX8w
z3I5z3WJCDvL2NrUwAAikMo9Fv4MrbUKymY/EsaQTI5EKEFqCOU+TbWLV3K3ZkMI
+pnprkNHVOGpQHvGCKCXNOUrJ/a1JHKIVyqF8HJ7Z/Y8zmYP/JWhIrhrQLHVwC+V
LPQPODnu+hJ1lSKHeXb4RcPZVN4DIEw4uYLwQ/uef+p2+sncJLc6IQkpRFkid3Ni
0yHFnl7jLR84PCCMj2QfW8CCTtLw6iq7BVKqXuJaEFa9d1vyjvkvIWoPYDg0GWdg
DWLCbw6qoGgqu1oyPcUi6RVsgqmBQ3qLoRYbfu4wT7oVQVxxYw7bhDRFn4ogaBTj
D6bgyQBwICZ4j8k81WGVlhyZ57waqqFH8WtTlH/fC+aveBGd0VHbXSQwPpVaK9O4
aFawb1PLXXHhrk949FVByCJbB0NIQlUN/4SmCqQQ9e3mdkKkFAv9O7iVTinCDNs1
xr/c5VvrIqGxwHdJrRZ0wJBQVbxko3Hs2QgDChAqC8sSwbQuhXF+oOa7MK+pB3UU
njHYRy0cHSEtllnhsacWgkDJO4BgaSn2TA5xInTWstSzoXjyaT0=
=aHuD
-----END PGP SIGNATURE-----

--=-Klw7jP/3hV4Gv6DinMXc--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
