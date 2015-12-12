From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended set
Date: Fri, 11 Dec 2015 20:15:42 -0500
Message-ID: <20151212011542.GI7855@phlsvsds.ph.intel.com>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <20151211235630.GG7855@phlsvsds.ph.intel.com> <20151212000047.GA9961@obsidianresearch.com> <20151212002313.GH7855@phlsvsds.ph.intel.com> <20151212004715.GA10790@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151212004715.GA10790-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 11, 2015 at 05:47:15PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 11, 2015 at 07:23:13PM -0500, ira.weiny wrote:
> > On Fri, Dec 11, 2015 at 05:00:47PM -0700, Jason Gunthorpe wrote:
> > > 
> > > FWIW, I also hate the sysfs counters that reflect the PMA, these would
> > > be much better are free running, wrapping, non-resetting counters
> > > unrelated to the PMA. Something that doesn't zero after the SM samples
> > > it. Sounds like qib, hif, rdmavt can trivially fix this, and should, IMHO.
> > 
> > To be fair with a 64bit counter these are not going to get reset very often.
> 
> It resets when ever the SM sends a reset packet, so 'whenever'

It's been a while since I have looked at OpenSMs PM but a 64 bit counter does
not get reset very often.

For OPA with 64bit counters the same is true.

> 
> > Furthermore, I don't think we can change the behavior now.
> 
> Sure we can, the restting is really a bug, to the point that nothing
> can actually use the sysfs counters reliably.

Well...  That would be changing the behavior that everyone is expecting.  I
know your argument; these are useless and no one is using them.  But that is
not the point.  They were there as a check to see the PMA counters directly.
Any change now is breaking the existing ABI.

Don't get me wrong.  I'm not against keeping running counters for devices.
But, I would rather see a more flexible interface.  Something like netlink
perhaps.

And I will again mention that both IB and OPA have PMs which keep running
counters.

For now Christophs series is a welcome improvement.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
