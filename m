From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Fri, 24 Jul 2015 13:10:03 -0600
Message-ID: <20150724191003.GA26225@obsidianresearch.com>
References: <20150722170413.GE6443@infradead.org>
 <55AFD3DC.8070508@dev.mellanox.co.il>
 <20150722175755.GH26909@obsidianresearch.com>
 <55B0C18B.4080901@dev.mellanox.co.il>
 <20150723163124.GD25174@obsidianresearch.com>
 <55B11D84.102@dev.mellanox.co.il>
 <20150723185334.GB31346@obsidianresearch.com>
 <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com>
 <20150724162657.GA21473@obsidianresearch.com>
 <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <903CDFB5-04FE-47B6-B044-E960E8A8BC4C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 01:46:05PM -0400, Chuck Lever wrote:
> > I'm not surprised since invalidate is sync. I belive you need to
> > incorporate SEND WITH INVALIDATE to substantially recover this
> > overhead.
>=20
> I tried to find another kernel ULP using SEND WITH INVALIDATE, but
> I didn=E2=80=99t see one. I assume you mean the NFS server would use =
this
> WR when replying, to knock down the RPC=E2=80=99s client MRs remotely=
?

Yes. I think the issue with it not being used in the kernel is mainly
to do with lack of standardization. The verb cannot be used unless
both sides negotiate it and perhaps the older RDMA protocols have not
been revised to include that.

=46or simple testing purposes it shouldn't be too hard to force it to
get an idea if it is worth perusing. On the RECV work completion check
if the right rkey was invalidated and skip the invalidation
step. Presumably the HCA does all this internally very quickly..
=20
> I may not have understood your comment.

Okay, I didn't looke closely at the entire series together..

> Only the RPC/RDMA header has to be parsed, but yes. The needed
> parsing is handled in rpcrdma_reply_handler right before the
> .ro_unmap_unsync call.

Right, okay, if this could be done in the rq callback itself rather
than bounce to a wq and immediately turn around the needed invalidate
posts you'd get back a little more overhead by reducing the time to
turn it around... Then bounce to the wq to complete from the SQ
callback ?

> > Did you test without that artificial limit you mentioned before?
>=20
> Yes. No problems now, the limit is removed in the last patch
> in that series.

Okay, so that was just overflowing the sq due to not accounting..

> >> During some other testing I found that when a completion upcall
> >> returns to the provider leaving CQEs still on the completion queue=
,
> >> there is a non-zero probability that a completion will be lost.
> >=20
> > What does lost mean?
>=20
> Lost means a WC in the CQ is skipped by ib_poll_cq().
>=20
> In other words, I expected that during the next upcall,
> ib_poll_cq() would return WCs that were not processed, starting
> with the last one on the CQ when my upcall handler returned.

Yes, this is what it should do. I wouldn't expect a timely upcall, but
none should be lost.

> I found this by intentionally having the completion handler
> process only one or two WCs and then return.
>=20
> > The CQ is edge triggered, so if you don't drain it you might not ge=
t
> > another timely CQ callback (which is bad), but CQEs themselves shou=
ld
> > not be lost.
>=20
> I=E2=80=99m not sure I fully understand this problem, it might
> even be my misuderstanding about ib_poll_cq(). But forcing
> the completion upcall handler to completely drain the CQ
> during each upcall prevents the issue.

CQs should never be lost.

The idea that you can completely drain the CQ during the upcall is
inherently racey, so this cannot be the answer to whatever the problem
is..

Is there any chance this is still an artifact of the lazy SQE flow
control? The RDMA buffer SQE recycling is solved by the sync
invalidate, but workloads that don't use RDMA buffers (ie SEND only)
will still run without proper flow control...

If you are totally certain a CQ was dropped from ib_poll_cq, and that
the SQ is not overflowing by strict accounting, then I'd say driver
problem, but the odds of having an undetected driver problem like that
at this point seem somehow small...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
