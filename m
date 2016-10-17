From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: RQ overflow seen running isert traffic
Date: Mon, 17 Oct 2016 16:46:56 +0530
Message-ID: <20161017111655.GA21245@chelsio.com>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: SWise OGC <swise@opengridcomputing.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday, October 10/05/16, 2016 at 11:44:12 +0530, Sagi Grimberg wrote:
> 
> > Hi Sagi,
> 
> Hey Baharat,
> 
> Sorry for the late response, its the holiday
> season in Israel...
> 
> > I've been trying to understand the isert functionality with respect to
> > RDMA Receive Queue sizing and Queue full handling. Here is the problem
> > is see with iw_cxgb4:
> >
> > After running few minutes of iSER traffic with iw_cxgb4, I am seeing
> > post receive failures due to receive queue full returning -ENOMEM.
> > In case of iw_cxgb4 the RQ size is 130 with qp attribute max_recv_wr = 129,
> > passed down by isert to iw_cxgb4.isert decides on max_recv_wr as 129 based
> > on (ISERT_QP_MAX_RECV_DTOS = ISCSI_DEF_XMIT_CMDS_MAX = 128) + 1.
> 
> That's correct.

Hi Sagi,
Sorry for the late reply, I had to recheck my findings before I reply
you back.

My interpretation of the queue full issue was not complete, got carried
away by the recieve queue and missed the SQ failure due to full among
the debug logs.

Here is what was happening:
It was the SQ full first and fails to get posted with ENOMEM, due to this 
the command is queued to queue full list this will schedule it to post at
later instance and this repeated try for posting will cause the rq to get
full. For everyfurther try sq post will any way fail and an extra rq wr is
posted as a part of datain() leading it to be full too.

This happened a bit earlier in my case, since I corrected the the
iser_put_datain() to return error to LIO. 

Here is the failure log on a fresh 4.8 kernel:
isert: isert_rdma_rw_ctx_post: Cmd: ffff882ec8c96e60 failed to post RDMA
res <===here is the post send failure due to ENOMEM.
ABORT_TASK: Found referenced iSCSI task_tag: 33
ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 33
isert: isert_post_recv: ib_post_recv() failed with ret: -22
isert: isert_post_response: ib_post_recv failed with -22
isert: isert_post_recv: ib_post_recv() failed with ret: -22
isert: isert_post_response: ib_post_recv failed with -22
isert: isert_post_recv: ib_post_recv() failed with ret: -22
isert: isert_post_response: ib_post_recv failed with -22
isert: isert_post_recv: ib_post_recv() failed with ret: -22
isert: isert_post_response: ib_post_recv failed with -22
isert: isert_post_recv: ib_post_recv() failed with ret: -22
isert: isert_post_response: ib_post_recv failed with -22
cxgb4 0000:84:00.4: AE qpid 1026 opcode 10 status 0x1 type 1 len 0x0
wrid.hi 0x0 wrid.lo 0x4c01
isert: isert_qp_event_callback: QP access error (3): conn
ffff8817ddc46000
iSCSI Login timeout on Network Portal 10.40.40.198:3260
INFO: task iscsi_np:14744 blocked for more than 120 seconds.

Here are the QP and CQ stats before my assert for queue full:
qhp->attr.sq_num_entries 523
qhp->attr.rq_num_entries 129
qhp->wq.sq.qid 1026
qhp->wq.rq.qid 1027
qhp->wq.sq.in_use 523 <=== SQ to the brim
qhp->wq.sq.size 524 <=== SQ size
qhp->wq.sq.cidx 391
qhp->wq.sq.pidx 390
qhp->wq.sq.wq_pidx 202
qhp->wq.sq.wq_pidx_inc 0
qhp->wq.sq.flush_cidx 391
qhp->wq.rq.in_use 128
qhp->wq.rq.size 130
qhp->wq.rq.cidx 112
qhp->wq.rq.pidx 110
qhp->wq.rq.wq_pidx 240
qhp->wq.rq.wq_pidx_inc 0
qhp->wq.flushed 0
chp->cq.cqid 1024
chp->cq.size 6335
chp->cq.cidx 4978
chp->cq.sw_cidx 4126
chp->cq.sw_pidx 4126
chp->cq.sw_in_use 0
chp->cq.cidx_inc 0

As an experiment I tried increasing the ISCSI_DEF_XMIT_CMDS_MAX to 256
instead of 128, which incase of iwarp creates SQ with size 1548, the 
issue is not seen.
I doubt if the SQ is not sized properly incase of iWARP Or factored
incorrectly in the rdma api for iser IOP. 

I am digging for root cause.

Thanks for your time,
Bharat.

> 
> >
> > My debug suggests that at some point isert tries to post more than
> > 129 receive WRs into the RQ and fails as the queue is full already. From
> > the code most of the recv wr are posted only after a recieve completion,
> > but few datain operations(isert_put_datain()) are done independent of
> > receive completions.
> 
> Interesting. I suspect that this issue haven't come up is that
> the devices I used to test with allocate the send/recv queues in
> the next power of 2 (which would be 256) which was enough to hide
> this I guess...
> 
> We repost the recv buffer under the following conditions:
> 1. We are queueing data + response (datain) or just response (dataout)
> and we are done with the recv buffer.
> 2. We got a unsolicited dataout.
> 
> Can you please turn off unsolicited dataouts and see if this
> still happen? (InitialR2T=Yes)
> 
> > In fact the last WR failed to post in to RQ is from
> > isert_put_datain() through target_complete_ok_work(). CQ stats at the
> > time of failure shows the cq polled to empty.
> 
> That is strange, each scsi command should trigger iscsit_queue_data_in
> just once. Can you provide evidence of a command that triggers it more
> than once?
> 
> Another possible reason is that we somehow get to put_data_in and
> put_response for the same command (which we should never do because
> we handle the response in put_data_in).
> 
> Thanks for reporting.
> Sagi.
