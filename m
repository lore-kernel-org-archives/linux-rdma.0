From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 5/37] librdmacm: replace query_route call with separate
 queries
Date: Mon, 10 May 2010 13:07:57 -0500
Message-ID: <4BE84B7D.40703@opengridcomputing.com>
References: <D81E70C032A3452B9FD00D7EB445F6CF@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D81E70C032A3452B9FD00D7EB445F6CF-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

You define global int af_ib_support.  It never gets set to non-zero.  
Was this debug code or does it get set somewhere else that I'm missing?


Steve.


Sean Hefty wrote:
> To support other address families and multiple path records,
> replace the query_route call with specific query calls to obtain
> only the desired information.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
>  src/cma.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 60 insertions(+), 9 deletions(-)
>
> diff --git a/src/cma.c b/src/cma.c
> index 2a70d20..c57d166 100644
> --- a/src/cma.c
> +++ b/src/cma.c
> @@ -161,6 +161,7 @@ static struct cma_device *cma_dev_array;
>  static int cma_dev_cnt;
>  static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
>  static int abi_ver = RDMA_USER_CM_MAX_ABI_VERSION;
> +int af_ib_support;
>  
>  #define container_of(ptr, type, field) \
>  	((type *) ((void *)ptr - offsetof(type, field)))
> @@ -627,7 +628,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
>  	struct cma_id_private *id_priv;
>  	void *msg;
>  	int ret, size, i;
> -	
> +
>  	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY_ROUTE, size);
>  	id_priv = container_of(id, struct cma_id_private, id);
>  	cmd->id = id_priv->handle;
> @@ -1060,7 +1061,10 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
>  	if (ret != size)
>  		return (ret >= 0) ? ERR(ENODATA) : -1;
>  
> -	return ucma_query_route(id);
> +	if (af_ib_support)
> +		return ucma_query_addr(id);
> +	else
> +		return ucma_query_route(id);
>  }
>  
>  int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
> @@ -1326,6 +1330,57 @@ int rdma_ack_cm_event(struct rdma_cm_event *event)
>  	return 0;
>  }
>  
> +static void ucma_process_addr_resolved(struct cma_event *evt)
> +{
> +	if (af_ib_support) {
> +		evt->event.status = ucma_query_addr(&evt->id_priv->id);
> +		if (!evt->event.status &&
> +		    evt->id_priv->id.verbs->device->transport_type == IBV_TRANSPORT_IB)
> +			evt->event.status = ucma_query_gid(&evt->id_priv->id);
> +	} else {
> +		evt->event.status = ucma_query_route(&evt->id_priv->id);
> +	}
> +
> +	if (evt->event.status)
> +		evt->event.event = RDMA_CM_EVENT_ADDR_ERROR;
> +}
> +
> +static void ucma_process_route_resolved(struct cma_event *evt)
> +{
> +	if (evt->id_priv->id.verbs->device->transport_type != IBV_TRANSPORT_IB)
> +		return;
> +
> +	if (af_ib_support)
> +		evt->event.status = ucma_query_path(&evt->id_priv->id);
> +	else
> +		evt->event.status = ucma_query_route(&evt->id_priv->id);
> +
> +	if (evt->event.status)
> +		evt->event.event = RDMA_CM_EVENT_ROUTE_ERROR;
> +}
> +
> +static int ucma_query_req_info(struct rdma_cm_id *id)
> +{
> +	int ret;
> +
> +	if (!af_ib_support)
> +		return ucma_query_route(id);
> +
> +	ret = ucma_query_addr(id);
> +	if (ret)
> +		return ret;
> +
> +	ret = ucma_query_gid(id);
> +	if (ret)
> +		return ret;
> +
> +	ret = ucma_query_path(id);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  static int ucma_process_conn_req(struct cma_event *evt,
>  				 uint32_t handle)
>  {
> @@ -1344,7 +1399,7 @@ static int ucma_process_conn_req(struct cma_event *evt,
>  	evt->event.id = &id_priv->id;
>  	id_priv->handle = handle;
>  
> -	ret = ucma_query_route(&id_priv->id);
> +	ret = ucma_query_req_info(&id_priv->id);
>  	if (ret) {
>  		rdma_destroy_id(&id_priv->id);
>  		goto err;
> @@ -1473,14 +1528,10 @@ retry:
>  
>  	switch (resp->event) {
>  	case RDMA_CM_EVENT_ADDR_RESOLVED:
> -		evt->event.status = ucma_query_route(&evt->id_priv->id);
> -		if (evt->event.status)
> -			evt->event.event = RDMA_CM_EVENT_ADDR_ERROR;
> +		ucma_process_addr_resolved(evt);
>  		break;
>  	case RDMA_CM_EVENT_ROUTE_RESOLVED:
> -		evt->event.status = ucma_query_route(&evt->id_priv->id);
> -		if (evt->event.status)
> -			evt->event.event = RDMA_CM_EVENT_ROUTE_ERROR;
> +		ucma_process_route_resolved(evt);
>  		break;
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
>  		evt->id_priv = (void *) (uintptr_t) resp->uid;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
