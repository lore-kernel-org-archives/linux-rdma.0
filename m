From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mad: pass ib_mad_send_buf explicitly to the recv_handler
Date: Mon, 4 Jan 2016 18:58:59 -0500
Message-ID: <20160104235859.GA12703@phlsvsds.ph.intel.com>
References: <1451913359-25074-1-git-send-email-hch@lst.de> <1451913359-25074-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1451913359-25074-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 04, 2016 at 02:15:58PM +0100, Christoph Hellwig wrote:
> Stop abusing wr_id and just pass the parameter explicitly.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/cm.c          |  1 +
>  drivers/infiniband/core/mad.c         | 18 ++++++++++--------
>  drivers/infiniband/core/sa_query.c    |  7 ++++---
>  drivers/infiniband/core/user_mad.c    |  1 +
>  drivers/infiniband/ulp/srpt/ib_srpt.c |  1 +
>  include/rdma/ib_mad.h                 |  2 ++
>  6 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index e3a95d1..ad3726d 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -3503,6 +3503,7 @@ int ib_cm_notify(struct ib_cm_id *cm_id, enum ib_event_type event)
>  EXPORT_SYMBOL(ib_cm_notify);
>  
>  static void cm_recv_handler(struct ib_mad_agent *mad_agent,
> +			    struct ib_mad_send_buf *send_buf,
>  			    struct ib_mad_recv_wc *mad_recv_wc)
>  {
>  	struct cm_port *port = mad_agent->context;
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index d4d2a61..cbe232a 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -693,7 +693,7 @@ static void snoop_recv(struct ib_mad_qp_info *qp_info,
>  
>  		atomic_inc(&mad_snoop_priv->refcount);
>  		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
> -		mad_snoop_priv->agent.recv_handler(&mad_snoop_priv->agent,
> +		mad_snoop_priv->agent.recv_handler(&mad_snoop_priv->agent, NULL,
>  						   mad_recv_wc);
>  		deref_snoop_agent(mad_snoop_priv);
>  		spin_lock_irqsave(&qp_info->snoop_lock, flags);
> @@ -1994,9 +1994,9 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>  				/* user rmpp is in effect
>  				 * and this is an active RMPP MAD
>  				 */
> -				mad_recv_wc->wc->wr_id = 0;
> -				mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
> -								   mad_recv_wc);
> +				mad_agent_priv->agent.recv_handler(
> +						&mad_agent_priv->agent, NULL,
> +						mad_recv_wc);
>  				atomic_dec(&mad_agent_priv->refcount);
>  			} else {
>  				/* not user rmpp, revert to normal behavior and
> @@ -2010,9 +2010,10 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>  			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>  
>  			/* Defined behavior is to complete response before request */
> -			mad_recv_wc->wc->wr_id = (unsigned long) &mad_send_wr->send_buf;
> -			mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
> -							   mad_recv_wc);
> +			mad_agent_priv->agent.recv_handler(
> +					&mad_agent_priv->agent,
> +					&mad_send_wr->send_buf,
> +					mad_recv_wc);
>  			atomic_dec(&mad_agent_priv->refcount);
>  
>  			mad_send_wc.status = IB_WC_SUCCESS;
> @@ -2021,7 +2022,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>  			ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
>  		}
>  	} else {
> -		mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
> +		mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent, NULL,
>  						   mad_recv_wc);
>  		deref_mad_agent(mad_agent_priv);
>  	}
> @@ -2762,6 +2763,7 @@ static void local_completions(struct work_struct *work)
>  					   IB_MAD_SNOOP_RECVS);
>  			recv_mad_agent->agent.recv_handler(
>  						&recv_mad_agent->agent,
> +						&local->mad_send_wr->send_buf,
>  						&local->mad_priv->header.recv_wc);
>  			spin_lock_irqsave(&recv_mad_agent->lock, flags);
>  			atomic_dec(&recv_mad_agent->refcount);
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index e364a42..1f91b6e 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -1669,14 +1669,15 @@ static void send_handler(struct ib_mad_agent *agent,
>  }
>  
>  static void recv_handler(struct ib_mad_agent *mad_agent,
> +			 struct ib_mad_send_buf *send_buf,
>  			 struct ib_mad_recv_wc *mad_recv_wc)
>  {
>  	struct ib_sa_query *query;
> -	struct ib_mad_send_buf *mad_buf;
>  
> -	mad_buf = (void *) (unsigned long) mad_recv_wc->wc->wr_id;
> -	query = mad_buf->context[0];
> +	if (!send_buf)
> +		return;
>  
> +	query = send_buf->context[0];
>  	if (query->callback) {
>  		if (mad_recv_wc->wc->status == IB_WC_SUCCESS)
>  			query->callback(query,
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
> index 57f281f..415a318 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -210,6 +210,7 @@ static void send_handler(struct ib_mad_agent *agent,
>  }
>  
>  static void recv_handler(struct ib_mad_agent *agent,
> +			 struct ib_mad_send_buf *send_buf,
>  			 struct ib_mad_recv_wc *mad_recv_wc)
>  {
>  	struct ib_umad_file *file = agent->context;
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 105512d..1d78de1 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -455,6 +455,7 @@ static void srpt_mad_send_handler(struct ib_mad_agent *mad_agent,
>   * srpt_mad_recv_handler() - MAD reception callback function.
>   */
>  static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
> +				  struct ib_mad_send_buf *send_buf,
>  				  struct ib_mad_recv_wc *mad_wc)
>  {
>  	struct srpt_port *sport = (struct srpt_port *)mad_agent->context;
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index ec9b44d..61c5baa 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -438,6 +438,7 @@ typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
>  /**
>   * ib_mad_recv_handler - callback handler for a received MAD.
>   * @mad_agent: MAD agent requesting the received MAD.
> + * @send_buf: Send buffer if found, else NULL
>   * @mad_recv_wc: Received work completion information on the received MAD.
>   *
>   * MADs received in response to a send request operation will be handed to
> @@ -447,6 +448,7 @@ typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
>   * modify the data referenced by @mad_recv_wc.
>   */
>  typedef void (*ib_mad_recv_handler)(struct ib_mad_agent *mad_agent,
> +			 	    struct ib_mad_send_buf *send_buf,
>  				    struct ib_mad_recv_wc *mad_recv_wc);
>  
>  /**
> -- 
> 1.9.1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
