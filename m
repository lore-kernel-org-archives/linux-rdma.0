From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND 11/11] staging/rdma/hfi1: Workaround to prevent corruption during packet delivery
Date: Mon, 9 Nov 2015 19:01:50 -0500
Message-ID: <20151110000149.GA23733@phlsvsds.ph.intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com> <1446858426-30509-12-git-send-email-jubin.john@intel.com> <20151107032531.GA4920@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151107032531.GA4920-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 06, 2015 at 07:25:31PM -0800, Greg KH wrote:
> On Fri, Nov 06, 2015 at 08:07:06PM -0500, Jubin John wrote:
> > --- a/drivers/staging/rdma/hfi1/hfi.h
> > +++ b/drivers/staging/rdma/hfi1/hfi.h
> > @@ -1084,6 +1084,10 @@ struct hfi1_devdata {
> >  	/* Save the enabled LCB error bits */
> >  	u64 lcb_err_en;
> >  	u8 dc_shutdown;
> > +
> > +	/* receive context tail dummy address */
> > +	volatile __le64 *rcvhdrtail_dummy_kvaddr;
> 
> There's no way that volatile here is actually correct, please fix.
> 
You're right. Will fix in v2.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
