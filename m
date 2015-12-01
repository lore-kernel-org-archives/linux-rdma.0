From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 6/6] IB/srp: Fix srp_map_sg_fr()
Date: Tue, 1 Dec 2015 10:39:51 -0800
Message-ID: <565DE977.2070606@sandisk.com>
References: <565DE3EC.2070002@sandisk.com> <565DE4BA.1040703@sandisk.com>
 <565DE864.5050407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE864.5050407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/01/2015 10:35 AM, Sagi Grimberg wrote:
>> After dma_map_sg() has been called the return value of that function
>> must be used as the number of elements in the scatterlist instead of
>> scsi_sg_count().
>
> Umm, but ib_map_mr_sg iterates on the sg list. Say you have sg_nents=3
> and after mapping you got dma_nents=2 (2 entries are contig) and you
> pass that, ib_sg_to_pages will only iterate on 2 elements won't it? am
> I missing something?

Hello Sagi,

 From https://www.kernel.org/doc/Documentation/DMA-API-HOWTO.txt:

<quote>
With scatterlists, you map a region gathered from several regions by:

	int i, count = dma_map_sg(dev, sglist, nents, direction);
	struct scatterlist *sg;

	for_each_sg(sglist, sg, count, i) {
		hw_address[i] = sg_dma_address(sg);
		hw_len[i] = sg_dma_len(sg);
	}

where nents is the number of entries in the sglist.
</quote>

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
