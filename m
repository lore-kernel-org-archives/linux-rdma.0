From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 01/22] IB/core: Reserve bits in enum ib_qp_create_flags
 for low-level driver use
Date: Wed, 05 Sep 2012 10:55:39 -0400
Message-ID: <504767EB.6090004@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-2-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4D4C7843D312B30F610B368"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-2-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4D4C7843D312B30F610B368
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> Reserve bits 26-31 for internal use by low-level drivers. Two
> such bits are used in the mlx4 driver SRIOV IB implementation.
>=20
> These enum additions guarantee that the core layer will never use
> these bits, so that low level drivers may safely make use of them.
>=20
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 07996af..46bc045 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -614,6 +614,9 @@ enum ib_qp_type {
>  enum ib_qp_create_flags {
>  	IB_QP_CREATE_IPOIB_UD_LSO		=3D 1 << 0,
>  	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	=3D 1 << 1,
> +	/* reserve bits 26-31 for low level drivers' internal use */
> +	IB_QP_CREATE_RESERVED_START		=3D 1 << 26,
> +	IB_QP_CREATE_RESERVED_END		=3D 1 << 31,
>  };
> =20
>  struct ib_qp_init_attr {
>=20

Reserving 6 bits for driver use out of 32 seems reasonable.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigD4D4C7843D312B30F610B368
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQR2frAAoJELgmozMOVy/d6mEP/iFj3J95eZbLHfxwMeUc6cL4
+zM5vgmsvoP3oekWaPb94wLCHd5Db15cMqOv+VRfaT+4IoWMD9OyhyMFLyXvVHYZ
7DIE93ccKJlw7lGb8bdeI4jTmoN3E4QP8OQgDBS13WcW6ac9EB2O/K21J08/DSkU
MMwqxGgE6RqFcdUKb4lSM4YcRRChjiEcaq32/VnDBqJT3L1VGFi3ECzRdR5cihNr
s6TAo3lx1o/3r4nIo3GeOTrTyGqiVO+sFdIZZQbpZigW3N8/aShASc4NqPbBigy8
TyDA7j6qCui/kmuUvRENB5fHM+hT9YC4+pQ+aClWaft3HW3VTBvR/B/S55ob2hAB
6gok8c/2pAUIorkEaQLzzBGCC7irINnzJB8BX4zu3oOHrNKFBhN857TN9zWuhwqd
JgdbEH7NBy4Sv5txK06/O4P8Q07LctnLY4OTYpCi+6WUZo3C+g62cvpQ3L40ucOq
6FkdmMbp7ROD6GZp+5pnvvdeUWcsNxlMRZNM9jpAyN80DyCD7pT45Q7JsiQo8O26
QxtO9WpN8IkciPJ7zBZImITxAjIoJJyiUdnaYAh6HkmZTzbtN1GQcD26wY0szUJn
Q5iqeiQRxUKZ91kRgBmPMfhMwAunoKrh8Qzu/AIsVR3TlvC1bxpBl7/rsSXjEQh7
DntDgt0pXJXGEFfbA4du
=83qd
-----END PGP SIGNATURE-----

--------------enigD4D4C7843D312B30F610B368--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
