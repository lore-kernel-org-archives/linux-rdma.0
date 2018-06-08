From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/2] Convert IB/mad to use an IDR for agent IDs
Date: Fri,  8 Jun 2018 10:42:16 -0700
Message-ID: <20180608174218.32455-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Compared to the RFC I sent yesterday, this version retains the per-port
spinlock for use when looking up the MAD agent by vendor/class/etc.
Now we should only see a performance improvement relative to the current
code.  We should see that improvement two different ways: interrupts
remain enabled and no spinlock is taken when doing a lookup in the IDR,
and we don't walk a linked list looking for the right agent; we just
walk the (low height) tree and find the correct agent.

There are more improvements that could be made, but this fixes the mlx4
bug that Hans reported.

Matthew Wilcox (2):
  IB/mad: Agent registration is process context only
  IB/mad: Use IDR for agent IDs

 drivers/infiniband/core/mad.c      | 90 ++++++++++++++++++------------
 drivers/infiniband/core/mad_priv.h |  7 ++-
 include/linux/idr.h                |  9 +++
 3 files changed, 66 insertions(+), 40 deletions(-)

-- 
2.17.1
