From: Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS over RDMA crashing
Date: Wed, 12 Mar 2014 10:28:06 -0400
Message-ID: <20140312102806.435847a7@ipyr.poochiereds.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <731A7629-7DBB-4FC3-8F21-70380705ED4E-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Dr Fields James Bruce <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tucker Tom <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 12 Mar 2014 10:05:24 -0400
Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:

> 
> On Mar 12, 2014, at 9:33, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Sat, 08 Mar 2014 14:13:44 -0600
> > Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> > 
> >> On 3/8/2014 1:20 PM, Steve Wise wrote:
> >>> 
> >>>> I removed your change and started debugging original crash that 
> >>>> happens on top-o-tree.   Seems like rq_next_pages is screwed
> >>>> up.  It should always be >= rq_respages, yes?  I added a
> >>>> BUG_ON() to assert this in rdma_read_xdr() we hit the BUG_ON().
> >>>> Look
> >>>> 
> >>>> crash> svc_rqst.rq_next_page 0xffff8800b84e6000
> >>>> rq_next_page = 0xffff8800b84e6228
> >>>> crash> svc_rqst.rq_respages 0xffff8800b84e6000
> >>>> rq_respages = 0xffff8800b84e62a8
> >>>> 
> >>>> Any ideas Bruce/Tom?
> >>>> 
> >>> 
> >>> Guys, the patch below seems to fix the problem.  Dunno if it is 
> >>> correct though.  What do you think?
> >>> 
> >>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c 
> >>> b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>> index 0ce7552..6d62411 100644
> >>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> >>> @@ -90,6 +90,7 @@ static void rdma_build_arg_xdr(struct svc_rqst
> >>> *rqstp, sge_no++;
> >>>       }
> >>>       rqstp->rq_respages = &rqstp->rq_pages[sge_no];
> >>> +       rqstp->rq_next_page = rqstp->rq_respages;
> >>> 
> >>>       /* We should never run out of SGE because the limit is
> >>> defined to
> >>>        * support the max allowed RPC data length
> >>> @@ -276,6 +277,7 @@ static int fast_reg_read_chunks(struct 
> >>> svcxprt_rdma *xprt,
> >>> 
> >>>       /* rq_respages points one past arg pages */
> >>>       rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
> >>> +       rqstp->rq_next_page = rqstp->rq_respages;
> >>> 
> >>>       /* Create the reply and chunk maps */
> >>>       offset = 0;
> >>> 
> >>> 
> >> 
> >> While this patch avoids the crashing, it apparently isn't
> >> correct...I'm getting IO errors reading files over the mount. :)
> >> 
> > 
> > I hit the same oops and tested your patch and it seems to have fixed
> > that particular panic, but I still see a bunch of other mem
> > corruption oopses even with it. I'll look more closely at that when
> > I get some time.
> > 
> > FWIW, I can easily reproduce that by simply doing something like:
> > 
> >   $ dd if=/dev/urandom of=/file/on/nfsordma/mount bs=4k count=1
> > 
> > I'm not sure why you're not seeing any panics with your patch in
> > place. Perhaps it's due to hw differences between our test rigs.
> > 
> > The EIO problem that you're seeing is likely the same client bug
> > that Chuck recently fixed in this patch:
> > 
> >   [PATCH 2/8] SUNRPC: Fix large reads on NFS/RDMA
> > 
> > AIUI, Trond is merging that set for 3.15, so I'd make sure your
> > client has those patches when testing.
> > 
> 
> Nothing is in my queue yet.
> 

Doh! Any reason not to merge that set from Chuck? They do fix a couple
of nasty client bugs...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
