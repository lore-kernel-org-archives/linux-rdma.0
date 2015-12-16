From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Wed, 16 Dec 2015 09:35:23 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512160933200.17364@east.gentwo.org>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <20151211235630.GG7855@phlsvsds.ph.intel.com> <20151212000047.GA9961@obsidianresearch.com> <566EEE69.5080906@dev.mellanox.co.il> <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com> <5670717F.9090701@dev.mellanox.co.il> <20151215212035.GD28167@obsidianresearch.com> <56708961.1040505@dev.mellanox.co.il> <56708A19.8030403@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56708A19.8030403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2015, Doug Ledford wrote:

> On 12/15/2015 04:42 PM, Hal Rosenstock wrote:
> > On 12/15/2015 4:20 PM, Jason Gunthorpe wrote:
> >>> The unicast/multicast extended counters are not always supported -
> >>>> depends on setting of PerfMgt ClassPortInfo
> >>>> CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).
> >
> >> Yes.. certainly this proposed patch needs to account for that and
> >> continue to use the 32 bit ones in that case.
> >
> > There are no 32 bit equivalents of those 4 "IETF" counters ([uni
> > multi]cast [xmit rcv] pkts).
> >
> > When not supported, perhaps it is best not to populate these counters in
> > sysfs so one can discern between counter not supported and 0 value.
> >
> > I'm still working on definitive mthca answer but think the attribute is
> > not supported there. Does anyone out there have an mthca setup where
> > they can try this ?
>
> Yes.

We can return ENOSYS for the counters not supported.

Or simply not create the sysfs files when the device is instantiated as
well as fall back to the 32 bit counters on instantiation for those
devices not supporting the extended set.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
