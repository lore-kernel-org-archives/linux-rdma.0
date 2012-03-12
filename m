From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC] mxl4_core: Scale size of MTT table with system RAM
Date: Mon, 12 Mar 2012 16:29:30 -0700
Message-ID: <CAL1RGDVaGpVXukyKpJ2vPZE3br4UWn+td8Ba03fKHuY-53H2vg@mail.gmail.com>
References: <1330970972-10225-1-git-send-email-roland@kernel.org> <CAJZOPZ+qLzZaH=fmKVRE0K559DoeQ1SsrsjSDY0TS-z8+WjnYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+qLzZaH=fmKVRE0K559DoeQ1SsrsjSDY0TS-z8+WjnYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 12, 2012 at 2:35 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> just curious, why we want to cover > totalram? also the commit title
> has "mxl4" instead of "mlx4"

It's just a heuristic, but I figured some app might want to register essentially
all of memory, and then we want some more to cover other users.  The amount
of memory used for unused MTT space is pretty small, I think.

I fixed the mxl4->mlx4, thanks.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
