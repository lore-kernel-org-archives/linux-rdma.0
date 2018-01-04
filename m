From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Date: Thu, 4 Jan 2018 12:52:24 -0700
Message-ID: <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104192225.GS11348-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/01/18 12:22 PM, Jason Gunthorpe wrote:
> This seems really clunky since we are going to want to do this same
> logic all over the place.
> 
> I'd be much happier if dma_map_sg can tell the memory is P2P or not
> from the scatterlist or dir arguments and not require the callers to
> have this.

We tried things like this in an earlier iteration[1] which assumed the 
SG was homogenous (all P2P or all regular memory). This required serious 
ugliness to try and ensure SGs were in fact homogenous[2]. If you don't 
assume homogenousness you need change every DMA mapping provider or have 
a way to efficiently know if the SGL contains any P2P pages.

Unfortunately, it's hard to do any of this without significant 
improvements to the SGL code (like [3]) but I understand there's 
significant push back against such changes at this time.

> For instance adding DMA_TO_P2P_DEVICE and DMA_FROM_P2P_DEVICE, or
> adding another bit to the page flags in scatterlist.

Creating new direction flags doesn't really solve the problem you point 
out. It'd only really work in the rdma_rw_ctx_init() case because that 
function already takes the direction argument. It doesn't work in the 
similar block device case because the DMA direction isn't passed through 
the request.

Though, if there's agreement to do something like that I'm not against it.

> The signature of pci_p2pmem_map_sg also doesn't look very good, it
> should mirror the usual dma_map_sg, otherwise it needs more revision
> to extend this to do P2P through a root complex.

Generally, the feedback that I get is to not make changes that try to 
anticipate the future. It would be easy enough to add those arguments 
when the code for going through the RC is made (which I expect will be 
very involved anyway).

Logan

[1] 
https://github.com/sbates130272/linux-p2pmem/commit/af3d3742669511c343c2c5bfbbfaccc325bee80a
[2] 
https://github.com/sbates130272/linux-p2pmem/commit/61ec04fa63c79dab14570ea0e97432d9325ad127
[3] 
https://github.com/sbates130272/linux-p2pmem/commit/d8635a4de3c674b577b95653d431fd61c2504ccd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
