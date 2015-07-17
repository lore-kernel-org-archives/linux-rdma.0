From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Fri, 17 Jul 2015 15:26:04 -0400
Message-ID: <9A70883F-9963-42D0-9F5C-EF49F822A037@oracle.com>
References: <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com> <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com> <20150715224928.GA941@obsidianresearch.com> <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com> <20150716174046.GB3680@obsidianresearch.com> <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com> <20150716204932.GA10638@obsidianresearch.com> <62F9F5B8-0A18-4DF8-B47E-7408BFFE9904@oracle.com> <20150717172141.GA15808@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717172141.GA15808-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 17, 2015, at 1:21 PM, Jason Gunthorpe <jgunthorpe@obsidianresear=
ch.com> wrote:

> On Fri, Jul 17, 2015 at 11:03:45AM -0400, Chuck Lever wrote:
>>=20
>> On Jul 16, 2015, at 4:49 PM, Jason Gunthorpe <jgunthorpe@obsidianres=
earch.com> wrote:
>>=20
>>> Use a scheme where you supress signaling and use the SQE accounting=
 to
>>> request a completion entry and signal around every 1/2 length of th=
e
>>> SQ.
>>=20
>> Actually Sagi and I have found we can=92t leave more than about 80
>> sends unsignalled, no matter how long the pre-allocated SQ is.
>=20
> Hum, I'm pretty sure I've done more than that before on mlx4 and
> mthca. Certainly, I can't think of any reason (spec wise) for the
> above to be true. Sagi, do you know what this is?
>=20
> The fact you see unexplained problems like this is more likely to be =
a
> reflection of NFS not following the rules for running the SQ, than a
> driver bug. QP blow ups and posting failures are exactly the symptoms
> of not following the rules :)
>=20
> Once the ULP is absolutely certain, by direct accounting of consumed
> SQEs that it is not over posting, would I look for a driver/hw
> problem....
>=20
>> Since most send completions are silenced, xprtrdma relies on seeing
>> the completion of a _subsequent_ WR.
>=20
> Right, since you don't care about the sends, you only need enough
> information and signalling to flow control the SQ/SCQ. But, a SEND
> that would other wise be silenced, should be signaled if it falls at
> the 1/2 mark, or is the last WR placed into a becoming full SQ. That
> minimum basic mandatory signalling is required to avoid deadlocking.
>=20
>> So, if my reply handler were to issue a LOCAL_INV WR and wait for
>> its completion, then the completion of send WRs submitted before
>> that one, even if they are silent, is guaranteed.
>=20
> Yes, the SQ is strongly ordered.
>=20
>> In the cases where the reply handler issues a LOCAL_INV, waiting
>> for its completion before allowing the next RPC to be sent is
>> enough to guarantee space on the SQ, I would think.
>=20
>> For FMR and smaller RPCs that don=92t need RDMA, we=92d probably
>> have to wait on the completion of the RDMA SEND of the RPC call
>> message.
>=20
>> So, we could get away with signalling only the last send WR issued
>> for each RPC.
>=20
> I think I see you thinking about how to bolt on a different implicit
> accounting scheme, again using inference about X completing meaning Y
> is available?
>=20
> I'm sure that can be made to work (and I think you've got the right
> reasoning), but I strongly don't recommend it - it is complicated and
> brittle to maintain. ie Perhaps NFS had a reasonable scheme like this
> once, but the FRWR additions appear to have damanged it's basic
> unstated assumptions.
>=20
> Directly track the number of SQEs used and available, use WARN_ON
> before every post to make sure the invariant isn't violated.
>=20
> Because NFS has a mixed scheme where only INVALIDATE is required
> synchronous, I'd optimize for free flow without requiring SEND to be
> signaled.
>=20
> Based on your comments, I think an accounting scheme like this makes
> sense:
> 0. Broadly we want to have three pools for a RPC slot:
>     - Submitted to the upper layer and available for immediate use
>     - Submitted to the network and currently executing
>     - Waiting for resources to recycle
>       * A recv buffer is posted to the local RQ
>       * The far end has posted its recv buffer to its RQ
>       * The SQ/SCQ has avilable space to issue any RPC
> 1. Each RPC slot takes a maximum of N SQE credits. Figure this
>    constant out at the start of time. I suspect it is 3 when using FR=
WR.
> 2. When you pass a RPC slot to the upper layer, either at the start
>    of time, or when completing recvs, decrease the SQE accounting
>    by N. ie the upper layer is now free to use that RPC slot at any
>    momement, the maximum N SQEs it could require are guaranteed
>    available and nothing can steal them.
>=20
>    If N SQEs are not available then do not give the slot to the
>    upper layer.
> 3. When the RPC is actually submitted figure out how many SQEs it
>    really needs and adjust the accounting. Ie if only 1 is needed the=
n
>    return 2 SQE credits.
> 4. Track SQE credits use at SCQ time using some scheme, and return
>    credit for explicitly&implicitly completed SQEs.
> 5. Figure out the right place to inject the 3rd pool of #0. This can
>    absolutely be done by deferring advancing the recvQ until the RPC
>    recycling conditions are all met, but it would be better
>    (latency wise) to process the recv and then defer recycling the
>    empty RPC slot.
>=20
> Use signaling when necessary: at the 1/2 point, for all SQEs when fre=
e
> space is < N (deadlock avoidance) and when NFS needs to wait for a
> sync invalidate.
>=20
> It sounds more complicated than it is. :)
>=20
> If you have a work load with no sync-invalidates then the above still
> functions at full speed without requiring extra SEND signaling.
> sync-invalidates cause SQE credits to recycle faster and guarentees w=
e
> won't do the deferral in #5.
>=20
> Size the SQ length to be at least something like 2*N*(the # of RPC)
> slots..
>=20
> I'd say the above is broadly typical for what I'd consider correct us=
e
> of a RDMA QP.. The three flow control loops of #0 should be fairly ob=
vious
> and explicit in the code.

Jason, thanks for your comments and your time.

The send queue overflows I saw may indeed be related to the
current design which assumes the receive completion for an RPC
reply always implies the send queue has space for the next RPC
operation=92s send WRs.

I wonder if I introduced this problem when I split the completion
queue.

Some send queue accounting is already in place (see DECR_CQCOUNT).
I=92m sure that can be enhanced. What may be missing is a check for
available send queue resources before dispatching the next RPC.

The three #0 pools make sense, and I can see a mapping onto the
current RPC client design. When the send queue is full, the next
RPC can be deferred by not calling xprt_release_rqst_cong() until
this RPC=92s resources are free.

However, if we start signaling more aggressively when the send
queue is full, that means intentionally multiplying the completion
and interrupt rate when the workload is heaviest. That could have
performance scalability consequences.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
