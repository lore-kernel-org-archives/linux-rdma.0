From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 16:07:04 -0400
Message-ID: <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com>
References: <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com> <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com> <20150715224928.GA941@obsidianresearch.com> <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com> <20150716174046.GB3680@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716174046.GB3680-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 16, 2015, at 1:40 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Thu, Jul 16, 2015 at 10:45:46AM -0400, Chuck Lever wrote:

>> The reply handler parses the incoming reply, looks up the XID and
>> matches it to a waiting RPC request (xprt_lookup_rqst). It then
>> wakes that request (xprt_complete_rqst). The tasklet goes to the
>> next reply on the global list.
>>=20
>> The RPC scheduler sees the awoken RPC request and steps the
>> finished request through to completion, at which point
>> xprt_release() is invoked to retire the request slot.
>=20
> At what point does the RPC layer touch the RDMA'd data? Based on your
> description it must be after xprt_release is called?

There are three different data transfer mechanisms with RPC/RDMA.

1.  RDMA SEND: used for the RPC/RDMA header and small RPC messages

2.  RDMA READ: the server reads a data payload (NFS WRITE), or a
    large RPC call

3.  RDMA WRITE: the server writes a data payload (NFS READ), or
    a large RPC reply

In case 2, the RDMA READs are done as part of an RPC call, just
after the server receives the RPC call message. So, the READ is
complete before the server can even start processing the RPC call.

The MRs are registered only for remote read. I don=92t think
catastrophic harm can occur on the client in this case if the
invalidation and DMA sync comes late. In fact, I=92m unsure why
a DMA sync is even necessary as the MR is invalidated in this
case.

In case 3, the RDMA WRITEs are done as part of an RPC reply,
just before the server sends the RPC reply message. The server=92s
send queue sees to it that the WRITE completes before the server
SENDs the reply.

The RPC client does not touch the data payload with NFS READ. But
there is no co-ordination between the LOCAL_INVALIDATE and when
the upper layer is finally awake and accessing that data.

Ultimately, yes, we=92ll have to do the invalidation earlier so
that the ULP cannot touch that data payload until the MR has
been knocked down and synced.

In the case of incoming data payloads (NFS READ) the DMA sync
ordering is probably an important issue. The sync has to happen
before the ULP can touch the data, 100% of the time.

That could be addressed by performing a DMA sync on the write
list or reply chunk MRs right in the RPC reply handler (before
xprt_complete_rqst).


>>> Second, the FRWR stuff looks deeply suspicious, it is posting a
>>> IB_WR_LOCAL_INV, but the completion of that (in frwr_sendcompletion=
)
>>> triggers nothing. Handoff to the kernel must be done only after see=
ing
>>> IB_WC_LOCAL_INV, never before.
>>=20
>> I don=92t understand. Our LOCAL_INV is typically unsignalled because
>> there=92s nothing to do in the normal case. frwr_sendcompletion is
>> there to handle only flushed sends.
>=20
> The purpose of invalidate in the spec is to fence the RDMA. The
> correct, secure, way to use RDMA is to invalidate a rkey, then DMA
> flush it's backing memory, then access that data with the CPU.
>=20
> The scheme NFS is using for FRWR is trading security for performance
> by running the invalidate async - so a black-hat peer can maliciously
> abuse that.
>=20
> Recovering the lost performance is what SEND WITH INVALIDATE is used
> for.
>=20
> Usually such a trade off should be a user option..
>=20
>> I=92m not sure it matters here, because when the RPC reply shows
>> up at the client, it already means the server isn=92t going to
>> access that MR/rkey again. (If the server does access that MR
>> again, it would be a protocol violation).
>=20
> A simple contained protocol violation would be fine, but this elevate=
s
> into threatening the whole machine if it happens:
>=20
> - Random memory corruption: Freeing the RDMA buffers before
>   invalidate completes recylces them to other users while the remote
>   can still write to them
> - CPU mis-operation: A validating parse can become broken if the data
>   under it is changed by the remote during operation
> - Linux DMA API contract failure:
>    * If bounce buffering, recycling the buffer will allow corruption
>      of someone eles's memory
>    * Cache coherence is lost, resulting in unpredictable data
>      corruption, happening unpredictably in time (ie perhaps after
>      the buffer is recycled to some other use)
>    * If using the IOMMU a spurious DMA may machine check and hard
>      stop the machine.
>=20
> [I wouldn't say this is serious enough to address immediately, but it
> means NFS is not an example of best practices..]
>=20
>> Can you provide an example in another kernel ULP?
>=20
> I'm still looking at them, sadly there is alot of 'interesting' stuff
> in the ULPs :(
>=20
>>> Finally, where is the flow control for posting the IB_WR_LOCAL_INV =
to
>>> the SQ? I'm guessing there is some kind of implicit flow control he=
re
>>> where the SEND buffer is recycled during RECV of the response, and
>>> this limits the SQ usage, then there are guarenteed 3x as many SQEs=
 as
>>> SEND buffers to accommodate the REG_MR and INVALIDATE WRs??
>>=20
>> RPC/RDMA provides flow control via credits. The peers agree on
>> a maximum number of concurrent outstanding RPC requests.
>> Typically that is 32, though implementations are increasing that
>> default to 128.
>>=20
>> There=92s a comment in frwr_op_open that explains how we calculate
>> the maximum number of send queue entries for each credit.
>=20
> That is what it looked like..
>=20
> So, this scheme is dangerous too. The RDMA spec doesn't guarantee tha=
t
> the receive side and send side run in lock step - that is to say, eve=
n
> though you got a RECV that indicates a SEND was executed, that doesn'=
t
> mean that SQ or SCQ space has been made available to post a new SEND.
>=20
> This is primarily because SQ/SCQ space is not freed until the ACK is
> processed, and the behavior of ACKs is not simple: particularly if a
> compound ACK is delivered concurrently with the reply's SEND.
>=20
> So, lets say you completely fill the SQ with SENDs, and all the sends
> get dumped on the wire. The SQ is still full. The far side returns a
> SEND+ACK combo packet for the first send (either together or close in
> time), the local HCA+system now runs two concurrent tracks: the first
> is updating the SQ/SCQ space to reflect the ACK and the second is
> delivering the SEND as a receive. This is a classic race, if the CPU
> sees the SEND's recv and tries to post before the CPU sees the ACK
> side then the QP blows up as full.
>=20
> I've actually hit this - under very heavy loading (ie a continuously
> full SQ) with a similar scheme that relied on RCQ to track SQ/SCQ
> usage would very rarely blow up with full SQ/SCQ because of the above
> lack of synchronicity.

> The only absolutely correct way to run the RDMA stack is to keep trac=
k
> of SQ/SCQ space directly, and only update that tracking by processing
> SCQEs.

In other words, the only time it is truly safe to do a post_send is
after you=92ve received a send completion that indicates you have
space on the send queue.

The problem then is how do you make the RDMA consumer wait until
there is send queue space. I suppose the xprt_complete_rqst()
could be postponed in this case, or simulated xprt congestion
could be used to prevent starting new RPCs while the send queue
is full.


> For us, the sucky part, is any new API we build will have to be based
> on 'the correct way to use RDMA' (eg, invalidate used as security,
> direct SQ/SCQ tracking, etc), retrofitting may be difficult on
> ULPs that are taking shortcuts. :( :(


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
