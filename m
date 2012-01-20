From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Fri, 20 Jan 2012 20:30:23 +0200
Message-ID: <CALfB72DdN9onmiqUhWqbPNC6Qf00TB_pC3UkM0xKQQJMg+zMKA@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
 <CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com> <CAL1RGDWKg_+VZ0Gxqvf9-4W9O-YU_6euE7jOqbmdN6=zWiNS8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWKg_+VZ0Gxqvf9-4W9O-YU_6euE7jOqbmdN6=zWiNS8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello

On Fri, Jan 20, 2012 at 8:03 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> By the way, I wonder if we should auto-tune num_mtt so
> we have enough MTTs to cover, say, 4X of the amount of
> physical memory.
> How much RAM do you have in your system?

192 GB.

FYI, new Sandy Bridge motherboards will be out soon that do 512 GB and
even 768 GB.

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
