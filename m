From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Remove unused vlan_tag variable
Date: Mon, 13 Nov 2017 13:53:42 -0500
Message-ID: <1510599222.3735.22.camel@redhat.com>
References: <20171029150522.23641-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9ATYEIEYVzs0NtJM+DhQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029150522.23641-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-9ATYEIEYVzs0NtJM+DhQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-10-29 at 17:05 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The Broadcom driver produces the following compilation warning
>=20
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:
>         In function =E2=80=98bnxt_re_create_ah=E2=80=99:
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:668:6:
>         warning: variable =E2=80=98vlan_tag=E2=80=99 set but not used [-W=
unused-but-set-variable]
>         u16 vlan_tag;
>=20
> Let's remove it till vlan_tag will be implemented properly.
>=20
> Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-9ATYEIEYVzs0NtJM+DhQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ6jYACgkQuCajMw5X
L92ggBAAgSS8f94Tgx2ysuiH6VYBKQMvHGLwEvMRF5pZ7A1Fc/rgbU6ALxGmNaK5
MDmfZv8bWjLJ3FUSe2ot9d6f+38XCsNex1PpTSF+nDRqq4dK9lWsinDCcYeBPECy
johh1YCoIJsGUt+IKsH60HcBdoZ5uL8l9O+LwODfkTos02NVQ3QRs7h9U6ImqT/O
977RYyruTJIo2UW1VWIHqPny0ju30G1akRnexB8BMJIWXIqv/oaimJT4D0GrBw49
GhFTqaRH/Fny+NpbWuoQOuFVfaEFej3cBP5VXmJ2mMItA5ipBcRAEibrcbx/UYTY
jbO/UYngyA9K2ZbucIUMfjVKy7ghvf/bnp2mBoF90JykTOnucNiRQ4hAyPoTz6XL
zIh3Knnu2555Iv8VeD4yBr2qaLx3hlUD6usC3h4Q4JQgkJpcfY0+XAZnpW/51OtC
GRhOb1+uUtRkCojc9zbC//vJZDZTceKwk300hfFvMbK3aihGtdmXN8+SrFWa/R6i
F/y7M7pYY64t5VFg3NsWQPFsAKQ/islzx6eKi+UoC4cLkc6RSJIdEoPTEz8xmU/7
GZWWNNtG9FVFBWzmeYd376U5evo+kA4vrLoVaaGxArSmyMEXawqgMg32e2CiwnpQ
LbS0Hs1C08IV5rmX2suGq1ehbLG3OPyi/XGpXeJM9V4uhRxJU6g=
=mRBx
-----END PGP SIGNATURE-----

--=-9ATYEIEYVzs0NtJM+DhQ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
