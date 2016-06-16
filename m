From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: hfi1 use of PCI internals
Date: Thu, 16 Jun 2016 15:08:17 -0500
Message-ID: <20160616200817.GA17778@localhost>
References: <20160616162052.GA2144@localhost>
 <tnm1toa71hsw1.fsf@phwtpriv05.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tnm1toa71hsw1.fsf@phwtpriv05.ph.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 16, 2016 at 02:48:30PM -0400, Ashutosh Dixit wrote:
> On Thu, Jun 16 2016 at 12:20:52 PM, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > I noticed drivers/infiniband/hw/hfi1 got moved from staging to
> > drivers/ for v4.7.  It does a bunch of grubbing around in PCIe ASPM
> > configuration, e.g., see drivers/infiniband/hw/hfi1/aspm.h.
> >
> > I know there have been lots of ASPM issues, both hardware problems and
> > Linux kernel problems, but it is *supposed* to be manageable by the
> > core, without special driver support.  What's the justification for
> > having to do this in the hfi1 driver?
> 
> The description for commit affa48de84 "staging/rdma/hfi1: Add support
> for enabling/disabling PCIe ASPM" anticipates this question and
> describes why this was done in the hfi1 driver:
> 
>     Finally, the kernel ASPM API is not used in this patch. This is
>     because this patch does several non-standard things as SW
>     workarounds for HW issues. As mentioned above, it enables ASPM even
>     when advertised actual latencies are greater than acceptable
>     latencies. Also, whereas the kernel API only allows drivers to
>     disable ASPM from driver probe, this patch enables/disables ASPM
>     directly from interrupt context. Due to these reasons the kernel
>     ASPM API was not used.

That's a good start, but leads to more questions.  For example, it
doesn't answer the obvious question of why the driver needs to
enable/disable ASPM from interrupt context.

Disabling ASPM should only require writing the device's Link Control
register.  The PCI core could probably provide an interface to do that
in interrupt context.

Enabling ASPM is not latency-critical and could probably be done from
a work queue outside interrupt context, although conceptually there
shouldn't be much required here either, and possibly the PCI core
interface could be improved.

It's possible the latency problem could be handled by some sort of
quirk that overrides the acceptable latency.

It's hard enough to get ASPM support in the PCI core correct without
having to worry about drivers doing their own thing behind the back of
the core.

As far as I can tell, none of these PCI questions were raised on
linux-pci, so we never even had a chance to have a conversation about
them.

Bjorn
