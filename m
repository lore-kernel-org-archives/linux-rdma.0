From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Sat, 5 Nov 2016 09:03:07 -0600
Message-ID: <20161105150307.GB23803@obsidianresearch.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
 <20161104004620.GA30318@obsidianresearch.com>
 <b88ad364-9d33-dd3e-a803-bb660de3b384@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b88ad364-9d33-dd3e-a803-bb660de3b384-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 04, 2016 at 02:00:37PM -0700, Adit Ranadive wrote:
> On Thu, Nov 03, 2016 at 5:46:20PM -0700, Jason Gunthorpe wrote:
> > On Thu, Nov 03, 2016 at 04:44:29PM -0700, Adit Ranadive wrote:
> > > 
> > > I have included the shared ABI file here based on the RDMA fix up stuff 
> > > that Jason pointed me to.
> > 
> > I left you some trivial notes on github.
> 
> Thanks for taking a look at the code!

Oh, I wanted to ask about the name - we have two 'pv' drivers now,
should this be called pvrdma_vmware or something? Is there a
convention for this in other parts of the kernel?

Same comment for the kernel patch set too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
