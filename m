From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Fix incorrect cast in usnic_ib_fw_string_to_u64
Date: Wed, 23 Dec 2015 11:12:29 -0500
Message-ID: <567AC7ED.30502@redhat.com>
References: <1449686539-29959-2-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IpbpePNMQ90xcpnJJdhJQ9WgRS6VnD6Mf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-2-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IpbpePNMQ90xcpnJJdhJQ9WgRS6VnD6Mf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:42 PM, Nelson Escobar wrote:
> Signed-off-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/inf=
iniband/hw/usnic/usnic_ib_verbs.c
> index f8e3211..5ae6569 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -51,7 +51,7 @@
> =20
>  static void usnic_ib_fw_string_to_u64(char *fw_ver_str, u64 *fw_ver)
>  {
> -	*fw_ver =3D (u64) *fw_ver_str;
> +	*fw_ver =3D *((u64 *)fw_ver_str);
>  }
> =20
>  static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp=
,
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IpbpePNMQ90xcpnJJdhJQ9WgRS6VnD6Mf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesftAAoJELgmozMOVy/dZ1gP/2WtZk9VCREe9HLzIZQln+x1
L7sK2nDjxXwiZxkGU+tbRrnxtLW7FdfvBqmCFYu45RwNUW7dJcG7I7pQSImmSnpl
PEJg8jbcw/y/kJKrSQcwZbOHOXamiDJQozgm9OAOj/nB5hmgSYGWqHyYfQPy5v2p
0Cvu40C16aT1uCOvJxGkul6FX+szzwA/Z3CsotIWTApDVPovFk8V4CnlSk3AHTo2
rSb/8TGNo0eHHfmlMfonq2J8+WG9541+Lmq6wgWVCAxzq273qVcky5DSC3gNwtqZ
8tZ+D9UuJcZFgYBcMbJyjPdHsf+OTzOUaM7hXbik4dr6PvACLiCeva23CCcW0P/I
9t3UK6Gx6Q4UjDf0nteKSKWX/w9gp29qIi6yWDw6vwT/rXpPJAOVzc8RtLFg/NZi
Cw0FycESeAHe9IEHNKbyLcxaNppo1oslLNu/L2PAc1iqrBMMBdj1u8GQUMLJB/ci
A0CaR76dkx1lTVyv0glH2DnCSCJ8NYi5phBvG86vpQ/uIf9fMp2wzk6AtXyu14Ie
iaR+ewNErcqgu727VR6qtz34pV78rct1eVAgaurv8X2fb/EfOz4bFhXZ/IV+/8D+
SdEO+E2JMFV7CPXXE0SGKQTpN7DvRFLZ00w/JZ5osZMN7OLVzJhlzaRqadpuaV6n
imCiVQWI5Ar2pOf/U3Yk
=ctaG
-----END PGP SIGNATURE-----

--IpbpePNMQ90xcpnJJdhJQ9WgRS6VnD6Mf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
