From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v9 00/13] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Wed, 10 Oct 2018 17:03:33 -0600
Message-ID: <5c674a1b-2471-33eb-44f4-fe1bb8807a22@deltatee.com>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181010201918.GF5906@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010201918.GF5906@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-rdma@vger.kernel.org



On 2018-10-10 2:19 p.m., Bjorn Helgaas wrote:
> I added the reviewed-by tags from Christoph, Jens' ack on the blkdev.h
> change, and applied these to pci/peer-to-peer with the intent of
> merging these for v4.20.
> 
> I gave up on waiting for an ack for the memremap.h and mm.h changes.
> 
> I dropped the "nvme-pci: Add a quirk for a pseudo CMB" quirk because
> of Christoph's objection.  After this is all merged, I won't need to
> be involved, and you and the NVMe folks can hash that out.
> 
> If there are updates to "nvmet: Optionally use PCI P2P memory" based
> on Sagi's comments, send an incremental patch and I'll fold them in.

Thanks for picking this up. However, I hate to throw a wrench in the
works, but I had a v10[1] queued up because kbuild found some problems
with the series over the weekend. I can send v10 off right away if you
want to just replace it in your branch or, if you'd like, I can generate
some incremental patches. Let me know which you'd prefer.

Thanks,

Logan

[1] https://github.com/sbates130272/linux-p2pmem pci-p2p-v10
