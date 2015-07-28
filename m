From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2] iw_cxgb4: set the default MPA version to 2
Date: Tue, 28 Jul 2015 11:23:50 -0400
Message-ID: <55B79E86.4080207@redhat.com>
References: <1437986332-6746-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eHg6qFn6FKsT5hXvfuHlrvKGgs4HOn8ba"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437986332-6746-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eHg6qFn6FKsT5hXvfuHlrvKGgs4HOn8ba
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/27/2015 04:38 AM, Hariprasad Shenai wrote:
> This enables ORD/IRD negotiation and its about time to enable it by
> default
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/c=
xgb4/cm.c
> index 3ad8dc7..75144d9 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -115,11 +115,11 @@ module_param(ep_timeout_secs, int, 0644);
>  MODULE_PARM_DESC(ep_timeout_secs, "CM Endpoint operation timeout "
>  				   "in seconds (default=3D60)");
> =20
> -static int mpa_rev =3D 1;
> +static int mpa_rev =3D 2;
>  module_param(mpa_rev, int, 0644);
>  MODULE_PARM_DESC(mpa_rev, "MPA Revision, 0 supports amso1100, "
>  		"1 is RFC0544 spec compliant, 2 is IETF MPA Peer Connect Draft"
> -		" compliant (default=3D1)");
> +		" compliant (default=3D2)");
> =20
>  static int markers_enabled;
>  module_param(markers_enabled, int, 0644);
>=20

Accepted.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--eHg6qFn6FKsT5hXvfuHlrvKGgs4HOn8ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt56GAAoJELgmozMOVy/dFgUP/R7rLRg+YSWXcOd6GZ3BhEKE
+Lh18pz/afTlOMxph4DHEwV2cC8RKkvGc6/dfWp3+h8349AwIXP9CF78y1mweVp0
BN0z9F7NxtSKvpfggGnTN2FURqNIsw/EbNE/yWPH1lcrj+S5L0LoCuoCERDbKEQq
7xv8wljcYTO4QE0ZKPCv7emMHT2FzNgFcNKy0t27BGwKpZTwZKKejEZWSkdLSvqp
MpZlCkOPdClvZb/oCDS7n35JiLy+uRJ35d/dDVU9HcmPHQhoDg4aWdj0ik/fAaId
TA+TvcLxultylMTx15INGXq3zGgYHMYkKTDwymSSS0+roUSM8jhDjlNUJTxE342a
Sdc6NLK9mZsJfnD0y597SAZjaSTjWsAZqd7Ardb+9VCuUHZlkDebNYza7Sp+D/8+
5WeSJgQAw9Vzfa0EkothJIVskfcTqHuUooTIU1sZHDKhRbo31Q/2z6TbAtKfw3eu
UjIj0t874GTDe4UydDyADydZLciHiy/fLwZFO7oVaoSECP/A+4uBQA7+cEzGohgc
0Qf3IVZXDFMWsf+4NX6nrOrIrCQdM9xN++Lzwau5FbYhjutA6bgC+liMwAivhVxy
K1iFJ8lp56KXSKg1nz4xzBmAOaODFOfm86KCqKs8x4r6ev3NuYaO0bwnwnWb4ePl
LIUU5gsQlag9ls+XDkEd
=0GkB
-----END PGP SIGNATURE-----

--eHg6qFn6FKsT5hXvfuHlrvKGgs4HOn8ba--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
