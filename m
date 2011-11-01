From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 14:49:01 -0700
Message-ID: <CAG4TOxM4n3=51-3UqYF=iRS25OdRjTXoKDD6u1DukgRrwvTW1g@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
 <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
 <20111101162218.GA10710@obsidianresearch.com> <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
 <20111101173625.GH26974@obsidianresearch.com> <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 1, 2011 at 11:14 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Guys (Roland, Jason), I'm open to any comments, any time, for any
> patch, but for a patch which was posted weeks ago it's pretty unfair
> to have your comments coming only eight days after the merge window
> has been opened, lets try to come quickly to decision so I can fix
> this up along those lines,

Let's not get into fairness here... I'm trying to make progress on my backlog
but there are patches that for better or worse have been around for a year
or more.  And for this merge window, I did manage to do

 84 files changed, 4738 insertions(+), 984 deletions(-)

and include more than 60 patches.

There's no obligation to merge something just because you posted it before
the merge window, and in fact Linus's complaint at the kernel summit is
always that sub-maintainers don't say no enough.

And let's be honest in this specific case: the world is not going to end without
a few performance counters in sysfs.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
