From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Tue, 26 Apr 2016 09:23:18 -0600
Message-ID: <20160426152318.GE24104@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414175243.GA9310@phlsvsds.ph.intel.com>
 <20160420203616.GA28991@obsidianresearch.com>
 <20160422183844.GB21996@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160422183844.GB21996-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 22, 2016 at 02:38:45PM -0400, Dennis Dalessandro wrote:
> >Stuff like this should be a build bug:
> >/* NOTE: assumes unsigned long is 8 bytes */
> 
> Our Kconfig depends on X86_64. Should we add a BUILD_BUG_ON or something?

Yes

> as we can maintain the same functionality, which seems doable. It's just
> that no one has spoken up about these things in the 9+ months since the
> driver was added. We need a bit of time to get it all sorted out.

Unfortunately this is a bit of a flaw with the staging process, really
it is not designed to handle uAPI work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
