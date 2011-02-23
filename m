From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] ib/cm: Bump reference count on cm_id before
 invoking callback
Date: Wed, 23 Feb 2011 12:57:24 -0500
Message-ID: <1298483844.19018.43.camel@firewall.xsintricity.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C5393@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t+dS4uE41QWFxF26W97Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C5393-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-t+dS4uE41QWFxF26W97Z
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-02-23 at 08:17 -0800, Hefty, Sean wrote:
> When processing a SIDR REQ, the ib_cm allocates a new cm_id.  The refcoun=
t
> of the cm_id is initialized to 1.  However, cm_process_work will
> decrement the refcount after invoking all callbacks.  The result is that
> the cm_id will end up with refcount set to 0 by the end of the sidr req
> handler.
>=20
> If a user tries to destroy the cm_id, the destruction will proceed, under
> the incorrect assumption that no other threads are referencing the cm_id.
> This can lead to a crash when the cm callback thread tries to access
> the cm_id.
>=20
> This problem was noticed as part of a larger investigation with kernel
> crashes in the rdma_cm when running on a real time OS.
>=20
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>=20
>  drivers/infiniband/core/cm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 64e0903..1d9616b 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -2989,6 +2989,7 @@ static int cm_sidr_req_handler(struct cm_work *work=
)
>  		goto out; /* No match. */
>  	}
>  	atomic_inc(&cur_cm_id_priv->refcount);
> +	atomic_inc(&cm_id_priv->refcount);
>  	spin_unlock_irq(&cm.lock);
> =20
>  	cm_id_priv->id.cm_handler =3D cur_cm_id_priv->id.cm_handler;
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-t+dS4uE41QWFxF26W97Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1lSoQACgkQg6WylM+/8ZRefgCgmyu+CcBo73q4tnXump41dKzT
brYAnRs9qmOSjNZRSSJnxqx41QEzhkjl
=DTJm
-----END PGP SIGNATURE-----

--=-t+dS4uE41QWFxF26W97Z--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
