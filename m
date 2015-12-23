From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Fix resource leak in error case
Date: Wed, 23 Dec 2015 11:14:22 -0500
Message-ID: <567AC85E.9070704@redhat.com>
References: <1449686539-29959-5-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CQRckBG71P9cvF9uJ93WD5NwRbG4VmOxh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-5-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CQRckBG71P9cvF9uJ93WD5NwRbG4VmOxh
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
> index b306870..5f44b66 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> @@ -575,7 +575,7 @@ alloc_res_chunk_list(struct usnic_vnic *vnic,
>  	return res_chunk_list;
> =20
>  out_free_res:
> -	for (i--; i > 0; i--)
> +	for (i--; i >=3D 0; i--)
>  		usnic_vnic_put_resources(res_chunk_list[i]);
>  	kfree(res_chunk_list);
>  	return ERR_PTR(err);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CQRckBG71P9cvF9uJ93WD5NwRbG4VmOxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesheAAoJELgmozMOVy/d3HsQAInvwYmlDa4CoBItqLkFBQtz
OF2aMGMrAs2m7fCmhc0d5N5guksVQCNERelHgFxw46282D77C6bA82sVCQPjPhce
fyb/+7cJiocMebGsO6LzhzhPDSIamMxwCTkO93gTOsIZuSYwZ6z8I+lb53IjFtYP
IF4mCPXBmmptPvaOh8x+6m0lAvz6NolnW8Lqydnu+QFfkKNK0awUtPHd9ifV1vDt
Q6t7F7mIOkYYGnmgUJBn94oN/awBXzk3BcS9moe/DXUplnr0B/4WiZ8D+mXYC/HX
GLq69hlVyg7bfweaE17qklK0JkbFMz2pDkx37kvuTrMKuPiPaFpdd6znqfQ4iMwv
L8nidTq9cEVdBzE3MO4TC1kwM1NgUgno1K9Z33uFfg7KFAOJZtZYEkFkvQjitq+Q
iJoF5q/LsraESnwfxiAtxJZ6nk2QpTXxmAFT8FROnmn9ggFAIHqXGuuczlEMTbCK
FLIHy6gVuBPpRoUiPirpZYNJnBjYc/oJCy9zFbRshdone3bomlXMcJxSwElMyKhr
eDGIagkvwnRQ1L5N7PyHvGsdWNpScIr2xGMqY3gFmErXA/AhTMiNylWuq+YB1otR
fCYMdsn8cdcMdW8//LEv2vULhRt6phqyAaygbvlGGOLO1s30vpPhrxsBKewN3GR4
08MKptzBLVaV7HVhrnNO
=j1Zw
-----END PGP SIGNATURE-----

--CQRckBG71P9cvF9uJ93WD5NwRbG4VmOxh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
