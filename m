From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Fri, 20 Jan 2012 10:38:08 -0800
Message-ID: <CAL1RGDU8sFGyx9WQtLQ6kYN9HhhCctQvm+_dYthpAmMUs2RmkQ@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
 <CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com>
 <CAL1RGDWKg_+VZ0Gxqvf9-4W9O-YU_6euE7jOqbmdN6=zWiNS8A@mail.gmail.com> <CALfB72DdN9onmiqUhWqbPNC6Qf00TB_pC3UkM0xKQQJMg+zMKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72DdN9onmiqUhWqbPNC6Qf00TB_pC3UkM0xKQQJMg+zMKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2012 at 10:30 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> FYI, new Sandy Bridge motherboards will be out soon that do 512 GB and
> even 768 GB.

Yeah, Cisco UCS C260 goes up to 1TB in a 2socket 2U already so we really
should fix this.  I'll cook something up.

The good news is that the overhead is that we use more memory for adapter
context, but if you have 1TB of RAM you probably don't care about a few
more MB over overhead :)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
