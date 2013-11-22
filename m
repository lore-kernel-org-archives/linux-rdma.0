From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: PCIe 2.0 motherboard + ConnectX-3 cards
Date: Fri, 22 Nov 2013 02:59:17 -0500
Message-ID: <CADPSxAi06+_zjJ50v7CgCDzv+abDowN0pxBEgAZKwKBGPCe1ig@mail.gmail.com>
References: <CADPSxAhPhtMegUYmjVS6qZGsWVAbYKeOGRKz1CG9oK3S-pgD7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAhPhtMegUYmjVS6qZGsWVAbYKeOGRKz1CG9oK3S-pgD7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I had a related question regarding PCIe usage.

How exactly does the userspace driver interact with the HCA? I'm
reading the code for libmlx4 but I can't find any code for interaction
with PCIe. There are some references to 'ringing a doorbell via PCI
MMIO' - can someone please tell me how that works?

In general, it would be great if someone could explain the CPU-HCA
communication steps involved in doing an RDMA operation. If there is
an online resource from where I can read about this, I'd appreciate a
pointer.

Thanks for your time!

--Anuj



On Thu, Nov 21, 2013 at 5:26 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I have machines with Mellanox ConnectX-3 cards connected to a
> motherboard with PCIe 2.0. I had some questions regarding performance
> of this system:
>
> 1. When multiple clients issue small (32 byte) RDMA writes to the
> server, the combined throughput is about 22 million operations per
> second. With ConnectX-3 I should be able to get 35 million (quote from
> Mellanox).
>
> Is 22 million DMAs per second a PCIe 2.0 bottleneck?
>
> 2. When one client machine issues RDMA writes to multiple server
> machines, it can issue at most 10-11 million writes per second. Is
> this a PCIe bottleneck again?
>
> I believe it's a PCIe issue because an RDMA operation should involve 2
> (or more) PCIe operations at the active side:
> a. Write the work request to the HCA (or maybe the HCA reads the request).
> b. The HCA reads the payload from the processor.
>
> Does this reasoning sound correct?
>
> 3. Is there a way to reduce the number of PCIe operations at the
> active side? I don't think that posting a linked list of WQEs will
> help because the HCA should read them one by one.
>
> --Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
