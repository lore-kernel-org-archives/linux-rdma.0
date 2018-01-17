From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 2/4] nvmet-rdma: notify QP on Last WQE Reached event arrival
Date: Wed, 17 Jan 2018 09:37:02 -0600
Message-ID: <02bf01d38fa9$05254550$0f6fcff0$@opengridcomputing.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com> <1516197178-26493-3-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197178-26493-3-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> In order to avoid resource leakage for QP associated with
> a Shared Receive Queue (SRQ), notify it on Last WQE Reached
> event arrival.
> 
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/nvme/target/rdma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 4991290..99a14a7 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1151,6 +1151,9 @@ static void nvmet_rdma_qp_event(struct ib_event
> *event, void *priv)
>  	case IB_EVENT_COMM_EST:
>  		rdma_notify(queue->cm_id, event->event);
>  		break;
> +	case IB_EVENT_QP_LAST_WQE_REACHED:
> +		ib_notify_qp(queue->cm_id->qp, event->event);
> +		break;
>  	default:
>  		pr_err("received IB QP event: %s (%d)\n",
>  		       ib_event_msg(event->event), event->event);

I wonder if this could be handled in ib_dispatch_event() for all ULPS?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
