From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] ib_srpt: Convert to target_submit_* + drop ioctx->kref
Date: Wed, 28 Nov 2012 19:31:20 +0000
Message-ID: <1354131082-17884-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi hch & Co,

This series converts ib_srpt to use target_submit_cmd() and target_submit_tmr()
callers, and also removes the now unnessecary internal use of ioctx->kref in
favor of modern se_cmd->cmd_kref usage.

So far the I/O path is running as expected, but there appears to be a session
reset happening during TMR LUN_RESET, that is not directly related to the
conversion.  I'm still tracking down the TMR bit.

Please review for-3.8.

Thanks,

--nab

Nicholas Bellinger (2):
  ib_srpt: Convert I/O path to target_submit_cmd + drop legacy
    ioctx->kref
  ib_srpt: Convert TMR path to target_submit_tmr

 drivers/infiniband/ulp/srpt/ib_srpt.c |  153 ++++++++++++++------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 2 files changed, 67 insertions(+), 87 deletions(-)

-- 
1.7.2.5
