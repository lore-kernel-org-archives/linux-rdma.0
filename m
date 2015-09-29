From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/38] IB/ehca: fix handling idr_alloc result
Date: Tue, 29 Sep 2015 14:23:36 -0400
Message-ID: <560AD728.30506@redhat.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
 <1442842450-29769-5-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JBs2Ge0CWoHPRDSCeghDptU31Wur4jqh1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442842450-29769-5-git-send-email-a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JBs2Ge0CWoHPRDSCeghDptU31Wur4jqh1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/21/2015 09:33 AM, Andrzej Hajda wrote:
> The function can return negative value.
>=20
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
>=20
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2038576
>=20
> Signed-off-by: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Patch looks fine to me.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/staging/rdma/ehca/ehca_cq.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/ehca/ehca_cq.c b/drivers/staging/rdma=
/ehca/ehca_cq.c
> index 9b68b17..ea1b5c1 100644
> --- a/drivers/staging/rdma/ehca/ehca_cq.c
> +++ b/drivers/staging/rdma/ehca/ehca_cq.c
> @@ -130,7 +130,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *devi=
ce,
>  	void *vpage;
>  	u32 counter;
>  	u64 rpage, cqx_fec, h_ret;
> -	int ipz_rc, i;
> +	int rc, i;
>  	unsigned long flags;
> =20
>  	if (attr->flags)
> @@ -170,16 +170,17 @@ struct ib_cq *ehca_create_cq(struct ib_device *de=
vice,
> =20
>  	idr_preload(GFP_KERNEL);
>  	write_lock_irqsave(&ehca_cq_idr_lock, flags);
> -	my_cq->token =3D idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOW=
AIT);
> +	rc =3D idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
>  	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
>  	idr_preload_end();
> =20
> -	if (my_cq->token < 0) {
> +	if (rc < 0) {
>  		cq =3D ERR_PTR(-ENOMEM);
>  		ehca_err(device, "Can't allocate new idr entry. device=3D%p",
>  			 device);
>  		goto create_cq_exit1;
>  	}
> +	my_cq->token =3D rc;
> =20
>  	/*
>  	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
> @@ -195,11 +196,11 @@ struct ib_cq *ehca_create_cq(struct ib_device *de=
vice,
>  		goto create_cq_exit2;
>  	}
> =20
> -	ipz_rc =3D ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
> +	rc =3D ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
>  				EHCA_PAGESIZE, sizeof(struct ehca_cqe), 0, 0);
> -	if (!ipz_rc) {
> +	if (!rc) {
>  		ehca_err(device, "ipz_queue_ctor() failed ipz_rc=3D%i device=3D%p",
> -			 ipz_rc, device);
> +			 rc, device);
>  		cq =3D ERR_PTR(-EINVAL);
>  		goto create_cq_exit3;
>  	}
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--JBs2Ge0CWoHPRDSCeghDptU31Wur4jqh1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCtcoAAoJELgmozMOVy/d/xkP/RSJADRmp6WMjMLQCTeKbV+P
5MZF8Hlbg/CbnRS5mSrAH/42rmJE8fEX/2u+bnGmtfuRy8L8KDdnLolomyDCxVYq
genZj/DJyyP98WguBAJR7N1BgUyHWaaNN3JOswgcLLR+NCP7nk39B8mHU1paeKtv
GiqOfI3PXJwm+TL1OljkO2xYdfyXjIjyTlNJivox+Ha0h7LWUMZNm/mxEkUFAtvw
EJJ6zB4I9VcycAIyw5wDiSQhxHfNiRMn8zn9kz3MokWstA5SOLIUBy7z8LvSts9q
2jHP5qnUqYKmWqnfA0Z3qPYZnQGbP3fvxgbTTHZFH+ldAj99VP5ul0adbVCM9UmP
Zd8DjkqGrOtsjQ8M2G/oe8EhwnLdUlwmX+awX6B5uF5lK14rulOuhcygq2pay55Y
Q2x0cNPCyG1IfQo9V8tb9Q2hfQBsVy1wEEIpciZ1ePBnrH2iVzJn1lvLaaP3MtXW
25awUFSLSccjTHxvkEZtNLpPb5m+nhjYZ8yviGbyWcTCmj+g3HT0xz++KmWFLHcS
wpr/Oi0WzJuZICN8RlOQEBSqVvwCa4wpt+z4BZDrqzzB+mgrirtNnwuy7cBn3M/M
4N8vwbbxNigPhHixetf+1YT4Ltk0Xq1zwtb1GEZUm92uALTczYOx2SA/yKQjU29K
lb4WSg03HLKOW234BMqD
=V40Q
-----END PGP SIGNATURE-----

--JBs2Ge0CWoHPRDSCeghDptU31Wur4jqh1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
