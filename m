From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH, RFC 0/5] IB: Optimize DMA mapping
Date: Wed, 7 Dec 2016 17:10:00 -0800
Message-ID: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The DMA mapping operations are in the hot path so it is important that 
the overhead of these operations is as low as possible. There has been a 
reason in the past to have DMA mapping operations that are specific to 
the IB subsystem but that reason no longer exists today. Hence this 
patch series that eliminates the if (dev->dma_ops) test from the hot 
path. An additional benefit is that the size of HW and SW drivers that 
do not use DMA is reduced by switching to dma_noop_ops. The patches in 
this series are:

0001-treewide-constify-most-struct-dma_map_ops.patch
0002-misc-vop-Remove-a-cast.patch
0003-Move-dma_ops-from-archdata-into-struct-device.patch
0004-IB-Switch-from-struct-ib_dma_mapping_ops-to-struct-d.patch
0005-treewide-Inline-ib_dma_map_-functions.patch

As usual, feedback is welcome.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
