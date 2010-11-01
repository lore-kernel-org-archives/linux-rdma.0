From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RPING: Make sure CQ event thread exits before destroying
 the CQ.
Date: Mon, 01 Nov 2010 12:14:36 -0500
Message-ID: <4CCEF57C.60306@opengridcomputing.com>
References: <20101025194309.11127.29600.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025194309.11127.29600.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

Thoughts on this?

I did quick rping tests on mthca, mlx4 and T3.  Tested out ok.


Steve.


On 10/25/2010 02:43 PM, Steve Wise wrote:
> It is possible for the CQ event thread to poll the CQ after it has been
> destroyed which can result in a seg fault on T3 interfaces.  This patch
> waits for the thread to exit before destroying the CQ.
>
> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
>   examples/rping.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/examples/rping.c b/examples/rping.c
> index b58ea74..a8af4d6 100644
> --- a/examples/rping.c
> +++ b/examples/rping.c
> @@ -280,12 +280,11 @@ static int rping_cq_event_handler(struct rping_cb *cb)
>   		ret = 0;
>
>   		if (wc.status) {
> -			if (wc.status != IBV_WC_WR_FLUSH_ERR) {
> +			if (wc.status != IBV_WC_WR_FLUSH_ERR)
>   				fprintf(stderr,
>   					"cq completion failed status %d\n",
>   					wc.status);
> -				ret = -1;
> -			}
> +			ret = -1;
>   			goto error;
>   		}
>
> @@ -802,10 +801,9 @@ static void *rping_persistent_server_thread(void *arg)
>
>   	rping_test_server(cb);
>   	rdma_disconnect(cb->child_cm_id);
> +	pthread_join(cb->cqthread, NULL);
>   	rping_free_buffers(cb);
>   	rping_free_qp(cb);
> -	pthread_cancel(cb->cqthread);
> -	pthread_join(cb->cqthread, NULL);
>   	rdma_destroy_id(cb->child_cm_id);
>   	free_cb(cb);
>   	return NULL;
> @@ -890,6 +888,7 @@ static int rping_run_server(struct rping_cb *cb)
>
>   	rping_test_server(cb);
>   	rdma_disconnect(cb->child_cm_id);
> +	pthread_join(cb->cqthread, NULL);
>   	rdma_destroy_id(cb->child_cm_id);
>   err2:
>   	rping_free_buffers(cb);
> @@ -1057,6 +1056,7 @@ static int rping_run_client(struct rping_cb *cb)
>
>   	rping_test_client(cb);
>   	rdma_disconnect(cb->cm_id);
> +	pthread_join(cb->cqthread, NULL);
>   err2:
>   	rping_free_buffers(cb);
>   err1:
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
