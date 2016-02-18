From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: Replace memset with eth_zero_addr
Date: Thu, 18 Feb 2016 12:31:50 -0500
Message-ID: <56C60006.3090401@redhat.com>
References: <20160212074610.GA19134@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P664kfBR2OPbwUkOISvdXB2X8OQimhlmn"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160212074610.GA19134@amitoj-Inspiron-3542>
Sender: linux-kernel-owner@vger.kernel.org
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P664kfBR2OPbwUkOISvdXB2X8OQimhlmn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/12/2016 2:46 AM, Amitoj Kaur Chawla wrote:
> Use eth_zero_addr to assign the zero address to the given address
> array instead of memset when second argument is address of zero.
>=20
> The Coccinelle semantic patch used to make this change is as follows:
>=20
> // <smpl>
> @eth_zero_addr@
> expression e;
> @@
>=20
> -memset(e,0x00,ETH_ALEN);
> +eth_zero_addr(e);
> // </smpl>
>=20
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>

Thanks, applied.

> ---
>  drivers/infiniband/core/sa_query.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/co=
re/sa_query.c
> index f334090..4b3ac76 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -1221,7 +1221,7 @@ static void ib_sa_path_rec_callback(struct ib_sa_=
query *sa_query,
>  		rec.net =3D NULL;
>  		rec.ifindex =3D 0;
>  		rec.gid_type =3D IB_GID_TYPE_IB;
> -		memset(rec.dmac, 0, ETH_ALEN);
> +		eth_zero_addr(rec.dmac);
>  		query->callback(status, &rec, query->context);
>  	} else
>  		query->callback(status, NULL, query->context);
>=20



--P664kfBR2OPbwUkOISvdXB2X8OQimhlmn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxgAGAAoJELgmozMOVy/d06cP/0o3kubDGA9Wuz6d2Ab/0vfz
Y3wnJ9B3oYZzBZ96tVCnypP4NppUCk2Wvf8SVJ8/XKkz8tLWJMoI5BAihefRxTIh
1zcdJkZAxAVsbeHbVLsMcF6ETYJAeAQP7vPjHGPeVeUCOcDTIkq6gYkMkksyh5rH
IZQQgHG6X0gkEefXIfJp+VhsiZYw4PC/QU5JB3i6FMcT2MR/tM5CaWTRkazrQ+Vq
LLzJZLvtGB3Cz/ccrMIpvvKJI9lM9PhoXneS6tCH+uHzxYFmlTNDQIpQ9XbhSg0j
M8lN3AYkGBZafxgWzGmRbq9zjr5WxjbWyewtXdXuS/f0jVwkaziLfFSHv9PB5ayZ
5Q/cMEIcy70Hl16scpHWY8Od8ZFGkslml6jzx6+dtoXPhzXzxzhrvdgHK1XX5cjP
72ghOi4i2ZBGdxitWFHzSLAWuP8jdV4IX4hGZFtcAfTPeBt+Ff/ZFi/jrDVlEHhL
QTxBgkZR0Ozty4LSEUmUpVmk006zB+XsFyc1Z/16WRjNyzUhISdpqNhFmln7Y8HT
M+Q6pMTJAHzB64k6sVPwo8gDGu3b5yDj2aaN27NT70bzPmkP+jUTuyS4lAacXZpL
k/5mCA+jSYfZx8ARr5PHd3yFT9XeXI+dhge4QouzK6Lf0/017gQXjZVcqX4nW6xy
zni+MSqgNPdSSnkLKDtI
=Y/KC
-----END PGP SIGNATURE-----

--P664kfBR2OPbwUkOISvdXB2X8OQimhlmn--
