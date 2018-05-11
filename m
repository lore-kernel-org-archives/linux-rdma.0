From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Fri, 11 May 2018 16:55:11 -0600
Message-ID: <fe1e1d66-9764-768a-a2da-73845d319b4e@deltatee.com>
References: <20180423233046.21476-5-logang@deltatee.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
 <f0101988-cf82-7ffb-2aca-d3b8d2f4b504@deltatee.com>
 <868B49CE-4F0E-4A48-BE78-12149F85F1A4@raithlin.com>
 <8113cba8-62b9-1801-7a77-f82be223b183@deltatee.com>
 <cf2b92c9-7c5b-f19c-b5b1-2f2d435296d1@amd.com>
 <53fa38ce-40dd-6bc1-9b83-c6ccf228b755@deltatee.com>
 <A50EA568-81E7-4AD7-8C1B-1029FEA92F49@raithlin.com>
 <YTXPR0101MB2045DC0248A9B125CA276969AA9F0@YTXPR0101MB2045.CANPRD01.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YTXPR0101MB2045DC0248A9B125CA276969AA9F0@YTXPR0101MB2045.CANPRD01.PROD.OUTLOOK.COM>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Bates <sbates@raithlin.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On 5/11/2018 4:24 PM, Stephen  Bates wrote:
> All
> 
>>   Alex (or anyone else) can you point to where IOVA addresses are generated?
> 
> A case of RTFM perhaps (though a pointer to the code would still be appreciated).
> 
> https://www.kernel.org/doc/Documentation/Intel-IOMMU.txt
> 
> Some exceptions to IOVA
> -----------------------
> Interrupt ranges are not address translated, (0xfee00000 - 0xfeefffff).
> The same is true for peer to peer transactions. Hence we reserve the
> address from PCI MMIO ranges so they are not allocated for IOVA addresses.

Hmm, except I'm not sure how to interpret that. It sounds like there 
can't be an IOVA address that overlaps with the PCI MMIO range which is 
good and what I'd expect.

But for peer to peer they say they don't translate the address which 
implies to me that the intention is for a peer to peer address to not be 
mapped in the same way using the dma_map interface (of course though if 
you were using ATS you'd want this for sure). Unless the existing 
dma_map command's notice a PCI MMIO address and handle them differently, 
but I don't see how.

Logan
