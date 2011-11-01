From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Wed, 2 Nov 2011 00:32:48 +0200
Message-ID: <CAJZOPZKhWKSCHDvPHSEzbNhEfmv670pKvggR-wds0u8QEym8HQ@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
	<CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
	<CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
	<20111101162218.GA10710@obsidianresearch.com>
	<CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
	<20111101173625.GH26974@obsidianresearch.com>
	<CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
	<CAG4TOxM4n3=51-3UqYF=iRS25OdRjTXoKDD6u1DukgRrwvTW1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxM4n3=51-3UqYF=iRS25OdRjTXoKDD6u1DukgRrwvTW1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 1, 2011 at 11:49 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> There's no obligation to merge something just because you posted it before
> the merge window, and in fact Linus's complaint at the kernel summit is
> always that sub-maintainers don't say no enough.
>
> And let's be honest in this specific case: the world is not going to end without
> a few performance counters in sysfs.

Agree on all,  I just want to see progress here, its okay for this
discussion and its such
to miss this or that merge window, as long as at some point we get
into a resolution which allows to fix a patch and queue it for the
next merge window, e.g in this case, if we miss 3.2-rc1 and you don't
feel the patches are appropriate for -rc2, they can be queued for 3.3

BTW - this brings something I wanted to raise long ago... I would be
happy to see the for-next branch active at all times, e.g in the same
manner net-next is, which means that patches aren't reviewed/accepted
only/mostly in the weeks before the merge window opens but rather
constantly over time. This shouldn't increase the amortized load on
you and reduce the possible (maybe existing to some extent?)
frustration by people who submit patches long before the next window
opens and don't much feedback... (again, not relevant to this patch
and the next)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
