From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: hfi1 use of PCI internals
Date: Fri, 17 Jun 2016 18:04:39 -0500
Message-ID: <20160617230439.GB21200@localhost>
References: <20160616162052.GA2144@localhost>
 <tnm1toa71hsw1.fsf@phwtpriv05.ph.intel.com>
 <20160616200817.GA17778@localhost>
 <tnm1t4m8rh3ns.fsf@phwtpriv05.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tnm1t4m8rh3ns.fsf@phwtpriv05.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 17, 2016 at 06:05:43PM -0400, Ashutosh Dixit wrote:
> On Thu, Jun 16 2016 at 04:08:17 PM, Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > That's a good start, but leads to more questions.  For example, it
> > doesn't answer the obvious question of why the driver needs to
> > enable/disable ASPM from interrupt context.
> 
> For power saving reasons we keep ASPM L1 enabled, but implement a
> heuristic to "quickly" disable ASPM L1 when we notice PCIe traffic (as
> measured by the interrupt rate) starting up. If interrupt activity
> ceases ASPM L1 is re-enabled.
> 
> > Disabling ASPM should only require writing the device's Link Control
> > register.  The PCI core could probably provide an interface to do that
> > in interrupt context.
> >
> > Enabling ASPM is not latency-critical and could probably be done from
> > a work queue outside interrupt context, although conceptually there
> > shouldn't be much required here either, and possibly the PCI core
> > interface could be improved.
> 
> That is true, to keep latencies low we need to disable ASPM from
> interrupt context, but re-enabling ASPM is not latency critical.

For endpoint devices, it should be theoretically possible to
enable/disable ASPM very quickly, by touching only that device.  We
don't do that today because pcie/aspm.c does all sorts of buffoonery
and path walking.  I think that could be simplified, assuming we think
this sort of intensive ASPM-management is desirable.

> > It's possible the latency problem could be handled by some sort of
> > quirk that overrides the acceptable latency.
> 
> Correct, this is another issue that needs to be resolved.
