From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage
 the CMB
Date: Mon, 5 Mar 2018 13:50:15 -0700
Message-ID: <20180305205015.GT11337@mellanox.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
 <20180305201053.GK11337@mellanox.com>
 <20180305204212.GD30975@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180305204212.GD30975@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Oliver <oohall@gmail.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 05, 2018 at 01:42:12PM -0700, Keith Busch wrote:
> On Mon, Mar 05, 2018 at 01:10:53PM -0700, Jason Gunthorpe wrote:
> > So when reading the above mlx code, we see the first wmb() being used
> > to ensure that CPU stores to cachable memory are visible to the DMA
> > triggered by the doorbell ring.
> 
> IIUC, we don't need a similar barrier for NVMe to ensure memory is
> visibile to DMA since the SQE memory is allocated DMA coherent when the
> SQ is not within a CMB.

You still need it.

DMA coherent just means you don't need to call the DMA API after
writing, it says nothing about CPU ordering.

eg on x86 DMA coherent is just normal system memory, and you do need
the SFENCE betweeen system memory stores and DMA triggering MMIO,
apparently.

Jason
