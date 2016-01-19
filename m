From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: Replace memset with eth_zero_addr
Date: Tue, 19 Jan 2016 15:44:29 -0500
Message-ID: <569EA02D.4050604@redhat.com>
References: <1453212390-6478-1-git-send-email-tanure@linux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wB6XGV5lU39Iw3COJQujxXUmtVgOjelL2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453212390-6478-1-git-send-email-tanure-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lucas Tanure <tanure-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wB6XGV5lU39Iw3COJQujxXUmtVgOjelL2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/19/2016 09:06 AM, Lucas Tanure wrote:
> Use eth_zero_addr to assign the zero address to the given address
> array instead of memset when second argument is address of zero.
>=20
> Signed-off-by: Lucas Tanure <tanure-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/ah.c       | 2 +-
>  drivers/infiniband/hw/nes/nes_utils.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/ml=
x4/ah.c
> index 86af713..44d4164 100644
> --- a/drivers/infiniband/hw/mlx4/ah.c
> +++ b/drivers/infiniband/hw/mlx4/ah.c
> @@ -92,7 +92,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd,=
 struct ib_ah_attr *ah_attr
>  				ah_attr->grh.sgid_index, &sgid, &gid_attr);
>  	if (ret)
>  		return ERR_PTR(ret);
> -	memset(ah->av.eth.s_mac, 0, ETH_ALEN);
> +	eth_zero_addr(ah->av.eth.s_mac);
>  	if (gid_attr.ndev) {
>  		if (is_vlan_dev(gid_attr.ndev))
>  			vlan_tag =3D vlan_dev_vlan_id(gid_attr.ndev);
> diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband=
/hw/nes/nes_utils.c
> index 2042c0f..6d3a169 100644
> --- a/drivers/infiniband/hw/nes/nes_utils.c
> +++ b/drivers/infiniband/hw/nes/nes_utils.c
> @@ -727,7 +727,7 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip=
_addr, u8 *mac_addr, u32 acti
>  	if (action =3D=3D NES_ARP_DELETE) {
>  		nes_debug(NES_DBG_NETDEV, "DELETE, arp_index=3D%d\n", arp_index);
>  		nesadapter->arp_table[arp_index].ip_addr =3D 0;
> -		memset(nesadapter->arp_table[arp_index].mac_addr, 0x00, ETH_ALEN);
> +		eth_zero_addr(nesadapter->arp_table[arp_index].mac_addr);
>  		nes_free_resource(nesadapter, nesadapter->allocated_arps, arp_index)=
;
>  		return arp_index;
>  	}
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wB6XGV5lU39Iw3COJQujxXUmtVgOjelL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqAtAAoJELgmozMOVy/dCn0QALEB3Z7JEFkWtpLsIq73oSSN
h3h/xvLxGh+w0X4EBl8bx1bUXqK/0pCFXWjGXJWrSqgaNPql6RhzW8ZP/s9Eiizr
Rf9keGNsf1WF49wooy7iEm23ZjwoIkTfLvjdeR+qhuv9N3vaIrYGdU8OrR4DgpcM
P1aGrjXTeCJZy45zC8hdY1b69nZiPd48ILQ5vtKowwGzCjbxCsVmxW3Ccii5gF6u
Z/0qF1HNUrcmdXTtCqcNlF45YHQTGU1XhZnHa3tQ1rSm52fT9pksUkVt5dlST3YA
gh2t7kZdFV6se89q/sQbnQQzSM47O0jKVzZxXrLJ8orw8nOtk+hg2wZGTjLnh2jh
LYLWpHzujRd9leUE5582221rGXmYmTysWQeW6P2EDI/THzUipIPtkQE742ttvdOb
W/ihJFYl6Io76ewc7qrxpSC9XtE8cEfv7NxjoreJt5uwxc9R4pAjXGzN92/69RHC
bTmr/CDjwatvWb9Ft+96RnV0n2XClsdcIuTEE+oft6hkYJOVdfsoUW4aFYR2oSud
gKQXfPWNZ+YXa5K6Q3A/kvGbdbQCk3kU8sy6D8riZwGXhAr3hrqn83yqfyIu9cdD
Fjpxhw6JzwJj5fT3nFoDXcT7K2IKfzvAqLYUmHjbuKS7nC+Y3AVBYeMjYD4xD5ov
tnVDmTO4bIfbVQnqoP47
=UshE
-----END PGP SIGNATURE-----

--wB6XGV5lU39Iw3COJQujxXUmtVgOjelL2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
