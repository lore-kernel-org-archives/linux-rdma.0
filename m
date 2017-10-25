From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Wed, 25 Oct 2017 08:14:35 +0300
Message-ID: <20171025051435.rz5dpmguey6c6d5b@mwanda>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
 <1508771116.3325.0.camel@redhat.com>
 <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
 <1508783626.3325.16.camel@redhat.com>
 <20171023190400.GA24412@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC3443EB1C@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3443EB1C-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 24, 2017 at 07:54:40PM +0000, Marciniszyn, Mike wrote:
> > Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
> > 
> > On Mon, Oct 23, 2017 at 02:33:46PM -0400, Doug Ledford wrote:
> > > > > > @@ -3781,7 +3781,7 @@ static int
> > > > > > __subn_get_opa_hfi1_cong_log(struct
> > > > > > opa_smp *smp, u32 am,
> > > > > >   		 * required to wrap the counter are supposed to
> > > > > >   		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
> > > > > >   		 */
> > > > > > -		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
> > > > > > +		if ((u64)(ts - cce->timestamp) > (2ULL *
> > > > > > UINT_MAX))
> > 
> > This is really weird looking. Both ts and cce->timestamp are s64, why
> > do the convoluted conversion to unsigned? And surely UINT_MAX is not
> > the right thing..
> > 
> > if ((ts - cce->timestamp)/2 > 0xFFFFFFFF)
> > 
> > ?
> > 
> > ktime_get is defined to be monotonic, so ts - cce->timestamp should
> > never go negative.
> > 
> 
> I agree that this is an issue.
> 
> My proposal:
> - Change s64 to u64 for ts and in timestamp in opa_hfi1_cong_log_event_internal
> - Change the calls:
>         ktime_to_ns(ktime_get()) / 1024
>         -- to --
>         ktime_get_ns() / 1024
> - Change to use Jason's test from above with UINT_MAX
> 
> Dan, we can do the patch or you can send a v2?
> 

Can you do the patch and give me a Reported-by tag?

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
