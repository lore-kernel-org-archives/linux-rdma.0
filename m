From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Sun, 17 Dec 2017 02:46:16 +0100
Message-ID: <1513475176.31439.81.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
         <20171216094525.5e9c985c@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171216094525.5e9c985c@xeon-e3>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-12-16 at 09:45 -0800, Stephen Hemminger wrote:
> On Sat, 16 Dec 2017 15:42:29 +0100
> Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > +
> > +# Important to fix from a quality perspective:
> > +#
> > +except AVOID_BUG connection.c ib.c ib_cm.c ib_rdma.c ib_recv.c ib_ring.c ib_send.c
> info.c loop.c message.c
> > +except AVOID_BUG rdma.c recv.c send.c stats.c tcp_recv.c transport.c
> > +except MEMORY_BARRIER ib_recv.c send.c tcp_send.c
> > +except WAITQUEUE_ACTIVE cong.c ib_rdma.c ib_ring.c ib_send.c
> > +except UNNECESSARY_ELSE bind.c ib_cm.c
> > +except MACRO_ARG_PRECEDENCE connection.c ib.h rds.h
> > +except MACRO_ARG_REUSE rds.h
> > +except ALLOC_SIZEOF_STRUCT cong.c ib.c ib_cm.c loop.c message.c rdma.c
> > +except UNCOMMENTED_DEFINITION ib_cm.c
> > +
> > +# Code simplification:
> > +#
> > +except ALLOC_WITH_MULTIPLY ib.c
> > +except PREFER_PR_LEVEL ib_cm.c ib_recv.c ib_send.c rdma_transport.c threads.c
> transport.c
> > +except UNNECESSARY_ELSE ib_fmr.c
> > +except UNNECESSARY_PARENTHESES ib_rdma.c rdma.c recv.c send.c
> > +except PRINTK_RATELIMITED ib_frmr.c
> > +except EMBEDDED_FUNCTION_NAME ib_rdma.c
> > +
> > +# Style and readability:
> > +#
> > +except BRACES ib_cm.c ib_rdma.c ib_recv.c send.c transport.c
> > +except OOM_MESSAGE ib.c tcp.c
> > +except LONG_LINE_STRING ib.c ib_recv.c ib_send.c
> > +except FUNCTION_ARGUMENTS ib.h ib_mr.h rds.h tcp.h
> > +except OPEN_ENDED_LINE recv.c ib_recv.c
> > +
> > +# Candidates to leave as exceptions (don't fix):
> > +except MULTIPLE_ASSIGNMENTS ib_send.c
> > +except LONG_LINE_STRING connection.c
> > +except OPEN_BRACE connection.c
> > +
> 
> Why start letting subsystems have a free-pass?

It's not a free pass, on the contrary - it's a way to enable the build bots/CI systems to
prevent regressions!

Right now, no automatic system can be set up to run checkpatch on almost any subsystem in
the kernel because there are so many warnings. That means that regressions happens all
over the place, even on source files and for types of checks that there currently are no
issues. Also reviewers have to spend time correcting whitespace issues which automation
can really handle much better!

Now, let's assume that we get the build bots to run their builds with make C=2 (which my
patches here allow, since it produces 0 warnings by design and by default)

Once this patch is in, errors of any kind of any of the types that are *not* excepted by
this file will break the build and generate a warning report, forcing the committer to fix
the errors right away. To me that's a big improvement from today.

> Also this would mean that new patches to IB would continue the bad habits

That's **only for the excepted types and files, and a temporary situation 
until we can fix the rest of the issues.

See my additional patch set here as an example of how I see us attack this piecemeal:

https://github.com/knuto/linux/tree/runchecks

I'll post that set as soon as patch #1/2 here is in.

I hope this clarifies!

Thanks,
Knut

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
