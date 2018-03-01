From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Date: Thu, 1 Mar 2018 14:21:55 -0700
Message-ID: <20180301142155.5966c4c0@w520.home>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
 <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
 <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <0D05579B-789C-4A19-B3A2-C1A630BE31C0-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen  Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 1 Mar 2018 18:54:01 +0000
"Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:

> Thanks for the detailed review Bjorn!
> 
> >>  
> >> +	  Enabling this option will also disable ACS on all ports behind
> >> +	  any PCIe switch. This effictively puts all devices behind any
> >> +	  switch into the same IOMMU group.  
> 
> >
> >  Does this really mean "all devices behind the same Root Port"?  
> 
> Not necessarily. You might have a cascade of switches (i.e switches below a switch) to achieve a very large fan-out (in an NVMe SSD array for example) and we will only disable ACS on the ports below the relevant switch.
> 
> > What does this mean in terms of device security?  I assume it means,
> > at least, that individual devices can't be assigned to separate VMs.  
> 
> This was discussed during v1 [1]. Disabling ACS on all downstream ports of the switch means that all the EPs below it have to part of the same IOMMU grouping. However it was also agreed that as long as the ACS disable occurred at boot time (which is does in v2) then the virtualization layer will be aware of it and will perform the IOMMU group formation correctly.

This is still a pretty terrible solution though, your kernel provider
needs to decide whether they favor device assignment or p2p, because we
can't do both, unless there's a patch I haven't seen yet that allows
boot time rather than compile time configuration.  There are absolutely
supported device assignment cases of switches proving isolation between
devices allowing the downstream EPs to be used independently.  I think
this is a non-starter for distribution support without boot time or
dynamic configuration.  I could imagine dynamic configuration through
sysfs that might trigger a soft remove and rescan of the affected
devices in order to rebuild the IOMMU group.  The hard part might be
determining which points to allow that to guarantee correctness.  For
instance, upstream switch ports don't actually support ACS, but they'd
otherwise be an obvious concentration point to trigger a
reconfiguration.  Thanks,

Alex
