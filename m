From: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: hfi1 use of PCI internals
Date: Thu, 16 Jun 2016 14:48:30 -0400
Message-ID: <tnm1toa71hsw1.fsf@phwtpriv05.ph.intel.com>
References: <20160616162052.GA2144@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160616162052.GA2144@localhost> (Bjorn Helgaas's message of
	"Thu, 16 Jun 2016 10:20:52 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci@vger.kernel.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 16 2016 at 12:20:52 PM, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> I noticed drivers/infiniband/hw/hfi1 got moved from staging to
> drivers/ for v4.7.  It does a bunch of grubbing around in PCIe ASPM
> configuration, e.g., see drivers/infiniband/hw/hfi1/aspm.h.
>
> I know there have been lots of ASPM issues, both hardware problems and
> Linux kernel problems, but it is *supposed* to be manageable by the
> core, without special driver support.  What's the justification for
> having to do this in the hfi1 driver?

The description for commit affa48de84 "staging/rdma/hfi1: Add support
for enabling/disabling PCIe ASPM" anticipates this question and
describes why this was done in the hfi1 driver:

    Finally, the kernel ASPM API is not used in this patch. This is
    because this patch does several non-standard things as SW
    workarounds for HW issues. As mentioned above, it enables ASPM even
    when advertised actual latencies are greater than acceptable
    latencies. Also, whereas the kernel API only allows drivers to
    disable ASPM from driver probe, this patch enables/disables ASPM
    directly from interrupt context. Due to these reasons the kernel
    ASPM API was not used.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
