From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Fri, 17 Jul 2015 14:36:02 -0600
Message-ID: <20150717203602.GA21949@obsidianresearch.com>
References: <20150715171926.GB23588@obsidianresearch.com>
 <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com>
 <20150715224928.GA941@obsidianresearch.com>
 <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com>
 <20150716174046.GB3680@obsidianresearch.com>
 <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com>
 <20150716204932.GA10638@obsidianresearch.com>
 <62F9F5B8-0A18-4DF8-B47E-7408BFFE9904@oracle.com>
 <20150717172141.GA15808@obsidianresearch.com>
 <9A70883F-9963-42D0-9F5C-EF49F822A037@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9A70883F-9963-42D0-9F5C-EF49F822A037-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 17, 2015 at 03:26:04PM -0400, Chuck Lever wrote:
> > I'd say the above is broadly typical for what I'd consider correct =
use
> > of a RDMA QP.. The three flow control loops of #0 should be fairly =
obvious
> > and explicit in the code.
>=20
> Jason, thanks for your comments and your time.

No problem, I hope you can work something out and keep participating
in the various new API discussions!

> Some send queue accounting is already in place (see DECR_CQCOUNT).
> I=E2=80=99m sure that can be enhanced. What may be missing is a check=
 for
> available send queue resources before dispatching the next RPC.

Just some more clarity and colour: I talked about tracking SQEs, this
is explicitly monitoring the SQ and preventing overflow, but I'm
assuming that there is a 1:1 mapping of SQ to CQ -> ie the CQ is not
shared.

In this case, the SQE limit is the smaller of the two queues and
tracking the SQEs tracks the CQ space.

If the CQ is shared, then the CQ itself should also be tracked, and
nobody can post to a related Q without CQ space. This forms a fourth
flow control loop.

So language wise, talk about tracking SQE (send queue entries), and
if you have shared CQs then add a CQ count.

Implementation wise, I often use wrapping 64 bit counters to keep
track of this stuff. Every SQE post incres the head and every SCQ reap
incrs the tail, (head-tail) < limit is the main math.

This lets the counter be used as a record, and aids debugging, see
below

> However, if we start signaling more aggressively when the send
> queue is full, that means intentionally multiplying the completion
> and interrupt rate when the workload is heaviest. That could have
> performance scalability consequences.

Consider, it is also possible that the SQ is full because we
are not signaling enough: There are many unreaped entries.

There are many different schemes that are possible here.. What I
described was something simple and easy to understand, while still
thinking about various deadlock situations.

Something like this is a more complete example:

uint64_t head_sqe;
uint64_t tail_sqe;
uint64_t signaled_sqe;

if (need_signal || =20
    (head_sqe - signaled_sqe) >=3D sqe_limit/2 ||
   ((head_sqe - tail_sqe) >=3D (sqe_limit - N) &&
    (head_sqe - signaled_sqe) >=3D sqe_limit/4) &&
    ring64_gt(signaled_sqe,tail_sqe)) {
  wr[0].send_flags |=3D IB_SEND_SIGNALED;
  signaled_sqe =3D head_sqe;
}

ib_post(..,1);

head_sqe +=3D 1;
assert(head_sqe - tail_sqe < sqe_limit);

- Every SQE that crosses a 1/2 marker get a signal at the marker.
- Upon going full we start signaling, unless we signaled recently,
  and the last signal has not been reaped.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
