From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 0/2] Convert IB/mad to use an IDR for agent IDs
Date: Wed, 13 Jun 2018 05:34:01 -0700
Message-ID: <20180613123403.25233-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-rdma@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Thanks for the review / feedback / testing.  Here's v3.  Changes:

 - Split out the change to the IDR code into its own patch.
 - Dropped the "Agent registration is process context only" patch as
   Jason already merged it.
 - Added comment about why we're limiting the agent ID to 2^24.
 - Used a named constant instead of a bare '1 << 24'.
 - Updated the changelog to incorporate more of Hans' original message.
 - Added Tested-by, Acked-by and Reported-by to the second patch.

Matthew Wilcox (2):
  IDR: Expose the XArray lock
  IB/mad: Use IDR for agent IDs

 drivers/infiniband/core/mad.c      | 83 ++++++++++++++++++------------
 drivers/infiniband/core/mad_priv.h |  7 +--
 include/linux/idr.h                | 11 ++++
 3 files changed, 66 insertions(+), 35 deletions(-)

-- 
2.17.1
