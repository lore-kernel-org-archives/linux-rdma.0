From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IB/iSER-Target: Release connection resources
 properly when receiving RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Tue, 2 Aug 2016 12:15:47 +0300
Message-ID: <eb8c2e34-0815-85fd-3218-4497f8f6975d@grimberg.me>
References: <20160802084635.14414-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160802084635.14414-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> When the low level driver exercises the hot unplug they would call
> rdma_cm cma_remove_one which would fire DEVICE_REMOVAL event to all cma
> consumers. Now, if consumer doesn't make sure they destroy all IB
> objects created on that IB device instance prior to finalizing all
> processing of DEVICE_REMOVAL callback, rdma_cm will let the lld to
> de-register with IB core and destroy the IB device instance. And if the
> consumer calls (say) ib_dereg_mr(), it will crash since that dev object
> is NULL.
>
> In the current implementation, iser-target just initiates the cleanup
> and returns from DEVICE_REMOVAL callback. This deferred work creates a
> race between iser-target cleaning IB objects(say MR) and lld destroying
> IB device instance.
>
> This patch includes the following fixes
>   -> make sure that consumer frees all IB objects associated with device
>      instance
>   -> return non-zero from the callback to destroy the rdma_cm id
>
> Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
> Changes since v1:
> - Added S.O.B note

Hi Raju,

I forgot to mention it, but iser-target patches usually go via the
scsi target tree. CCing target-devel and Nic.

And, you forgot my ack tag:

Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

>
>  drivers/infiniband/ulp/isert/ib_isert.c | 23 ++++++++++++++++++++---
>  drivers/infiniband/ulp/isert/ib_isert.h |  2 ++
>  2 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index a990c04..3dfd903 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -405,6 +405,7 @@ isert_init_conn(struct isert_conn *isert_conn)
>  	INIT_LIST_HEAD(&isert_conn->node);
>  	init_completion(&isert_conn->login_comp);
>  	init_completion(&isert_conn->login_req_comp);
> +	init_waitqueue_head(&isert_conn->rem_wait);
>  	kref_init(&isert_conn->kref);
>  	mutex_init(&isert_conn->mutex);
>  	INIT_WORK(&isert_conn->release_work, isert_release_work);
> @@ -580,7 +581,8 @@ isert_connect_release(struct isert_conn *isert_conn)
>  	BUG_ON(!device);
>
>  	isert_free_rx_descriptors(isert_conn);
> -	if (isert_conn->cm_id)
> +	if (isert_conn->cm_id &&
> +	    !isert_conn->dev_removed)
>  		rdma_destroy_id(isert_conn->cm_id);
>
>  	if (isert_conn->qp) {
> @@ -595,7 +597,10 @@ isert_connect_release(struct isert_conn *isert_conn)
>
>  	isert_device_put(device);
>
> -	kfree(isert_conn);
> +	if (isert_conn->dev_removed)
> +		wake_up_interruptible(&isert_conn->rem_wait);
> +	else
> +		kfree(isert_conn);
>  }
>
>  static void
> @@ -755,6 +760,7 @@ static int
>  isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>  {
>  	struct isert_np *isert_np = cma_id->context;
> +	struct isert_conn *isert_conn;
>  	int ret = 0;
>
>  	isert_info("%s (%d): status %d id %p np %p\n",
> @@ -775,10 +781,21 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>  		break;
>  	case RDMA_CM_EVENT_ADDR_CHANGE:    /* FALLTHRU */
>  	case RDMA_CM_EVENT_DISCONNECTED:   /* FALLTHRU */
> -	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
>  	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
>  		ret = isert_disconnected_handler(cma_id, event->event);
>  		break;
> +	case RDMA_CM_EVENT_DEVICE_REMOVAL:
> +		isert_conn = cma_id->qp->qp_context;
> +		isert_conn->dev_removed = true;
> +		isert_disconnected_handler(cma_id, event->event);
> +		wait_event_interruptible(isert_conn->rem_wait,
> +					 isert_conn->state == ISER_CONN_DOWN);
> +		kfree(isert_conn);
> +		/*
> +		 * return non-zero from the callback to destroy
> +		 * the rdma cm id
> +		 */
> +		return 1;
>  	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
>  	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
>  	case RDMA_CM_EVENT_CONNECT_ERROR:
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
> index e512ba9..d0c5c2c 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.h
> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
> @@ -159,6 +159,8 @@ struct isert_conn {
>  	struct work_struct	release_work;
>  	bool                    logout_posted;
>  	bool                    snd_w_inv;
> +	wait_queue_head_t       rem_wait;
> +	bool                    dev_removed;
>  };
>
>  #define ISERT_MAX_CQ 64
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
