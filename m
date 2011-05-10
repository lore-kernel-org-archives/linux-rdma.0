From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: Support REUSEADDR
Date: Tue, 10 May 2011 14:30:26 -0700
Message-ID: <20110510143026.69042817.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2B@orsmsx501.amr.corp.intel.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christopher J. Morrone" <morrone2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Apr 2011 23:46:09 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Lustre requires that clients bind to a privileged port number before
> connecting to a remote server.  On larger clusters (typically more than
> about 1000 nodes), the number of privileged ports is exhausted,
> resulting in lustre being unusable.
> 
> To address this limitation, we add support for reusable addresses
> to the rdma_cm.  This mimics the behavior of the socket option
> SO_REUSEADDR.  A user may set an rdma_cm_id to reuse an address
> before calling rdma_bind_addr (explicitly or implicitly).  If set,
> other rdma_cm_id's may be bound to the same address, provided that
> they all have reuse enabled, and there are no active listens.
> 
> If rdma_listen is called on an rdma_cm_id that has reuse enabled,
> it will only succeed if there are no other id's bound to that same
> address.  The reuse option is exported to user space.  The behavior
> of the kernel reuse implementation was verified against that given
> by sockets.
> 
> This patch is derived from a path by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

> ---
> Ira, can you please verify that these patches work for you?
> 
>  drivers/infiniband/core/cma.c  |  190 ++++++++++++++++++++++++++--------------
>  drivers/infiniband/core/ucma.c |    7 +
>  include/rdma/rdma_cm.h         |   11 ++
>  include/rdma/rdma_user_cm.h    |    5 +
>  4 files changed, 144 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index a1b1e27..0590a4d 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -148,6 +148,7 @@ struct rdma_id_private {
>  	u32			qp_num;
>  	u8			srq;
>  	u8			tos;
> +	u8			reuseaddr;
>  };
>  
>  struct cma_multicast {
> @@ -1561,50 +1562,6 @@ static void cma_listen_on_all(struct rdma_id_private *id_priv)
>  	mutex_unlock(&lock);
>  }
>  
> -int rdma_listen(struct rdma_cm_id *id, int backlog)
> -{
> -	struct rdma_id_private *id_priv;
> -	int ret;
> -
> -	id_priv = container_of(id, struct rdma_id_private, id);
> -	if (id_priv->state == CMA_IDLE) {
> -		((struct sockaddr *) &id->route.addr.src_addr)->sa_family = AF_INET;
> -		ret = rdma_bind_addr(id, (struct sockaddr *) &id->route.addr.src_addr);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_LISTEN))
> -		return -EINVAL;
> -
> -	id_priv->backlog = backlog;
> -	if (id->device) {
> -		switch (rdma_node_get_transport(id->device->node_type)) {
> -		case RDMA_TRANSPORT_IB:
> -			ret = cma_ib_listen(id_priv);
> -			if (ret)
> -				goto err;
> -			break;
> -		case RDMA_TRANSPORT_IWARP:
> -			ret = cma_iw_listen(id_priv, backlog);
> -			if (ret)
> -				goto err;
> -			break;
> -		default:
> -			ret = -ENOSYS;
> -			goto err;
> -		}
> -	} else
> -		cma_listen_on_all(id_priv);
> -
> -	return 0;
> -err:
> -	id_priv->backlog = 0;
> -	cma_comp_exch(id_priv, CMA_LISTEN, CMA_ADDR_BOUND);
> -	return ret;
> -}
> -EXPORT_SYMBOL(rdma_listen);
> -
>  void rdma_set_service_type(struct rdma_cm_id *id, int tos)
>  {
>  	struct rdma_id_private *id_priv;
> @@ -2096,6 +2053,25 @@ err:
>  }
>  EXPORT_SYMBOL(rdma_resolve_addr);
>  
> +int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse)
> +{
> +	struct rdma_id_private *id_priv;
> +	unsigned long flags;
> +	int ret;
> +
> +	id_priv = container_of(id, struct rdma_id_private, id);
> +	spin_lock_irqsave(&id_priv->lock, flags);
> +	if (id_priv->state == CMA_IDLE) {
> +		id_priv->reuseaddr = reuse;
> +		ret = 0;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +	spin_unlock_irqrestore(&id_priv->lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(rdma_set_reuseaddr);
> +
>  static void cma_bind_port(struct rdma_bind_list *bind_list,
>  			  struct rdma_id_private *id_priv)
>  {
> @@ -2171,43 +2147,73 @@ retry:
>  	return -EADDRNOTAVAIL;
>  }
>  
> -static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
> +/*
> + * Check that the requested port is available.  This is called when trying to
> + * bind to a specific port, or when trying to listen on a bound port.  In
> + * the latter case, the provided id_priv may already be on the bind_list, but
> + * we still need to check that it's okay to start listening.
> + */
> +static int cma_check_port(struct rdma_bind_list *bind_list,
> +			  struct rdma_id_private *id_priv, uint8_t reuseaddr)
>  {
>  	struct rdma_id_private *cur_id;
>  	struct sockaddr *addr, *cur_addr;
> -	struct rdma_bind_list *bind_list;
>  	struct hlist_node *node;
> -	unsigned short snum;
>  
>  	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
> -	snum = ntohs(cma_port(addr));
> -	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
> -		return -EACCES;
> -
> -	bind_list = idr_find(ps, snum);
> -	if (!bind_list)
> -		return cma_alloc_port(ps, id_priv, snum);
> -
> -	/*
> -	 * We don't support binding to any address if anyone is bound to
> -	 * a specific address on the same port.
> -	 */
> -	if (cma_any_addr(addr))
> +	if (cma_any_addr(addr) && !reuseaddr)
>  		return -EADDRNOTAVAIL;
>  
>  	hlist_for_each_entry(cur_id, node, &bind_list->owners, node) {
> -		cur_addr = (struct sockaddr *) &cur_id->id.route.addr.src_addr;
> -		if (cma_any_addr(cur_addr))
> -			return -EADDRNOTAVAIL;
> +		if (id_priv == cur_id)
> +			continue;
>  
> -		if (!cma_addr_cmp(addr, cur_addr))
> -			return -EADDRINUSE;
> -	}
> +		if ((cur_id->state == CMA_LISTEN) ||
> +		    !reuseaddr || !cur_id->reuseaddr) {
> +			cur_addr = (struct sockaddr *) &cur_id->id.route.addr.src_addr;
> +			if (cma_any_addr(cur_addr))
> +				return -EADDRNOTAVAIL;
>  
> -	cma_bind_port(bind_list, id_priv);
> +			if (!cma_addr_cmp(addr, cur_addr))
> +				return -EADDRINUSE;
> +		}
> +	}
>  	return 0;
>  }
>  
> +static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
> +{
> +	struct rdma_bind_list *bind_list;
> +	unsigned short snum;
> +	int ret;
> +
> +	snum = ntohs(cma_port((struct sockaddr *) &id_priv->id.route.addr.src_addr));
> +	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
> +		return -EACCES;
> +
> +	bind_list = idr_find(ps, snum);
> +	if (!bind_list) {
> +		ret = cma_alloc_port(ps, id_priv, snum);
> +	} else {
> +		ret = cma_check_port(bind_list, id_priv, id_priv->reuseaddr);
> +		if (!ret)
> +			cma_bind_port(bind_list, id_priv);
> +	}
> +	return ret;
> +}
> +
> +static int cma_bind_listen(struct rdma_id_private *id_priv)
> +{
> +	struct rdma_bind_list *bind_list = id_priv->bind_list;
> +	int ret = 0;
> +
> +	mutex_lock(&lock);
> +	if (bind_list->owners.first->next)
> +		ret = cma_check_port(bind_list, id_priv, 0);
> +	mutex_unlock(&lock);
> +	return ret;
> +}
> +
>  static int cma_get_port(struct rdma_id_private *id_priv)
>  {
>  	struct idr *ps;
> @@ -2259,6 +2265,56 @@ static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
>  	return 0;
>  }
>  
> +int rdma_listen(struct rdma_cm_id *id, int backlog)
> +{
> +	struct rdma_id_private *id_priv;
> +	int ret;
> +
> +	id_priv = container_of(id, struct rdma_id_private, id);
> +	if (id_priv->state == CMA_IDLE) {
> +		((struct sockaddr *) &id->route.addr.src_addr)->sa_family = AF_INET;
> +		ret = rdma_bind_addr(id, (struct sockaddr *) &id->route.addr.src_addr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_LISTEN))
> +		return -EINVAL;
> +
> +	if (id_priv->reuseaddr) {
> +		ret = cma_bind_listen(id_priv);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	id_priv->backlog = backlog;
> +	if (id->device) {
> +		switch (rdma_node_get_transport(id->device->node_type)) {
> +		case RDMA_TRANSPORT_IB:
> +			ret = cma_ib_listen(id_priv);
> +			if (ret)
> +				goto err;
> +			break;
> +		case RDMA_TRANSPORT_IWARP:
> +			ret = cma_iw_listen(id_priv, backlog);
> +			if (ret)
> +				goto err;
> +			break;
> +		default:
> +			ret = -ENOSYS;
> +			goto err;
> +		}
> +	} else
> +		cma_listen_on_all(id_priv);
> +
> +	return 0;
> +err:
> +	id_priv->backlog = 0;
> +	cma_comp_exch(id_priv, CMA_LISTEN, CMA_ADDR_BOUND);
> +	return ret;
> +}
> +EXPORT_SYMBOL(rdma_listen);
> +
>  int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
>  {
>  	struct rdma_id_private *id_priv;
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index ec1e9da..b3fa798 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -883,6 +883,13 @@ static int ucma_set_option_id(struct ucma_context *ctx, int optname,
>  		}
>  		rdma_set_service_type(ctx->cm_id, *((u8 *) optval));
>  		break;
> +	case RDMA_OPTION_ID_REUSEADDR:
> +		if (optlen != sizeof(int)) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ret = rdma_set_reuseaddr(ctx->cm_id, *((int *) optval) ? 1 : 0);
> +		break;
>  	default:
>  		ret = -ENOSYS;
>  	}
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 4fae903..2cb5e7f 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -329,4 +329,15 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr);
>   */
>  void rdma_set_service_type(struct rdma_cm_id *id, int tos);
>  
> +/**
> + * rdma_set_reuseaddr - Allow the reuse of local addresses when binding
> + *    the rdma_cm_id.
> + * @id: Communication identifier to configure.
> + * @reuse: Value indicating if the bound address is reusable.
> + *
> + * Reuse must be set before an address is bound to the id.
> + */
> +int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse);
> +
> +
>  #endif /* RDMA_CM_H */
> diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
> index 1d16502..fc82c18 100644
> --- a/include/rdma/rdma_user_cm.h
> +++ b/include/rdma/rdma_user_cm.h
> @@ -221,8 +221,9 @@ enum {
>  
>  /* Option details */
>  enum {
> -	RDMA_OPTION_ID_TOS	= 0,
> -	RDMA_OPTION_IB_PATH	= 1
> +	RDMA_OPTION_ID_TOS	 = 0,
> +	RDMA_OPTION_ID_REUSEADDR = 1,
> +	RDMA_OPTION_IB_PATH	 = 1
>  };
>  
>  struct rdma_ucm_set_option {
> 
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
