From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 11/20] ib_srp: Make srp_disconnect_target() wait for IB
 completions
Date: Thu, 23 Aug 2012 17:59:39 +0200
Message-ID: <5036536B.1000003@profitbricks.com>
References: <5023DA39.7020000@acm.org> <5023DCFF.4020709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DCFF.4020709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

we've triggered the WARN_ON() in srp_wait_last_send_wqe() by connecting
to a disabled SCST SRP target.

I would remove that one.

Cheers,
Sebastian

 
On 09.08.2012 17:53, Bart Van Assche wrote:
> Modify srp_disconnect_target() such that it waits until it is
> sure that no new IB completions will be received anymore.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |  104 ++++++++++++++++++++++++++++++-----
>  drivers/infiniband/ulp/srp/ib_srp.h |    6 ++
>  2 files changed, 95 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0e7825a..4de7c46 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -40,7 +40,7 @@
>  #include <linux/parser.h>
>  #include <linux/random.h>
>  #include <linux/jiffies.h>
> -
> +#include <linux/delay.h>
>  #include <linux/atomic.h>
>  
>  #include <scsi/scsi.h>
> @@ -229,14 +229,16 @@ static int srp_create_target_ib(struct srp_target_port *target)
>  		return -ENOMEM;
>  
>  	target->recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
> -				       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
> +				       srp_recv_completion, NULL, target,
> +				       SRP_RQ_SIZE + 1, 0);
>  	if (IS_ERR(target->recv_cq)) {
>  		ret = PTR_ERR(target->recv_cq);
>  		goto err;
>  	}
>  
>  	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
> -				       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
> +				       srp_send_completion, NULL, target,
> +				       SRP_SQ_SIZE + 1, 0);
>  	if (IS_ERR(target->send_cq)) {
>  		ret = PTR_ERR(target->send_cq);
>  		goto err_recv_cq;
> @@ -245,8 +247,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
>  	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
>  
>  	init_attr->event_handler       = srp_qp_event;
> -	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
> -	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
> +	init_attr->cap.max_send_wr     = SRP_SQ_SIZE + 1;
> +	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE + 1;
>  	init_attr->cap.max_recv_sge    = 1;
>  	init_attr->cap.max_send_sge    = 1;
>  	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
> @@ -460,11 +462,69 @@ static bool srp_change_conn_state(struct srp_target_port *target,
>  	return changed;
>  }
>  
> +static void srp_wait_last_recv_wqe(struct srp_target_port *target)
> +{
> +	static struct ib_recv_wr wr = {
> +		.wr_id = SRP_LAST_RECV,
> +	};
> +	struct ib_recv_wr *bad_wr;
> +	int ret;
> +
> +	if (target->last_recv_wqe)
> +		return;
> +
> +	ret = ib_post_recv(target->qp, &wr, &bad_wr);
> +	if (ret < 0) {
> +		shost_printk(KERN_ERR, target->scsi_host,
> +			     "ib_post_recv() failed (%d)\n", ret);
> +		return;
> +	}
> +
> +	ret = wait_event_timeout(target->qp_wq, target->last_recv_wqe,
> +				 target->rq_tmo_jiffies);
> +	WARN(ret <= 0, "Timeout while waiting for last recv WQE (ret = %d)\n",
> +	     ret);
> +}
> +
> +static void srp_wait_last_send_wqe(struct srp_target_port *target)
> +{
> +	static struct ib_send_wr wr = {
> +		.wr_id = SRP_LAST_SEND,
> +	};
> +	struct ib_send_wr *bad_wr;
> +	unsigned long deadline = jiffies + target->rq_tmo_jiffies;
> +	int ret;
> +
> +	if (target->last_send_wqe)
> +		return;
> +
> +	ret = ib_post_send(target->qp, &wr, &bad_wr);
> +	if (ret < 0) {
> +		shost_printk(KERN_ERR, target->scsi_host,
> +			     "ib_post_send() failed (%d)\n", ret);
> +		return;
> +	}
> +
> +	while (!target->last_send_wqe && time_before(jiffies, deadline)) {
> +		srp_send_completion(target->send_cq, target);
> +		msleep(20);
> +	}
> +
> +	WARN_ON(!target->last_send_wqe);

<-- here it is - remove it

> +}
> +
>  static void srp_disconnect_target(struct srp_target_port *target)
>  {
> +	static struct ib_qp_attr qp_attr = {
> +		.qp_state = IB_QPS_ERR
> +	};
> +	int ret;
> +
>  	if (srp_change_conn_state(target, false)) {
>  		/* XXX should send SRP_I_LOGOUT request */
>  
> +		BUG_ON(!target->cm_id);
> +
>  		init_completion(&target->done);
>  		if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
>  			shost_printk(KERN_DEBUG, target->scsi_host,
> @@ -473,6 +533,20 @@ static void srp_disconnect_target(struct srp_target_port *target)
>  			wait_for_completion(&target->done);
>  		}
>  	}
> +
> +	if (target->cm_id) {
> +		ib_destroy_cm_id(target->cm_id);
> +		target->cm_id = NULL;
> +	}
> +
> +	if (target->qp) {
> +		ret = ib_modify_qp(target->qp, &qp_attr, IB_QP_STATE);
> +		WARN(ret != 0, "ib_modify_qp() failed: %d\n", ret);
> +
> +		srp_wait_last_recv_wqe(target);
> +
> +		srp_wait_last_send_wqe(target);
> +	}
>  }
>  
>  static void srp_free_req_data(struct srp_target_port *target)
> @@ -516,7 +590,6 @@ static void srp_remove_target(struct srp_target_port *target)
>  	srp_remove_host(target->scsi_host);
>  	scsi_remove_host(target->scsi_host);
>  	srp_disconnect_target(target);
> -	ib_destroy_cm_id(target->cm_id);
>  	srp_free_target_ib(target);
>  	srp_free_req_data(target);
>  	scsi_host_put(target->scsi_host);
> @@ -544,6 +617,8 @@ static int srp_connect_target(struct srp_target_port *target)
>  	WARN_ON(target->connected);
>  
>  	target->qp_in_error = false;
> +	target->last_recv_wqe = false;
> +	target->last_send_wqe = false;
>  
>  	ret = srp_lookup_path(target);
>  	if (ret)
> @@ -678,7 +753,6 @@ static int srp_reconnect_target(struct srp_target_port *target)
>  {
>  	struct Scsi_Host *shost = target->scsi_host;
>  	struct ib_qp_attr qp_attr;
> -	struct ib_wc wc;
>  	int i, ret;
>  
>  	if (target->state != SRP_TARGET_LIVE)
> @@ -704,11 +778,6 @@ static int srp_reconnect_target(struct srp_target_port *target)
>  	if (ret)
>  		goto err;
>  
> -	while (ib_poll_cq(target->recv_cq, 1, &wc) > 0)
> -		; /* nothing */
> -	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
> -		; /* nothing */
> -
>  	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
>  		struct srp_request *req = &target->req_ring[i];
>  		if (req->scmnd)
> @@ -1285,7 +1354,7 @@ static void srp_handle_qp_err(enum ib_wc_status wc_status,
>  			      enum ib_wc_opcode wc_opcode,
>  			      struct srp_target_port *target)
>  {
> -	if (target->connected)
> +	if (target->connected && !target->qp_in_error)
>  		shost_printk(KERN_ERR, target->scsi_host,
>  			     PFX "failed %s status %d\n",
>  			     wc_opcode & IB_WC_RECV ? "receive" : "send",
> @@ -1303,8 +1372,11 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
>  		if (likely(wc.status == IB_WC_SUCCESS)) {
>  			srp_handle_recv(target, &wc);
>  		} else {
> +			if (wc.wr_id == SRP_LAST_RECV) {
> +				target->last_recv_wqe = true;
> +				wake_up(&target->qp_wq);
> +			}
>  			srp_handle_qp_err(wc.status, wc.opcode, target);
> -			break;
>  		}
>  	}
>  }
> @@ -1320,8 +1392,9 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
>  			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
>  			list_add(&iu->list, &target->free_tx);
>  		} else {
> +			if (wc.wr_id == SRP_LAST_SEND)
> +				target->last_send_wqe = true;
>  			srp_handle_qp_err(wc.status, wc.opcode, target);
> -			break;
>  		}
>  	}
>  }
> @@ -2255,6 +2328,7 @@ static ssize_t srp_create_target(struct device *dev,
>  	spin_lock_init(&target->lock);
>  	INIT_LIST_HEAD(&target->free_tx);
>  	INIT_LIST_HEAD(&target->free_reqs);
> +	init_waitqueue_head(&target->qp_wq);
>  	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
>  		struct srp_request *req = &target->req_ring[i];
>  
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index de2d0b3..1b11117 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -76,6 +76,9 @@ enum {
>  
>  	SRP_MAP_ALLOW_FMR	= 0,
>  	SRP_MAP_NO_FMR		= 1,
> +
> +	SRP_LAST_RECV		= 0,
> +	SRP_LAST_SEND		= 0,
>  };
>  
>  enum srp_target_state {
> @@ -180,6 +183,9 @@ struct srp_target_port {
>  	struct completion	done;
>  	int			status;
>  	bool			qp_in_error;
> +	bool			last_recv_wqe;
> +	bool			last_send_wqe;
> +	wait_queue_head_t	qp_wq;
>  
>  	struct completion	tsk_mgmt_done;
>  	u8			tsk_mgmt_status;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
