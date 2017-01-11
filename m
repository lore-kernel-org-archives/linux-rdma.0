From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/9] IB: Optimize DMA mapping
Date: Tue, 10 Jan 2017 17:28:14 -0800
Message-ID: <320aa1cd-8110-2724-a43d-514efc386127@oracle.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111005648.14988-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/10/17 4:56 PM, Bart Van Assche wrote:
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
>
This is really good series. I was always wondering why the extra
indirection was added first place on streaming APIs.

Regards,
Santosh


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
