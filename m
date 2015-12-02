From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 6/6] IB/srp: Fix srp_map_sg_fr()
Date: Wed, 2 Dec 2015 04:41:54 -0800
Message-ID: <20151202124154.GF28278@infradead.org>
References: <565DE3EC.2070002@sandisk.com>
 <565DE4BA.1040703@sandisk.com>
 <565DE864.5050407@dev.mellanox.co.il>
 <565DE977.2070606@sandisk.com>
 <565EDD2A.6050407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <565EDD2A.6050407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 02, 2015 at 01:59:38PM +0200, Sagi Grimberg wrote:
> >where nents is the number of entries in the sglist.
> ></quote>
> 
> From Documentation/DMA_API.txt
> 
> <quote>
>         int
>         dma_map_sg(struct device *dev, struct scatterlist *sg,
>                 int nents, enum dma_data_direction direction)
> 
> Returns: the number of DMA address segments mapped (this may be shorter
> than <nents> passed in if some elements of the scatter/gather list are
> physically or virtually adjacent and an IOMMU maps them with a single
> entry).
> </quote>

dma_map_sg returns the actual number of entries to iterate.  At least
historically some IOMMU implementations would do strange tricks like:

  If entries 2 and 3 could be merged dma_len for 2 would span 2 and 3,
  and then entry 3 would actually have the dma addr and len for entry 4.

I'm not sure anyone still does that, but the first spot to check would
be the Parisc IOMMU drivers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
