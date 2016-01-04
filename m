From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Mon, 4 Jan 2016 01:55:35 -0500
Message-ID: <20160104065535.GE329@phlsvsds.ph.intel.com>
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

[snip]

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

I'm not sure if it is absolutely required to assign cqe.done in both
ib_create_send_mad and ib_send_mad.  But I don't think it hurts either.

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

NIT: I would change this to be send_mad_err_handler...

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

For consistency I think we should use local->mad_send_wr->send_wr.wr.wr_cqe
here as mad_send_wr is passed through from handle_outgoing_dr_smp even if the
completion is never going to get called.

Ira

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
