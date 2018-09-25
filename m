From: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 10/13] nvme-pci: Add support for P2P memory in requests
Date: Tue, 25 Sep 2018 11:48:35 -0600
Message-ID: <20180925174835.GA12185@localhost.localdomain>
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-11-logang@deltatee.com>
 <20180925171147.GB11822@localhost.localdomain>
 <3549a9bb-3604-1739-c008-4e1a95441333@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3549a9bb-3604-1739-c008-4e1a95441333-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 25, 2018 at 11:41:44AM -0600, Logan Gunthorpe wrote:
> Hey,
> 
> On 2018-09-25 11:11 a.m., Keith Busch wrote:
> > Sorry if this was already discussed. Is there a reason the following
> > pattern is not pushed to the generic dma_map_sg_attrs?
> > 
> > 	if (is_pci_p2pdma_page(sg_page(sg)))
> > 		pci_p2pdma_map_sg(dev, sg, nents, dma_dir);
> > 
> > Beyond that, series looks good.
> 
> Yes, this has been discussed. It comes down to a few reasons:
> 
> 1) Intrusiveness on other systems: ie. not needing to pay the cost for
> every single dma_map_sg call
> 
> 2) Consistency: we can add the check to dma_map_sg, but adding similar
> functionality to dma_map_page, etc is difficult seeing it's hard for the
> unmap operation to detect if a dma_addr_t was P2P memory to begin with.
> 
> 3) Safety for developers trying to use P2P memory: Right now developers
> must be careful with P2P pages and ensure they aren't mapped using other
> means (ie dma_map_page). Having them check the drivers that are handling
> the pages to ensure the appropriate map function is always used is and
> that P2P pages aren't being mixed with regular pages is better than
> developers relying on magic in dma_map_sg() and getting things wrong.
> 
> That being said, I think in the future everyone would like to move in
> that direction but it means we will have to solve some difficult
> problems with the existing infrastructure.

Gotchya, thanks for jogging my memory.
