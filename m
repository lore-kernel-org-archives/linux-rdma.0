From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/6] SRP initiator related bug fixes
Date: Sat, 5 Dec 2015 03:17:15 -0800
Message-ID: <20151205111715.GA31393@infradead.org>
References: <565DE3EC.2070002@sandisk.com>
 <56621CDF.3070604@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56621CDF.3070604-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On Fri, Dec 04, 2015 at 03:08:15PM -0800, Bart Van Assche wrote:
> While preparing this patch series I noticed that none of the SCSI RDMA
> initiator drivers syncs RDMA buffers before performing RDMA. Does
> anyone know why something like the code below is not present in these
> drivers and why no dma_sync_sg operations are present in struct
> ib_dma_mapping_ops ?

dma_map*/dma_unmap* have to do implicit syns, so no explicit call
is required.  That's probably the reason why we don't need them in
the weird RDMA shadows of these functions (for which I still don't
understand the reason, while we're at it..).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
