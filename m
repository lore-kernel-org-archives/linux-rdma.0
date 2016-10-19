From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/2] IB/rdmavt: cq ktrhead worker fix and API update
Date: Wed, 19 Oct 2016 14:07:18 +0200
Message-ID: <1476878840-14548-1-git-send-email-pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-rdma@vger.kernel.org

The kthread worker API has been improved in 4.9-rc1. The 2nd
patch uses the new functions and simplifies the kthread worker
creation and destroying.

I have found a possible race when working on the API conversion.
A proposed fix is in the 1st patch.

Both changes are compile tested only. I did not find an easy way
how to test them at runtime.

Petr Mladek (2):
  IB/rdmavt: Avoid queuing work into a destroyed cq kthread worker
  IB/rdmavt: Handle the kthread worker using the new API

 drivers/infiniband/sw/rdmavt/cq.c | 64 +++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

-- 
1.8.5.6
