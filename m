From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 01/12] pci-p2p: Support peer to peer memory
Date: Thu, 4 Jan 2018 16:06:11 -0700
Message-ID: <9ae2d22d-3052-9bad-4074-ebcd80d86f1c@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-2-logang@deltatee.com>
 <20180104214028.GD189897@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180104214028.GD189897-1RhO1Y9PlrlHTL0Zs8A6p5iNqAH0jzoTYJqu5kTmcBRl57MIdRCFDg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for the speedy review!

On 04/01/18 02:40 PM, Bjorn Helgaas wrote:
> Run "git log --oneline drivers/pci" and follow the convention.  I
> think it would make sense to add a new tag like "PCI/P2P", although
> "P2P" has historically also been used in the "PCI-to-PCI bridge"
> context, so maybe there's something less ambiguous.  "P2PDMA"?

Ok, I'll fix this for v2. I'm fine with renaming things to p2pdma

> When you add new files, I guess we're looking for the new SPDX
> copyright stuff?

Will do.

> It's more than "non-trivial" or "with good performance" (from Kconfig
> help), isn't it?  AFAIK, there's no standard way at all to discover
> whether P2P DMA is supported between root ports or RCs.

Yup, that's correct. This would have to be done with a white list.

> 
> s/bars/BARs/ (and similarly below, except in C code)
> Similarly, s/dma/DMA/ and s/pci/PCI/ below.
> And probably also s/p2p/peer-to-peer DMA/ in messages.

Will do.

> Maybe clarify this domain bit.  Using "domain" suggests the common PCI
> segment/domain usage, but I think you really mean something like the
> part of the hierarchy where peer-to-peer DMA is guaranteed by the PCI
> spec to work, i.e., anything below a single PCI bridge.

Ok, I like the wording you proposed.


> 
> Seems like there should be
> 
>    if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>      return -EINVAL;
> 
> or similar here?

That sounds like a good idea. Will add.

> 
>> +	if (WARN_ON(offset >= pci_resource_len(pdev, bar)))
>> +		return -EINVAL;
> 
> Are these WARN_ONs for debugging purposes, or do you think we need
> them in production?  Granted, hitting it would probably be a kernel
> driver bug, but still, not sure if the PCI core needs to coddle the
> driver author that much.

Sure, I'll drop all the WARN_ONs.

> I'm guessing Christoph's dev_pagemap revamp repo must change
> pgmap->res from a pointer to a structure, but I don't see the actual
> link in your cover letter.

Sorry, the patch set is here:

https://www.mail-archive.com/linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org/msg07323.html

git://git.infradead.org/users/hch/misc.git hch/pgmap-cleanups.3

> I think you should set pgmap->res.flags here, too.

Sure, I don't think it's used and not set by the NVDIMM code; but I 
agree that it'd be a good idea to set it anyway.

>> +	dev_info(&pdev->dev, "added %zdB of p2p memory\n", size);
> 
> Can we add %pR and print pgmap->res itself, too?

Yup.

> You have a bit of a mix of PCI ("pci device", "bridge") and PCIe
> ("switch", "switch port") terminology.  I haven't read the rest of the
> patches yet, so I don't know if you intend to restrict this to
> PCIe-only, e.g., so you can use ACS, or if you want to make it
> available on conventional PCI as well.
> 
> If the latter, I would use the generic PCI terminology, i.e., "bridge"
> instead of "switch".

Ok, I'll change it to use the generic term bridge. There's no 
restriction in the code to limit it to PCIe only, though I don't expect 
anybody will ever be using this with legacy PCI.

>> + * pci_virt_to_bus - return the pci bus address for a given virtual
>> + *	address obtained with pci_alloc_p2pmem
>> + * @pdev:	the device the memory was allocated from
>> + * @addr:	address of the memory that was allocated
>> + */
>> +pci_bus_addr_t pci_p2pmem_virt_to_bus(struct pci_dev *pdev, void *addr)
>> +{
>> +	if (!addr)
>> +		return 0;
>> +	if (!pdev->p2p)
>> +		return 0;
>> +
>> +	return gen_pool_virt_to_phys(pdev->p2p->pool, (unsigned long)addr);
> 
> This doesn't seem right.  A physical address is not the same as a PCI
> bus address.  I expected something like pci_bus_address() or
> pcibios_resource_to_bus() here.  Am I missing something?  If so, a
> clarifying comment would be helpful.

What you're missing is that when we called gen_pool_add_virt we used the 
PCI bus address as the physical address and not the CPU physical address 
(which we don't care about). I'll add a comment explaining this.

> I've been noticing that we're accumulating PCI-related files in
> include/linux: pci.h, pci-aspm.h pci-ats.h, pci-dma.h, pcieport_if.h,
> etc.  I'm not sure there's value in all those and am thinking maybe
> they should just be folded into pci.h.  What do you think?

We started with that. Once we reached a certain amount of code, 
Christoph suggested we put it in its own header.

Logan
