From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 07/19] IB/mad: Convert ib_mad_private allocations
 from kmem_cache to kmalloc
Date: Tue, 24 Feb 2015 09:22:15 -0500
Message-ID: <1424787735.4847.19.camel@redhat.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
	 <1423092585-26692-8-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-N/nJYsyIcxYHcFjZAJsM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-8-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-N/nJYsyIcxYHcFjZAJsM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-02-04 at 18:29 -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Use the new max_mad_size specified by devices for the allocations and DMA=
 maps.
>=20
> kmalloc is more flexible to support devices with different sized MADs and
> research and testing showed that the current use of kmem_cache does not p=
rovide
> performance benefits over kmalloc.
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
>  drivers/infiniband/core/mad.c | 73 ++++++++++++++++++-------------------=
------
>  1 file changed, 30 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.=
c
> index a6a33cf..cc0a3ad 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -59,8 +59,6 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue i=
n number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of wo=
rk requests");
> =20
> -static struct kmem_cache *ib_mad_cache;
> -
>  static struct list_head ib_mad_port_list;
>  static u32 ib_mad_client_id =3D 0;
> =20
> @@ -717,6 +715,13 @@ static void build_smp_wc(struct ib_qp *qp,
>  	wc->port_num =3D port_num;
>  }
> =20
> +static struct ib_mad_private *alloc_mad_priv(struct ib_device *dev)
> +{
> +	return (kmalloc(sizeof(struct ib_mad_private_header) +
> +			sizeof(struct ib_grh) +
> +			dev->cached_dev_attrs.max_mad_size, GFP_ATOMIC));

Ouch!  GFP_ATOMIC?  I thought that generally all of the mad processing
was done from workqueue context where sleeping is allowed?  In the two
places where you removed kmem_cache_alloc() calls and replaced it with
calls to this code, they both used GFP_KERNEL and now you have switched
it to GFP_ATOMIC.  If there isn't a good reason for this, it should be
switched back to GFP_KERNEL.

> +}
> +
>  /*
>   * Return 0 if SMP is to be sent
>   * Return 1 if SMP was consumed locally (whether or not solicited)
> @@ -771,7 +776,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent=
_private *mad_agent_priv,
>  	}
>  	local->mad_priv =3D NULL;
>  	local->recv_mad_agent =3D NULL;
> -	mad_priv =3D kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
> +
> +	mad_priv =3D alloc_mad_priv(mad_agent_priv->agent.device);
>  	if (!mad_priv) {
>  		ret =3D -ENOMEM;
>  		dev_err(&device->dev, "No memory for local response MAD\n");
> @@ -801,10 +807,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_age=
nt_private *mad_agent_priv,
>  			 */
>  			atomic_inc(&mad_agent_priv->refcount);
>  		} else
> -			kmem_cache_free(ib_mad_cache, mad_priv);
> +			kfree(mad_priv);
>  		break;
>  	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED:
> -		kmem_cache_free(ib_mad_cache, mad_priv);
> +		kfree(mad_priv);
>  		break;
>  	case IB_MAD_RESULT_SUCCESS:
>  		/* Treat like an incoming receive MAD */
> @@ -820,14 +826,14 @@ static int handle_outgoing_dr_smp(struct ib_mad_age=
nt_private *mad_agent_priv,
>  			 * No receiving agent so drop packet and
>  			 * generate send completion.
>  			 */
> -			kmem_cache_free(ib_mad_cache, mad_priv);
> +			kfree(mad_priv);
>  			break;
>  		}
>  		local->mad_priv =3D mad_priv;
>  		local->recv_mad_agent =3D recv_mad_agent;
>  		break;
>  	default:
> -		kmem_cache_free(ib_mad_cache, mad_priv);
> +		kfree(mad_priv);
>  		kfree(local);
>  		ret =3D -EINVAL;
>  		goto out;
> @@ -1237,7 +1243,7 @@ void ib_free_recv_mad(struct ib_mad_recv_wc *mad_re=
cv_wc)
>  					    recv_wc);
>  		priv =3D container_of(mad_priv_hdr, struct ib_mad_private,
>  				    header);
> -		kmem_cache_free(ib_mad_cache, priv);
> +		kfree(priv);
>  	}
>  }
>  EXPORT_SYMBOL(ib_free_recv_mad);
> @@ -1924,6 +1930,11 @@ static void ib_mad_complete_recv(struct ib_mad_age=
nt_private *mad_agent_priv,
>  	}
>  }
> =20
> +static size_t mad_recv_buf_size(struct ib_device *dev)
> +{
> +	return(sizeof(struct ib_grh) + dev->cached_dev_attrs.max_mad_size);
> +}
> +
>  static bool generate_unmatched_resp(struct ib_mad_private *recv,
>  				    struct ib_mad_private *response)
>  {
> @@ -1964,8 +1975,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_=
port_private *port_priv,
>  	recv =3D container_of(mad_priv_hdr, struct ib_mad_private, header);
>  	ib_dma_unmap_single(port_priv->device,
>  			    recv->header.mapping,
> -			    sizeof(struct ib_mad_private) -
> -			      sizeof(struct ib_mad_private_header),
> +			    mad_recv_buf_size(port_priv->device),
>  			    DMA_FROM_DEVICE);
> =20
>  	/* Setup MAD receive work completion from "normal" work completion */
> @@ -1982,7 +1992,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_=
port_private *port_priv,
>  	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
>  		goto out;
> =20
> -	response =3D kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
> +	response =3D alloc_mad_priv(port_priv->device);
>  	if (!response) {
>  		dev_err(&port_priv->device->dev,
>  			"ib_mad_recv_done_handler no memory for response buffer\n");
> @@ -2075,7 +2085,7 @@ out:
>  	if (response) {
>  		ib_mad_post_receive_mads(qp_info, response);
>  		if (recv)
> -			kmem_cache_free(ib_mad_cache, recv);
> +			kfree(recv);
>  	} else
>  		ib_mad_post_receive_mads(qp_info, recv);
>  }
> @@ -2535,7 +2545,7 @@ local_send_completion:
>  		spin_lock_irqsave(&mad_agent_priv->lock, flags);
>  		atomic_dec(&mad_agent_priv->refcount);
>  		if (free_mad)
> -			kmem_cache_free(ib_mad_cache, local->mad_priv);
> +			kfree(local->mad_priv);
>  		kfree(local);
>  	}
>  	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
> @@ -2664,7 +2674,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_q=
p_info *qp_info,
>  			mad_priv =3D mad;
>  			mad =3D NULL;
>  		} else {
> -			mad_priv =3D kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
> +			mad_priv =3D alloc_mad_priv(qp_info->port_priv->device);
>  			if (!mad_priv) {
>  				dev_err(&qp_info->port_priv->device->dev,
>  					"No memory for receive buffer\n");
> @@ -2674,8 +2684,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_q=
p_info *qp_info,
>  		}
>  		sg_list.addr =3D ib_dma_map_single(qp_info->port_priv->device,
>  						 &mad_priv->grh,
> -						 sizeof *mad_priv -
> -						   sizeof mad_priv->header,
> +						 mad_recv_buf_size(qp_info->port_priv->device),
>  						 DMA_FROM_DEVICE);
>  		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
>  						  sg_list.addr))) {
> @@ -2699,10 +2708,9 @@ static int ib_mad_post_receive_mads(struct ib_mad_=
qp_info *qp_info,
>  			spin_unlock_irqrestore(&recv_queue->lock, flags);
>  			ib_dma_unmap_single(qp_info->port_priv->device,
>  					    mad_priv->header.mapping,
> -					    sizeof *mad_priv -
> -					      sizeof mad_priv->header,
> +					    mad_recv_buf_size(qp_info->port_priv->device),
>  					    DMA_FROM_DEVICE);
> -			kmem_cache_free(ib_mad_cache, mad_priv);
> +			kfree(mad_priv);
>  			dev_err(&qp_info->port_priv->device->dev,
>  				"ib_post_recv failed: %d\n", ret);
>  			break;
> @@ -2739,10 +2747,9 @@ static void cleanup_recv_queue(struct ib_mad_qp_in=
fo *qp_info)
> =20
>  		ib_dma_unmap_single(qp_info->port_priv->device,
>  				    recv->header.mapping,
> -				    sizeof(struct ib_mad_private) -
> -				      sizeof(struct ib_mad_private_header),
> +				    mad_recv_buf_size(qp_info->port_priv->device),
>  				    DMA_FROM_DEVICE);
> -		kmem_cache_free(ib_mad_cache, recv);
> +		kfree(recv);
>  	}
> =20
>  	qp_info->recv_queue.count =3D 0;
> @@ -3138,45 +3145,25 @@ static struct ib_client mad_client =3D {
> =20
>  static int __init ib_mad_init_module(void)
>  {
> -	int ret;
> -
>  	mad_recvq_size =3D min(mad_recvq_size, IB_MAD_QP_MAX_SIZE);
>  	mad_recvq_size =3D max(mad_recvq_size, IB_MAD_QP_MIN_SIZE);
> =20
>  	mad_sendq_size =3D min(mad_sendq_size, IB_MAD_QP_MAX_SIZE);
>  	mad_sendq_size =3D max(mad_sendq_size, IB_MAD_QP_MIN_SIZE);
> =20
> -	ib_mad_cache =3D kmem_cache_create("ib_mad",
> -					 sizeof(struct ib_mad_private),
> -					 0,
> -					 SLAB_HWCACHE_ALIGN,
> -					 NULL);
> -	if (!ib_mad_cache) {
> -		pr_err("Couldn't create ib_mad cache\n");
> -		ret =3D -ENOMEM;
> -		goto error1;
> -	}
> -
>  	INIT_LIST_HEAD(&ib_mad_port_list);
> =20
>  	if (ib_register_client(&mad_client)) {
>  		pr_err("Couldn't register ib_mad client\n");
> -		ret =3D -EINVAL;
> -		goto error2;
> +		return(-EINVAL);
>  	}
> =20
>  	return 0;
> -
> -error2:
> -	kmem_cache_destroy(ib_mad_cache);
> -error1:
> -	return ret;
>  }
> =20
>  static void __exit ib_mad_cleanup_module(void)
>  {
>  	ib_unregister_client(&mad_client);
> -	kmem_cache_destroy(ib_mad_cache);
>  }
> =20
>  module_init(ib_mad_init_module);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-N/nJYsyIcxYHcFjZAJsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU7IkXAAoJELgmozMOVy/dXAEQAJkW4mO/1aSuG+V9r8mOqAuF
b8x3MeJSvBP6/TxQG3VRf9P3wS6q/XBS1/p4hiQwBsf4xXLPR7TSV6xKpvQeyqXk
Ab6udpWHuK4Oum7q1sViGvIY5w8q5l0ushHUUePBU3oKLL0TqtFVlrLJNpLuxMhp
6dvLkG5x4gYbEB9C0sV/wQQtBdA+04XnZAmv+yBak4QwbvSoBUtuLVol31705Rd6
5qYYIupcc9nNl+SOS6yhiS9K52bbX/34rGTPTBxHKSj7dqtgvV3EIHUvnm034FkD
JDGCcB8d5uSrYgE7+wcShxtifwemOGLRsTn7c8sdLTy4G/jWRxXNjXLoKgQ7X2xc
36Swot3YjBPuPPrFsE64pzS0XvV1b1UXlll2BL0/rHfiFMzSneB4YNHM4ej0l8vC
fQKjxtynFIGfB2vERE32tLCzenyxKToYPKANSNQ6Jo5VfSsRDG8/wmiLRdCYFpnA
z8mBm2wABWo6I5YphBZomBQCyeSREuVRo2shyk9ZfgwhYCey2SFSUwUuJnJYhTAB
VPwla03oQT//wnXLZZRQzniWL13/xrC/VfMgUigMwjtZrdJVysBP24ORTiutsbdy
RlmMOQRYadjO1IRLQK09cKOop8bqpV+JvGQvh1ByuaP3/2uq5kEVgyAZ/RyM/LT7
cFIimwgC8gpz+qeyQt5b
=5ydQ
-----END PGP SIGNATURE-----

--=-N/nJYsyIcxYHcFjZAJsM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
