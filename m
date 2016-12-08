From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH, RFC 0/5] IB: Optimize DMA mapping
Date: Thu, 8 Dec 2016 08:48:16 +0200
Message-ID: <CAJ3xEMi4HY9Ehp-V4rP5UieAk=GjAu0X4uEnP-yMDomcFDpHkA@mail.gmail.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <07c07529-4636-fafb-2598-7358d8a1460d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 8, 2016 at 3:10 AM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> The DMA mapping operations are in the hot path so it is important that the
> overhead of these operations is as low as possible. There has been a reason
> in the past to have DMA mapping operations that are specific to the IB
> subsystem but that reason no longer exists today.

can you elaborate on that a little further... I recall it was
something with the ipath and Co
drivers and memory extensions on 32 bit systems?

> An additional benefit is that the size of HW and SW
> drivers that do not use DMA is reduced by switching to dma_noop_ops.

few words on that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
