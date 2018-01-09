From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
        rdma_rw_ctx_[init|destroy]()
Date: Tue, 9 Jan 2018 17:46:40 +0100
Message-ID: <20180109164640.GA12159@lst.de>
References: <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com> <20180104221337.GV11348@ziepe.ca> <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com> <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de> <20180108180917.GF11348@ziepe.ca> <20180108183434.GA15549@lst.de> <cffacbee-477a-fbe9-19cc-373cd2ec6fef@deltatee.com> <20180108185743.GA15936@lst.de> <20180108194950.GK11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108194950.GK11348@ziepe.ca>
Sender: linux-block-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, open list <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 12:49:50PM -0700, Jason Gunthorpe wrote:
> Pretty sure P2P capable IOMMU hardware exists.
> 
> With SOC's we also have the scenario that an DMA originated from an
> on-die device wishes to target an off-die PCI BAR (through the IOMMU),
> that definitely exists today, and people care about it :)

Then people will have to help and contribute support for it.
