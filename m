From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
 roce_gid_cache
Date: Mon, 23 Feb 2015 05:25:27 +0000
Message-ID: <de2ee483-0c24-4951-af76-87ab3499636a@CMEXHTCAS1.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f91c8ed3-f6a4-4b63-85f9-870d9687a14f-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan,

Please find a comment inline below:

-Regards
Devesh
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Somnath Kotur
> Sent: Friday, February 20, 2015 3:32 AM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak; Somnath Kotur
> Subject: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
> roce_gid_cache
> 
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Previously, we resolved the dmac and took the smac and vlan from the resolved
> address. Changing that into finding a net device that matches the IP and vlan of
> the network packet and querying the RoCE GID cache for this net device, GID
> and GID type.
> 
> ocrdma driver changes were done by Somnath Kotur
> <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
> 
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/addr.c           |    3 +-
>  drivers/infiniband/core/cm.c             |   30 ------
>  drivers/infiniband/core/cma.c            |    9 --
>  drivers/infiniband/core/core_priv.h      |    4 +-
>  drivers/infiniband/core/sa_query.c       |    4 -
>  drivers/infiniband/core/ucma.c           |    1 -
>  drivers/infiniband/core/uverbs_cmd.c     |    6 +-
>  drivers/infiniband/core/verbs.c          |  159 +++++++++++++++++------------
>  drivers/infiniband/hw/mlx4/ah.c          |   15 +++-
>  drivers/infiniband/hw/mlx4/mad.c         |   12 ++-
>  drivers/infiniband/hw/mlx4/mcg.c         |    2 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h     |    2 +-
>  drivers/infiniband/hw/mlx4/qp.c          |   42 ++++++--
>  drivers/infiniband/hw/ocrdma/ocrdma.h    |    1 +
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |   20 +++--
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   17 ++-
>  include/rdma/ib_addr.h                   |    2 +-
>  include/rdma/ib_sa.h                     |    2 -
>  include/rdma/ib_verbs.h                  |    7 +-
>  19 files changed, 183 insertions(+), 155 deletions(-)
> 
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index f80da50..43af7f5 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -458,7 +458,7 @@ static void resolve_cb(int status, struct sockaddr
> *src_addr,  }
> 
>  int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8
> *dmac,
> -			       u16 *vlan_id)
> +			       u16 *vlan_id, int if_index)
>  {
>  	int ret = 0;
>  	struct rdma_dev_addr dev_addr;
> @@ -481,6 +481,7 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid,
> union ib_gid *dgid, u8 *dmac,
>  		return ret;
> 
>  	memset(&dev_addr, 0, sizeof(dev_addr));
> +	dev_addr.bound_dev_if = if_index;
> 
>  	ctx.addr = &dev_addr;
>  	init_completion(&ctx.comp);
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c index
> d88f2ae..7974e74 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -178,8 +178,6 @@ struct cm_av {
>  	struct ib_ah_attr ah_attr;
>  	u16 pkey_index;
>  	u8 timeout;
> -	u8  valid;
> -	u8  smac[ETH_ALEN];
>  };
> 
>  struct cm_work {
> @@ -382,7 +380,6 @@ static int cm_init_av_by_path(struct ib_sa_path_rec
> *path, struct cm_av *av)
>  			     &av->ah_attr);
>  	av->timeout = path->packet_life_time + 1;
> 
> -	av->valid = 1;
>  	return 0;
>  }
> 
> @@ -1563,7 +1560,6 @@ static int cm_req_handler(struct cm_work *work)
>  	cm_format_paths_from_req(req_msg, &work->path[0], &work-
> >path[1]);
> 
>  	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac,
> ETH_ALEN);
> -	work->path[0].vlan_id = cm_id_priv->av.ah_attr.vlan_id;
>  	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
>  	if (ret) {
>  		ib_get_cached_gid(work->port->cm_dev->ib_device,
> @@ -3511,32 +3507,6 @@ static int cm_init_qp_rtr_attr(struct cm_id_private
> *cm_id_priv,
>  		*qp_attr_mask = IB_QP_STATE | IB_QP_AV |
> IB_QP_PATH_MTU |
>  				IB_QP_DEST_QPN | IB_QP_RQ_PSN;
>  		qp_attr->ah_attr = cm_id_priv->av.ah_attr;
> -		if (!cm_id_priv->av.valid) {
> -			spin_unlock_irqrestore(&cm_id_priv->lock, flags);
> -			return -EINVAL;
> -		}
> -		if (cm_id_priv->av.ah_attr.vlan_id != 0xffff) {
> -			qp_attr->vlan_id = cm_id_priv->av.ah_attr.vlan_id;
> -			*qp_attr_mask |= IB_QP_VID;
> -		}
> -		if (!is_zero_ether_addr(cm_id_priv->av.smac)) {
> -			memcpy(qp_attr->smac, cm_id_priv->av.smac,
> -			       sizeof(qp_attr->smac));
> -			*qp_attr_mask |= IB_QP_SMAC;
> -		}
> -		if (cm_id_priv->alt_av.valid) {
> -			if (cm_id_priv->alt_av.ah_attr.vlan_id != 0xffff) {
> -				qp_attr->alt_vlan_id =
> -					cm_id_priv->alt_av.ah_attr.vlan_id;
> -				*qp_attr_mask |= IB_QP_ALT_VID;
> -			}
> -			if (!is_zero_ether_addr(cm_id_priv->alt_av.smac)) {
> -				memcpy(qp_attr->alt_smac,
> -				       cm_id_priv->alt_av.smac,
> -				       sizeof(qp_attr->alt_smac));
> -				*qp_attr_mask |= IB_QP_ALT_SMAC;
> -			}
> -		}
>  		qp_attr->path_mtu = cm_id_priv->path_mtu;
>  		qp_attr->dest_qp_num = be32_to_cpu(cm_id_priv-
> >remote_qpn);
>  		qp_attr->rq_psn = be32_to_cpu(cm_id_priv->rq_psn); diff --git
> a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c index
> 335def9..659676c 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -666,15 +666,6 @@ static int cma_modify_qp_rtr(struct rdma_id_private
> *id_priv,
>  	if (ret)
>  		goto out;
> 
> -	if (rdma_node_get_transport(id_priv->cma_dev->device->node_type)
> -	    == RDMA_TRANSPORT_IB &&
> -	    rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)
> -	    == IB_LINK_LAYER_ETHERNET) {
> -		ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac,
> NULL);
> -
> -		if (ret)
> -			goto out;
> -	}
>  	if (conn_param)
>  		qp_attr.max_dest_rd_atomic = conn_param-
> >responder_resources;
>  	ret = ib_modify_qp(id_priv->id.qp, &qp_attr, qp_attr_mask); diff --git
> a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> index d6e73f8..fbe5922 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -52,8 +52,8 @@ void ib_sysfs_cleanup(void);  int  ib_cache_setup(void);
> void ib_cache_cleanup(void);
> 
> -int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
> -			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
> +int ib_resolve_eth_dmac(struct ib_qp *qp,
> +			struct ib_qp_attr *qp_attr, int *qp_attr_mask);
> 
>  typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
>  	      struct net_device *idev, void *cookie); diff --git
> a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index 5b20237..705b6b8 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -559,11 +559,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8
> port_num,
>  	}
>  	if (force_grh) {
>  		memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
> -		ah_attr->vlan_id = rec->vlan_id;
> -	} else {
> -		ah_attr->vlan_id = 0xffff;
>  	}
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(ib_init_ah_from_path);
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 45d67e9..5eacda4 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1125,7 +1125,6 @@ static int ucma_set_ib_path(struct ucma_context
> *ctx,
>  		return -EINVAL;
> 
>  	memset(&sa_path, 0, sizeof(sa_path));
> -	sa_path.vlan_id = 0xffff;
> 
>  	ib_sa_unpack_path(path_data->path_rec, &sa_path);
>  	ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1); diff --git
> a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index b7943ff..07d7f13 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2089,15 +2089,16 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file
> *file,
>  	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
> 
>  	if (qp->real_qp == qp) {
> -		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
> +		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
>  		if (ret)
> -			goto out;
> +			goto out_put;
>  		ret = qp->device->modify_qp(qp, attr,
>  			modify_qp_mask(qp->qp_type, cmd.attr_mask),
> &udata);
>  	} else {
>  		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type,
> cmd.attr_mask));
>  	}
> 
> +out_put:
>  	put_qp_read(qp);
> 
>  	if (ret)
> @@ -2552,7 +2553,6 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file
> *file,
>  	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
>  	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
>  	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
> -	attr.vlan_id           = 0;
>  	memset(&attr.dmac, 0, sizeof(attr.dmac));
>  	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 1fe3e71..2c54d31 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -41,6 +41,9 @@
>  #include <linux/export.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <net/addrconf.h>
> 
>  #include <rdma/ib_verbs.h>
>  #include <rdma/ib_cache.h>
> @@ -192,6 +195,35 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct
> ib_ah_attr *ah_attr)  }  EXPORT_SYMBOL(ib_create_ah);
> 
> +struct find_gid_index_context {
> +	u16 vlan_id;
> +};
> +
> +static bool find_gid_index(const union ib_gid *gid,
> +			   const struct ib_gid_attr *gid_attr,
> +			   void *context)
> +{
> +	struct find_gid_index_context *ctx =
> +		(struct find_gid_index_context *)context;
> +
> +	if ((!!(ctx->vlan_id != 0xffff) == !is_vlan_dev(gid_attr->ndev)) ||
> +	    (is_vlan_dev(gid_attr->ndev) &&
> +	     vlan_dev_vlan_id(gid_attr->ndev) != ctx->vlan_id))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
> +				   u16 vlan_id, union ib_gid *sgid,
> +				   u16 *gid_index)
> +{
> +	struct find_gid_index_context context = {.vlan_id = vlan_id};
> +
> +	return ib_find_gid_by_filter(device, sgid, port_num, find_gid_index,
> +				     &context, gid_index);
> +}
> +
>  int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc
> *wc,
>  		       struct ib_grh *grh, struct ib_ah_attr *ah_attr)  { @@ -
> 203,21 +235,30 @@ int ib_init_ah_from_wc(struct ib_device *device, u8
> port_num, struct ib_wc *wc,
> 
>  	memset(ah_attr, 0, sizeof *ah_attr);
>  	if (is_eth) {
> +		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
> +				wc->vlan_id : 0xffff;
> +
>  		if (!(wc->wc_flags & IB_WC_GRH))
>  			return -EPROTOTYPE;
> 
> -		if (wc->wc_flags & IB_WC_WITH_SMAC &&
> -		    wc->wc_flags & IB_WC_WITH_VLAN) {
> -			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
> -			ah_attr->vlan_id = wc->vlan_id;
> -		} else {
> +		if (!(wc->wc_flags & IB_WC_WITH_SMAC) ||
> +		    !(wc->wc_flags & IB_WC_WITH_VLAN)) {
>  			ret = rdma_addr_find_dmac_by_grh(&grh->dgid,
> &grh->sgid,
> -					ah_attr->dmac, &ah_attr->vlan_id);
> +							 ah_attr->dmac,
> +							 wc->wc_flags &
> IB_WC_WITH_VLAN ?
> +							 NULL : &vlan_id,
> +							 0);
>  			if (ret)
>  				return ret;
>  		}
> -	} else {
> -		ah_attr->vlan_id = 0xffff;
> +
> +		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
> +					      &grh->dgid, &gid_index);
> +		if (ret)
> +			return ret;
> +
> +		if (wc->wc_flags & IB_WC_WITH_SMAC)
> +			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
>  	}
> 
>  	ah_attr->dlid = wc->slid;
> @@ -229,10 +270,14 @@ int ib_init_ah_from_wc(struct ib_device *device, u8
> port_num, struct ib_wc *wc,
>  		ah_attr->ah_flags = IB_AH_GRH;
>  		ah_attr->grh.dgid = grh->sgid;
> 
> -		ret = ib_find_cached_gid(device, &grh->dgid, IB_GID_TYPE_IB,
> -					 NULL, 0, &port_num, &gid_index);
> -		if (ret)
> -			return ret;
> +		if (!is_eth) {
> +			ret = ib_find_cached_gid_by_port(device, &grh->dgid,
> +							 IB_GID_TYPE_IB,
> +							 port_num, NULL, 0,
> +							 &gid_index);
> +			if (ret)
> +				return ret;
> +		}
> 
>  		ah_attr->grh.sgid_index = (u8) gid_index;
>  		flow_class = be32_to_cpu(grh->version_tclass_flow);
> @@ -502,9 +547,7 @@ EXPORT_SYMBOL(ib_create_qp);  static const struct {
>  	int			valid;
>  	enum ib_qp_attr_mask	req_param[IB_QPT_MAX];
> -	enum ib_qp_attr_mask	req_param_add_eth[IB_QPT_MAX];
>  	enum ib_qp_attr_mask	opt_param[IB_QPT_MAX];
> -	enum ib_qp_attr_mask	opt_param_add_eth[IB_QPT_MAX];
>  } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
>  	[IB_QPS_RESET] = {
>  		[IB_QPS_RESET] = { .valid = 1 },
> @@ -585,12 +628,6 @@ static const struct {
> 
> 	IB_QP_MAX_DEST_RD_ATOMIC	|
>  						IB_QP_MIN_RNR_TIMER),
>  			},
> -			.req_param_add_eth = {
> -				[IB_QPT_RC]  = (IB_QP_SMAC),
> -				[IB_QPT_UC]  = (IB_QP_SMAC),
> -				[IB_QPT_XRC_INI]  = (IB_QP_SMAC),
> -				[IB_QPT_XRC_TGT]  = (IB_QP_SMAC)
> -			},
>  			.opt_param = {
>  				 [IB_QPT_UD]  = (IB_QP_PKEY_INDEX
> 	|
>  						 IB_QP_QKEY),
> @@ -611,21 +648,7 @@ static const struct {
>  				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX
> 	|
>  						 IB_QP_QKEY),
>  			 },
> -			.opt_param_add_eth = {
> -				[IB_QPT_RC]  = (IB_QP_ALT_SMAC
> 		|
> -						IB_QP_VID
> 	|
> -						IB_QP_ALT_VID),
> -				[IB_QPT_UC]  = (IB_QP_ALT_SMAC
> 		|
> -						IB_QP_VID
> 	|
> -						IB_QP_ALT_VID),
> -				[IB_QPT_XRC_INI]  = (IB_QP_ALT_SMAC
> 		|
> -						IB_QP_VID
> 	|
> -						IB_QP_ALT_VID),
> -				[IB_QPT_XRC_TGT]  = (IB_QP_ALT_SMAC
> 			|
> -						IB_QP_VID
> 	|
> -						IB_QP_ALT_VID)
> -			}
> -		}
> +		},
>  	},
>  	[IB_QPS_RTR]   = {
>  		[IB_QPS_RESET] = { .valid = 1 },
> @@ -847,13 +870,6 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state,
> enum ib_qp_state next_state,
>  	req_param = qp_state_table[cur_state][next_state].req_param[type];
>  	opt_param = qp_state_table[cur_state][next_state].opt_param[type];
> 
> -	if (ll == IB_LINK_LAYER_ETHERNET) {
> -		req_param |= qp_state_table[cur_state][next_state].
> -			req_param_add_eth[type];
> -		opt_param |= qp_state_table[cur_state][next_state].
> -			opt_param_add_eth[type];
> -	}
> -
>  	if ((mask & req_param) != req_param)
>  		return 0;
> 
> @@ -864,41 +880,52 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state,
> enum ib_qp_state next_state,  }  EXPORT_SYMBOL(ib_modify_qp_is_ok);
> 
> -int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
> -			    struct ib_qp_attr *qp_attr, int *qp_attr_mask)
> +int ib_resolve_eth_dmac(struct ib_qp *qp,
> +			struct ib_qp_attr *qp_attr, int *qp_attr_mask)
>  {
>  	int           ret = 0;
> -	union ib_gid  sgid;
> 
>  	if ((*qp_attr_mask & IB_QP_AV)  &&
> -	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num)
> == IB_LINK_LAYER_ETHERNET)) {
> -		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
> -				   qp_attr->ah_attr.grh.sgid_index, &sgid,
> -				   NULL);
> -		if (ret)
> -			goto out;
> +	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num)
> ==
> +	     IB_LINK_LAYER_ETHERNET)) {
>  		if (rdma_link_local_addr((struct in6_addr *)qp_attr-
> >ah_attr.grh.dgid.raw)) {
> -			rdma_get_ll_mac((struct in6_addr *)qp_attr-
> >ah_attr.grh.dgid.raw, qp_attr->ah_attr.dmac);
> -			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr-
> >smac);
> -			if (!(*qp_attr_mask & IB_QP_VID))
> -				qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
> +			rdma_get_ll_mac((struct in6_addr *)qp_attr-
> >ah_attr.grh.dgid.raw,
> +					qp_attr->ah_attr.dmac);
>  		} else {
> -			ret = rdma_addr_find_dmac_by_grh(&sgid, &qp_attr-
> >ah_attr.grh.dgid,
> -					qp_attr->ah_attr.dmac, &qp_attr-
> >vlan_id);
> -			if (ret)
> -				goto out;
> -			ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr-
> >smac, NULL);
> -			if (ret)
> +			union ib_gid		sgid;
> +			struct ib_gid_attr	sgid_attr;
> +			int			ifindex;
> +
> +			rcu_read_lock();
> +			ret = ib_query_gid(qp->device,
> +					   qp_attr->ah_attr.port_num,
> +					   qp_attr->ah_attr.grh.sgid_index,
> +					   &sgid, &sgid_attr);
> +
> +			if (ret || !sgid_attr.ndev) {
> +				if (!ret)
> +					ret = -ENXIO;
> +				rcu_read_unlock();
>  				goto out;
> +			}
> +
> +			dev_hold(sgid_attr.ndev);
> +			ifindex = sgid_attr.ndev->ifindex;
> +
> +			rcu_read_unlock();
> +
> +			ret = rdma_addr_find_dmac_by_grh(&sgid,
> +							 &qp_attr-
> >ah_attr.grh.dgid,
> +							 qp_attr-
> >ah_attr.dmac,
> +							 NULL, ifindex);

Vlan-ID can also be resolved here and passed to vendor specific modify_qp?

Similarly for UD:
ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
                            const char __user *buf, int in_len,
                            int out_len)

could resolve the dmac and vlan-id before calling ib_create_ah() in uverbs_cmd.c

these changes would make vendor drivers independent of how the attributes are resolved.

> +
> +			dev_put(sgid_attr.ndev);
>  		}
> -		*qp_attr_mask |= IB_QP_SMAC;
> -		if (qp_attr->vlan_id < 0xFFFF)
> -			*qp_attr_mask |= IB_QP_VID;
>  	}
>  out:
>  	return ret;
>  }
> -EXPORT_SYMBOL(ib_resolve_eth_l2_attrs);
> +EXPORT_SYMBOL(ib_resolve_eth_dmac);
> 
> 
>  int ib_modify_qp(struct ib_qp *qp,
> @@ -907,7 +934,7 @@ int ib_modify_qp(struct ib_qp *qp,  {
>  	int ret;
> 
> -	ret = ib_resolve_eth_l2_attrs(qp, qp_attr, &qp_attr_mask);
> +	ret = ib_resolve_eth_dmac(qp, qp_attr, &qp_attr_mask);
>  	if (ret)
>  		return ret;
> 
> diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
> index f50a546..aaeeb60 100644
> --- a/drivers/infiniband/hw/mlx4/ah.c
> +++ b/drivers/infiniband/hw/mlx4/ah.c
> @@ -76,7 +76,9 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd,
> struct ib_ah_attr *ah_attr
>  	struct mlx4_dev *dev = ibdev->dev;
>  	int is_mcast = 0;
>  	struct in6_addr in6;
> -	u16 vlan_tag;
> +	u16 vlan_tag = 0xffff;
> +	union ib_gid sgid;
> +	struct ib_gid_attr gid_attr;
> 
>  	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof(in6));
>  	if (rdma_is_multicast_addr(&in6)) {
> @@ -85,7 +87,16 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd,
> struct ib_ah_attr *ah_attr
>  	} else {
>  		memcpy(ah->av.eth.mac, ah_attr->dmac, ETH_ALEN);
>  	}
> -	vlan_tag = ah_attr->vlan_id;
> +	rcu_read_lock();
> +	ib_get_cached_gid(pd->device, ah_attr->port_num,
> +			  ah_attr->grh.sgid_index, &sgid, &gid_attr);
> +	memset(ah->av.eth.s_mac, 0, ETH_ALEN);
> +	if (gid_attr.ndev) {
> +		if (is_vlan_dev(gid_attr.ndev))
> +			vlan_tag = vlan_dev_vlan_id(gid_attr.ndev);
> +		memcpy(ah->av.eth.s_mac, gid_attr.ndev->dev_addr,
> ETH_ALEN);
> +	}
> +	rcu_read_unlock();
>  	if (vlan_tag < 0x1000)
>  		vlan_tag |= (ah_attr->sl & 7) << 13;
>  	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr-
> >port_num << 24)); diff --git a/drivers/infiniband/hw/mlx4/mad.c
> b/drivers/infiniband/hw/mlx4/mad.c
> index 82a7dd8..e686e95 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1154,7 +1154,7 @@ static int is_proxy_qp0(struct mlx4_ib_dev *dev, int
> qpn, int slave)  int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8
> port,
>  			 enum ib_qp_type dest_qpt, u16 pkey_index,
>  			 u32 remote_qpn, u32 qkey, struct ib_ah_attr *attr,
> -			 u8 *s_mac, struct ib_mad *mad)
> +			 u8 *s_mac, u16 vlan_id, struct ib_mad *mad)
>  {
>  	struct ib_sge list;
>  	struct ib_send_wr wr, *bad_wr;
> @@ -1241,6 +1241,9 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev,
> int slave, u8 port,
>  	wr.send_flags = IB_SEND_SIGNALED;
>  	if (s_mac)
>  		memcpy(to_mah(ah)->av.eth.s_mac, s_mac, 6);
> +	if (vlan_id < 0x1000)
> +		vlan_id |= (attr->sl & 7) << 13;
> +	to_mah(ah)->av.eth.vlan = cpu_to_be16(vlan_id);
> 
> 
>  	ret = ib_post_send(send_qp, &wr, &bad_wr); @@ -1277,6 +1280,7 @@
> static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct
> ib_wc
>  	u8 *slave_id;
>  	int slave;
>  	int port;
> +	u16 vlan_id;
> 
>  	/* Get slave that sent this packet */
>  	if (wc->src_qp < dev->dev->phys_caps.base_proxy_sqpn || @@ -
> 1362,10 +1366,10 @@ static void mlx4_ib_multiplex_mad(struct
> mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
>  		return;
>  	ah_attr.port_num = port;
>  	memcpy(ah_attr.dmac, tunnel->hdr.mac, 6);
> -	ah_attr.vlan_id = be16_to_cpu(tunnel->hdr.vlan);
> +	vlan_id = be16_to_cpu(tunnel->hdr.vlan);
>  	/* if slave have default vlan use it */
>  	mlx4_get_slave_default_vlan(dev->dev, ctx->port, slave,
> -				    &ah_attr.vlan_id, &ah_attr.sl);
> +				    &vlan_id, &ah_attr.sl);
> 
>  	mlx4_ib_send_to_wire(dev, slave, ctx->port,
>  			     is_proxy_qp0(dev, wc->src_qp, slave) ?
> @@ -1373,7 +1377,7 @@ static void mlx4_ib_multiplex_mad(struct
> mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
>  			     be16_to_cpu(tunnel->hdr.pkey_index),
>  			     be32_to_cpu(tunnel->hdr.remote_qpn),
>  			     be32_to_cpu(tunnel->hdr.qkey),
> -			     &ah_attr, wc->smac, &tunnel->mad);
> +			     &ah_attr, wc->smac, vlan_id, &tunnel->mad);
>  }
> 
>  static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx, diff --git
> a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
> index ed327e6..86bc158 100644
> --- a/drivers/infiniband/hw/mlx4/mcg.c
> +++ b/drivers/infiniband/hw/mlx4/mcg.c
> @@ -217,7 +217,7 @@ static int send_mad_to_wire(struct mlx4_ib_demux_ctx
> *ctx, struct ib_mad *mad)
>  	spin_unlock(&dev->sm_lock);
>  	return mlx4_ib_send_to_wire(dev, mlx4_master_func_num(dev->dev),
>  				    ctx->port, IB_QPT_GSI, 0, 1, IB_QP1_QKEY,
> -				    &ah_attr, NULL, mad);
> +				    &ah_attr, NULL, 0xffff, mad);
>  }
> 
>  static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx, diff --
> git a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index 721540c..42fe035 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -761,7 +761,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int
> slave, u8 port,  int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8
> port,
>  			 enum ib_qp_type dest_qpt, u16 pkey_index, u32
> remote_qpn,
>  			 u32 qkey, struct ib_ah_attr *attr, u8 *s_mac,
> -			 struct ib_mad *mad);
> +			 u16 vlan_id, struct ib_mad *mad);
> 
>  __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx);
> 
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 5889c68..9ab9156 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -1351,11 +1351,12 @@ static int _mlx4_set_path(struct mlx4_ib_dev
> *dev, const struct ib_ah_attr *ah,  static int mlx4_set_path(struct mlx4_ib_dev
> *dev, const struct ib_qp_attr *qp,
>  			 enum ib_qp_attr_mask qp_attr_mask,
>  			 struct mlx4_ib_qp *mqp,
> -			 struct mlx4_qp_path *path, u8 port)
> +			 struct mlx4_qp_path *path, u8 port,
> +			 u16 vlan_id, u8 *smac)
>  {
>  	return _mlx4_set_path(dev, &qp->ah_attr,
> -			      mlx4_mac_to_u64((u8 *)qp->smac),
> -			      (qp_attr_mask & IB_QP_VID) ? qp->vlan_id : 0xffff,
> +			      mlx4_mac_to_u64(smac),
> +			      vlan_id,
>  			      path, &mqp->pri, port);
>  }
> 
> @@ -1366,9 +1367,8 @@ static int mlx4_set_alt_path(struct mlx4_ib_dev
> *dev,
>  			     struct mlx4_qp_path *path, u8 port)  {
>  	return _mlx4_set_path(dev, &qp->alt_ah_attr,
> -			      mlx4_mac_to_u64((u8 *)qp->alt_smac),
> -			      (qp_attr_mask & IB_QP_ALT_VID) ?
> -			      qp->alt_vlan_id : 0xffff,
> +			      0,
> +			      0xffff,
>  			      path, &mqp->alt, port);
>  }
> 
> @@ -1384,7 +1384,8 @@ static void update_mcg_macs(struct mlx4_ib_dev
> *dev, struct mlx4_ib_qp *qp)
>  	}
>  }
> 
> -static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev, struct
> mlx4_ib_qp *qp, u8 *smac,
> +static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev,
> +				    struct mlx4_ib_qp *qp,
>  				    struct mlx4_qp_context *context)  {
>  	u64 u64_mac;
> @@ -1524,9 +1525,30 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>  	}
> 
>  	if (attr_mask & IB_QP_AV) {
> +		u8 port_num = attr_mask & IB_QP_PORT ? attr->port_num :
> qp->port;
> +		int index = attr->ah_attr.grh.sgid_index;
> +		union ib_gid gid;
> +		struct ib_gid_attr gid_attr;
> +		u16 vlan = 0xffff;
> +		u8 smac[ETH_ALEN];
> +		int status = 0;
> +
> +		if (rdma_port_get_link_layer(&dev->ib_dev, qp->port) ==
> +				IB_LINK_LAYER_ETHERNET) {
> +			rcu_read_lock();
> +			status = ib_get_cached_gid(ibqp->device, port_num,
> +						   index, &gid, &gid_attr);
> +			if (!status) {
> +				vlan = rdma_vlan_dev_vlan_id(gid_attr.ndev);
> +				memcpy(smac, gid_attr.ndev->dev_addr,
> ETH_ALEN);
> +			}
> +			rcu_read_unlock();
> +		}
> +		if (status)
> +			goto out;
> +
>  		if (mlx4_set_path(dev, attr, attr_mask, qp, &context->pri_path,
> -				  attr_mask & IB_QP_PORT ?
> -				  attr->port_num : qp->port))
> +				  port_num, vlan, smac))
>  			goto out;
> 
>  		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH | @@ -
> 1663,7 +1685,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>  			if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_UD ||
>  			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI
> ||
>  			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_GSI) {
> -				err = handle_eth_ud_smac_index(dev, qp, (u8
> *)attr->smac, context);
> +				err = handle_eth_ud_smac_index(dev, qp,
> context);
>  				if (err)
>  					return -EINVAL;
>  				if (qp->mlx4_ib_qp_type ==
> MLX4_IB_QPT_PROXY_GSI) diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h
> b/drivers/infiniband/hw/ocrdma/ocrdma.h
> index c9780d9..16ee36e 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
> @@ -36,6 +36,7 @@
>  #include <rdma/ib_verbs.h>
>  #include <rdma/ib_user_verbs.h>
>  #include <rdma/ib_addr.h>
> +#include <rdma/ib_cache.h>
> 
>  #include <be_roce.h>
>  #include "ocrdma_sli.h"
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> index d812904..7ecd230 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> @@ -41,10 +41,9 @@
> 
>  static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
>  			struct ib_ah_attr *attr, union ib_gid *sgid,
> -			int pdid, bool *isvlan)
> +			int pdid, bool *isvlan, u16 vlan_tag)
>  {
>  	int status = 0;
> -	u16 vlan_tag;
>  	struct ocrdma_eth_vlan eth;
>  	struct ocrdma_grh grh;
>  	int eth_sz;
> @@ -53,7 +52,6 @@ static inline int set_av_attr(struct ocrdma_dev *dev,
> struct ocrdma_ah *ah,
>  	memset(&grh, 0, sizeof(grh));
> 
>  	/* VLAN */
> -	vlan_tag = attr->vlan_id;
>  	if (!vlan_tag || (vlan_tag > 0xFFF))
>  		vlan_tag = dev->pvid;
>  	if (vlan_tag && (vlan_tag < 0x1000)) { @@ -94,9 +92,11 @@ static
> inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,  struct
> ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)  {
>  	u32 *ahid_addr;
> -	bool isvlan = false;
>  	int status;
>  	struct ocrdma_ah *ah;
> +	bool isvlan = false;
> +	u16 vlan_tag = 0xffff;
> +	struct ib_gid_attr sgid_attr;
>  	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
>  	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
>  	union ib_gid sgid;
> @@ -114,16 +114,22 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd,
> struct ib_ah_attr *attr)
>  	if (status)
>  		goto av_err;
> 
> -	status = ocrdma_query_gid(&dev->ibdev, 1, attr->grh.sgid_index,
> &sgid);
> +	rcu_read_lock();
> +	status = ib_get_cached_gid(&dev->ibdev, 1, attr->grh.sgid_index,
> &sgid,
> +				   &sgid_attr);
>  	if (status) {
>  		pr_err("%s(): Failed to query sgid, status = %d\n",
>  		      __func__, status);
>  		goto av_conf_err;
>  	}
> +	if (sgid_attr.ndev && is_vlan_dev(sgid_attr.ndev))
> +		vlan_tag = vlan_dev_vlan_id(sgid_attr.ndev);
> +	rcu_read_unlock();
> 
>  	if (pd->uctx) {
>  		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
> -                                        attr->dmac, &attr->vlan_id);
> +						    attr->dmac, &vlan_tag,
> +						    sgid_attr.ndev->ifindex);
>  		if (status) {
>  			pr_err("%s(): Failed to resolve dmac from gid."
>  				"status = %d\n", __func__, status); @@ -131,7
> +137,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct
> ib_ah_attr *attr)
>  		}
>  	}
> 
> -	status = set_av_attr(dev, ah, attr, &sgid, pd->id, &isvlan);
> +	status = set_av_attr(dev, ah, attr, &sgid, pd->id, &isvlan, vlan_tag);
>  	if (status)
>  		goto av_conf_err;
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 31493b1..c0dda74 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -2428,7 +2428,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp
> *qp,
>  	int status;
>  	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
>  	union ib_gid sgid, zgid;
> -	u32 vlan_id;
> +	struct ib_gid_attr sgid_attr;
> +	u32 vlan_id = 0xffff;
>  	u8 mac_addr[6];
>  	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
> 
> @@ -2446,10 +2447,15 @@ static int ocrdma_set_av_params(struct
> ocrdma_qp *qp,
>  	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
>  	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
>  	       sizeof(cmd->params.dgid));
> -	status = ocrdma_query_gid(&dev->ibdev, 1,
> -			ah_attr->grh.sgid_index, &sgid);
> -	if (status)
> -		return status;
> +
> +	rcu_read_lock();
> +	status = ib_get_cached_gid(&dev->ibdev, 1, ah_attr->grh.sgid_index,
> +				   &sgid, &sgid_attr);
> +	if (!status) {
> +		vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
> +		memcpy(mac_addr, sgid_attr.ndev->dev_addr, ETH_ALEN);
> +	}
> +	rcu_read_unlock();
> 
>  	memset(&zgid, 0, sizeof(zgid));
>  	if (!memcmp(&sgid, &zgid, sizeof(zgid))) @@ -2467,7 +2473,6 @@
> static int ocrdma_set_av_params(struct ocrdma_qp *qp,
>  	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd-
> >params.sgid));
>  	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] <<
> 8);
>  	if (attr_mask & IB_QP_VID) {
> -		vlan_id = attrs->vlan_id;
>  		cmd->params.vlan_dmac_b4_to_b5 |=
>  		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
>  		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID; diff --git
> a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h index 3cf32d1..0dfaaa7
> 100644
> --- a/include/rdma/ib_addr.h
> +++ b/include/rdma/ib_addr.h
> @@ -112,7 +112,7 @@ int rdma_addr_size(struct sockaddr *addr);
> 
>  int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16
> *vlan_id);  int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid
> *dgid, u8 *smac,
> -			       u16 *vlan_id);
> +			       u16 *vlan_id, int if_index);
> 
>  static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)  { diff --
> git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h index 6a1b994..eea01e6
> 100644
> --- a/include/rdma/ib_sa.h
> +++ b/include/rdma/ib_sa.h
> @@ -154,9 +154,7 @@ struct ib_sa_path_rec {
>  	u8           packet_life_time_selector;
>  	u8           packet_life_time;
>  	u8           preference;
> -	u8           smac[ETH_ALEN];
>  	u8           dmac[ETH_ALEN];
> -	u16          vlan_id;
>  	int	     ifindex;
>  	struct net  *net;
>  };
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> 37c3f8f..854e705 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -74,6 +74,8 @@ enum ib_gid_type {
>  	IB_GID_TYPE_SIZE
>  };
> 
> +#define ROCE_V2_UDP_DPORT	1021
> +
>  struct ib_gid_attr {
>  	enum ib_gid_type	gid_type;
>  	struct net_device	*ndev;
> @@ -668,7 +670,6 @@ struct ib_ah_attr {
>  	u8			ah_flags;
>  	u8			port_num;
>  	u8			dmac[ETH_ALEN];
> -	u16			vlan_id;
>  };
> 
>  enum ib_wc_status {
> @@ -979,10 +980,6 @@ struct ib_qp_attr {
>  	u8			rnr_retry;
>  	u8			alt_port_num;
>  	u8			alt_timeout;
> -	u8			smac[ETH_ALEN];
> -	u8			alt_smac[ETH_ALEN];
> -	u16			vlan_id;
> -	u16			alt_vlan_id;
>  };
> 
>  enum ib_wr_opcode {
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
