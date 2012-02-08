From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
Date: Wed, 8 Feb 2012 13:35:16 -0800
Message-ID: <CAG4TOxPwcdw+CwyczAVXBqovpECVj8ad+RsraqmchuQdM2bCXw@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop> <1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com> <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 8, 2012 at 1:26 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I noted that you typically use the for-next branch of the infiniband
> tree for fixes during
> the 1 < kernN-rc < (say) 6 time and for features during (kernN-rc > 6)
> till kern(N+1)-rc1
>
> This means that the window of time when features are actually accepted
> into your tree is kind of very limited. Would it be possible to
> maintain two branches: for-next and (say) rc-fixes, such that
> practically patches are reviewed/accepted to for-next at almost all
> times?
>
> BTW I see that networking and scsi maintainers use two trees
> (net/net-next) and (scsi-misc/scsi-rc-fixes), maybe it would be eaiser
> for you go this way?

It's not really an issue of not having a tree to put things into.  It's
more that the window when I actually review major things is not
as big as perhaps it should be.

So I generally try to get fixes in expeditiously because they're
easy to deal with, whereas I only dedicate time to merging bigger
things when I feel the pressure of the impending merge window.

I do usually have some small patches that are fine for the next window
but which I have only marked "to apply" in my mailbox, which it
might be a good idea to apply sooner so they get more -next tree
coverage.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
