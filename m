From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 17:25:11 -0400
Message-ID: <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715171926.GB23588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 15, 2015, at 1:19 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Wed, Jul 15, 2015 at 10:32:55AM -0400, Chuck Lever wrote:
>=20
>> I would rather not build a non-deterministic delay into the
>> unmap interface. Using a pool or having map do an implicit
>> unmap are both solutions I=92d rather avoid.
>=20
> Can you explain how NFS is using FMR today? When does it unmap a FMR
> rkey and lkey?

Client side:

The content in RPC send buffers is sent with RDMA SEND using
local_dma_lkey, or with an lkey obtained from an MR allocated via
ib_dma_get_mr(). These are used to send RPC-over-RDMA headers
usually along with the content of small RPC requests.

These are left registered, essentially, during the lifetime of
the transport, and access to them is only local.

NFS READ and WRITE data payloads are mapped with ib_map_phys_mr()
just before the RPC is sent, and those payloads are unmapped
with ib_unmap_fmr() as soon as the client sees the server=92s RPC
reply.

These memory regions require an rkey, which is sent in the RPC
call to the server. The server performs RDMA READ or WRITE on
these regions.

I don=92t think the server ever uses FMR to register the target
memory regions for RDMA READ and WRITE.


> If NFS/etc currently have a hole on rkey invalidation when using FMR,
> and that hole simply cannot reasonably be solved, I'm actually mildly=
 OK
> with enshrining that in a new MR API..
>=20
> So, it would seem to me, the only major addition we'd need to Sagi's
> draft to support FMR, would be a way to catch the completion (the
> rdma_unreg_mr) and trigger async MR recycling async in a work queue.

As long as it is guaranteed that the unmap is scheduled as soon
as each RPC operation is complete, that might be tolerable, ie:

  rdma_unreg_mr_async()

Where the API hands the MR to a work queue to be unmapped, and
guarantees the MR cannot be reused until it knows it is unmapped.

I=92m sure there=92s a hole in there I=92m missing.


> Sagi, how does cleanup of the temporary FRMR work in your draft
> proposal? What does the ULP do upon completion?
>=20
> [Also, just mildly curious, how do we get into an unsleepable
> context anyhow? is the IB completion pending callback called in a
> sleepable context?]
>=20
> Jason

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
