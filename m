From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2 1/1] RDMA/nes: Fix for incorrect recording of
 the MAC address
Date: Wed, 08 Jul 2015 18:35:20 -0400
Message-ID: <559DA5A8.1080602@redhat.com>
References: <20150702175229.GA12160@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2rJN0SC4F7NOi1tSVUrnmJxL81H7OjXwI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150702175229.GA12160@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2rJN0SC4F7NOi1tSVUrnmJxL81H7OjXwI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/02/2015 01:52 PM, Tatyana Nikolova wrote:
> Fix for incorrect recording of the MAC address
>=20
> Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/nes/nes_hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw=
/nes/nes_hw.c
> index 02120d3..4713dd7 100644
> --- a/drivers/infiniband/hw/nes/nes_hw.c
> +++ b/drivers/infiniband/hw/nes/nes_hw.c
> @@ -3861,7 +3861,7 @@ void nes_manage_arp_cache(struct net_device *netd=
ev, unsigned char *mac_addr,
>  				(((u32)mac_addr[2]) << 24) | (((u32)mac_addr[3]) << 16) |
>  				(((u32)mac_addr[4]) << 8)  | (u32)mac_addr[5]);
>  		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_HIGH_IDX] =3D cpu_to_le32(
> -				(((u32)mac_addr[0]) << 16) | (u32)mac_addr[1]);
> +				(((u32)mac_addr[0]) << 8) | (u32)mac_addr[1]);
>  	} else {
>  		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_ADDR_LOW_IDX] =3D 0;
>  		cqp_wqe->wqe_words[NES_CQP_ARP_WQE_MAC_HIGH_IDX] =3D 0;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2rJN0SC4F7NOi1tSVUrnmJxL81H7OjXwI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnaWoAAoJELgmozMOVy/d0aUP/jWcfEPDJ698Rgb280gGegL/
FZkEP+4O7M+xKAWVLxqNF9s/gLnhkMcm7gFSfM8s9CC2OmLYUVfz+za6xhk1iKwt
LFFufQ9PNuVAzjtMD67fGgf1iR1jsKwTdRsdZp7LrAbEHohixZ6ETgW3zc7HMLo3
hEOceQP9ie77e5TtUEJSAaxlTPH4vRdI1e32JMYkF/kVLK0PMNI5D5jKS78PN8Dk
yG36yNh75y95x/Nh28jKgTq1rB9wO+QBRdNrXi5ngl4lvqbEN4r9mydLzMdkQW7I
cGn3G9N3dtfFdS5F+BpU84ybPSE0oOovs/6o/N2GXKOKwgGzGYfLoVy6VPsJcuwG
U5QDi9e2kmFcGpW2HDqDc1Ty2Hh/j6nGxunM0DqYinlH3l085aWqToHm28gixc57
Xb1KV/hQNWVSUL5dXdN7Wi60y8ThsNrN29mOqV3lgL8qsmgY+jRDVDY+oeLm5al/
q0FjMKBBoKcIxicUzWW3ZkfE0wyDsibAkxL8luD6QNi0cqfpnLYrnq/sIgyaYKsL
2sR6gzP/h1e4r8FP1ImAbbjwmdBbgQcVra0o1sQS8+DBJW07If2+HPyWegIKvep3
QGCpV74BvFSW9oYtHcvdu1T9S/YFeh1vpCLgozS7CkLujbbq+n8x8m4OuQjJ/pXd
gRPwnBZdIVleJKSuoYN1
=Vhpf
-----END PGP SIGNATURE-----

--2rJN0SC4F7NOi1tSVUrnmJxL81H7OjXwI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
