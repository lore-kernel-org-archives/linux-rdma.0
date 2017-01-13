From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Fri, 13 Jan 2017 23:26:22 +0200
Message-ID: <eb220182-6e02-2729-27ac-7ee402c808af@grimberg.me>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hello Doug,
>
> As you know there are two sets of DMA mapping operations in the Linux
> kernel:
> - One set of DMA mapping operations that is used by most drivers.
> - Another set of DMA mapping operations that is only used by the RDMA
>   drivers.
> Having two sets of DMA mapping operations is not only a source of
> confusion but also a source of unnecessary overhead. The DMA mapping
> operations are in the hot path so it is important that the overhead
> of these operations is as low as possible. Hence this patch series
> that converts the RDMA code to the standard DMA mapping API and
> thereby eliminates the if (dev->dma_ops) test from the hot path. An
> additional benefit is that the size of HW and SW drivers that do not
> use DMA is reduced by switching to dma_virt_ops.

This looks really good!

Thanks Bart for doing this,

For the series:

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
