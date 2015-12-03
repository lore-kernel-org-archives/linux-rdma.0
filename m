From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 6/6] IB/srp: Fix srp_map_sg_fr()
Date: Thu, 3 Dec 2015 01:11:26 -0800
Message-ID: <20151203091126.GA21893@infradead.org>
References: <565DE3EC.2070002@sandisk.com>
 <565DE4BA.1040703@sandisk.com>
 <565DE864.5050407@dev.mellanox.co.il>
 <565DE977.2070606@sandisk.com>
 <565EDD2A.6050407@dev.mellanox.co.il>
 <20151202124154.GF28278@infradead.org>
 <565EE90D.8060303@dev.mellanox.co.il>
 <56600152.5050401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56600152.5050401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 03, 2015 at 10:46:10AM +0200, Sagi Grimberg wrote:
> >>   If entries 2 and 3 could be merged dma_len for 2 would span 2 and 3,
> >>   and then entry 3 would actually have the dma addr and len for entry 4.
> 
> So what would be in the last entry {dma_addr, dma_len}? zeros?
> 
> >>I'm not sure anyone still does that, but the first spot to check would
> >>be the Parisc IOMMU drivers.
> 
> So how does that sit with the fact that dma_unmap requires the
> same sg_nents as in dma_map and not the actual value of dma entries?

Take a look at drivers/parisc/iommu-helpers.h:iommu_coalesce_chunks()
and drivers/parisc/sba_iommu.c:sba_unmap_sg() for example.

The first fills out the sglist, and zeroes all unused entries past what
it fills in.  The unmap side than simply exits the loop if the entries
are zeroed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
