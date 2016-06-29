From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iw_cxgb4-4.8] RDMA/iw_cxgb4: Use kfree_skb instead of
 kfree
Date: Wed, 29 Jun 2016 13:48:09 +0300
Message-ID: <20160629104809.GB4750@leon.nu>
References: <1467189584-9812-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467189584-9812-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2016 at 02:09:44PM +0530, Hariprasad Shenai wrote:
> The commit 0f8ab0b6e91b4d53 ("RDMA/iw_cxgb4: Low resource fixes for Memory
> registration") from Jun 10, 2016, leads to the following static checker
> warning:
>=20
>         drivers/infiniband/hw/cxgb4/mem.c:612 c4iw_alloc_mw()
>         error: use kfree_skb() here instead of kfree(mhp->dereg_skb)
>=20
> Also fixes skb leak in c4iw_dealloc_mw
>=20
> Fixes: 0f8ab0b6e91b4d53 ("RDMA/iw_cxgb4: Low resource fixes for Memory re=
gistration")
>=20
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/mem.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cx=
gb4/mem.c
> index 5d0aa55e82d4..3a4e6fba3010 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -603,16 +603,13 @@ struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum =
ib_mw_type type,
> =20
>  	mhp->dereg_skb =3D alloc_skb(SGE_MAX_WR_LEN, GFP_KERNEL);
>  	if (!mhp->dereg_skb) {
> -		kfree(mhp);
> -		return ERR_PTR(-ENOMEM);
> +		ret =3D -ENOMEM;
> +		goto free_mhp;
>  	}
> =20
>  	ret =3D allocate_window(&rhp->rdev, &stag, php->pdid);
> -	if (ret) {
> -		kfree(mhp->dereg_skb);
> -		kfree(mhp);
> -		return ERR_PTR(ret);
> -	}
> +	if (ret)
> +		goto free_skb;
>  	mhp->rhp =3D rhp;
>  	mhp->attr.pdid =3D php->pdid;
>  	mhp->attr.type =3D FW_RI_STAG_MW;
> @@ -620,13 +617,19 @@ struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum =
ib_mw_type type,
>  	mmid =3D (stag) >> 8;
>  	mhp->ibmw.rkey =3D stag;
>  	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
> -		deallocate_window(&rhp->rdev, mhp->attr.stag, mhp->dereg_skb);
> -		kfree(mhp->dereg_skb);
> -		kfree(mhp);
> -		return ERR_PTR(-ENOMEM);
> +		ret =3D -ENOMEM;
> +		goto dealloc_win;
>  	}
>  	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
>  	return &(mhp->ibmw);
> +
> +dealloc_win:
> +	deallocate_window(&rhp->rdev, mhp->attr.stag, mhp->dereg_skb);
> +free_skb:
> +	kfree_skb(mhp->dereg_skb);
> +free_mhp:
> +	kfree(mhp);
> +	return ERR_PTR(ret);
>  }
> =20
>  int c4iw_dealloc_mw(struct ib_mw *mw)
> @@ -640,6 +643,8 @@ int c4iw_dealloc_mw(struct ib_mw *mw)
>  	mmid =3D (mw->rkey) >> 8;
>  	remove_handle(rhp, &rhp->mmidr, mmid);
>  	deallocate_window(&rhp->rdev, mhp->attr.stag, mhp->dereg_skb);
> +	if (mhp->dereg_skb)
> +		kfree_skb(mhp->dereg_skb);

You don't need to check existence of mhp->dereg_skb.
kfree_skb will check it by itself.

net/core/skbuff.c:
695 void kfree_skb(struct sk_buff *skb)
696 {
697         if (unlikely(!skb))
698                 return;

>  	kfree(mhp);
>  	PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __func__, mw, mmid, mhp);
>  	return 0;
> --=20
> 2.3.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXc6dpAAoJEORje4g2clinC2QP/1zUgtLU0HQU0wY5xi9A80+R
6i33u9hrVmk2ivGqG/zdc/Xj14ac2At1DosizfmYcN+aeMLvzR3S5cVPO0twiMO4
yO19TU6uB/LGKQzfBEdaKSLUUI+U8PfP/491876gs9njU9ZAjiQLGmcyC7u8tQ6Q
ylR5mVesbhec9P/OzrC8bpOe2C6NqLLQ15x8Tc453DPjIF25dTpP5TP5iJtqeumA
/TSKMMtC7jgcp4JdWNdQXVUUuj2SUdE54jol3g1QNm46NOiVegmmbhTbxNqz4241
evk6LCZu+KVQjEzow6vm5P1qud2M9TVfUlhfCERaDit74/H46zUbm0MJH3/g2w/m
Y6tJzrlC/X3AHF+zcMoTlJAu8ZAATmH8Co5+4vkSO2pUyFShEZgJ0yqeqTC0zMSq
GMgm9aIV3xXtItGDx9BFL2dMGuceLEW2IdMALiJWH1efW94pmlvWjU1kHji27CaV
3TSN5Kkv2GlIEVOYTxgpQ0H25KlxDcCDqJKlw1KXULzPmKHlL/lISjD2Dh8SofId
JKly9LTA/Dp/K2sqxVQaLIold9HuJJQFJczx3tcFwm7l6BH7tw78Z7lwj8fsy0X+
1vdNbo2aGl9tBn1KAw4kRwacG2bJFc6PYxyNDlt6Mr5laFN2wHQDDaqd70B19HX5
VEvTBWiWI9X95pE/xWx+
=dq8T
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
