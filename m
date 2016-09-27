From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: RQ overflow seen running isert traffic
Date: Tue, 27 Sep 2016 12:31:59 +0530
Message-ID: <20160927070157.GA13140@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: sagi@grimberg.me
Cc: swise@opengridcomputing.com, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,
I've been trying to understand the isert functionality with respect to
RDMA Receive Queue sizing and Queue full handling. Here is the problem
is see with iw_cxgb4:

After running few minutes of iSER traffic with iw_cxgb4, I am seeing
post receive failures due to receive queue full returning -ENOMEM.
In case of iw_cxgb4 the RQ size is 130 with qp attribute max_recv_wr = 129, 
passed down by isert to iw_cxgb4.isert decides on max_recv_wr as 129 based 
on (ISERT_QP_MAX_RECV_DTOS = ISCSI_DEF_XMIT_CMDS_MAX = 128) + 1.

My debug suggests that at some point isert tries to post more than
129 receive WRs into the RQ and fails as the queue is full already. From
the code most of the recv wr are posted only after a recieve completion,
but few datain operations(isert_put_datain()) are done independent of
receive completions. In fact the last WR failed to post in to RQ is from
isert_put_datain() through target_complete_ok_work(). CQ stats at the
time of failure shows the cq polled to empty.

How could I check for the possible conditions leading to this issue?
I am happy to provide you any details further.
Thanks for your time.

Bharat.
