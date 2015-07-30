From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Thu, 30 Jul 2015 16:30:37 -0600
Message-ID: <20150730223037.GA4266@obsidianresearch.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com>
 <32E1700B9017364D9B60AED9960492BC2577809D@fmsmsx120.amr.corp.intel.com>
 <55BAA0E1.7000402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BAA0E1.7000402-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 06:10:41PM -0400, Doug Ledford wrote:
> > I did ask you in http://marc.info/?l=linux-rdma&m=143707462806767&w=2 if you thought ioctl was ok.
> > 
> > Hearing nothing, we left the interface as it was.

It isn't really fair to expect other people to design your UAPI for
you, Al didn't respond either. Nobody else but you understand what the
heck this is doing... I gave you lots of options and guidance. Pick
something that make sense.

> I think the interface is fine as is, with the only thing I would do, if
> *really* forced to by Al, would be to do as I suggested above and
> convert all of the write cases to writev with a single element.

The point of Al's comment was that write() and writev() do *different
things* and calling writev with a single iov entry is *NOT*
equivalent to write() with the same data.

That is fundamentally not how write and writev should behave - they
are supposed to be symmetrically interchangeable.

I don't think adding a comment makes the situation any better.

> they differ in their basic usage.  If Al had a clear comment saying "our
> write function is used to pass a single command to our driver, and our
> writev function is used to pass a queue of formatted commands,

Well, that would probably be fine, but that is not what is going on at
all....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
