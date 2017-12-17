From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Sun, 17 Dec 2017 03:02:16 +0100
Message-ID: <1513476136.31439.96.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
         <20171216094525.5e9c985c@xeon-e3> <1513448673.4647.45.camel@perches.com>
         <499ec5ae-d1d5-3bb2-8e10-de48283a1c2e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <499ec5ae-d1d5-3bb2-8e10-de48283a1c2e-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-12-16 at 12:00 -0800, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> On 12/16/17 10:24 AM, Joe Perches wrote:
> > On Sat, 2017-12-16 at 09:45 -0800, Stephen Hemminger wrote:
> >> On Sat, 16 Dec 2017 15:42:29 +0100 Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>> +# Code simplification:
> >>> +#
> >>> +except ALLOC_WITH_MULTIPLY ib.c
> >>> +except PREFER_PR_LEVEL ib_cm.c ib_recv.c ib_send.c rdma_transport.c threads.c
> transport.c
> >>> +except UNNECESSARY_ELSE ib_fmr.c
> >>> +except UNNECESSARY_PARENTHESES ib_rdma.c rdma.c recv.c send.c
> >>> +except PRINTK_RATELIMITED ib_frmr.c
> >>> +except EMBEDDED_FUNCTION_NAME ib_rdma.c
> >>> +
> >>> +# Style and readability:
> >>> +#
> >>> +except BRACES ib_cm.c ib_rdma.c ib_recv.c send.c transport.c
> >>> +except OOM_MESSAGE ib.c tcp.c
> >>> +except LONG_LINE_STRING ib.c ib_recv.c ib_send.c
> >>> +except FUNCTION_ARGUMENTS ib.h ib_mr.h rds.h tcp.h
> >>> +except OPEN_ENDED_LINE recv.c ib_recv.c
> >>> +
> >>> +# Candidates to leave as exceptions (don't fix):
> >>> +except MULTIPLE_ASSIGNMENTS ib_send.c
> >>> +except LONG_LINE_STRING connection.c
> >>> +except OPEN_BRACE connection.c
> >>> +
> >>
> >> Why start letting subsystems have a free-pass?
> >> Also this would mean that new patches to IB would continue the bad habits.
> And I don't need any free pass for RDS either.

It's not a free pass, it's an assessment of the current situation, to allow 
people to start working on it easily. I have already done some of that work
and will post that later.

> I missed V1 of this series but Knut, please don't add
> any exceptions for RDS and if there is something needs to
> be fixed, we can address it. Once your infrastructure
> gets merged, the subsequent fixes can be added.

This is about temporary masking some errors to allow automated testing
to prevent new regressions to occur in all the files and for all the 
types that are not excepted!

> > 
> > I agree with this comment at least for net/rds.
> > 
> > Most of these existing messages from checkpatch should
> > probably be inspected and corrected where possible to
> > minimize the style differences between this subsystem
> > and the rest of the kernel.
> > 
> > For instance, here's a trivial patch to substitute
> > pr_<level> for printks and a couple braces next to
> > these substitutions.
> >
> Thanks Joe. I actually had a similar patch a while back but
> since it was lot of churn, and code was already merged,
> never submitted it and then later forgot about it.
> 
> Will look into it.

Please look at my set here first - I have already spent considerable time cleaning up
stuff while working on this:

https://github.com/knuto/linux/tree/runchecks

Thanks,
Knut

> > btw:
> > 
> > in ib_cm, why is one call to ib_modify_qp emitted
> > with a -ret and the other with a positive err?
> >
> Its oversight and will fix that.
> 
> Regards,
> Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
