From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Date: Mon, 8 Jan 2018 19:57:43 +0100
Message-ID: <20180108185743.GA15936@lst.de>
References: <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca> <20180108183434.GA15549@lst.de>
 <cffacbee-477a-fbe9-19cc-373cd2ec6fef@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cffacbee-477a-fbe9-19cc-373cd2ec6fef-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 11:44:41AM -0700, Logan Gunthorpe wrote:
>> Think about what the dma mapping routines do:
>>
>>   (a) translate from host address to bus addresses
>>
>> and
>>
>>   (b) flush caches (in non-coherent architectures)
>>
>> Both are obviously not needed for P2P transfers, as they never reach
>> the host.
>
> Isn't pci_p2pdma_map_sg doing (a)? It's just translating from a host 
> address to a PCI bus address.

It does, sort of - but in a different way then the normal DMA map
ops.  And only to work around the fact that we need to map our
P2P space into struct pages.  Without that we could just pass the
bus address around, but the Linux stack and VM isn't anywhere near
ready for something that advanced.

>>> Very long term the IOMMUs under the ops will need to care about this,
>>> so the wrapper is not an optimal place to put it - but I wouldn't
>>> object if it gets it out of RDMA :)
>>
>> Unless you have an IOMMU on your PCIe switch and not before/inside
>> the root complex that is not correct.
>
> Per the ACS discussion, in the future we might want to implement "ACS 
> Direct Translated P2P" as Alex described. I expect it would be the IOMMU 
> that needs to set that up. So, I think, we also have the dma_map 
> implementations also doing something like:
>
> (c) setup/manage any security permissions on mappings
> Which P2P may at some point be concerned with.

Maybe once root complexes with iommus actually support P2P.  But until
then we have a lot more more important problems to solve.
