From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Thu, 17 Dec 2015 13:21:52 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512171321110.8087@east.gentwo.org>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <20151211235630.GG7855@phlsvsds.ph.intel.com> <20151212000047.GA9961@obsidianresearch.com> <566EEE69.5080906@dev.mellanox.co.il> <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com> <5670717F.9090701@dev.mellanox.co.il> <20151215212035.GD28167@obsidianresearch.com> <alpine.DEB.2.20.1512161000150.17457@east.gentwo.org> <alpine.DEB.2.20.1512161332200.10147@east.gentwo.org>
 <5672F47F.9060806@dev.mellanox.co.il> <alpine.DEB.2.20.1512171252200.2954@east.gentwo.org> <5673097D.8050906@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5673097D.8050906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 17 Dec 2015, Hal Rosenstock wrote:

> > I thought a port is always supplied since we get the info for a particular
> > port and the directory only exists if there is a port?
>
> Yes, but there is no port (PortSelect) field in ClassPortInfo attribute
> unlike the PortCounters and PortExtendedCounters attributes.

Ok but its valid for all ports on that class right? Then this does not
matter?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
