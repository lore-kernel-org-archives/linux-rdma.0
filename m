From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Fix message typo
Date: Wed, 23 Dec 2015 11:12:44 -0500
Message-ID: <567AC7FC.9010506@redhat.com>
References: <1449686539-29959-3-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D7cXup8luuDeClmUoNTp52XJveCo5L6sc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-3-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D7cXup8luuDeClmUoNTp52XJveCo5L6sc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:42 PM, Nelson Escobar wrote:
> Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/in=
finiband/hw/usnic/usnic_ib_qp_grp.c
> index fcea3a2..b306870 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> @@ -521,7 +521,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *=
qp_grp,
> =20
>  	if (!status) {
>  		qp_grp->state =3D new_state;
> -		usnic_info("Transistioned %u from %s to %s",
> +		usnic_info("Transitioned %u from %s to %s",
>  		qp_grp->grp_id,
>  		usnic_ib_qp_grp_state_to_string(old_state),
>  		usnic_ib_qp_grp_state_to_string(new_state));
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--D7cXup8luuDeClmUoNTp52XJveCo5L6sc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesf8AAoJELgmozMOVy/dH24P+wdJToq5Svs9qPyYZQWFFbSF
lN8Bu7ytgJaofEyY+jvicVZ+6cLK16FPXaV10zwGPG8UiIvhSJcjM+epM+uF/IkH
2AYISU+y/S9RFkB0VYkgg2RnZFeEYC3f2aT+AzH8/sezfXPW/c9AayqPoIMQD5yu
jvSSuDVMCtRXznZDsucy5dRp3SYO2LTiYktcaVuM+vTtxTSYsmuBojfZ4HgPZ4kG
VG8sxEmNtn6ddXtVpKemrZ6OI8jxvsIMkNhlPiwPSu1lNgTmAEgxWwKAI+9hUUxG
VsQzmUCy0y0sk4FB3eE1YjQslO+dRaMj867PRn4XtcKrTA8JiQf00YdDTS/F5fQN
BMvRZHFghgi3hH668zGWxDlbo7D3jjsnkedk+biYT5xINGH4h/WiLbCls0mmorxZ
3h9WyONmCNAKpXOm2bE/Br1pYUy/rSQLHUV3uqYsimt254IsNfV9KDVODHtkAlif
+9V3VsoOCYWrfIL4zCI3KWypc98w8JB/3DnRS/8/R7tDQIGZpJS7jjF01oL+7xHe
gTkZBRAqB4U6UtKfZLLPrUnH3tR7kfqIwNgb3Xej0A4YAmUz0WSa/qg+ShYqdvOl
tntHrnTFoKOlBkx8qDcsSuXLTfSESAtlKJSZQGKhjnjowr08EBDrljq+4JmbW7yP
iB1GXZA0uGJmP2xc7e80
=4YjJ
-----END PGP SIGNATURE-----

--D7cXup8luuDeClmUoNTp52XJveCo5L6sc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
