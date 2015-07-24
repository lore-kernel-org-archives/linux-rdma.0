From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Fri, 24 Jul 2015 13:46:05 -0400
Message-ID: <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-39-git-send-email-sagig@mellanox.com> <20150722170413.GE6443@infradead.org> <55AFD3DC.8070508@dev.mellanox.co.il> <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724162657.GA21473-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 24, 2015, at 12:26 PM, Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com> wrote:

> On Fri, Jul 24, 2015 at 10:36:07AM -0400, Chuck Lever wrote:
>=20
>> Unfinished, but operational:
>>=20
>> http://git.linux-nfs.org/?p=3Dcel/cel-2.6.git;a=3Dshortlog;h=3Drefs/=
heads/nfs-rdma-future
>=20
> Nice..
>=20
> Can you spend some time and reflect on how some of this could be
> lowered into the core code?

The point of the prototype is to start thinking about this with
actual data. :-) So I=92m with you.


> The FMR and FRWR side have many
> similarities now..


>> FRWR is seeing a 10-15% throughput reduction with 8-thread dbench,
>> but a 5% improvement with 16-thread fio IOPS. 4K and 8K direct
>> read and write are negatively impacted.
>=20
> I'm not surprised since invalidate is sync. I belive you need to
> incorporate SEND WITH INVALIDATE to substantially recover this
> overhead.

I tried to find another kernel ULP using SEND WITH INVALIDATE, but
I didn=92t see one. I assume you mean the NFS server would use this
WR when replying, to knock down the RPC=92s client MRs remotely?


> It would be neat if the RQ could continue to advance while waiting fo=
r
> the invalidate.. That looks almost doable..

The new reply handling work queue is not restricted to serial reply
processing. Unlike the tasklet model, multiple RPC replies can be
processed at once, and can run across all CPUs.

The tasklet was global, shared across all RPC/RDMA receive queues on
that client. AFAICT there is very little else that is shared between
RPC replies.

I think using a work queue instead may be a tiny bit slower for each
RPC (perhaps due to additional context switching), but will allow
much better scaling with the number of transports and mount points
the client creates.

I may not have understood your comment.


>> I converted the RPC reply handler tasklet to a work queue context
>> to allow sleeping. A new .ro_unmap_sync method is invoked after
>> the RPC/RDMA header is parsed but before xprt_complete_rqst()
>> wakes up the waiting RPC.
>=20
> .. so the issue is the RPC must be substantially parsed to learn whic=
h
> MR it is associated with to schedule the invalidate?=20

Only the RPC/RDMA header has to be parsed, but yes. The needed
parsing is handled in rpcrdma_reply_handler right before the
=2Ero_unmap_unsync call.

Parsing the RPC reply results is then done by the upper layer
once xprt_complete_rqst() has run.


>> This is actually much more efficient than the current logic,
>> which serially does an ib_unmap_fmr() for each MR the RPC owns.
>> So FMR overall performs better with this change.
>=20
> Interesting..
>=20
>> Because the next RPC cannot awaken until the last send completes,
>> send queue accounting is based on RPC/RDMA credit flow control.
>=20
> So for FRWR the sync invalidate effectively guarentees all SQEs
> related to this RPC are flushed. That seems reasonable, if the number
> of SQEs and CQEs are properly sized in relation to the RPC slot count
> it should be workable..

Yes, both queues are sized in rpcrdma_ep_create() according to
the slot count / credit limit.


> How does FMR and PHYS synchronize?

We still rely on timing there.

The RPC's send buffer may be re-allocated by the next RPC
if that RPC wants to send a bigger request than this one. Thus
there is still a tiny but non-zero risk the HCA may not be
done with that send buffer. Closing that hole is still on my
to-do list.


>> I=92m sure there are some details here that still need to be
>> addressed, but this fixes the big problem with FRWR send queue
>> accounting, which was that LOCAL_INV WRs would continue to
>> consume SQEs while another RPC was allowed to start.
>=20
> Did you test without that artificial limit you mentioned before?

Yes. No problems now, the limit is removed in the last patch
in that series.


> I'm also wondering about this:
>=20
>> During some other testing I found that when a completion upcall
>> returns to the provider leaving CQEs still on the completion queue,
>> there is a non-zero probability that a completion will be lost.
>=20
> What does lost mean?

Lost means a WC in the CQ is skipped by ib_poll_cq().

In other words, I expected that during the next upcall,
ib_poll_cq() would return WCs that were not processed, starting
with the last one on the CQ when my upcall handler returned.

I found this by intentionally having the completion handler
process only one or two WCs and then return.


> The CQ is edge triggered, so if you don't drain it you might not get
> another timely CQ callback (which is bad), but CQEs themselves should
> not be lost.

I=92m not sure I fully understand this problem, it might
even be my misuderstanding about ib_poll_cq(). But forcing
the completion upcall handler to completely drain the CQ
during each upcall prevents the issue.

(Note, I don=92t think fixing this is a pre-requisite for
the synchronous invalidate work, but it just happened
to be in the patch queue).


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
