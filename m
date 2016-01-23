From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 11:02:44 -0800
Message-ID: <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A3A777.3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 23, 2016 at 8:16 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> There is a schedule document somewhere?

For just the schedule? No. But there's this, for example:

    Documentation/development-process/2.Process

which talks about it and says "The merge window lasts for
approximately two weeks".

The easiest way to find that piece of documentation is actually to
just google "merge window". It's the first hit.

> I don't think it's as "clearly not ready" as you think, but that's just
> my opinion ;-)

So how ready and stable is this? IOW, if I do this pull, can I rely on
that being "it", and really just get fixes.

One of the reasons I absolutely detest the "last Friday" pull requests
is that it really tends to smell like "this pull request was hurried
to hit the merge window".  I much prefer seeing early pull requests
because that just shows that the subsystem is on top of the timing.
And that in turn means that I also get that warm and fuzzy feeling
that if the subsystem has its act together, I'll be getting just fixes
after the merge window is over.

(The _other_ reason I don't like the last-Friday pull requests and
prefer the early ones is that then I'm not hurried, and I can take my
time and do the pull requests in sensible groups - filesystems
together etc)

So if I end up pulling this, can I rely on getting just fixes for the
next ~6-7 weeks?

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
