From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/srp: rename some symbolic constants
Date: Mon, 02 Aug 2010 17:23:47 -0400
Message-ID: <1280784227.2451.72.camel@lap75545.ornl.gov>
References: <201008021732.38682.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008021732.38682.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> The patch below realizes the following transformations on the symbolic
> constants defined in ib_srp.h and used in ib_srp.h and ib_srp.c:
> * Added the constants SRP_RQ_MASK and SRP_SQ_MASK.
> * Renamed SRP_SQ_SIZE into SRP_REQ_SQ_SIZE.
> * Changed the value of SRP_SQ_SIZE from 63 to 64.
> 
> Note: this patch does not change the behavior of ib_srp in any way.

I don't mean to single you out on this Bart -- I've seen a lot of these
lately from many different people -- but I'm not keen on this style of
commit message. I can easily see that you changed values, added
constants, and the like from the patch. What doesn't show up in the
patch is the why.

Something like the following I think captures the intent better:

    IB/srp: differentiate the uses of SRP_SQ_SIZE

    SRP_SQ_SIZE was used in many places that needed to know about the
    real size of the data structures, and needed to use a magic offset.
    Additionally, the meaning of the value was different depending on
    where it was used. Prepare for future work by naming the use
    appropriately for the site.

You don't have to use that wording, of course. It's just an example of
capturing the motivation of a patch.

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 39a69b7..8252a45 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -248,7 +248,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
>  	}
>  
>  	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
> -				       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
> +				       srp_send_completion, NULL, target,
> +				       SRP_REQ_SQ_SIZE, 0);

Since we'll have to process completions from sending responses as well,
shouldn't this remain SRP_SQ_SIZE? Maybe that should be addressed in the
next patch that starts sending those responses, but it seems silly to
make this change only to revert it in the next one in the series.

If you decide to leave it as SRP_SQ_SIZE in this patch, it would
probably be helpful to mention why it wasn't touched, in order to help
other reviewers.

> @@ -268,7 +269,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
>  	}
>  
>  	init_attr->event_handler       = srp_qp_event;
> -	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
> +	init_attr->cap.max_send_wr     = SRP_REQ_SQ_SIZE;

Similarly here.

> @@ -1051,7 +1052,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
>  
>  	srp_send_completion(target->send_cq, target);
>  
> -	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
> +	if (target->tx_head - target->tx_tail >= SRP_REQ_SQ_SIZE)
>  		return NULL;

I'm not keen on the name SRP_REQ_SQ_SIZE. I had used SRP_SQ_FULL here
and SRP_MAX_CREDIT elsewhere to be more descriptive of their use, but
I'm not sold on those names either. Anyone have better ideas?

Also, the portion of the original patch that checked that the ring sizes
were a power of 2 seem to have been dropped. Now that we have a macro
for that -- BUILD_BUG_ON_NOT_POWER_OF_2() -- I think they could be added
cleanly.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
