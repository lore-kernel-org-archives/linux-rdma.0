From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Support more QP state transitions
Date: Wed, 23 Dec 2015 11:13:49 -0500
Message-ID: <567AC83D.1000603@redhat.com>
References: <1449686539-29959-4-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nCt1pllbSJC6f5KwcXTtdQkfwt1OSf0ow"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-4-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nCt1pllbSJC6f5KwcXTtdQkfwt1OSf0ow
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:42 PM, Nelson Escobar wrote:
> They were already implemented at a lower layer, but the upper level
> routine placed arbitrary restrictions on which transitions were
> permitted.  Simplify the state machine logic to live wholly in
> usnic_ib_qp_grp_modify.
>=20
> Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/inf=
iniband/hw/usnic/usnic_ib_verbs.c
> index 5ae6569..111afd5 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -571,20 +571,20 @@ int usnic_ib_modify_qp(struct ib_qp *ibqp, struct=
 ib_qp_attr *attr,
> =20
>  	qp_grp =3D to_uqp_grp(ibqp);
> =20
> -	/* TODO: Future Support All States */
>  	mutex_lock(&qp_grp->vf->pf->usdev_lock);
> -	if ((attr_mask & IB_QP_STATE) && attr->qp_state =3D=3D IB_QPS_INIT) {=

> -		status =3D usnic_ib_qp_grp_modify(qp_grp, IB_QPS_INIT, NULL);
> -	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state =3D=3D IB_QPS_=
RTR) {
> -		status =3D usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTR, NULL);
> -	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state =3D=3D IB_QPS_=
RTS) {
> -		status =3D usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTS, NULL);
> +	if ((attr_mask & IB_QP_PORT) && attr->port_num !=3D 1) {
> +		/* usnic devices only have one port */
> +		status =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +	if (attr_mask & IB_QP_STATE) {
> +		status =3D usnic_ib_qp_grp_modify(qp_grp, attr->qp_state, NULL);
>  	} else {
> -		usnic_err("Unexpected combination mask: %u state: %u\n",
> -				attr_mask & IB_QP_STATE, attr->qp_state);
> +		usnic_err("Unhandled request, attr_mask=3D0x%x\n", attr_mask);
>  		status =3D -EINVAL;
>  	}
> =20
> +out_unlock:
>  	mutex_unlock(&qp_grp->vf->pf->usdev_lock);
>  	return status;
>  }
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nCt1pllbSJC6f5KwcXTtdQkfwt1OSf0ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesg9AAoJELgmozMOVy/dTO0P+wftQ7Q/SeE4e8ojaUO0uNk0
z+Aw1gtl+3oBGhjSxbokvo+xOT7XvYh0iRZGcYTSybDe80IY4fsTxd5g3ClDfPq1
TprVrMZndWkzqM4ktmRCrqRY3CAWjjtbzmxMi/lnYeavXhlQ0tOwmDCyP4ILSWbG
F3ISw/Ax2NXAcI76DNlk6veM+ipL8lV1z+M4LIQegqopQ+pMrteRh75VgBdp2ot2
LGjG9tsR8sQDNlC0UWLu1gjQaMGbjbh7AoG//BXIxLF0qaCo4+oPWisAyFhp/cZ/
Q5ZVCtAeYpMEQthVf4DbVFexzc7qXgUQ90cxACRFZZhbV7dUGNbdKRGPmitAZDZE
SY8Yf4Z4FR30H06Axn9qG/wBqyyVsviVbHorVYSXxtUOoS0J7/8PpYTUFbdZsmhO
oAAU1jZrV1MD/sOS6dZR18EnWjnZ3R3TJlABATkFCFImZvC42YWjPoMT+Yoj3oea
h/K4WAAGWGBqy8LctyRw8xOLWB0iHgCK8jH5ENGeVRp1Vn+POI3Jo4GlsZvaD8Dq
5E2wwL1gHTNu1SuTMtn/uPkahRMbxyCPYldF6/NWm7Xv2ry3kN+zvW7/MgIubT6i
OyhInGHetOLgmzND/nD7LadLk1NnHmUBF3iWhVrLIwfT9MacyGPagoM72FStbtTu
2SwOLtAy6nmAZiKBPuzv
=eycH
-----END PGP SIGNATURE-----

--nCt1pllbSJC6f5KwcXTtdQkfwt1OSf0ow--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
