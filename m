From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 14:38:58 -0600
Message-ID: <20160505203858.GA18611@obsidianresearch.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <72645a3b-5945-419a-d7af-1c065080e415@redhat.com>
 <20160505192024.GA17249@obsidianresearch.com>
 <5334ab9c-428a-547f-b80a-e0bee3f85449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5334ab9c-428a-547f-b80a-e0bee3f85449-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 03:32:32PM -0400, Doug Ledford wrote:
> On 05/05/2016 03:20 PM, Jason Gunthorpe wrote:
> > On Thu, May 05, 2016 at 02:57:01PM -0400, Doug Ledford wrote:
> >  
> >> and the eeprom is written with the new data.  If you need to do special
> >> things, like Mellanox, in terms of recovering burned data like GIDs
> >> or
> > 
> > The 'eeprom' and device firmware are very different things. hfi1 has
> > both, and uses request_firmware too.
> > 
> > I've never heard of a driver using ethtool eeprom to deal with nv
> > firmware like mlx has.
> 
> There's no reason it couldn't.  Since you can pass offset and length
> parameters and write things in multiple chunks, you can actually set up
> access to eeprom, nv ram, and firmware all through the one interface
> simply by defining the start/stop points of each to be at specific, well
> known locations for your device.

Well, sort of.

firmware write tends to be super-critical, doing it wrong can often
mean the card is bricked. eg some devices require good firmware to
start the PCI-E at all.

This means the firmware write process needs to be bomb-proof and all
competent vendors provide a user space program that does all necesary
checks. Using the latest version of that program is always a good idea
:)

I would be strongly against moving that sort of complexity into the
kernel.

In turn this means users will never have a uniform user space
experience, like 'cat | ethtool' - because that will not include the
checks.

Further, the very worst thing we could do is create a situation where
a new kernel driver is required to do a firmware update (eg because we
decided to move the checks into the kernel), and worse, potentially
the new driver won't load on old firmware or old kernels. IIRC mlx had
some problems like this once.

>From that view, I think, if it can be don entirely via resource0, then
that is what vendors should do, there is no value in a common API for
firmware nv writing.

ethtool eeprom exists as simple debugging/helper tool that should
really never be used by end users. It is reasonble to duplicate it for
eeprom like things, and AFAIK those uses cannot truely brick the
hardware.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
