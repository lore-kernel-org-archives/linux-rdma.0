From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/10] PCI/P2PDMA: Support peer to peer memory
Date: Thu, 1 Mar 2018 17:00:32 -0600
Message-ID: <20180301230032.GA74737@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-2-logang@deltatee.com>
 <20180301173752.GE13722@bhelgaas-glaptop.roam.corp.google.com>
 <b81503c2-9f07-b5f6-df06-64d1fdc53386@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b81503c2-9f07-b5f6-df06-64d1fdc53386-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 01, 2018 at 11:55:51AM -0700, Logan Gunthorpe wrote:
> Hi Bjorn,
> 
> Thanks for the review. I'll correct all the nits for the next version.
> 
> On 01/03/18 10:37 AM, Bjorn Helgaas wrote:
> > On Wed, Feb 28, 2018 at 04:39:57PM -0700, Logan Gunthorpe wrote:
> > > Some PCI devices may have memory mapped in a BAR space that's
> > > intended for use in Peer-to-Peer transactions. In order to enable
> > > such transactions the memory must be registered with ZONE_DEVICE pages
> > > so it can be used by DMA interfaces in existing drivers.
> 
> > Is there anything about this memory that makes it specifically
> > intended for peer-to-peer transactions?  I assume the device can't
> > really tell whether a transaction is from a CPU or a peer.
> 
> No there's nothing special about the memory and it can still be accessed by
> the CPU. This is just the intended purpose. You could use this PCI memory as
> regular DMA buffers or regular memory but I'm not sure why you would. It
> would probably be pretty bad performance-wise.
> 
> 
> > BTW, maybe there could be some kind of guide for device driver writers
> > in Documentation/PCI/?
> Makes sense we can look at writing something for the next iteration.
> 
> > I think it would be clearer and sufficient to simply say that we have
> > no way to know whether peer-to-peer routing between PCIe Root Ports is
> > supported (PCIe r4.0, sec 1.3.1).
> 
> Fair enough.
> 
> > The fact that you use the PCIe term "switch" suggests that a PCIe
> > Switch is required, but isn't it sufficient for the peers to be below
> > the same "PCI bridge", which would include PCIe Root Ports, PCIe
> > Switch Downstream Ports, and conventional PCI bridges?
> > The comments at get_upstream_bridge_port() suggest that this isn't
> > enough, and the peers actually do have to be below the same PCIe
> > Switch, but I don't know why.
> 
> I do mean Switch as we do need to keep the traffic off the root complex.
> Seeing, as stated above, we don't know if it actually support it. (While we
> can be certain any PCI switch does). So we specifically want to exclude PCIe
> Root ports and I'm not sure about the support of PCI bridges but I can't
> imagine anyone wanting to do P2P around them so I'd rather be safe than
> sorry and exclude them.

I don't think this is correct.  A Root Port defines a hierarchy domain
(I'm looking at PCIe r4.0, sec 1.3.1).  The capability to route
peer-to-peer transactions *between* hierarchy domains is optional.  I
think this means a Root Complex is not required to route transactions
from one Root Port to another Root Port.

This doesn't say anything about routing between two different devices
below a Root Port.  Those would be in the same hierarchy domain and
should follow the conventional PCI routing rules.  Of course, since a
Root Port has one link that leads to one device, they would probably
be different functions of a single multi-function device, so I don't
know how practical it would be to test this.

> > This whole thing is confusing to me.  Why do you want to reject peers
> > directly connected to the same root port?  Why do you require the same
> > Switch Upstream Port?  You don't exclude conventional PCI, but it
> > looks like you would require peers to share *two* upstream PCI-to-PCI
> > bridges?  I would think a single shared upstream bridge (conventional,
> > PCIe Switch Downstream Port, or PCIe Root Port) would be sufficient?
> 
> Hmm, yes, this may just be laziness on my part. Finding the shared upstream
> bridge is a bit more tricky than just showing that they are on the same
> switch. So as coded, a fabric of switches with peers on different legs of
> the fabric are not supported. But yes, maybe they just need to be two
> devices with a single shared upstream bridge that is not the root port.
> Again, we need to reject the root port because we can't know if the root
> complex can support P2P traffic.

This sounds like the same issue as above, so we just need to resolve
that.

> > Since "pci_p2pdma_add_client()" includes "pci_" in its name, it seems
> > sort of weird that callers supply a non-PCI device and then we look up
> > a PCI device here.  I assume you have some reason for this; if you
> > added a writeup in Documentation/PCI, that would be a good place to
> > elaborate on that, maybe with a one-line clue here.
> 
> Well yes, but this is much more convenient for callers which don't need to
> care if the device they are attempting to add (which in the NVMe target
> case, could be a random block device) is a pci device or not. Especially
> seeing find_parent_pci_dev() is non-trivial.

OK.  I accept that it might be convenient, but I still think it leads
to a weird API.  Maybe that's OK; I don't know enough about the
scenario in the caller to do anything more than say "hmm, strange".

> > > +void *pci_alloc_p2pmem(struct pci_dev *pdev, size_t size)
> > > +{
> > > +	void *ret;
> > > +
> > > +	if (unlikely(!pdev->p2pdma))
> > 
> > Is this a hot path?  I'm not sure it's worth cluttering
> > non-performance paths with likely/unlikely.
> 
> I'd say it can be pretty hot given that we need to allocate and free buffers
> at multiple GB/s for the NVMe target case. I don't exactly have benchmarks
> or anything to show this though...

OK, I'll take your word for that.  I'm fine with this as long as it is
performance-sensitive.

Bjorn
