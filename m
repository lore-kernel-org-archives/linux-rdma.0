From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 16:49:28 -0600
Message-ID: <20150715224928.GA941@obsidianresearch.com>
References: <55A4CABC.5050807@dev.mellanox.co.il>
 <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
 <20150715171926.GB23588@obsidianresearch.com>
 <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 05:25:11PM -0400, Chuck Lever wrote:

> NFS READ and WRITE data payloads are mapped with ib_map_phys_mr()
> just before the RPC is sent, and those payloads are unmapped
> with ib_unmap_fmr() as soon as the client sees the server=E2=80=99s R=
PC
> reply.

Okay.. but.. ib_unmap_fmr is the thing that sleeps, so you must
already have a sleepable context when you call it?

I was poking around to see how NFS is working (to see how we might fit
a different API under here), I didn't find the call to ro_unmap I'd
expect? xprt_rdma_free is presumbly the place, but how it relates to
rpcrdma_reply_handler I could not obviously see. Does the upper layer
call back to xprt_rdma_free before any of the RDMA buffers are
touched?  Can you clear up the call chain for me?

Second, the FRWR stuff looks deeply suspicious, it is posting a
IB_WR_LOCAL_INV, but the completion of that (in frwr_sendcompletion)
triggers nothing. Handoff to the kernel must be done only after seeing
IB_WC_LOCAL_INV, never before.

Third all the unmaps do something like this:

frwr_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
{
	invalidate_wr.opcode =3D IB_WR_LOCAL_INV;
   [..]
	while (seg1->mr_nsegs--)
		rpcrdma_unmap_one(ia->ri_device, seg++);
	read_lock(&ia->ri_qplock);
	rc =3D ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);

That is the wrong order, the DMA unmap of rpcrdma_unmap_one must only
be done once the invalidate is complete. For FR this is ib_unmap_fmr
returning, for FRWR it is when you see IB_WC_LOCAL_INV.

=46inally, where is the flow control for posting the IB_WR_LOCAL_INV to
the SQ? I'm guessing there is some kind of implicit flow control here
where the SEND buffer is recycled during RECV of the response, and
this limits the SQ usage, then there are guarenteed 3x as many SQEs as
SEND buffers to accommodate the REG_MR and INVALIDATE WRs??

> These memory regions require an rkey, which is sent in the RPC
> call to the server. The server performs RDMA READ or WRITE on
> these regions.
>=20
> I don=E2=80=99t think the server ever uses FMR to register the target
> memory regions for RDMA READ and WRITE.

What happens if you hit the SGE limit when constructing the RDMA
READ/WRITE? Upper layer forbids that? What about iWARP, how do you
avoid the 1 SGE limit on RDMA READ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
