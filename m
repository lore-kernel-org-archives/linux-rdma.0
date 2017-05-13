From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/CM: Create appropriate path records
 when handling CM request
Date: Sat, 13 May 2017 14:39:36 +0300
Message-ID: <20170513113936.GM3616@mtr-leonro.local>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458598-6911-3-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zROEGoKAXsG5UqGB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494458598-6911-3-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zROEGoKAXsG5UqGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 07:23:16PM -0400, Dasaratharaman Chandramouli wrote:
> When handling an incoming conection request, ib_cm creates
> either an IB or an OPA path record based on the gid field
> in the request.
>
> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c | 39 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 9a7f4be..01cfa24 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -1421,6 +1421,12 @@ static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
>  		 (be32_to_cpu(local_qpn) > be32_to_cpu(remote_qpn))));
>  }
>
> +static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
> +{
> +	return ((req_msg->alt_local_lid) ||
> +		(ib_is_opa_gid(&req_msg->alt_local_gid)));
> +}
> +
>  static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
>  				     struct sa_path_rec *primary_path,
>  				     struct sa_path_rec *alt_path)
> @@ -1800,9 +1806,18 @@ static int cm_req_handler(struct cm_work *work)
>  					 dev_net(gid_attr.ndev));
>  			dev_put(gid_attr.ndev);
>  		} else {
> -			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
> +			/*
> +			 * If the gid in the request is an OPA GID,
> +			 * create an OPA PR
> +			 */
> +			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
> +			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
> +					    work->port->port_num))

Why isn't ib_is_opa_gid enough?

> +				work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
> +			else
> +				work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
>  		}
> -		if (req_msg->alt_local_lid)
> +		if (cm_req_has_alt_path(req_msg))
>  			work->path[1].rec_type = work->path[0].rec_type;
>  		cm_format_paths_from_req(req_msg, &work->path[0],
>  					 &work->path[1]);
> @@ -1827,16 +1842,21 @@ static int cm_req_handler(struct cm_work *work)
>  					 dev_net(gid_attr.ndev));
>  			dev_put(gid_attr.ndev);
>  		} else {
> -			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
> +			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
> +			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
> +					    work->port->port_num))
> +				work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
> +			else
> +				work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
>  		}
> -		if (req_msg->alt_local_lid)
> +		if (cm_req_has_alt_path(req_msg))
>  			work->path[1].rec_type = work->path[0].rec_type;
>  		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>  			       &work->path[0].sgid, sizeof work->path[0].sgid,
>  			       NULL, 0);
>  		goto rejected;
>  	}
> -	if (req_msg->alt_local_lid) {
> +	if (cm_req_has_alt_path(req_msg)) {
>  		ret = cm_init_av_by_path(&work->path[1], &cm_id_priv->alt_av,
>  					 cm_id_priv);
>  		if (ret) {
> @@ -2953,8 +2973,6 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
>  				    struct sa_path_rec *path,
>  				    struct cm_lap_msg *lap_msg)
>  {
> -	memset(path, 0, sizeof *path);
> -	path->rec_type = SA_PATH_REC_TYPE_IB;
>  	path->dgid = lap_msg->alt_local_gid;
>  	path->sgid = lap_msg->alt_remote_gid;
>  	sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
> @@ -2990,6 +3008,13 @@ static int cm_lap_handler(struct cm_work *work)
>  		return -EINVAL;
>
>  	param = &work->cm_event.param.lap_rcvd;
> +	memset(&work->path[0], 0, sizeof(work->path[0]));
> +	if (ib_is_opa_gid(&lap_msg->alt_local_gid) &&
> +	    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
> +			    work->port->port_num))
> +		work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
> +	else
> +		work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
>  	param->alternate_path = &work->path[0];
>  	cm_format_path_from_lap(cm_id_priv, param->alternate_path, lap_msg);
>  	work->cm_event.private_data = &lap_msg->private_data;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--zROEGoKAXsG5UqGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkW8HgACgkQ5GN7iDZy
WKdUnBAAhwoWiWwHezxu52lKUTpbgqTlw0MG0rh8EOUzq0YSktMwSXqywblpkuY1
VXFho9QXH6B7WKG454rI/aFWB6LnQEkviN6uhewUojmUAT3iunMiz/5OtXO18duW
cuhRKsdlcOlCG/ZKM6nJjQ6VNe0FPlwOPyGTfyZL7PPVD8njJ90wYNIFVUcTNR2+
0jlhQAAua9t3qHO1oV3Dk5zMvsjoYPQ7qxgNzcU6VB1JK37VbBHKmYF+YeSmEdLE
KeVV2LTNbQ1y7GI6V0T5njqA8F0T9Fix16Z3GFVIs4JmguAeYV5Eo3qGjwNuSh1u
elD385tnn0gXFGTJFce0fpoRVPNYcD48wL4J0Qyt7wfGLIzFGiIKiYi0tHoTKwCX
pbt0uO7uZa+CsLmR02vvXH1w2gVOil3Afnw2p8EZPsLLmUOdQ7DeXfz/Ay68TLol
SsQh7+c045BQlRAfmWysBN4TS4b5bwx3BCZCS2jVyGflwRXCcsnXqdtdHDEGs5Zf
7ipt3vedYeHxjJMxjiI+p1Ejg39Y06fj919N9ykBR1NdnS+qVityVU/RZ2qTDNti
O+Qy1fYfyNgGng/OjB+m8XaY8RIRaTDSUKhdCgQYwfuUMlQxAY9GCWsFA/GTLTL5
DuH129ql3wNW0pepGU3vd4VOrIPJxq2yBgz4aNc/b1jtQJ99JlY=
=5vJ6
-----END PGP SIGNATURE-----

--zROEGoKAXsG5UqGB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
