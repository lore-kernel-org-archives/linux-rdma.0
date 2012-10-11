From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Thu, 11 Oct 2012 13:44:41 -0700
Message-ID: <CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A@mail.gmail.com>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 11, 2012 at 8:34 AM, Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org> wrote:
>
> During memory memory registration, userspace buffers also go through same
> API calls (dma_map_sg_attrs(...)).
> What I am confused about why no such synchronization primitives are
> required in userspace before accessing
> an RDMA data buffer just after when an incoming write/recv (DMA on it) is
> finished? Who guarantees data
> freshness?

No one has really ever tried to deal with the issue of userspace RDMA on
a cache-incoherent architecture.  Basically if you try the current stack, the
in-kernel users (IPoIB etc) should be OK but libibverbs etc. will be completely
broken.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
