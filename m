From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Fri, 17 Jul 2015 11:21:41 -0600
Message-ID: <20150717172141.GA15808@obsidianresearch.com>
References: <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
 <20150715171926.GB23588@obsidianresearch.com>
 <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com>
 <20150715224928.GA941@obsidianresearch.com>
 <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com>
 <20150716174046.GB3680@obsidianresearch.com>
 <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com>
 <20150716204932.GA10638@obsidianresearch.com>
 <62F9F5B8-0A18-4DF8-B47E-7408BFFE9904@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <62F9F5B8-0A18-4DF8-B47E-7408BFFE9904-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 17, 2015 at 11:03:45AM -0400, Chuck Lever wrote:
>=20
> On Jul 16, 2015, at 4:49 PM, Jason Gunthorpe <jgunthorpe@obsidianrese=
arch.com> wrote:
>=20
> > On Thu, Jul 16, 2015 at 04:07:04PM -0400, Chuck Lever wrote:
> >=20
> >> The MRs are registered only for remote read. I don=E2=80=99t think
> >> catastrophic harm can occur on the client in this case if the
> >> invalidation and DMA sync comes late. In fact, I=E2=80=99m unsure =
why
> >> a DMA sync is even necessary as the MR is invalidated in this
> >> case.
> >=20
> > For RDMA, the worst case would be some kind of information leakage =
or
> > machine check halt.
> >=20
> > For read side the DMA API should be called before posting the FRWR,=
 no
> > completion side issues.
>=20
> It is: rpcrdma_map_one() is done by .ro_map in both the RDMA READ
> and WRITE cases.
>=20
> Just to confirm: you=E2=80=99re saying that for MRs that are read-acc=
essed,
> no matching ib_dma_unmap_{page,single}() is required ?

Sorry, I wasn't clear, dma_map/unmap must always be paired, they should
ideally be in the right ordering:
 dma_map(.)
 create MR
 invalidate MR
 dma_unmap()

Remember the DMA API could spin up IOMMU mappings or otherwise,
pairing is critical, ordering is critical, and I'd have some concern
around timeliness too..

When I said no issues, I was talking about running the MR invalidate
async with RPC processing. That should be fine.

But the dma unmap should be done from the SCQ processing loop, after
it is known the INVALIDATE for the ACCESS_REMOTE_READ MR is
complete. You could perhaps suppress completion for the invalidate, as
long as there is a scheme to track the needed invalidate (see my last
email)

A ACCES_REMOTE_WRITE MR side is basically the same, except the
INVALIDATE should be signaled and RPC processing should resume from
the SCQ side.

This is where you'd put a 'server trust' performance option to run
even the write invalidate async, then the dma_unmap should be done
when the invalidate is posted.

> Sure. It might be possible to move both the DMA unmap and the
> invalidate into the reply handler without a lot of surgery.
> We=E2=80=99ll see.
>=20
> There would be some performance cost. That=E2=80=99s unfortunate beca=
use
> the scenarios we=E2=80=99re guarding against are exceptionally rare.

NFS needs to learn to do SEND WITH INVALIDATE to mitigate the
invalidate cost...

> > Use a scheme where you supress signaling and use the SQE accounting=
 to
> > request a completion entry and signal around every 1/2 length of th=
e
> > SQ.
>=20
> Actually Sagi and I have found we can=E2=80=99t leave more than about=
 80
> sends unsignalled, no matter how long the pre-allocated SQ is.

Hum, I'm pretty sure I've done more than that before on mlx4 and
mthca. Certainly, I can't think of any reason (spec wise) for the
above to be true. Sagi, do you know what this is?

The fact you see unexplained problems like this is more likely to be a
reflection of NFS not following the rules for running the SQ, than a
driver bug. QP blow ups and posting failures are exactly the symptoms
of not following the rules :)

Once the ULP is absolutely certain, by direct accounting of consumed
SQEs that it is not over posting, would I look for a driver/hw
problem....

> Since most send completions are silenced, xprtrdma relies on seeing
> the completion of a _subsequent_ WR.

Right, since you don't care about the sends, you only need enough
information and signalling to flow control the SQ/SCQ. But, a SEND
that would other wise be silenced, should be signaled if it falls at
the 1/2 mark, or is the last WR placed into a becoming full SQ. That
minimum basic mandatory signalling is required to avoid deadlocking.

> So, if my reply handler were to issue a LOCAL_INV WR and wait for
> its completion, then the completion of send WRs submitted before
> that one, even if they are silent, is guaranteed.

Yes, the SQ is strongly ordered.

> In the cases where the reply handler issues a LOCAL_INV, waiting
> for its completion before allowing the next RPC to be sent is
> enough to guarantee space on the SQ, I would think.

> For FMR and smaller RPCs that don=E2=80=99t need RDMA, we=E2=80=99d p=
robably
> have to wait on the completion of the RDMA SEND of the RPC call
> message.

> So, we could get away with signalling only the last send WR issued
> for each RPC.

I think I see you thinking about how to bolt on a different implicit
accounting scheme, again using inference about X completing meaning Y
is available?

I'm sure that can be made to work (and I think you've got the right
reasoning), but I strongly don't recommend it - it is complicated and
brittle to maintain. ie Perhaps NFS had a reasonable scheme like this
once, but the FRWR additions appear to have damanged it's basic
unstated assumptions.

Directly track the number of SQEs used and available, use WARN_ON
before every post to make sure the invariant isn't violated.

Because NFS has a mixed scheme where only INVALIDATE is required
synchronous, I'd optimize for free flow without requiring SEND to be
signaled.

Based on your comments, I think an accounting scheme like this makes
sense:
 0. Broadly we want to have three pools for a RPC slot:
     - Submitted to the upper layer and available for immediate use
     - Submitted to the network and currently executing
     - Waiting for resources to recycle
       * A recv buffer is posted to the local RQ
       * The far end has posted its recv buffer to its RQ
       * The SQ/SCQ has avilable space to issue any RPC
 1. Each RPC slot takes a maximum of N SQE credits. Figure this
    constant out at the start of time. I suspect it is 3 when using FRW=
R.
 2. When you pass a RPC slot to the upper layer, either at the start
    of time, or when completing recvs, decrease the SQE accounting
    by N. ie the upper layer is now free to use that RPC slot at any
    momement, the maximum N SQEs it could require are guaranteed
    available and nothing can steal them.

    If N SQEs are not available then do not give the slot to the
    upper layer.
 3. When the RPC is actually submitted figure out how many SQEs it
    really needs and adjust the accounting. Ie if only 1 is needed then
    return 2 SQE credits.
 4. Track SQE credits use at SCQ time using some scheme, and return
    credit for explicitly&implicitly completed SQEs.
 5. Figure out the right place to inject the 3rd pool of #0. This can
    absolutely be done by deferring advancing the recvQ until the RPC
    recycling conditions are all met, but it would be better
    (latency wise) to process the recv and then defer recycling the
    empty RPC slot.

Use signaling when necessary: at the 1/2 point, for all SQEs when free
space is < N (deadlock avoidance) and when NFS needs to wait for a
sync invalidate.

It sounds more complicated than it is. :)

If you have a work load with no sync-invalidates then the above still
functions at full speed without requiring extra SEND signaling.
sync-invalidates cause SQE credits to recycle faster and guarentees we
won't do the deferral in #5.

Size the SQ length to be at least something like 2*N*(the # of RPC)
slots..

I'd say the above is broadly typical for what I'd consider correct use
of a RDMA QP.. The three flow control loops of #0 should be fairly obvi=
ous
and explicit in the code.

> > kfree/dma unmap/etc may only be done on a SEND buffer after seeing =
a
> > SCQE proving that buffer is done, or tearing down the QP and haltin=
g
> > the send side.
>=20
> The buffers the client uses to send an RPC call are DMA mapped once
> when the transport is created, and a local lkey is used in the SEND
> WR.
>=20
> They are re-used for the next RPCs in the pipe, but as far as I can
> tell the client=E2=80=99s send buffer contains the RPC call data unti=
l the
> RPC request slot is retired (xprt_release).

It is what I'd expect based on your past descriptions - just making
sure you are aware :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
