From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
        rdma_rw_ctx_[init|destroy]()
Date: Tue, 9 Jan 2018 17:55:49 +0100
Message-ID: <20180109165549.GC12159@lst.de>
References: <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca> <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com> <20180104221337.GV11348@ziepe.ca> <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com> <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de> <20180108180917.GF11348@ziepe.ca> <20180108183434.GA15549@lst.de> <20180108190116.GI11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108190116.GI11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 12:01:16PM -0700, Jason Gunthorpe wrote:
> > So I very much disagree about where to place that workaround - the
> > RDMA code is exactly the right place.
> 
> But why? RDMA is using core code to do this. It uses dma_ops in struct
> device and it uses normal dma_map SG. How is it RDMA's problem that
> some PCI drivers provide strange DMA ops?

Because RDMA uses the dma_virt_ops to pretend a device does DMA when
in fact it doesn't - at least not for the exact data mapped, or
as far as I can tell often not all - e.g. the QIB/HFI devices
might do mmio access for data mapped.

This whole problem only exist because a few RDMA HCA drivers lie
with the help of the RDMA core.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
