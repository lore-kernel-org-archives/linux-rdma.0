From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 01/12] pci-p2p: Support peer to peer memory
Date: Thu, 4 Jan 2018 15:40:29 -0600
Message-ID: <20180104214028.GD189897@bhelgaas-glaptop.roam.corp.google.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104190137.7654-2-logang@deltatee.com>
Sender: linux-pci-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

Run "git log --oneline drivers/pci" and follow the convention.  I
think it would make sense to add a new tag like "PCI/P2P", although
"P2P" has historically also been used in the "PCI-to-PCI bridge"
context, so maybe there's something less ambiguous.  "P2PDMA"?

When you add new files, I guess we're looking for the new SPDX
copyright stuff?

On Thu, Jan 04, 2018 at 12:01:26PM -0700, Logan Gunthorpe wrote:
> Some PCI devices may have memory mapped in a BAR space that's
> intended for use in Peer-to-Peer transactions. In order to enable
> such transactions the memory must be registered with ZONE_DEVICE pages
> so it can be used by DMA interfaces in existing drivers.
> 
> A kernel interface is provided so that other subsystems can find and
> allocate chunks of P2P memory as necessary to facilitate transfers
> between two PCI peers. Depending on hardware, this may reduce the
> bandwidth of the transfer but would significantly reduce pressure
> on system memory. This may be desirable in many cases: for example a
> system could be designed with a small CPU connected to a PCI switch by a
> small number of lanes which would maximize the number of lanes available
> to connect to NVME devices.
> 
> The interface requires a user driver to collect a list of client devices
> involved in the transaction with the pci_p2pmem_add_client*() functions
> then call pci_p2pmem_find() to obtain any suitable P2P memory. Once
> this is done the list is bound to the memory and the calling driver is
> free to add and remove clients as necessary. The ACS bits on the
> downstream switch port will be managed for all the registered clients.
> 
> The code is designed to only utilize the p2pmem device if all the devices
> involved in a transfer are behind the same PCI switch. This is because
> using P2P transactions through the PCI root complex can have performance
> limitations or, worse, might not work at all. Finding out how well a
> particular RC supports P2P transfers is non-trivial. 

It's more than "non-trivial" or "with good performance" (from Kconfig
help), isn't it?  AFAIK, there's no standard way at all to discover
whether P2P DMA is supported between root ports or RCs.

> +config PCI_P2P
> +	bool "PCI Peer to Peer transfer support"
> +	depends on ZONE_DEVICE
> +	select GENERIC_ALLOCATOR
> +	help
> +	  Enableѕ drivers to do PCI peer to peer transactions to and from
> +	  bars that are exposed to other devices in the same domain.

s/bars/BARs/ (and similarly below, except in C code)

Similarly, s/dma/DMA/ and s/pci/PCI/ below.

And probably also s/p2p/peer-to-peer DMA/ in messages.

Maybe clarify this domain bit.  Using "domain" suggests the common PCI
segment/domain usage, but I think you really mean something like the
part of the hierarchy where peer-to-peer DMA is guaranteed by the PCI
spec to work, i.e., anything below a single PCI bridge.

> +
> +	  Many PCIe root complexes do not support P2P transactions and
> +	  it's hard to tell which support it with good performance, so
> +	  at this time you will need a PCIe switch.
> +
> +	  If unsure, say N.

> + * pci_p2pmem_add_resource - add memory for use as p2p memory
> + * @pci: the device to add the memory to
> + * @bar: PCI bar to add
> + * @size: size of the memory to add, may be zero to use the whole bar
> + * @offset: offset into the PCI bar
> + *
> + * The memory will be given ZONE_DEVICE struct pages so that it may
> + * be used with any dma request.
> + */
> +int pci_p2pmem_add_resource(struct pci_dev *pdev, int bar, size_t size,
> +			    u64 offset)
> +{
> +	struct dev_pagemap *pgmap;
> +	void *addr;
> +	int error;

Seems like there should be

  if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
    return -EINVAL;

or similar here?

> +	if (WARN_ON(offset >= pci_resource_len(pdev, bar)))
> +		return -EINVAL;

Are these WARN_ONs for debugging purposes, or do you think we need
them in production?  Granted, hitting it would probably be a kernel
driver bug, but still, not sure if the PCI core needs to coddle the
driver author that much.

> +	if (!size)
> +		size = pci_resource_len(pdev, bar) - offset;
> +
> +	if (WARN_ON(size + offset > pci_resource_len(pdev, bar)))
> +		return -EINVAL;
> +
> +	if (!pdev->p2p) {
> +		error = pci_p2pmem_setup(pdev);
> +		if (error)
> +			return error;
> +	}
> +
> +	pgmap = devm_kzalloc(&pdev->dev, sizeof(*pgmap), GFP_KERNEL);
> +	if (!pgmap)
> +		return -ENOMEM;
> +
> +	pgmap->res.start = pci_resource_start(pdev, bar) + offset;
> +	pgmap->res.end = pgmap->res.start + size - 1;

I'm guessing Christoph's dev_pagemap revamp repo must change
pgmap->res from a pointer to a structure, but I don't see the actual
link in your cover letter.

I think you should set pgmap->res.flags here, too.

> +	pgmap->ref = &pdev->p2p->devmap_ref;
> +	pgmap->type = MEMORY_DEVICE_PCI_P2P;
> +
> +	addr = devm_memremap_pages(&pdev->dev, pgmap);
> +	if (IS_ERR(addr))
> +		return PTR_ERR(addr);
> +
> +	error = gen_pool_add_virt(pdev->p2p->pool, (uintptr_t)addr,
> +			pci_bus_address(pdev, bar) + offset,
> +			resource_size(&pgmap->res), dev_to_node(&pdev->dev));
> +	if (error)
> +		return error;
> +
> +	error = devm_add_action_or_reset(&pdev->dev, pci_p2pmem_percpu_kill,
> +					  &pdev->p2p->devmap_ref);
> +	if (error)
> +		return error;
> +
> +	dev_info(&pdev->dev, "added %zdB of p2p memory\n", size);

Can we add %pR and print pgmap->res itself, too?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_p2pmem_add_resource);

> + * If a device is behind a switch, we try to find the upstream bridge
> + * port of the switch. This requires two calls to pci_upstream_bridge:
> + * one for the upstream port on the switch, one on the upstream port
> + * for the next level in the hierarchy. Because of this, devices connected
> + * to the root port will be rejected.
> + */
> +static struct pci_dev *get_upstream_switch_port(struct pci_dev *pdev)
> +{
> +	struct pci_dev *up1, *up2;
> +
> +	if (!pdev)
> +		return NULL;
> +
> +	up1 = pci_dev_get(pci_upstream_bridge(pdev));
> +	if (!up1)
> +		return NULL;
> +
> +	up2 = pci_dev_get(pci_upstream_bridge(up1));
> +	pci_dev_put(up1);
> +
> +	return up2;
> +}
> +
> +static bool __upstream_bridges_match(struct pci_dev *upstream,
> +				     struct pci_dev *client)
> +{
> +	struct pci_dev *dma_up;
> +	bool ret = true;
> +
> +	dma_up = get_upstream_switch_port(client);
> +
> +	if (!dma_up) {
> +		dev_dbg(&client->dev, "not a pci device behind a switch\n");

You have a bit of a mix of PCI ("pci device", "bridge") and PCIe
("switch", "switch port") terminology.  I haven't read the rest of the
patches yet, so I don't know if you intend to restrict this to
PCIe-only, e.g., so you can use ACS, or if you want to make it
available on conventional PCI as well.

If the latter, I would use the generic PCI terminology, i.e., "bridge"
instead of "switch".

> + * pci_virt_to_bus - return the pci bus address for a given virtual
> + *	address obtained with pci_alloc_p2pmem
> + * @pdev:	the device the memory was allocated from
> + * @addr:	address of the memory that was allocated
> + */
> +pci_bus_addr_t pci_p2pmem_virt_to_bus(struct pci_dev *pdev, void *addr)
> +{
> +	if (!addr)
> +		return 0;
> +	if (!pdev->p2p)
> +		return 0;
> +
> +	return gen_pool_virt_to_phys(pdev->p2p->pool, (unsigned long)addr);

This doesn't seem right.  A physical address is not the same as a PCI
bus address.  I expected something like pci_bus_address() or
pcibios_resource_to_bus() here.  Am I missing something?  If so, a
clarifying comment would be helpful.

> + * pci_p2pmem_publish - publish the p2p memory for use by other devices
> + *	with pci_p2pmem_find
> + * @pdev:	the device with p2p memory to publish
> + * @publish:	set to true to publish the memory, false to unpublish it
> + */
> +void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
> +{
> +	if (WARN_ON(publish && !pdev->p2p))
> +		return;

Same WARN_ON question -- is this really intended for production?
Doesn't seem like the end user can really do anything with the warning
information.

> diff --git a/include/linux/pci-p2p.h b/include/linux/pci-p2p.h
> new file mode 100644
> index 000000000000..f811c97a5886
> --- /dev/null
> +++ b/include/linux/pci-p2p.h
> @@ -0,0 +1,85 @@
> +#ifndef _LINUX_PCI_P2P_H
> +#define _LINUX_PCI_P2P_H
> +/*
> + * Copyright (c) 2016-2017, Microsemi Corporation
> + * Copyright (c) 2017, Christoph Hellwig.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/pci.h>
> +
> +struct block_device;
> +struct scatterlist;

I've been noticing that we're accumulating PCI-related files in
include/linux: pci.h, pci-aspm.h pci-ats.h, pci-dma.h, pcieport_if.h,
etc.  I'm not sure there's value in all those and am thinking maybe
they should just be folded into pci.h.  What do you think?

> +#ifdef CONFIG_PCI_P2P
> +int pci_p2pmem_add_resource(struct pci_dev *pdev, int bar, size_t size,
> +		u64 offset);
> +int pci_p2pmem_add_client(struct list_head *head, struct device *dev);
> ...

Bjorn
