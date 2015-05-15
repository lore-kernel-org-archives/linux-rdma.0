From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Change rdma_protcol_iboe to roce
Date: Fri, 15 May 2015 17:14:11 +0200
Message-ID: <1431702851.4214.3.camel@opteya.com>
References: <1431630106-28829-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431630106-28829-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 14 mai 2015 =C3=A0 15:01 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org a =C3=A9cr=
it :
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> It has been decided that ROCE should be used within the kernel rather=
 than IBOE
> as we used before.  Change iboe to roce on the new rdma_protocol_* fu=
nctions.
>=20

Erk ... What's the usefulness of such patch ?

IBoE is used throughout the IB/RDMA subsystem.

Changing only these occurences is rather inconsistent.

> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c            | 12 ++++++------
>  drivers/infiniband/core/ucma.c           |  2 +-
>  include/rdma/ib_verbs.h                  |  4 ++--
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |  2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index 1977f601a1ec..ea92a0daa61c 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -391,7 +391,7 @@ static int cma_acquire_dev(struct rdma_id_private=
 *id_priv,
>  	if (listen_id_priv) {
>  		cma_dev =3D listen_id_priv->cma_dev;
>  		port =3D listen_id_priv->id.port_num;
> -		gidp =3D rdma_protocol_iboe(cma_dev->device, port) ?
> +		gidp =3D rdma_protocol_roce(cma_dev->device, port) ?
>  		       &iboe_gid : &gid;
> =20
>  		ret =3D cma_validate_port(cma_dev->device, port, gidp,
> @@ -409,7 +409,7 @@ static int cma_acquire_dev(struct rdma_id_private=
 *id_priv,
>  			    listen_id_priv->id.port_num =3D=3D port)
>  				continue;
> =20
> -			gidp =3D rdma_protocol_iboe(cma_dev->device, port) ?
> +			gidp =3D rdma_protocol_roce(cma_dev->device, port) ?
>  			       &iboe_gid : &gid;
> =20
>  			ret =3D cma_validate_port(cma_dev->device, port, gidp,
> @@ -647,7 +647,7 @@ static int cma_modify_qp_rtr(struct rdma_id_priva=
te *id_priv,
> =20
>  	BUG_ON(id_priv->cma_dev->device !=3D id_priv->id.device);
> =20
> -	if (rdma_protocol_iboe(id_priv->id.device, id_priv->id.port_num)) {
> +	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
>  		ret =3D rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
> =20
>  		if (ret)
> @@ -1966,7 +1966,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, i=
nt timeout_ms)
>  	atomic_inc(&id_priv->refcount);
>  	if (rdma_cap_ib_sa(id->device, id->port_num))
>  		ret =3D cma_resolve_ib_route(id_priv, timeout_ms);
> -	else if (rdma_protocol_iboe(id->device, id->port_num))
> +	else if (rdma_protocol_roce(id->device, id->port_num))
>  		ret =3D cma_resolve_iboe_route(id_priv);
>  	else if (rdma_protocol_iwarp(id->device, id->port_num))
>  		ret =3D cma_resolve_iw_route(id_priv, timeout_ms);
> @@ -3325,7 +3325,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, =
struct sockaddr *addr,
>  	list_add(&mc->list, &id_priv->mc_list);
>  	spin_unlock(&id_priv->lock);
> =20
> -	if (rdma_protocol_iboe(id->device, id->port_num)) {
> +	if (rdma_protocol_roce(id->device, id->port_num)) {
>  		kref_init(&mc->mcref);
>  		ret =3D cma_iboe_join_multicast(id_priv, mc);
>  	} else if (rdma_cap_ib_mcast(id->device, id->port_num))
> @@ -3365,7 +3365,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id=
, struct sockaddr *addr)
>  			if (rdma_cap_ib_mcast(id->device, id->port_num)) {
>  				ib_sa_free_multicast(mc->multicast.ib);
>  				kfree(mc);
> -			} else if (rdma_protocol_iboe(id->device, id->port_num))
> +			} else if (rdma_protocol_roce(id->device, id->port_num))
>  				kref_put(&mc->mcref, release_mc);
> =20
>  			return;
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core=
/ucma.c
> index d42b816c781f..ad45469f7582 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -725,7 +725,7 @@ static ssize_t ucma_query_route(struct ucma_file =
*file,
> =20
>  	if (rdma_cap_ib_sa(ctx->cm_id->device, ctx->cm_id->port_num))
>  		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
> -	else if (rdma_protocol_iboe(ctx->cm_id->device, ctx->cm_id->port_nu=
m))
> +	else if (rdma_protocol_roce(ctx->cm_id->device, ctx->cm_id->port_nu=
m))
>  		ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
>  	else if (rdma_protocol_iwarp(ctx->cm_id->device, ctx->cm_id->port_n=
um))
>  		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 29095fb6db5c..bcb87bf168c3 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1832,7 +1832,7 @@ static inline bool rdma_protocol_ib(struct ib_d=
evice *device, u8 port_num)
>  	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_=
CAP_PROT_IB;
>  }
> =20
> -static inline bool rdma_protocol_iboe(struct ib_device *device, u8 p=
ort_num)
> +static inline bool rdma_protocol_roce(struct ib_device *device, u8 p=
ort_num)
>  {
>  	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_=
CAP_PROT_ROCE;
>  }
> @@ -1842,7 +1842,7 @@ static inline bool rdma_protocol_iwarp(struct i=
b_device *device, u8 port_num)
>  	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_=
CAP_PROT_IWARP;
>  }
> =20
> -static inline bool rdma_ib_or_iboe(struct ib_device *device, u8 port=
_num)
> +static inline bool rdma_ib_or_roce(struct ib_device *device, u8 port=
_num)
>  {
>  	return device->port_immutable[port_num].core_cap_flags &
>  		(RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_PROT_ROCE);
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xp=
rtrdma/svc_rdma_transport.c
> index 3df8320c6efe..3f5750cf187e 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -987,7 +987,7 @@ static struct svc_xprt *svc_rdma_accept(struct sv=
c_xprt *xprt)
>  	 */
>  	if (!rdma_protocol_iwarp(newxprt->sc_cm_id->device,
>  				 newxprt->sc_cm_id->port_num) &&
> -	    !rdma_ib_or_iboe(newxprt->sc_cm_id->device,
> +	    !rdma_ib_or_roce(newxprt->sc_cm_id->device,
>  			     newxprt->sc_cm_id->port_num))
>  		goto errout;
> =20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
