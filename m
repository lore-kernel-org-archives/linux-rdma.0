From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/9] dma: Add dma_virt_ops
Date: Wed, 11 Jan 2017 16:07:35 -0800
Message-ID: <2be64d60-9579-4a2a-d38c-8f3ed4a2939f@sandisk.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
 <20170111005648.14988-4-bart.vanassche@sandisk.com>
 <20170111085625.GA15575@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111085625.GA15575-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/11/2017 12:56 AM, Christoph Hellwig wrote:
>> +lib-$(CONFIG_HAS_DMA) += dma-virt.o
> 
> There probably should be a config option for it for two reasons:
> 
>  - do not bloat kernels that don't need it.
>  - the feature can only work for 32-bit architectures or for
>    64-bit architectures that set ARCH_DMA_ADDR_T_64BIT…
>    Alternatively this option would have to force
>    ARCH_DMA_ADDR_T_64BIT when not yet set for 64-bit architectures.
> 
> And yes, this is currently broken already for, but we'd better fix it.

Hello Christoph,

That sounds like a good idea to me. I will make sure that both
dma_noop_ops and dma_virt_ops are only built if needed.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
