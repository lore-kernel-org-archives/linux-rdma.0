From: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/4] IB/hfi1: Restore EPROM read ability
Date: Mon, 26 Sep 2016 17:11:39 +0000
Message-ID: <4AF12E8016D2BF46BCDFCE8FAA77A3580BE0838F@FMSMSX103.amr.corp.intel.com>
References: <20160925144724.13602.38549.stgit@scvm10.sc.intel.com>
 <20160925144926.13602.47716.stgit@scvm10.sc.intel.com>
 <20160926165247.GB12011@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160926165247.GB12011-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hariharan, Easwar" <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, September 26, 2016 11:53 AM
> To: Dalessandro, Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hariharan, Easwar
> <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Luick, Dean <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH 1/4] IB/hfi1: Restore EPROM read ability
> 
> On Sun, Sep 25, 2016 at 07:49:29AM -0700, Dennis Dalessandro wrote:
> > +	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
> > +		read_page(dd, start + offset, buffer);
> > +		if (copy_to_user((void __user *)(addr + offset),
> 
> If it is not being used by userpsace then do not call copy_to_user...

The first patch in the series is a straight (partial) restore of the old code.  This is what you are commenting on.  The second patch does a "fixup" of the restored code and removes this call.  Should we squash patches 1 and 2 so that this never shows up?  It is a question of how much "show your work" is desired.

Dean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
