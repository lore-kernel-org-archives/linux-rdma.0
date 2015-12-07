From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/6] SRP initiator related bug fixes
Date: Mon, 7 Dec 2015 09:15:37 -0800
Message-ID: <5665BEB9.5030501@sandisk.com>
References: <565DE3EC.2070002@sandisk.com> <56621CDF.3070604@sandisk.com>
 <20151205111715.GA31393@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151205111715.GA31393-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/05/2015 03:17 AM, Christoph Hellwig wrote:
> Hi Bart,
>
> On Fri, Dec 04, 2015 at 03:08:15PM -0800, Bart Van Assche wrote:
>> While preparing this patch series I noticed that none of the SCSI RDMA
>> initiator drivers syncs RDMA buffers before performing RDMA. Does
>> anyone know why something like the code below is not present in these
>> drivers and why no dma_sync_sg operations are present in struct
>> ib_dma_mapping_ops ?
>
> dma_map*/dma_unmap* have to do implicit syncs, so no explicit call
> is required.  That's probably the reason why we don't need them in
> the weird RDMA shadows of these functions (for which I still don't
> understand the reason, while we're at it..).

Hello Christoph,

struct ib_dma_mapping_ops was added through commit "IB: Add DMA mapping 
functions to allow device drivers to interpose" 
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=9b513090a3c5e4964f9ac09016c1586988abb3d5). 
I'm not sure that these functions are still needed by the qib or ipath 
drivers since the .dma_address and .dma_len members have been removed 
some time ago from that structure (see also 
http://thread.gmane.org/gmane.linux.drivers.rdma/19730). It would be 
useful to have data available that shows the performance difference with 
and without struct ib_dma_mapping_ops for the qib and ipath drivers but 
I do not know whether such data is available publicly.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
