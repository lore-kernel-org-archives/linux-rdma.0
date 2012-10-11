From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Thu, 11 Oct 2012 23:04:02 +0200
Message-ID: <CAJZOPZJiEj7rMjF1ouukCPAGCXaNBhHoG1-YuDfEikvM-LLrXg@mail.gmail.com>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
	<CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 11, 2012 at 10:44 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> No one has really ever tried to deal with the issue of userspace RDMA on
> a cache-incoherent architecture.  Basically if you try the current stack, the
> in-kernel users (IPoIB etc) should be OK but libibverbs etc. will be completely broken.

I think the question might refer even to cache-coherent systems, e.g
in the kernel IB core and ULPs all buffers are dma mapped to/from the
device before/after they are touched by the CPU and vise versa, wheres
in user space, after the buffers are registered once, they are
repeatedly touched by the CPUs and provided to the HW for DMA, e.g all
user space buffers are treated like kernel DMA coherent ones.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
