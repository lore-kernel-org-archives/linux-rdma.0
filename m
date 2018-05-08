From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Tue, 8 May 2018 10:57:59 -0600
Message-ID: <20180508105759.7dbaa8fe@w520.home>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180507232346.GI161390@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180507232346.GI161390-1RhO1Y9PlrlHTL0Zs8A6p5iNqAH0jzoTYJqu5kTmcBRl57MIdRCFDg@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?UTF-8?B?S8O2bmln?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 7 May 2018 18:23:46 -0500
Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Mon, Apr 23, 2018 at 05:30:32PM -0600, Logan Gunthorpe wrote:
> > Hi Everyone,
> > 
> > Here's v4 of our series to introduce P2P based copy offload to NVMe
> > fabrics. This version has been rebased onto v4.17-rc2. A git repo
> > is here:
> > 
> > https://github.com/sbates130272/linux-p2pmem pci-p2p-v4
> > ...  
> 
> > Logan Gunthorpe (14):
> >   PCI/P2PDMA: Support peer-to-peer memory
> >   PCI/P2PDMA: Add sysfs group to display p2pmem stats
> >   PCI/P2PDMA: Add PCI p2pmem dma mappings to adjust the bus offset
> >   PCI/P2PDMA: Clear ACS P2P flags for all devices behind switches
> >   docs-rst: Add a new directory for PCI documentation
> >   PCI/P2PDMA: Add P2P DMA driver writer's documentation
> >   block: Introduce PCI P2P flags for request and request queue
> >   IB/core: Ensure we map P2P memory correctly in
> >     rdma_rw_ctx_[init|destroy]()
> >   nvme-pci: Use PCI p2pmem subsystem to manage the CMB
> >   nvme-pci: Add support for P2P memory in requests
> >   nvme-pci: Add a quirk for a pseudo CMB
> >   nvmet: Introduce helper functions to allocate and free request SGLs
> >   nvmet-rdma: Use new SGL alloc/free helper for requests
> >   nvmet: Optionally use PCI P2P memory
> > 
> >  Documentation/ABI/testing/sysfs-bus-pci    |  25 +
> >  Documentation/PCI/index.rst                |  14 +
> >  Documentation/driver-api/index.rst         |   2 +-
> >  Documentation/driver-api/pci/index.rst     |  20 +
> >  Documentation/driver-api/pci/p2pdma.rst    | 166 ++++++
> >  Documentation/driver-api/{ => pci}/pci.rst |   0
> >  Documentation/index.rst                    |   3 +-
> >  block/blk-core.c                           |   3 +
> >  drivers/infiniband/core/rw.c               |  13 +-
> >  drivers/nvme/host/core.c                   |   4 +
> >  drivers/nvme/host/nvme.h                   |   8 +
> >  drivers/nvme/host/pci.c                    | 118 +++--
> >  drivers/nvme/target/configfs.c             |  67 +++
> >  drivers/nvme/target/core.c                 | 143 ++++-
> >  drivers/nvme/target/io-cmd.c               |   3 +
> >  drivers/nvme/target/nvmet.h                |  15 +
> >  drivers/nvme/target/rdma.c                 |  22 +-
> >  drivers/pci/Kconfig                        |  26 +
> >  drivers/pci/Makefile                       |   1 +
> >  drivers/pci/p2pdma.c                       | 814 +++++++++++++++++++++++++++++
> >  drivers/pci/pci.c                          |   6 +
> >  include/linux/blk_types.h                  |  18 +-
> >  include/linux/blkdev.h                     |   3 +
> >  include/linux/memremap.h                   |  19 +
> >  include/linux/pci-p2pdma.h                 | 118 +++++
> >  include/linux/pci.h                        |   4 +
> >  26 files changed, 1579 insertions(+), 56 deletions(-)
> >  create mode 100644 Documentation/PCI/index.rst
> >  create mode 100644 Documentation/driver-api/pci/index.rst
> >  create mode 100644 Documentation/driver-api/pci/p2pdma.rst
> >  rename Documentation/driver-api/{ => pci}/pci.rst (100%)
> >  create mode 100644 drivers/pci/p2pdma.c
> >  create mode 100644 include/linux/pci-p2pdma.h  
> 
> How do you envison merging this?  There's a big chunk in drivers/pci, but
> really no opportunity for conflicts there, and there's significant stuff in
> block and nvme that I don't really want to merge.
> 
> If Alex is OK with the ACS situation, I can ack the PCI parts and you could
> merge it elsewhere?

AIUI from previously questioning this, the change is hidden behind a
build-time config option and only custom kernels or distros optimized
for this sort of support would enable that build option.  I'm more than
a little dubious though that we're not going to have a wave of distros
enabling this only to get user complaints that they can no longer make
effective use of their devices for assignment due to the resulting span
of the IOMMU groups, nor is there any sort of compromise, configure
the kernel for p2p or device assignment, not both.  Is this really such
a unique feature that distro users aren't going to be asking for both
features?  Thanks,

Alex
