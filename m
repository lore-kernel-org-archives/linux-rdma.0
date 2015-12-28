From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Tue, 29 Dec 2015 01:25:33 +0200
Message-ID: <20151228232533.GB13150@x-vnc01.mtx.labs.mlnx>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com>
 <20151228165130.GA13150@x-vnc01.mtx.labs.mlnx>
 <20151228230546.GA19794@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151228230546.GA19794-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 28, 2015 at 06:05:46PM -0500, ira.weiny wrote:
> 
> Will it hurt to rearm?  The way the code stands I think the worse that will
> happen is an extra work item scheduled and an ib_poll_cq call.

If you re-arm unconditionally you call for extra interrupts which you
can do without. When you break the loop of processing completions since
you exhausted the quota, you queue the work so you can continue
processing completions in the next time slot of the work task. After
queueing the work you should call "return" instead of "break".
If you processed all the completions before reaching
MAD_COMPLETION_PROC_LIMIT you will exit the while loop and then
re-arming can take place.

> 
> I'm not quite sure what you mean about moving the ib_req_notify_cq outside of
> the while loop.  It seems like to do what you say we would need another work
> item which just does ib_poll_cq.  Is that what you meant?
> 
> Ira
> 
> > 
> > > @@ -2574,6 +2587,11 @@ static void ib_mad_completion_handler(struct work_struct *work)
> > >  			}
> > >  		} else
> > >  			mad_error_handler(port_priv, &wc);
> > > +
> > > +		if (++count > MAD_COMPLETION_PROC_LIMIT) {
> > > +			queue_work(port_priv->wq, &port_priv->work);
> > > +			break;
> > > +		}
> > >  	}
> > >  }
> > >  
> > > -- 
> > > 1.8.2
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
