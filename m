From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: use IB_CQ_REPORT_MISSED_EVENTS to avoid
 missed CQ callbacks
Date: Wed, 31 Mar 2010 12:20:45 -0700
Message-ID: <1270063245.4192.299.camel@chromite.mv.qlogic.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	 <20100331175747.24522.88472.stgit@chromite.mv.qlogic.com>
	 <ada4ojwjqz7.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4ojwjqz7.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The way I understand the sequence of events w/o the
patch is:

ib_req_notify_cq(IB_CQ_NEXT_COMP)
CQE 1 added to queue
	callback scheduled via tasklet
	future callbacks disarmed
callback function calls ib_req_notify_cq(IB_CQ_NEXT_COMP)
callback function calls ib_poll_cq() and gets CQE 1
callback function calls ib_poll_cq() and gets none
CQE 2 added to queue via IRQ
	callback scheduled via tasklet
	future callbacks disarmed
callback function returns
some time later, tasklet runs and calls CQ callback function.
callback function calls ib_req_notify_cq(IB_CQ_NEXT_COMP)
callback function calls ib_poll_cq() and gets CQE 2

Since a tasklet or workqueue can be scheduled in the
callback function, the second CQE isn't "missed" but
there is a scheduling delay before the callback happens
and sees CQE 2.

I guess it is a minor optimization since either CQE 2
will be seen in the first callback while looping in ib_poll_cq()
and then getting a callback later with ib_poll_cq()==0 or
seen in the second callback.

I'm willing to withdraw the 1-3 patches.

I still don't understand why the timing difference matters
to RDS.

On Wed, 2010-03-31 at 11:17 -0700, Roland Dreier wrote:
> > ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
>  > a callback for the next completion entered since there is a race
>  > between arming the callback and another CQE being added to the queue.
>  > The IB_CQ_REPORT_MISSED_EVENTS flag was added to detect this
>  > race and allow the verbs consumer to call ib_poll_cq() and
>  > ib_req_notify_cq() again to avoid delays in processing the CQE.
> 
> I'm not sure I understand the race you're fixing here... the existing
> code does the rearm before polling:
> 
>  > +	int ret;
>  >  
>  >  	port_priv = container_of(work, struct ib_mad_port_private, work);
>  > -	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
>  >  
>  > +again:
>  >  	while (ib_poll_cq(port_priv->cq, 1, &wc) == 1) {
>  >  		if (wc.status == IB_WC_SUCCESS) {
>  >  			switch (wc.opcode) {
>  > @@ -2246,6 +2247,10 @@ static void ib_mad_completion_handler(struct work_struct *work)
>  >  		} else
>  >  			mad_error_handler(port_priv, &wc);
>  >  	}
>  > +	ret = ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP |
>  > +					      IB_CQ_REPORT_MISSED_EVENTS);
>  > +	if (ret > 0)
>  > +		goto again;
> 
> The only issue with the existing code is that it may trigger extra
> events that will find the CQ empty when polling.
> 
> So this may be a valid optimization but I don't see it fixing any missed
> events.  Am I missing something?
> 
> Also for all these fixes, I think you only want to rearm the CQ once and
> go back and poll if you get a missed events warning; the next time the
> CQ is empty, then you know another event will happen.
> 
>  - R.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
