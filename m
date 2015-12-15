From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Tue, 15 Dec 2015 14:20:35 -0700
Message-ID: <20151215212035.GD28167@obsidianresearch.com>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
 <5670717F.9090701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5670717F.9090701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2015 at 03:01:03PM -0500, Hal Rosenstock wrote:
> > I would agree, from my observation, that the two main byte counters
> > are always available.
> 
> The extended packet counts work but I thought there was a PMA with one
> of the extended byte counts wired to 0.

Can't remember

> > But not necessarily the others.
> 
> The unicast/multicast extended counters are not always supported -
> depends on setting of PerfMgt ClassPortInfo
> CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).

Yes.. certainly this proposed patch needs to account for that and
continue to use the 32 bit ones in that case.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
