From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Mon, 26 Mar 2018 12:11:38 +0100
Message-ID: <20180326121138.00005e30@huawei.com>
References: <20180312193525.2855-1-logang@deltatee.com>
        <20180312193525.2855-2-logang@deltatee.com>
        <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
        <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Eric Wehage <Eric.Wehage@huawei.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 13 Mar 2018 10:43:55 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 12/03/18 09:28 PM, Sinan Kaya wrote:
> > On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> > Regarding the switch business, It is amazing how much trouble you went into
> > limit this functionality into very specific hardware.
> > 
> > I thought that we reached to an agreement that code would not impose
> > any limits on what user wants.
> > 
> > What happened to all the emails we exchanged?  
> 
> It turns out that root ports that support P2P are far less common than 
> anyone thought. So it will likely have to be a white list.

This came as a bit of a surprise to our PCIe architect.

His follow up was whether it was worth raising an ECR for the PCIe spec
to add a capability bit to allow this to be discovered.  This might
long term avoid the need to maintain the white list for new devices.

So is it worth having a long term solution for making this discoverable?

Jonathan

> Nobody else 
> seems keen on allowing the user to enable this on hardware that doesn't 
> work. The easiest solution is still limiting it to using a switch. From 
> there, if someone wants to start creating a white-list then that's 
> probably the way forward to support root ports.
> 
> And there's also the ACS problem which means if you want to use P2P on 
> the root ports you'll have to disable ACS on the entire system. (Or 
> preferably, the IOMMU groups need to get more sophisticated to allow for 
> dynamic changes).
> 
> Additionally, once you allow for root ports you may find the IOMMU 
> getting in the way.
> 
> So there are great deal more issues to sort out if you don't restrict to 
> devices behind switches.
> 
> Logan
