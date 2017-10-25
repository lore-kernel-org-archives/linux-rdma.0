From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Wed, 25 Oct 2017 08:27:18 +0300
Message-ID: <20171025052718.qdzakvhbjkmdyllf@mwanda>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
 <1508771116.3325.0.camel@redhat.com>
 <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
 <1508783626.3325.16.camel@redhat.com>
 <20171023190400.GA24412@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC3443EB1C@fmsmsx120.amr.corp.intel.com>
 <20171024200216.GA15994@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024200216.GA15994-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 24, 2017 at 02:02:16PM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 24, 2017 at 07:54:40PM +0000, Marciniszyn, Mike wrote:
> 
> > - Change to use Jason's test from above with UINT_MAX
> 
> UINT_MAX isn't U32_MAX, is it?

They are always the same.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
