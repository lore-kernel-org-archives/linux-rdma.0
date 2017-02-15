From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1] IB/cma: Add default RoCE TOS to CMA
 configfs
Date: Wed, 15 Feb 2017 10:11:32 -0500
Message-ID: <1487171492.86943.92.camel@redhat.com>
References: <20170214052152.16137-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0svOl24bhVtUAQShP90n"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214052152.16137-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0svOl24bhVtUAQShP90n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 07:21 +0200, Leon Romanovsky wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add new entry to the RDMA-CM configfs that allows users
> to select default TOS for RDMA-CM QPs.
>=20
> This is useful for users that want to control the TOS for legacy
> applications without changing their code.
>=20
> Application that sets the TOS explicitly using the rdma_set_option
> API will continue to work as expected, meaning overriding the
> configfs
> value.
>=20
> CC: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-0svOl24bhVtUAQShP90n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYpG+kAAoJELgmozMOVy/dHecP/iBG8IIzuF2d7zmrdG7v4JxP
9HPMXL4QqMXty/Wk1Jc3xW26V8TdZZnTR1gM11EzpVbkBZflyigm7MGCUr6kiqlo
9qkSrYxyt1qDiv3tbRCM3xq0SvNrlMzdLrn+i+LbLI/DlSwC9avItxfWneUbRxs6
SwJISwjr8XZUsC9+eV/B4VkuHvxZomE5T5dwEdfTZaBV+FCWkbIfC4shdR1Ck4YM
uFXAE3M3pQ+98a5uRuS+iKxvhIfsE5fes7D0ZKMDM9rKOYyxV3wCZDmyR8X61Q3u
daYTjtz/XL8PlR1cXNOcdDdWg0hE+GZ2sirqkLwxzOO8lU+6n6PEWv+8I80pkVkk
1MmzGdHLsYfZ6MuKo/zlnbc1XNk+XdfB9LDoP+FNTfEvQWAjIgoOC1kHdqmVRTb7
ziGVSINn+3BDosSOUSDrmSgMPvrsHGJhcpAa7kOqAwJaCEG8ekazCjU+jooDyN1t
LHBHFYjcL3jC4ydBj2Us+zgZbIywYqzix2bo8fb0qm40+mTws1WbLu+oehB8/qcK
Y45YyvfbRLq4i+e7b2hRw85IED2cNre4rydm+dH/X/3tPK4wMmJtoXxx1Cxtt6yE
qdEuuCgxCkWX4ftWw6SQA5oRT4YEbh3zkWIxcSshwuWjIgSp1xM+4+uEgBPd6+Z2
KSlzLOVp0wZ4pe4JfMRi
=3YKE
-----END PGP SIGNATURE-----

--=-0svOl24bhVtUAQShP90n--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
