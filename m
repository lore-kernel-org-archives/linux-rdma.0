From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: RQ overflow seen running isert traffic
Date: Wed, 5 Oct 2016 09:14:12 +0300
Message-ID: <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
References: <20160927070157.GA13140@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160927070157.GA13140@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: swise@opengridcomputing.com, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi,

Hey Baharat,

Sorry for the late response, its the holiday
season in Israel...

> I've been trying to understand the isert functionality with respect to
> RDMA Receive Queue sizing and Queue full handling. Here is the problem
> is see with iw_cxgb4:
>
> After running few minutes of iSER traffic with iw_cxgb4, I am seeing
> post receive failures due to receive queue full returning -ENOMEM.
> In case of iw_cxgb4 the RQ size is 130 with qp attribute max_recv_wr = 129,
> passed down by isert to iw_cxgb4.isert decides on max_recv_wr as 129 based
> on (ISERT_QP_MAX_RECV_DTOS = ISCSI_DEF_XMIT_CMDS_MAX = 128) + 1.

That's correct.

>
> My debug suggests that at some point isert tries to post more than
> 129 receive WRs into the RQ and fails as the queue is full already. From
> the code most of the recv wr are posted only after a recieve completion,
> but few datain operations(isert_put_datain()) are done independent of
> receive completions.

Interesting. I suspect that this issue haven't come up is that
the devices I used to test with allocate the send/recv queues in
the next power of 2 (which would be 256) which was enough to hide
this I guess...

We repost the recv buffer under the following conditions:
1. We are queueing data + response (datain) or just response (dataout)
and we are done with the recv buffer.
2. We got a unsolicited dataout.

Can you please turn off unsolicited dataouts and see if this
still happen? (InitialR2T=Yes)

> In fact the last WR failed to post in to RQ is from
> isert_put_datain() through target_complete_ok_work(). CQ stats at the
> time of failure shows the cq polled to empty.

That is strange, each scsi command should trigger iscsit_queue_data_in
just once. Can you provide evidence of a command that triggers it more
than once?

Another possible reason is that we somehow get to put_data_in and
put_response for the same command (which we should never do because
we handle the response in put_data_in).

Thanks for reporting.
Sagi.
