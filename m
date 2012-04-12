From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 12 Apr 2012 16:45:44 -0700
Message-ID: <1334274344-12422-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/srpt-srq-type fixes

----------------------------------------------------------------
Add a fix for a bug hit by Alexey Shvetsov in ib_srtp that hits on
non-mlx4 hardware.

----------------------------------------------------------------
Roland Dreier (1):
      IB/srpt: Set srq_type to IB_SRQT_BASIC

 drivers/infiniband/ulp/srpt/ib_srpt.c |    1 +
 1 file changed, 1 insertion(+)
