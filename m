From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Thu, 2 Aug 2012 09:26:26 -0700
Message-ID: <CAL1RGDVva-Se0EBAfDRX10o89KbbSMox6DSDNCf3o4viutFKwA@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
 <CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com>
 <CALfB72B_Ge0+Tyb9zs+M8K7-8EvKJDQH0ErTxod+UnG6+-KxaA@mail.gmail.com>
 <CAL1RGDU6ZSo5gO5+ngWCEcMuoiaKaNuNS4kw+YSTenJnWUaeLA@mail.gmail.com> <CALfB72CHMdVJ5pZcc1rFD_yh5tkTRyk7CaHLe6Z6me-ihaexeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72CHMdVJ5pZcc1rFD_yh5tkTRyk7CaHLe6Z6me-ihaexeA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 2, 2012 at 8:03 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Did something happen with this discussion?
>
> possible bug when scaling MTT table size with system ram
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11728.html

I thought I had merged a patch to use vmalloc for bigger allocations
but looking at what's actually upstream I don't see it.

Or, can you resend that if indeed it is missing?

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
