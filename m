From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 14:49:32 -0600
Message-ID: <20150716204932.GA10638@obsidianresearch.com>
References: <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
 <20150715171926.GB23588@obsidianresearch.com>
 <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com>
 <20150715224928.GA941@obsidianresearch.com>
 <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com>
 <20150716174046.GB3680@obsidianresearch.com>
 <F8484ABB-BED9-463F-8AEA-EB898EBDD93C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F8484ABB-BED9-463F-8AEA-EB898EBDD93C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 16, 2015 at 04:07:04PM -0400, Chuck Lever wrote:

> The MRs are registered only for remote read. I don=E2=80=99t think
> catastrophic harm can occur on the client in this case if the
> invalidation and DMA sync comes late. In fact, I=E2=80=99m unsure why
> a DMA sync is even necessary as the MR is invalidated in this
> case.

=46or RDMA, the worst case would be some kind of information leakage or
machine check halt.

=46or read side the DMA API should be called before posting the FRWR, n=
o
completion side issues.

> In the case of incoming data payloads (NFS READ) the DMA sync
> ordering is probably an important issue. The sync has to happen
> before the ULP can touch the data, 100% of the time.

Absolultely, the sync is critical.

> That could be addressed by performing a DMA sync on the write
> list or reply chunk MRs right in the RPC reply handler (before
> xprt_complete_rqst).

That sounds good to me, much more in line with what I'd expect to
see. The fmr unmap and invalidate post should also be in the reply
handler (for flow control reasons, see below)

> > The only absolutely correct way to run the RDMA stack is to keep tr=
ack
> > of SQ/SCQ space directly, and only update that tracking by processi=
ng
> > SCQEs.
>=20
> In other words, the only time it is truly safe to do a post_send is
> after you=E2=80=99ve received a send completion that indicates you ha=
ve
> space on the send queue.

Yes.

Use a scheme where you supress signaling and use the SQE accounting to
request a completion entry and signal around every 1/2 length of the
SQ.

Use the WRID in some way to encode the # SQEs each completion
represents.

I've used a scheme where the wrid is a wrapping index into
an array of SQ length long, that holds any meta information..

That makes it trivial to track SQE accounting and avoids memory
allocations for wrids.

Generically:

  posted_sqes -=3D (wc->wrid - last_wrid);
  for (.. I =3D last_wrid; I !=3D wc->wrid; ++I)
    complete(wr_data[I].ptr);

Many other options, too.

-----

There is a bit more going on too, *technically* the HCA owns the
buffer until a SCQE is produced. The recv proves the peer will drop
any re-transmits of the message, but it doesn't prove that the local
HCA won't create a re-transmit. Lost acks or other protocol weirdness
could *potentially* cause buffer re-read in the general RDMA
framework.

So if you use recv to drive re-use of the SEND buffer memory, it is
important that the SEND buffer remain full of data to send to that
peer and not be kfree'd, dma unmapped, or reused for another peer's
data.

kfree/dma unmap/etc may only be done on a SEND buffer after seeing a
SCQE proving that buffer is done, or tearing down the QP and halting
the send side.

> The problem then is how do you make the RDMA consumer wait until
> there is send queue space. I suppose the xprt_complete_rqst()

It depends on the overall ULP design..

=46or work that is created by the recv queue (ie invalidates, new posts=
,
etc) I've successfully simply stopped polling the rq if the sq doesn't
have room to issue the largest single compound a recv would require.

Ie on the client side a recv may require issuing an INVALIDATE, so
when the SQ fills, stop processing recv.

> could be postponed in this case, or simulated xprt congestion
> could be used to prevent starting new RPCs while the send queue
> is full.

Then the other half is async new work from someplace else, like the rq
case above, stop async work from advancing if the SQE cannot hold the
largerst required compound. Sounds like this is 2 (FMWR, SEND) for NFS
client.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
