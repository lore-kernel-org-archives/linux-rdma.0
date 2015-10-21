From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cxgb4: re-fix 32-bit build warning
Date: Wed, 21 Oct 2015 16:57:17 -0400
Message-ID: <5627FC2D.9000402@redhat.com>
References: <13543971.LQ3Q8CCxhL@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kwC3HlA7KuVmJvABoM7TahqkWXhhb5L7m"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13543971.LQ3Q8CCxhL@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Steve Wise <swise@chelsio.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kwC3HlA7KuVmJvABoM7TahqkWXhhb5L7m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/07/2015 08:10 AM, Arnd Bergmann wrote:
> Casting a pointer to __be64 produces a warning on 32-bit architectures:=

>=20
> drivers/infiniband/hw/cxgb4/mem.c:147:20: warning: cast from pointer to=
 integer of different size [-Wpointer-to-int-cast]
>     req->wr.wr_lo =3D (__force __be64)&wr_wait;
>=20
> This was fixed at least twice for this driver in different places,
> and accidentally reverted once more. This puts the correct version
> back in place.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 6198dd8d7a6a7 ("iw_cxgb4: 32b platform fixes")

Thanks, applied.

>=20
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/=
cxgb4/mem.c
> index 026b91ebd5e2..140415d31bcc 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -144,7 +144,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev =
*rdev, u32 addr, u32 len,
>  		if (i =3D=3D (num_wqe-1)) {
>  			req->wr.wr_hi =3D cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR) |
>  						    FW_WR_COMPL_F);
> -			req->wr.wr_lo =3D (__force __be64)&wr_wait;
> +			req->wr.wr_lo =3D (__force __be64)(unsigned long)&wr_wait;
>  		} else
>  			req->wr.wr_hi =3D cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR));
>  		req->wr.wr_mid =3D cpu_to_be32(
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--kwC3HlA7KuVmJvABoM7TahqkWXhhb5L7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ/wtAAoJELgmozMOVy/dVvoP/RyKubhXfUWdxucRnAty7RyR
IjZrQ62KdSvh9IVHdjWWO2YvYIiPfYkuJ3ddFo+ua83WATL4t+7/og1j9s1bc79b
JluT7BuoapocnPVwyEZUY20rabMl1OhAG2876vzub4KtyqmhYqnoEj4LEFaY/1Qa
z1veyCU1rl+CCFZaP3TY7hBHVL9an+tm4pp3KEy++NKfNzBacp1zK06ojcjW9VrR
VbTXBuIyc9hPZgJMTQRXMfCt4IIQmc6tuhtjN0oq2tkn1EtmK9IERstwPbyGVBVl
yz5+QLygllvONNQCkWisvS9OzDSSaZ8lk/joo4evpI4yjhq7ThFlSrRzqcbPHsNc
SYi5tdv1jtuK2NVmKTZEBpxvmvI0x/B48Hk/+y0cNsYu5evJwa1q3PaRScjhOqzE
9bL+3RIAa95+oB69ANF/tOJsCxgW7uwRQCG7d03RrRZ1xW5OiVQ/9C2n5qVMvNCN
6qlGPItMjJxPqST093LDOc2Mm1ABjFtEuinG5T41R4F7oPjqdgHM+eFhfLLsGIqC
RA72rTcaGZZ4Gim6GLUxfVvFWUWj7r6oArOSTsm3DB51/K47dPslDkKy0R9+TgMk
FiQ5XdOzjw1sE5vXj/SXY+gLSMZ+mImau0DodnUcHWpTIRmhB0SGcvfTyVn5/YE1
ve58/NHF+nLJokNeULzL
=2upm
-----END PGP SIGNATURE-----

--kwC3HlA7KuVmJvABoM7TahqkWXhhb5L7m--
