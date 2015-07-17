From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Fri, 17 Jul 2015 11:03:45 -0400
Message-ID: <62F9F5B8-0A18-4DF8-B47E-7408BFFE9904@oracle.com>
References: <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com> <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com> <20150715224928.GA941@obsidianresearch.com> <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com> <20150716174046.GB3680@obsidianresearch.com> <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com> <20150716204932.GA10638@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716204932.GA10638-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 16, 2015, at 4:49 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Thu, Jul 16, 2015 at 04:07:04PM -0400, Chuck Lever wrote:
>=20
>> The MRs are registered only for remote read. I don=92t think
>> catastrophic harm can occur on the client in this case if the
>> invalidation and DMA sync comes late. In fact, I=92m unsure why
>> a DMA sync is even necessary as the MR is invalidated in this
>> case.
>=20
> For RDMA, the worst case would be some kind of information leakage or
> machine check halt.
>=20
> For read side the DMA API should be called before posting the FRWR, n=
o
> completion side issues.

It is: rpcrdma_map_one() is done by .ro_map in both the RDMA READ
and WRITE cases.

Just to confirm: you=92re saying that for MRs that are read-accessed,
no matching ib_dma_unmap_{page,single}() is required ?


>> In the case of incoming data payloads (NFS READ) the DMA sync
>> ordering is probably an important issue. The sync has to happen
>> before the ULP can touch the data, 100% of the time.
>=20
> Absolultely, the sync is critical.
>=20
>> That could be addressed by performing a DMA sync on the write
>> list or reply chunk MRs right in the RPC reply handler (before
>> xprt_complete_rqst).
>=20
> That sounds good to me, much more in line with what I'd expect to
> see. The fmr unmap and invalidate post should also be in the reply
> handler (for flow control reasons, see below)

Sure. It might be possible to move both the DMA unmap and the
invalidate into the reply handler without a lot of surgery.
We=92ll see.

There would be some performance cost. That=92s unfortunate because
the scenarios we=92re guarding against are exceptionally rare.


>>> The only absolutely correct way to run the RDMA stack is to keep tr=
ack
>>> of SQ/SCQ space directly, and only update that tracking by processi=
ng
>>> SCQEs.
>>=20
>> In other words, the only time it is truly safe to do a post_send is
>> after you=92ve received a send completion that indicates you have
>> space on the send queue.
>=20
> Yes.
>=20
> Use a scheme where you supress signaling and use the SQE accounting t=
o
> request a completion entry and signal around every 1/2 length of the
> SQ.

Actually Sagi and I have found we can=92t leave more than about 80
sends unsignalled, no matter how long the pre-allocated SQ is.

xprtrdma caps the maximum number of unsignalled sends at 20,
though, as a margin of error. That gives about 95% send completion
mitigation.

Since most send completions are silenced, xprtrdma relies on seeing
the completion of a _subsequent_ WR.

So, if my reply handler were to issue a LOCAL_INV WR and wait for
its completion, then the completion of send WRs submitted before
that one, even if they are silent, is guaranteed.

In the cases where the reply handler issues a LOCAL_INV, waiting
for its completion before allowing the next RPC to be sent is
enough to guarantee space on the SQ, I would think.

=46or FMR and smaller RPCs that don=92t need RDMA, we=92d probably
have to wait on the completion of the RDMA SEND of the RPC call
message.

So, we could get away with signalling only the last send WR issued
for each RPC.


> Use the WRID in some way to encode the # SQEs each completion
> represents.
>=20
> I've used a scheme where the wrid is a wrapping index into
> an array of SQ length long, that holds any meta information..
>=20
> That makes it trivial to track SQE accounting and avoids memory
> allocations for wrids.
>=20
> Generically:
>=20
>  posted_sqes -=3D (wc->wrid - last_wrid);
>  for (.. I =3D last_wrid; I !=3D wc->wrid; ++I)
>    complete(wr_data[I].ptr);
>=20
> Many other options, too.
>=20
> -----
>=20
> There is a bit more going on too, *technically* the HCA owns the
> buffer until a SCQE is produced. The recv proves the peer will drop
> any re-transmits of the message, but it doesn't prove that the local
> HCA won't create a re-transmit. Lost acks or other protocol weirdness
> could *potentially* cause buffer re-read in the general RDMA
> framework.
>=20
> So if you use recv to drive re-use of the SEND buffer memory, it is
> important that the SEND buffer remain full of data to send to that
> peer and not be kfree'd, dma unmapped, or reused for another peer's
> data.
>=20
> kfree/dma unmap/etc may only be done on a SEND buffer after seeing a
> SCQE proving that buffer is done, or tearing down the QP and halting
> the send side.

The buffers the client uses to send an RPC call are DMA mapped once
when the transport is created, and a local lkey is used in the SEND
WR.

They are re-used for the next RPCs in the pipe, but as far as I can
tell the client=92s send buffer contains the RPC call data until the
RPC request slot is retired (xprt_release).

I need to review the mechanism in rpcrdma_buffer_get() to see if
that logic does prevent early re-use.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
