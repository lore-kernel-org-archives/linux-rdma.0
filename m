From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Date: Tue, 8 May 2018 13:34:07 -0600
Message-ID: <20180508133407.57a46902@w520.home>
References: <20180423233046.21476-1-logang@deltatee.com>
        <20180423233046.21476-5-logang@deltatee.com>
        <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
        <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
        <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
        <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
        <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Bjorn Helgaas <helgaas@kernel.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 8 May 2018 13:13:40 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 08/05/18 10:50 AM, Christian König wrote:
> > E.g. transactions are initially send to the root complex for 
> > translation, that's for sure. But at least for AMD GPUs the root complex 
> > answers with the translated address which is then cached in the device.
> > 
> > So further transactions for the same address range then go directly to 
> > the destination.  
> 
> Sounds like you are referring to Address Translation Services (ATS).
> This is quite separate from ACS and, to my knowledge, isn't widely
> supported by switch hardware.

They are not so unrelated, see the ACS Direct Translated P2P
capability, which in fact must be implemented by switch downstream
ports implementing ACS and works specifically with ATS.  This appears to
be the way the PCI SIG would intend for P2P to occur within an IOMMU
managed topology, routing pre-translated DMA directly between peer
devices while requiring non-translated requests to bounce through the
IOMMU.  Really, what's the value of having an I/O virtual address space
provided by an IOMMU if we're going to allow physical DMA between
downstream devices, couldn't we just turn off the IOMMU altogether?  Of
course ATS is not without holes itself, basically that we trust the
endpoint's implementation of ATS implicitly.  Thanks,

Alex
