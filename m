From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] staging/rdma/hfi1: check for ARMED->ACTIVE transition in receive interrupt
Date: Tue, 5 Jan 2016 13:48:17 -0500
Message-ID: <20160105184814.GA9152@phlsvsds.ph.intel.com>
References: <1451924479-26205-1-git-send-email-jubin.john@intel.com> <20160104202346.GC18146@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160104202346.GC18146-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 04, 2016 at 10:23:46PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 04, 2016 at 11:21:19AM -0500, Jubin John wrote:
> > From: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> >  		} else {
> > +			/* Auto activate link on non-SC15 packet receive */
> > +			if (unlikely(rcd->ppd->host_link_state ==
> > +				     HLS_UP_ARMED))
> > +				if (set_armed_to_active(rcd, packet, dd))
> > +					goto bail;
> 
> What is the advantage of double "if" over one "if"?
> Something like that
> + if (unlikely(rcd->ppd->host_link_state == HLS_UP_ARMED) && (set_armed_to_active(rcd, packet, dd))
> +		goto bail;

I don't think there is an advantage to the double if, so I will change
it to the single if in v3.

> 
> >  			last = process_rcv_packet(&packet, thread);
> >  		}
> >  
> > @@ -984,6 +1020,42 @@ bail:
> >  }
> >  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
