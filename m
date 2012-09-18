From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Fix crash resulted as of use after free for
 multicast object
Date: Tue, 18 Sep 2012 10:18:01 -0700
Message-ID: <CAL1RGDXBDaBVtON-oJ0_89F+HixmNiyrzc6qGC1MGaDUQC1kpw@mail.gmail.com>
References: <Pine.GSO.4.63.1208300859100.27363@stinky-local.trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.63.1208300859100.27363-ZwCfkpyJE+ZxMqFJ2HQs78wN0UxFyt4e@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 30, 2012 at 12:01 AM, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org> wrote:
> Fix a crash in ipoib_mcast_join_task(). With help from Or Gerlitz.

Thanks, applied.  But srsly, read over the changelog in that attachment
and think about a bit more proofreading next time around.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
