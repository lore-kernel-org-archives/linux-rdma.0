From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 09:56:24 -0500
Message-ID: <001e01d0bfd7$95f1ccb0$c1d56610$@opengridcomputing.com>
References: <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com> <F2C64EE9-38A5-4DEE-B60E-AD8430FE1049@oracle.com> <20150715224928.GA941@obsidianresearch.com> <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F0518DEF-D43C-4CB6-89ED-CA3E94A4DD72-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> Sent: Thursday, July 16, 2015 9:46 AM
> To: Jason Gunthorpe
> Cc: Sagi Grimberg; Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Steve Wise; Or Gerlitz; Oren Duer; Bart Van Assche; Liran Liss;
Hefty,
> Sean; Doug Ledford; Tom Talpey
> Subject: Re: Kernel fast memory registration API proposal [RFC]
> 
> 
> On Jul 15, 2015, at 6:49 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> > On Wed, Jul 15, 2015 at 05:25:11PM -0400, Chuck Lever wrote:
> >
> >> NFS READ and WRITE data payloads are mapped with ib_map_phys_mr()
> >> just before the RPC is sent, and those payloads are unmapped
> >> with ib_unmap_fmr() as soon as the client sees the server's RPC
> >> reply.
> >
> > Okay.. but.. ib_unmap_fmr is the thing that sleeps, so you must
> > already have a sleepable context when you call it?
> 
> The RPC scheduler operates on the assumption that the processing
> during each step does not sleep.
> 
> We're not holding a lock, so a short sleep here works. In general
> this kind of thing can deadlock pretty easily, but right at this
> step I think it's avoiding deadlock "by accident."
> 
> For some time, I've been considering deferring ib_unmap_fmr() to
> a work queue, but FMR is operational and is a bit of an antique
> so I haven't put much effort into bettering it.
> 
> The point is, this is not something that should be perpetuated
> into a new API, and certainly the other initiators have a hard
> intolerance for a sleep.
> 
> 
> > I was poking around to see how NFS is working (to see how we might fit
> > a different API under here), I didn't find the call to ro_unmap I'd
> > expect? xprt_rdma_free is presumbly the place, but how it relates to
> > rpcrdma_reply_handler I could not obviously see. Does the upper layer
> > call back to xprt_rdma_free before any of the RDMA buffers are
> > touched?  Can you clear up the call chain for me?
> 
> The server performs RDMA READ and WRITE operations, then SENDs the
> RPC reply.
> 
> On the client, rpcrdma_recvcq_upcall() is invoked when the RPC
> reply arrives and the RECV completes.
> 
> rpcrdma_schedule_tasklet() queues the incoming RPC reply on a
> global list and spanks our reply tasklet.
> 
> The tasklet invokes rpcrdma_reply_handler() for each reply on the
> list.
> 
> The reply handler parses the incoming reply, looks up the XID and
> matches it to a waiting RPC request (xprt_lookup_rqst). It then
> wakes that request (xprt_complete_rqst). The tasklet goes to the
> next reply on the global list.
> 
> The RPC scheduler sees the awoken RPC request and steps the
> finished request through to completion, at which point
> xprt_release() is invoked to retire the request slot.
> 
> Here resources allocated to the RPC request are freed. For
> RPC/RDMA transports, xprt->ops->buf_free is xprt_rdma_free().
> xprt_rdma_free() invokes the ro_unmap method to unmap/invalidate
> the MRs involved with the RPC request.
> 
> 
> > Second, the FRWR stuff looks deeply suspicious, it is posting a
> > IB_WR_LOCAL_INV, but the completion of that (in frwr_sendcompletion)
> > triggers nothing. Handoff to the kernel must be done only after seeing
> > IB_WC_LOCAL_INV, never before.
> 
> I don't understand. Our LOCAL_INV is typically unsignalled because
> there's nothing to do in the normal case. frwr_sendcompletion is
> there to handle only flushed sends.
> 
> Send queue ordering and the mw_list prevent each MR from being
> reused before it is truly invalidated.
> 
> 
> > Third all the unmaps do something like this:
> >
> > frwr_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
> > {
> > 	invalidate_wr.opcode = IB_WR_LOCAL_INV;
> >   [..]
> > 	while (seg1->mr_nsegs--)
> > 		rpcrdma_unmap_one(ia->ri_device, seg++);
> > 	read_lock(&ia->ri_qplock);
> > 	rc = ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> >
> > That is the wrong order, the DMA unmap of rpcrdma_unmap_one must only
> > be done once the invalidate is complete. For FR this is ib_unmap_fmr
> > returning, for FRWR it is when you see IB_WC_LOCAL_INV.
> 
> I'm assuming you mean the DMA unmap has to be done after LINV
> completes.
> 
> I'm not sure it matters here, because when the RPC reply shows
> up at the client, it already means the server isn't going to
> access that MR/rkey again. (If the server does access that MR
> again, it would be a protocol violation).
> 
> Can you provide an example in another kernel ULP?
> 
> 
> > Finally, where is the flow control for posting the IB_WR_LOCAL_INV to
> > the SQ? I'm guessing there is some kind of implicit flow control here
> > where the SEND buffer is recycled during RECV of the response, and
> > this limits the SQ usage, then there are guarenteed 3x as many SQEs as
> > SEND buffers to accommodate the REG_MR and INVALIDATE WRs??
> 
> RPC/RDMA provides flow control via credits. The peers agree on
> a maximum number of concurrent outstanding RPC requests.
> Typically that is 32, though implementations are increasing that
> default to 128.
> 
> There's a comment in frwr_op_open that explains how we calculate
> the maximum number of send queue entries for each credit.
> 
> 
> >> These memory regions require an rkey, which is sent in the RPC
> >> call to the server. The server performs RDMA READ or WRITE on
> >> these regions.
> >>
> >> I don't think the server ever uses FMR to register the target
> >> memory regions for RDMA READ and WRITE.
> >
> > What happens if you hit the SGE limit when constructing the RDMA
> > READ/WRITE? Upper layer forbids that? What about iWARP, how do you
> > avoid the 1 SGE limit on RDMA READ?
> 
> I'm much less familiar with the server side. Maybe Steve knows,
> but I suspect the RPC/RDMA code is careful to construct more
> READ Work Requests if it runs out of sges.


The server chunks it up based on the device limits and issues a series of rdma reads as required.  See rdma_read_chunk_frmr() and
rdma_read_chunks() which calls rdma_read_chunk_frmr() via xprt->sc_reader.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
