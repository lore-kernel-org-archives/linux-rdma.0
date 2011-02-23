From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Wed, 23 Feb 2011 12:57:44 -0500
Message-ID: <1298483864.19018.44.camel@firewall.xsintricity.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+yzk2Ay4r/vSVXznMIli"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-+yzk2Ay4r/vSVXznMIli
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-02-23 at 08:11 -0800, Hefty, Sean wrote:
> Doug Ledford and RedHat reported a crash when running the rdma_cm on a re=
al
> time OS.  The crash has the following call trace:
>=20
>     cm_process_work
>        cma_req_handler
>           cma_disable_callback
>           rdma_create_id
>              kzalloc
>              init_completion
>           cma_get_net_info
>           cma_save_net_info
>           cma_any_addr
>              cma_zero_addr
>           rdma_translate_ip
>              rdma_copy_addr
>           cma_acquire_dev
>              rdma_addr_get_sgid
>              ib_find_cached_gid
>              cma_attach_to_dev
>           ucma_event_handler
>              kzalloc
>              ib_copy_ah_attr_to_user
>           cma_comp
> =20
> [ preempted ]
> =20
>     cma_write
>         copy_from_user
>         ucma_destroy_id
>            copy_from_user
>            _ucma_find_context
>            ucma_put_ctx
>            ucma_free_ctx
>               rdma_destroy_id
>                  cma_exch
>                  cma_cancel_operation
>                  rdma_node_get_transport
>=20
>         rt_mutex_slowunlock
>         bad_area_nosemaphore
>         oops_enter
>=20
> They were able to reproduce the crash multiple times with the following
> details:
>=20
>     Crash seems to always happen on the:
>             mutex_unlock(&conn_id->handler_mutex);
>     as conn_id looks to have been freed during this code path.
>=20
> An examination of the code shows that a race exists in the request handle=
rs.
> When a new connection request is received, the rdma_cm allocates a new
> connection identifier.  This identifier has a single reference count on i=
t.
> If a user calls rdma_destroy_id() from another thread after receiving a
> callback, rdma_destroy_id will proceed to destroy the id and free
> the associated memory.  However, the request handlers may still be in
> the process of running.  When control returns to the request handlers,
> they can attempt to access the newly created identifiers.
>=20
> Fix this by holding a reference on the newly created rdma_cm_id until
> the request handler is through accessing it.
>=20
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
> This is obviously serious enough to cause a crash, but the bug has also b=
een there
> for a while before anyone detected it.  I have no real opinion on whether=
 this
> targets 2.6.38 (if that's even possible at this point) or 2.6.39.
>=20
>  drivers/infiniband/core/cma.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index 6884da2..e450c5a 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1210,6 +1210,11 @@ static int cma_req_handler(struct ib_cm_id *cm_id,=
 struct ib_cm_event *ib_event)
>  	cm_id->context =3D conn_id;
>  	cm_id->cm_handler =3D cma_ib_handler;
> =20
> +	/*
> +	 * Protect against the user destroying conn_id from another thread
> +	 * until we're done accessing it.
> +	 */
> +	atomic_inc(&conn_id->refcount);
>  	ret =3D conn_id->id.event_handler(&conn_id->id, &event);
>  	if (!ret) {
>  		/*
> @@ -1222,8 +1227,10 @@ static int cma_req_handler(struct ib_cm_id *cm_id,=
 struct ib_cm_event *ib_event)
>  			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
>  		mutex_unlock(&lock);
>  		mutex_unlock(&conn_id->handler_mutex);
> +		cma_deref_id(conn_id);
>  		goto out;
>  	}
> +	cma_deref_id(conn_id);
> =20
>  	/* Destroy the CM ID by returning a non-zero value. */
>  	conn_id->cm_id.ib =3D NULL;
> @@ -1425,17 +1432,25 @@ static int iw_conn_req_handler(struct iw_cm_id *c=
m_id,
>  	event.param.conn.private_data_len =3D iw_event->private_data_len;
>  	event.param.conn.initiator_depth =3D attr.max_qp_init_rd_atom;
>  	event.param.conn.responder_resources =3D attr.max_qp_rd_atom;
> +
> +	/*
> +	 * Protect against the user destroying conn_id from another thread
> +	 * until we're done accessing it.
> +	 */
> +	atomic_inc(&conn_id->refcount);
>  	ret =3D conn_id->id.event_handler(&conn_id->id, &event);
>  	if (ret) {
>  		/* User wants to destroy the CM ID */
>  		conn_id->cm_id.iw =3D NULL;
>  		cma_exch(conn_id, CMA_DESTROYING);
>  		mutex_unlock(&conn_id->handler_mutex);
> +		cma_deref_id(conn_id);
>  		rdma_destroy_id(&conn_id->id);
>  		goto out;
>  	}
> =20
>  	mutex_unlock(&conn_id->handler_mutex);
> +	cma_deref_id(conn_id);
> =20
>  out:
>  	if (dev)
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-+yzk2Ay4r/vSVXznMIli
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1lSpgACgkQg6WylM+/8ZTYpQCgt1j1iJ8D+O/VQkKhokRHAA7P
Yd8AoK5mcrbbwdszPEDefcgMaAOoj1Dv
=MizM
-----END PGP SIGNATURE-----

--=-+yzk2Ay4r/vSVXznMIli--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
