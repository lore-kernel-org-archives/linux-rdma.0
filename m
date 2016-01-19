From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Initialize hop_limit when creating address
 handle
Date: Tue, 19 Jan 2016 15:56:55 -0500
Message-ID: <569EA317.9080500@redhat.com>
References: <1452786422-30212-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9kOQXdGroRtFiVVNIDadQKOKaOfEF4HI3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452786422-30212-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9kOQXdGroRtFiVVNIDadQKOKaOfEF4HI3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/14/2016 10:47 AM, Moni Shoua wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hop limit value wasn't copied from attributes  when ah was created.
> This may influence packets for unconnected services to get dropped in
> routers when endpoints are not in the same subnet.
>=20
> Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/ah.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/ml=
x4/ah.c
> index 86af713..4fdb241 100644
> --- a/drivers/infiniband/hw/mlx4/ah.c
> +++ b/drivers/infiniband/hw/mlx4/ah.c
> @@ -104,6 +104,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *p=
d, struct ib_ah_attr *ah_attr
>  	ah->av.eth.port_pd =3D cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_n=
um << 24));
>  	ah->av.eth.gid_index =3D mlx4_ib_gid_index_to_real_index(ibdev, ah_at=
tr->port_num, ah_attr->grh.sgid_index);
>  	ah->av.eth.vlan =3D cpu_to_be16(vlan_tag);
> +	ah->av.eth.hop_limit =3D ah_attr->grh.hop_limit;
>  	if (ah_attr->static_rate) {
>  		ah->av.eth.stat_rate =3D ah_attr->static_rate + MLX4_STAT_RATE_OFFSE=
T;
>  		while (ah->av.eth.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFS=
ET &&
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9kOQXdGroRtFiVVNIDadQKOKaOfEF4HI3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqMXAAoJELgmozMOVy/dbpAQALoZztmgCYBvQKJhbjETPxmN
OaoYlPo55oTU5RfuphtajTy7hcTo5dq4JFVuwgRBMgyF0Z88vxORydAw8ov8r2gp
cOGeG+Ubs0q9IFTqkgM8ben4gBMpkI1agcrIWCueshd+BdA8xrTvggYjMHItsDvo
NNidHIF28dTb0NsUrHNqr+mKiEaH4aGQYKAer5wGZWGqvvPdhmRO6hEkEUOT3+bR
9flrAOBYBX6bfpxmGM8DpTs6ozfvY5rQ2J3Q1FVI9V910Bbj4sI64M5bLM2z1mZL
QrwmI9Hv+37ghiZfNlhbk/LFRFiYK3eoezMT8DAm5Szj5Wjooeu09bmladHAY+C6
iejSnqEmQX22XqLhKHMCUPpXbdshipcUGGeUd8aTdgYHKmX1kq1OTXojQFxVcN33
B8sGM4+jQ+XYHkzJAZnGiTg6KXdHpA4sUjjhXW8dxykTnQ6PVGn58f0EjdNQ76yS
u63BaZSRe3ItYnfuJ2/oQixFVw8VaYGNEI/tyYsw3pV2BqcJ9hB6EYtatjwROeu2
VZna6HPcEtoEu8rgHo03ZAbaJ3s0q3Uq+YqCr7hSBqrrzPCX5p3AtyMUmLucT06I
DFNrcY9HC1TY7eQE831JfHS9pFKV+wZGg6Kx6ySptOqq4RQJmw9cnqJ1UX1wz6WN
83O86geSeyAkf6QVh76e
=qVFf
-----END PGP SIGNATURE-----

--9kOQXdGroRtFiVVNIDadQKOKaOfEF4HI3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
