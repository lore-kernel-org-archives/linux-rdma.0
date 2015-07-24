From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Fri, 24 Jul 2015 10:26:57 -0600
Message-ID: <20150724162657.GA21473@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
 <20150722170413.GE6443@infradead.org>
 <55AFD3DC.8070508@dev.mellanox.co.il>
 <20150722175755.GH26909@obsidianresearch.com>
 <55B0C18B.4080901@dev.mellanox.co.il>
 <20150723163124.GD25174@obsidianresearch.com>
 <55B11D84.102@dev.mellanox.co.il>
 <20150723185334.GB31346@obsidianresearch.com>
 <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DE0226A1-A7FC-4618-91F1-FE34347C252A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 10:36:07AM -0400, Chuck Lever wrote:

> Unfinished, but operational:
>=20
> http://git.linux-nfs.org/?p=3Dcel/cel-2.6.git;a=3Dshortlog;h=3Drefs/h=
eads/nfs-rdma-future

Nice..

Can you spend some time and reflect on how some of this could be
lowered into the core code? The FMR and FRWR side have many
similarities now..

> FRWR is seeing a 10-15% throughput reduction with 8-thread dbench,
> but a 5% improvement with 16-thread fio IOPS. 4K and 8K direct
> read and write are negatively impacted.

I'm not surprised since invalidate is sync. I belive you need to
incorporate SEND WITH INVALIDATE to substantially recover this
overhead.

It would be neat if the RQ could continue to advance while waiting for
the invalidate.. That looks almost doable..

> I converted the RPC reply handler tasklet to a work queue context
> to allow sleeping. A new .ro_unmap_sync method is invoked after
> the RPC/RDMA header is parsed but before xprt_complete_rqst()
> wakes up the waiting RPC.

=2E. so the issue is the RPC must be substantially parsed to learn whic=
h
MR it is associated with to schedule the invalidate?=20

> This is actually much more efficient than the current logic,
> which serially does an ib_unmap_fmr() for each MR the RPC owns.
> So FMR overall performs better with this change.

Interesting..

> Because the next RPC cannot awaken until the last send completes,
> send queue accounting is based on RPC/RDMA credit flow control.

So for FRWR the sync invalidate effectively guarentees all SQEs
related to this RPC are flushed. That seems reasonable, if the number
of SQEs and CQEs are properly sized in relation to the RPC slot count
it should be workable..

How does FMR and PHYS synchronize?

> I=E2=80=99m sure there are some details here that still need to be
> addressed, but this fixes the big problem with FRWR send queue
> accounting, which was that LOCAL_INV WRs would continue to
> consume SQEs while another RPC was allowed to start.

Did you test without that artificial limit you mentioned before?

I'm also wondering about this:

> During some other testing I found that when a completion upcall
> returns to the provider leaving CQEs still on the completion queue,
> there is a non-zero probability that a completion will be lost.

What does lost mean?

The CQ is edge triggered, so if you don't drain it you might not get
another timely CQ callback (which is bad), but CQEs themselves should
not be lost.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
