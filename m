From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB: Refactor umem to use linear SG table
Date: Mon, 3 Feb 2014 07:30:16 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B8CF3AC3B@MTLDAG02.mtl.com>
References: <1390909215-5331-1-git-send-email-ogerlitz@mellanox.com>
 <52E7AA22.8020700@mellanox.com>
 <1F4FC384-349B-4F37-B06E-214A0B8570DE@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1F4FC384-349B-4F37-B06E-214A0B8570DE-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Upinder,

> -----Original Message-----
> From: Upinder Malhi (umalhi) [mailto:umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org]
> Sent: Saturday, February 01, 2014 3:46 AM
> To: Or Gerlitz
> Cc: Roland Dreier; <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Yishai Hadas; Faisal Latif;
> Mike Marciniszyn; Hoang-Nam Nguyen; Steve Wise; Shachar Raindel
> Subject: Re: [PATCH] IB: Refactor umem to use linear SG table
> 
> Or,
> 	umem_get internally calls dma_map_sg, which is punted to Intel's
> IOMMU driver's dma_map_sg. The Intel's IOMMU driver will program the
> IOMMU page tables, to monitor DMA's from the addresses in it's page tables
> to prevent cache coherency issues between DMA devices and CPU's.  usNIC also
> programs the Intel IOMMU via the API in iommu.h, for translating virtual
> address to physical address.  As part of programming the translation, the Intel
> IOMMU automatically will take care of cache coherency issues on these
> translation entries.  However, if a page is programmed in the IOMMU via the
> dma_map_sg API and the iommu API, the Intel IOMMU gets confused
> (confusion is that the cache coherency protocol ceases to work).  Therefore,
> usNIC cannot call umem_get.

Can you provide some additional detail regarding the confusion - what causes it?
Is the issue with the same page being mapped more than once in general?
Does the double mapping need to address the same device?

You can probably offer a patch to ib_umem_get, passing a flag to it identifying if
it should also do the DMA mapping, and use the same code base as the rest of the
IB drivers.

A better solution would be to fix Intel's IOMMU code such that it works properly if
the page is mapped using both dma_map_sg and the IOMMU API.


> 
> Any particular reason that the code in usNIC that walks the chunk sg's isn't
> ported to the linear SG table?

As your code didn't use the API which we changed, we preferred avoiding changing
it, to avoid introducing issues into the code, especially when we don't have the
needed hardware to test your code on.

You are more than welcome to implement a similar change in your code, or port
your code to use the ib_umem_get API.

Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
