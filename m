From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2] iw_cxgb4: gracefully handle unknown CQE status
 errors
Date: Tue, 28 Jul 2015 11:23:22 -0400
Message-ID: <55B79E6A.9040608@redhat.com>
References: <1437986294-6697-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1FUQ9KdOklggEfAxUxEBGc4vdAQIAHi7m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437986294-6697-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1FUQ9KdOklggEfAxUxEBGc4vdAQIAHi7m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/27/2015 04:38 AM, Hariprasad Shenai wrote:
> c4iw_poll_cq_on() shouldn't fail the poll operation just because
> the CQE status is unknown.  Rather, it should map this to the
> "fatal error" status and log the anomaly.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/c=
xgb4/cq.c
> index c7aab48..92d5183 100644
> --- a/drivers/infiniband/hw/cxgb4/cq.c
> +++ b/drivers/infiniband/hw/cxgb4/cq.c
> @@ -814,7 +814,7 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, st=
ruct ib_wc *wc)
>  			printk(KERN_ERR MOD
>  			       "Unexpected cqe_status 0x%x for QPID=3D0x%0x\n",
>  			       CQE_STATUS(&cqe), CQE_QPID(&cqe));
> -			ret =3D -EINVAL;
> +			wc->status =3D IB_WC_FATAL_ERR;
>  		}
>  	}
>  out:
>=20

Accepted for 4.2-rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1FUQ9KdOklggEfAxUxEBGc4vdAQIAHi7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt55qAAoJELgmozMOVy/dsuIP/RMyFkMc25ooojWBOa8s/058
JTi9fwKhnI970ojo1Bamzl8Le3cfgj2D+3Q0QmRUNQ6F1g4XP2+QmDmnMcRPPfBB
WQYakH8sggejgkZe54P2r3Yj6P67qW7nDkrKAYccz/y9yVnVcYp0tduguSiOTx0O
YmVnzqXnKUqXR/rw+laiEgQhfBSf5BmBx19kM3gENr2Tg091q19yB3nP/Le53Rv6
cjOzb0F55zMrh5K4nZb+BcGCsB3Q2dyOZPdmo/Oaz46D3Syk3qlXcR8cLGAWnU7A
I3P8fvSxmkjXspbHp0l/bQQNB2XDymxc0SnsAy/4c2QCYY/kUUOIAoTmR2E5I2zP
qegnMKKIcgy9+1XzuZhXKe8qiX+OCIzhESTyDTBWgjLgkxDspbv+Gs09kS7n5aRr
Z9riegW4tDfJhZBg72Y6zsPpYSvqCK0wknaP2F8Af6sg7Sd1SC4kZjDqImoU5F/9
1ZuFmAyZT3gDiID12MBQKAUxclwV90K6/hoGxZ5m+3vVwLINvecYcRFrIWYWu80p
AAfI08ShJjaki9QjIXE3fvMJ/ySYHZdauPtky5CEFvNldBEsDRulhM+TR0trswNo
5aC8N2dPo5i7NW6myFj6qb7WJgLEayGvAYoREueccXnVJxPVO4d4mRFDkYaRbzTi
SH//8a3xh2rCRL/Ut+EV
=kvQW
-----END PGP SIGNATURE-----

--1FUQ9KdOklggEfAxUxEBGc4vdAQIAHi7m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
