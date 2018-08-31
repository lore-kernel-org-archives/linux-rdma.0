From: Jonathan Cameron <jonathan.cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
Date: Fri, 31 Aug 2018 17:19:06 +0100
Message-ID: <20180831171906.00002751@huawei.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180830185352.3369-2-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 30 Aug 2018 12:53:40 -0600
Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:

> Some PCI devices may have memory mapped in a BAR space that's
> intended for use in peer-to-peer transactions. In order to enable
> such transactions the memory must be registered with ZONE_DEVICE pages
> so it can be used by DMA interfaces in existing drivers.
> 
> Add an interface for other subsystems to find and allocate chunks of P2P
> memory as necessary to facilitate transfers between two PCI peers:
> 
> int pci_p2pdma_add_client();
> struct pci_dev *pci_p2pmem_find();
> void *pci_alloc_p2pmem();
> 
> The new interface requires a driver to collect a list of client devices
> involved in the transaction with the pci_p2pmem_add_client*() functions
> then call pci_p2pmem_find() to obtain any suitable P2P memory. Once
> this is done the list is bound to the memory and the calling driver is
> free to add and remove clients as necessary (adding incompatible clients
> will fail). With a suitable p2pmem device, memory can then be
> allocated with pci_alloc_p2pmem() for use in DMA transactions.
> 
> Depending on hardware, using peer-to-peer memory may reduce the bandwidth
> of the transfer but can significantly reduce pressure on system memory.
> This may be desirable in many cases: for example a system could be designed
> with a small CPU connected to a PCIe switch by a small number of lanes
> which would maximize the number of lanes available to connect to NVMe
> devices.
> 
> The code is designed to only utilize the p2pmem device if all the devices
> involved in a transfer are behind the same PCI bridge. This is because we
> have no way of knowing whether peer-to-peer routing between PCIe Root Ports
> is supported (PCIe r4.0, sec 1.3.1). Additionally, the benefits of P2P
> transfers that go through the RC is limited to only reducing DRAM usage
> and, in some cases, coding convenience. The PCI-SIG may be exploring
> adding a new capability bit to advertise whether this is possible for
> future hardware.
> 
> This commit includes significant rework and feedback from Christoph
> Hellwig.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>

Apologies for being a late entrant to this conversation so I may be asking
about a topic that has been covered in detail in earlier patches!
> ---
...

> +/*
> + * Find the distance through the nearest common upstream bridge between
> + * two PCI devices.
> + *
> + * If the two devices are the same device then 0 will be returned.
> + *
> + * If there are two virtual functions of the same device behind the same
> + * bridge port then 2 will be returned (one step down to the PCIe switch,
> + * then one step back to the same device).
> + *
> + * In the case where two devices are connected to the same PCIe switch, the
> + * value 4 will be returned. This corresponds to the following PCI tree:
> + *
> + *     -+  Root Port
> + *      \+ Switch Upstream Port
> + *       +-+ Switch Downstream Port
> + *       + \- Device A
> + *       \-+ Switch Downstream Port
> + *         \- Device B
> + *
> + * The distance is 4 because we traverse from Device A through the downstream
> + * port of the switch, to the common upstream port, back up to the second
> + * downstream port and then to Device B.
> + *
> + * Any two devices that don't have a common upstream bridge will return -1.
> + * In this way devices on separate PCIe root ports will be rejected, which
> + * is what we want for peer-to-peer seeing each PCIe root port defines a
> + * separate hierarchy domain and there's no way to determine whether the root
> + * complex supports forwarding between them.
> + *
> + * In the case where two devices are connected to different PCIe switches,
> + * this function will still return a positive distance as long as both
> + * switches evenutally have a common upstream bridge. Note this covers
> + * the case of using multiple PCIe switches to achieve a desired level of
> + * fan-out from a root port. The exact distance will be a function of the
> + * number of switches between Device A and Device B.

This feels like a somewhat simplistic starting point rather than a
generally correct estimate to use.  Should we be taking the bandwidth of
those links into account for example, or any discoverable latencies?
Not all PCIe switches are alike - particularly when it comes to P2P.

I guess that can be a topic for future development if it turns out people
have horrible mixed systems.

> + *
> + * If a bridge which has any ACS redirection bits set is in the path
> + * then this functions will return -2. This is so we reject any
> + * cases where the TLPs are forwarded up into the root complex.
> + * In this case, a list of all infringing bridge addresses will be
> + * populated in acs_list (assuming it's non-null) for printk purposes.
> + */
