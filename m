From: Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS over RDMA crashing
Date: Wed, 12 Mar 2014 11:29:09 -0400
Message-ID: <20140312112909.58788783@ipyr.poochiereds.net>
References: <51127B3F.2090200@mellanox.com>
	<20130206222435.GL16417@fieldses.org>
	<20130207164134.GK3222@fieldses.org>
	<003601cf3a26$94523ee0$bcf6bca0$@opengridcomputing.com>
	<005d01cf3a45$94ced0d0$be6c7270$@opengridcomputing.com>
	<531B47B3.1070503@opengridcomputing.com>
	<531B6D90.2090208@opengridcomputing.com>
	<531B79F8.2020008@opengridcomputing.com>
	<20140312093300.7a434cbb@tlielax.poochiereds.net>
	<731A7629-7DBB-4FC3-8F21-70380705ED4E@primarydata.com>
	<20140312102806.435847a7@ipyr.poochiereds.net>
	<56B1FEC7-8514-4B2B-851B-7BC965A26AA8@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B1FEC7-8514-4B2B-851B-7BC965A26AA8-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Dr Fields James Bruce <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tucker Tom <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Lever Charles Edward <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 12 Mar 2014 11:03:52 -0400
Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:

>=20
> On Mar 12, 2014, at 10:28, Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > On Wed, 12 Mar 2014 10:05:24 -0400
> > Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:
> >=20
> >>=20
> >> On Mar 12, 2014, at 9:33, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >>=20
> >>> On Sat, 08 Mar 2014 14:13:44 -0600
> >>> Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> >>>=20
> >>>> On 3/8/2014 1:20 PM, Steve Wise wrote:
> >>>>>=20
> >>>>>> I removed your change and started debugging original crash
> >>>>>> that happens on top-o-tree.   Seems like rq_next_pages is
> >>>>>> screwed up.  It should always be >=3D rq_respages, yes?  I add=
ed
> >>>>>> a BUG_ON() to assert this in rdma_read_xdr() we hit the
> >>>>>> BUG_ON(). Look
> >>>>>>=20
> >>>>>> crash> svc_rqst.rq_next_page 0xffff8800b84e6000
> >>>>>> rq_next_page =3D 0xffff8800b84e6228
> >>>>>> crash> svc_rqst.rq_respages 0xffff8800b84e6000
> >>>>>> rq_respages =3D 0xffff8800b84e62a8
> >>>>>>=20
> >>>>>> Any ideas Bruce/Tom?
> >>>>>>=20
> >>>>>=20
> >>>>> Guys, the patch below seems to fix the problem.  Dunno if it is=
=20
> >>>>> correct though.  What do you think?
> >>>>>=20
> >>>>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c=20
> >>>>> b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>>>> index 0ce7552..6d62411 100644
> >>>>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>>>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>>>> @@ -90,6 +90,7 @@ static void rdma_build_arg_xdr(struct svc_rqs=
t
> >>>>> *rqstp, sge_no++;
> >>>>>      }
> >>>>>      rqstp->rq_respages =3D &rqstp->rq_pages[sge_no];
> >>>>> +       rqstp->rq_next_page =3D rqstp->rq_respages;
> >>>>>=20
> >>>>>      /* We should never run out of SGE because the limit is
> >>>>> defined to
> >>>>>       * support the max allowed RPC data length
> >>>>> @@ -276,6 +277,7 @@ static int fast_reg_read_chunks(struct=20
> >>>>> svcxprt_rdma *xprt,
> >>>>>=20
> >>>>>      /* rq_respages points one past arg pages */
> >>>>>      rqstp->rq_respages =3D &rqstp->rq_arg.pages[page_no];
> >>>>> +       rqstp->rq_next_page =3D rqstp->rq_respages;
> >>>>>=20
> >>>>>      /* Create the reply and chunk maps */
> >>>>>      offset =3D 0;
> >>>>>=20
> >>>>>=20
> >>>>=20
> >>>> While this patch avoids the crashing, it apparently isn't
> >>>> correct...I'm getting IO errors reading files over the mount. :)
> >>>>=20
> >>>=20
> >>> I hit the same oops and tested your patch and it seems to have
> >>> fixed that particular panic, but I still see a bunch of other mem
> >>> corruption oopses even with it. I'll look more closely at that
> >>> when I get some time.
> >>>=20
> >>> FWIW, I can easily reproduce that by simply doing something like:
> >>>=20
> >>>  $ dd if=3D/dev/urandom of=3D/file/on/nfsordma/mount bs=3D4k coun=
t=3D1
> >>>=20
> >>> I'm not sure why you're not seeing any panics with your patch in
> >>> place. Perhaps it's due to hw differences between our test rigs.
> >>>=20
> >>> The EIO problem that you're seeing is likely the same client bug
> >>> that Chuck recently fixed in this patch:
> >>>=20
> >>>  [PATCH 2/8] SUNRPC: Fix large reads on NFS/RDMA
> >>>=20
> >>> AIUI, Trond is merging that set for 3.15, so I'd make sure your
> >>> client has those patches when testing.
> >>>=20
> >>=20
> >> Nothing is in my queue yet.
> >>=20
> >=20
> > Doh! Any reason not to merge that set from Chuck? They do fix a
> > couple of nasty client bugs=E2=80=A6
> >=20
>=20
> Most of them are one-line debugging dprintks which I do not intend to
> apply.
>=20

=46air enough. Those are certainly not necessary, but some of them clea=
n
up existing printks and probably do need to go in. That said, debugging
this stuff is *really* difficult so having extra debug printks in place
seems like a good thing (unless you're arguing for moving wholesale to
tracepoints instead).

> One of them confuses a readdir optimisation with a bugfix; at the
> very least the patch comments need changing.

I'll leave that to Chuck to comment on. I had the impression that it
was a bugfix, but maybe there's some better way to handle that bug.

>  That leaves 2 that can
> go in, however as they are clearly insufficient to make RDMA safe for
> general use, they certainly do not warrant a stable@ label. The
> workaround for the Oopses is simple: use TCP.
>=20

Yeah, it's definitely rickety, but it's in and we do need to get fixes
merged to this code. I'm ok with dropping the stable labels on those
patches, but if we're going to declare this stuff "not stable enough
for general use" then I think that we should take an aggressive approac=
h
on merging fixes to it.

=46WIW, I also notice that Kconfig doesn't show the option to actually
enable/disable RDMA transports. I'll post a patch to fix that soon.
Since this stuff is not very safe to use, then we should make it
reasonably simple to disable it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
