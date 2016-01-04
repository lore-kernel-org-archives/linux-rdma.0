From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Sun, 3 Jan 2016 22:19:27 -0500
Message-ID: <20160104031927.GC329@phlsvsds.ph.intel.com>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com> <20151229091730.GA8445@infradead.org> <56825797.5030008@dev.mellanox.co.il> <20151229174014.GA329@phlsvsds.ph.intel.com> <20151230110133.GA4859@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151230110133.GA4859-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 30, 2015 at 03:01:33AM -0800, Christoph Hellwig wrote:
> Hi Ira,
> 
> please take a look at the patches I've attached - they are just WIP
> that hasn't been tested as I'm on a vacation without access to my
> IB setup until New Year's Eve.
> 
> Patch 1 is I think a genuine bug fix caused by the madness (pun
> intendended) of the wr_id abuses.
> 
> Patch 2: passes the mad_send_buf explicitily to mad handlers to get rid
> of that mess.
> 
> Patch 3 is the CQ API conversion which becomes relatively simple once
> the prior issues above are sorted out.
> 

I've tested all 3 patches together and things seem to be working just fine.
That said I have some comments below.

> From a22609131ca353278015b6b4aec3077db06ad9f5 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Wed, 30 Dec 2015 11:49:22 +0100
> Subject: IB/mad: pass send buf in wr_id in local_completions
> 
> The sa_query recv_handler expects the send_buf in wr_id, and all other recv
> handlers ignore wr_id.  It seems this is what we should pass, please confirm.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index d4d2a61..e0859e5 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -2734,7 +2734,7 @@ static void local_completions(struct work_struct *work)
>  			 * before request
>  			 */
>  			build_smp_wc(recv_mad_agent->agent.qp,
> -				     (unsigned long) local->mad_send_wr,
> +				     (unsigned long) &local->mad_send_wr->send_buf,

This is not right.

local_completions is only called for locally processed SMP packets (not SA
packets).  SMPs use the wr_id assigned by ib_create_send_mad (which points to
the internal struct ib_mad_send_wr_private object.)

It seems like a better fix (to make the code more explicit) would be:

20:08:58 > git di
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e0859e515b47..2840f27a18a0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2734,7 +2734,7 @@ static void local_completions(struct work_struct *work)
                         * before request
                         *                          */
                        build_smp_wc(recv_mad_agent->agent.qp,
-                                    (unsigned long) &local->mad_send_wr->send_buf,
+                                    local->mad_send_wr->send_wr.wr.wr_id,
                                     be16_to_cpu(IB_LID_PERMISSIVE),
                                     local->mad_send_wr->send_wr.pkey_index,
                                     recv_mad_agent->agent.port_num, &wc);

But this is just removed later anyway.


All that said I agree there is some hackyness (or as you said "abuse" in the
wr_id) in that the SA is depending on this code in ib_mad.

2013     mad_recv_wc->wc->wr_id = (unsigned long) &mad_send_wr->send_buf;
2014     mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
2015                                        mad_recv_wc);

Who is in control of wr_id is confusing in this area of the code.  For that
reason I like your next patch which makes this explicit throughout.


>  				     be16_to_cpu(IB_LID_PERMISSIVE),
>  				     local->mad_send_wr->send_wr.pkey_index,
>  				     recv_mad_agent->agent.port_num, &wc);
> -- 
> 1.9.1
> 

> From c6101bfa6543d0b35c2ca2fa0add09341f456e88 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Wed, 30 Dec 2015 11:54:02 +0100
> Subject: IB/mad: pass ib_mad_send_buf explicitly to the recv_handler
> 
> Stop abusing wr_id and just pass the parameter explicitly.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c          |  1 +
>  drivers/infiniband/core/mad.c         | 18 ++++++++++--------
>  drivers/infiniband/core/sa_query.c    |  7 ++-----
>  drivers/infiniband/core/user_mad.c    |  1 +
>  drivers/infiniband/ulp/srpt/ib_srpt.c |  1 +
>  include/rdma/ib_mad.h                 |  2 ++
>  6 files changed, 17 insertions(+), 13 deletions(-)
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
> index e0859e5..f15fcd6 100644
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
> index e364a42..982af30 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -1669,13 +1669,10 @@ static void send_handler(struct ib_mad_agent *agent,
>  }
>  
>  static void recv_handler(struct ib_mad_agent *mad_agent,
> +			 struct ib_mad_send_buf *send_buf,
>  			 struct ib_mad_recv_wc *mad_recv_wc)
>  {
> -	struct ib_sa_query *query;
> -	struct ib_mad_send_buf *mad_buf;
> -
> -	mad_buf = (void *) (unsigned long) mad_recv_wc->wc->wr_id;
> -	query = mad_buf->context[0];
> +	struct ib_sa_query *query = send_buf->context[0];

It seems that you should check for NULL here as the interface you have defined
allows for that.

I'm still going over the final patch but it seems ok from a quick over view.

Ira

>  
>  	if (query->callback) {
>  		if (mad_recv_wc->wc->status == IB_WC_SUCCESS)
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

> From 0a367aa36e5410f41333d613b7587913b57eb75f Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Wed, 30 Dec 2015 11:55:32 +0100
> Subject: IB/mad: use CQ abstraction
> 
> Remove the local workqueue to process mad completions and use the CQ API
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c      | 154 +++++++++++++------------------------
>  drivers/infiniband/core/mad_priv.h |   2 +-
>  2 files changed, 55 insertions(+), 101 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index f15fcd6..b04ad05 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -61,18 +61,6 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>  
> -/*
> - * Define a limit on the number of completions which will be processed by the
> - * worker thread in a single work item.  This ensures that other work items
> - * (potentially from other users) are processed fairly.
> - *
> - * The number of completions was derived from the default queue sizes above.
> - * We use a value which is double the larger of the 2 queues (receive @ 512)
> - * but keep it fixed such that an increase in that value does not introduce
> - * unfairness.
> - */
> -#define MAD_COMPLETION_PROC_LIMIT 1024
> -
>  static struct list_head ib_mad_port_list;
>  static u32 ib_mad_client_id = 0;
>  
> @@ -96,6 +84,9 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
>  			      u8 mgmt_class);
>  static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
>  			   struct ib_mad_agent_private *agent_priv);
> +static bool mad_error_handler(struct ib_mad_port_private *port_priv,
> +			      struct ib_wc *wc);
> +static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc);
>  
>  /*
>   * Returns a ib_mad_port_private structure or NULL for a device/port
> @@ -702,11 +693,11 @@ static void snoop_recv(struct ib_mad_qp_info *qp_info,
>  }
>  
>  static void build_smp_wc(struct ib_qp *qp,
> -			 u64 wr_id, u16 slid, u16 pkey_index, u8 port_num,
> +			 void *wr_cqe, u16 slid, u16 pkey_index, u8 port_num,
>  			 struct ib_wc *wc)
>  {
>  	memset(wc, 0, sizeof *wc);
> -	wc->wr_id = wr_id;
> +	wc->wr_cqe = wr_cqe;
>  	wc->status = IB_WC_SUCCESS;
>  	wc->opcode = IB_WC_RECV;
>  	wc->pkey_index = pkey_index;
> @@ -844,7 +835,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>  	}
>  
>  	build_smp_wc(mad_agent_priv->agent.qp,
> -		     send_wr->wr.wr_id, drslid,
> +		     send_wr->wr.wr_cqe, drslid,
>  		     send_wr->pkey_index,
>  		     send_wr->port_num, &mad_wc);
>  
> @@ -1051,7 +1042,9 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
>  
>  	mad_send_wr->sg_list[1].lkey = mad_agent->qp->pd->local_dma_lkey;
>  
> -	mad_send_wr->send_wr.wr.wr_id = (unsigned long) mad_send_wr;
> +	mad_send_wr->mad_list.cqe.done = ib_mad_send_done;
> +
> +	mad_send_wr->send_wr.wr.wr_cqe = &mad_send_wr->mad_list.cqe;
>  	mad_send_wr->send_wr.wr.sg_list = mad_send_wr->sg_list;
>  	mad_send_wr->send_wr.wr.num_sge = 2;
>  	mad_send_wr->send_wr.wr.opcode = IB_WR_SEND;
> @@ -1163,8 +1156,9 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
>  
>  	/* Set WR ID to find mad_send_wr upon completion */
>  	qp_info = mad_send_wr->mad_agent_priv->qp_info;
> -	mad_send_wr->send_wr.wr.wr_id = (unsigned long)&mad_send_wr->mad_list;
>  	mad_send_wr->mad_list.mad_queue = &qp_info->send_queue;
> +	mad_send_wr->mad_list.cqe.done = ib_mad_send_done;
> +	mad_send_wr->send_wr.wr.wr_cqe = &mad_send_wr->mad_list.cqe;
>  
>  	mad_agent = mad_send_wr->send_buf.mad_agent;
>  	sge = mad_send_wr->sg_list;
> @@ -2185,13 +2179,14 @@ handle_smi(struct ib_mad_port_private *port_priv,
>  	return handle_ib_smi(port_priv, qp_info, wc, port_num, recv, response);
>  }
>  
> -static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
> -				     struct ib_wc *wc)
> +static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
> +	struct ib_mad_port_private *port_priv = cq->cq_context;
> +	struct ib_mad_list_head *mad_list =
> +		container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
>  	struct ib_mad_qp_info *qp_info;
>  	struct ib_mad_private_header *mad_priv_hdr;
>  	struct ib_mad_private *recv, *response = NULL;
> -	struct ib_mad_list_head *mad_list;
>  	struct ib_mad_agent_private *mad_agent;
>  	int port_num;
>  	int ret = IB_MAD_RESULT_SUCCESS;
> @@ -2199,7 +2194,17 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
>  	u16 resp_mad_pkey_index = 0;
>  	bool opa;
>  
> -	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
> +	if (list_empty_careful(&port_priv->port_list))
> +		return;
> +
> +	if (wc->status != IB_WC_SUCCESS) {
> +		/*
> +		 * Receive errors indicate that the QP has entered the error
> +		 * state - error handling/shutdown code will cleanup
> +		 */
> +		return;
> +	}
> +
>  	qp_info = mad_list->mad_queue->qp_info;
>  	dequeue_mad(mad_list);
>  
> @@ -2240,7 +2245,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
>  	response = alloc_mad_private(mad_size, GFP_KERNEL);
>  	if (!response) {
>  		dev_err(&port_priv->device->dev,
> -			"ib_mad_recv_done_handler no memory for response buffer\n");
> +			"%s: no memory for response buffer\n", __func__);

NIT: Technically an unrelated change...

>  		goto out;
>  	}
>  
> @@ -2426,11 +2431,12 @@ done:
>  	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>  }
>  
> -static void ib_mad_send_done_handler(struct ib_mad_port_private *port_priv,
> -				     struct ib_wc *wc)
> +static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
> +	struct ib_mad_port_private *port_priv = cq->cq_context;
> +	struct ib_mad_list_head *mad_list =
> +		container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
>  	struct ib_mad_send_wr_private	*mad_send_wr, *queued_send_wr;
> -	struct ib_mad_list_head		*mad_list;
>  	struct ib_mad_qp_info		*qp_info;
>  	struct ib_mad_queue		*send_queue;
>  	struct ib_send_wr		*bad_send_wr;
> @@ -2438,7 +2444,14 @@ static void ib_mad_send_done_handler(struct ib_mad_port_private *port_priv,
>  	unsigned long flags;
>  	int ret;
>  
> -	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
> +	if (list_empty_careful(&port_priv->port_list))
> +		return;
> +
> +	if (wc->status != IB_WC_SUCCESS) {
> +		if (!mad_error_handler(port_priv, wc))
> +			return;
> +	}
> +
>  	mad_send_wr = container_of(mad_list, struct ib_mad_send_wr_private,
>  				   mad_list);
>  	send_queue = mad_list->mad_queue;
> @@ -2503,24 +2516,15 @@ static void mark_sends_for_retry(struct ib_mad_qp_info *qp_info)
>  	spin_unlock_irqrestore(&qp_info->send_queue.lock, flags);
>  }
>  
> -static void mad_error_handler(struct ib_mad_port_private *port_priv,
> +static bool mad_error_handler(struct ib_mad_port_private *port_priv,
>  			      struct ib_wc *wc)
>  {
> -	struct ib_mad_list_head *mad_list;
> -	struct ib_mad_qp_info *qp_info;
> +	struct ib_mad_list_head *mad_list =
> +		container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
> +	struct ib_mad_qp_info *qp_info = mad_list->mad_queue->qp_info;
>  	struct ib_mad_send_wr_private *mad_send_wr;
>  	int ret;
>  
> -	/* Determine if failure was a send or receive */
> -	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
> -	qp_info = mad_list->mad_queue->qp_info;
> -	if (mad_list->mad_queue == &qp_info->recv_queue)
> -		/*
> -		 * Receive errors indicate that the QP has entered the error
> -		 * state - error handling/shutdown code will cleanup
> -		 */
> -		return;
> -
>  	/*
>  	 * Send errors will transition the QP to SQE - move
>  	 * QP to RTS and repost flushed work requests
> @@ -2535,10 +2539,9 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
>  			mad_send_wr->retry = 0;
>  			ret = ib_post_send(qp_info->qp, &mad_send_wr->send_wr.wr,
>  					&bad_send_wr);
> -			if (ret)
> -				ib_mad_send_done_handler(port_priv, wc);
> -		} else
> -			ib_mad_send_done_handler(port_priv, wc);
> +			if (!ret)
> +				return false;
> +		}
>  	} else {
>  		struct ib_qp_attr *attr;
>  
> @@ -2557,43 +2560,9 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
>  			else
>  				mark_sends_for_retry(qp_info);
>  		}
> -		ib_mad_send_done_handler(port_priv, wc);
>  	}
> -}
>  
> -/*
> - * IB MAD completion callback
> - */
> -static void ib_mad_completion_handler(struct work_struct *work)
> -{
> -	struct ib_mad_port_private *port_priv;
> -	struct ib_wc wc;
> -	int count = 0;
> -
> -	port_priv = container_of(work, struct ib_mad_port_private, work);
> -	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
> -
> -	while (ib_poll_cq(port_priv->cq, 1, &wc) == 1) {
> -		if (wc.status == IB_WC_SUCCESS) {
> -			switch (wc.opcode) {
> -			case IB_WC_SEND:
> -				ib_mad_send_done_handler(port_priv, &wc);
> -				break;
> -			case IB_WC_RECV:
> -				ib_mad_recv_done_handler(port_priv, &wc);
> -				break;
> -			default:
> -				BUG_ON(1);
> -				break;
> -			}
> -		} else
> -			mad_error_handler(port_priv, &wc);
> -
> -		if (++count > MAD_COMPLETION_PROC_LIMIT) {
> -			queue_work(port_priv->wq, &port_priv->work);
> -			break;
> -		}
> -	}
> +	return true;
>  }
>  
>  static void cancel_mads(struct ib_mad_agent_private *mad_agent_priv)
> @@ -2734,8 +2703,7 @@ static void local_completions(struct work_struct *work)
>  			 * Defined behavior is to complete response
>  			 * before request
>  			 */
> -			build_smp_wc(recv_mad_agent->agent.qp,
> -				     (unsigned long) &local->mad_send_wr->send_buf,
> +			build_smp_wc(recv_mad_agent->agent.qp, NULL,
>  				     be16_to_cpu(IB_LID_PERMISSIVE),
>  				     local->mad_send_wr->send_wr.pkey_index,
>  				     recv_mad_agent->agent.port_num, &wc);
> @@ -2875,17 +2843,6 @@ static void timeout_sends(struct work_struct *work)
>  	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>  }
>  
> -static void ib_mad_thread_completion_handler(struct ib_cq *cq, void *arg)
> -{
> -	struct ib_mad_port_private *port_priv = cq->cq_context;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&ib_mad_port_list_lock, flags);
> -	if (!list_empty(&port_priv->port_list))
> -		queue_work(port_priv->wq, &port_priv->work);
> -	spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
> -}
> -
>  /*
>   * Allocate receive MADs and post receive WRs for them
>   */
> @@ -2933,8 +2890,9 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
>  			break;
>  		}
>  		mad_priv->header.mapping = sg_list.addr;
> -		recv_wr.wr_id = (unsigned long)&mad_priv->header.mad_list;
>  		mad_priv->header.mad_list.mad_queue = recv_queue;
> +		mad_priv->header.mad_list.cqe.done = ib_mad_recv_done;
> +		recv_wr.wr_cqe = &mad_priv->header.mad_list.cqe;
>  
>  		/* Post receive WR */
>  		spin_lock_irqsave(&recv_queue->lock, flags);
> @@ -3171,7 +3129,6 @@ static int ib_mad_port_open(struct ib_device *device,
>  	unsigned long flags;
>  	char name[sizeof "ib_mad123"];
>  	int has_smi;
> -	struct ib_cq_init_attr cq_attr = {};
>  
>  	if (WARN_ON(rdma_max_mad_size(device, port_num) < IB_MGMT_MAD_SIZE))
>  		return -EFAULT;
> @@ -3199,10 +3156,8 @@ static int ib_mad_port_open(struct ib_device *device,
>  	if (has_smi)
>  		cq_size *= 2;
>  
> -	cq_attr.cqe = cq_size;
> -	port_priv->cq = ib_create_cq(port_priv->device,
> -				     ib_mad_thread_completion_handler,
> -				     NULL, port_priv, &cq_attr);
> +	port_priv->cq = ib_alloc_cq(port_priv->device, port_priv, cq_size, 0,
> +			IB_POLL_WORKQUEUE);
>  	if (IS_ERR(port_priv->cq)) {
>  		dev_err(&device->dev, "Couldn't create ib_mad CQ\n");
>  		ret = PTR_ERR(port_priv->cq);
> @@ -3231,7 +3186,6 @@ static int ib_mad_port_open(struct ib_device *device,
>  		ret = -ENOMEM;
>  		goto error8;
>  	}
> -	INIT_WORK(&port_priv->work, ib_mad_completion_handler);
>  
>  	spin_lock_irqsave(&ib_mad_port_list_lock, flags);
>  	list_add_tail(&port_priv->port_list, &ib_mad_port_list);
> @@ -3258,7 +3212,7 @@ error7:
>  error6:
>  	ib_dealloc_pd(port_priv->pd);
>  error4:
> -	ib_destroy_cq(port_priv->cq);
> +	ib_free_cq(port_priv->cq);
>  	cleanup_recv_queue(&port_priv->qp_info[1]);
>  	cleanup_recv_queue(&port_priv->qp_info[0]);
>  error3:
> @@ -3291,7 +3245,7 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
>  	destroy_mad_qp(&port_priv->qp_info[1]);
>  	destroy_mad_qp(&port_priv->qp_info[0]);
>  	ib_dealloc_pd(port_priv->pd);
> -	ib_destroy_cq(port_priv->cq);
> +	ib_free_cq(port_priv->cq);
>  	cleanup_recv_queue(&port_priv->qp_info[1]);
>  	cleanup_recv_queue(&port_priv->qp_info[0]);
>  	/* XXX: Handle deallocation of MAD registration tables */
> diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
> index 990698a..28669f6 100644
> --- a/drivers/infiniband/core/mad_priv.h
> +++ b/drivers/infiniband/core/mad_priv.h
> @@ -64,6 +64,7 @@
>  
>  struct ib_mad_list_head {
>  	struct list_head list;
> +	struct ib_cqe cqe;
>  	struct ib_mad_queue *mad_queue;
>  };
>  
> @@ -204,7 +205,6 @@ struct ib_mad_port_private {
>  	struct ib_mad_mgmt_version_table version[MAX_MGMT_VERSION];
>  	struct list_head agent_list;
>  	struct workqueue_struct *wq;
> -	struct work_struct work;
>  	struct ib_mad_qp_info qp_info[IB_MAD_QPS_CORE];
>  };
>  
> -- 
> 1.9.1
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
