From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v3 0/2] IB:mad Use ID allocator routines to allocate agent number
Date: Thu,  7 Jun 2018 13:14:33 +0200
Message-ID: <20180607111435.17538-1-hans.westgaard.ry@oracle.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, Matthew Wilcox <mawilcox@microsoft.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Wei Wang <wei.w.wang@intel.com>, Chris Mi <chrism@mellanox.com>, Eric Biggers <ebiggers@google.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mel Gorman <mgorman@techsingularity.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

v3:
- Removed Oracle internal bug number information
v2:

- Implement ida_get_simple_cyclic and use it when allocating
  ib_mad_client_ids.

Hans Westgaard Ry (2):
  idr: Add ida_simple_get_cyclic
  IB/mad: Use ID allocator routines to allocate agent number

 drivers/infiniband/core/mad.c | 24 +++++++++++++---
 include/linux/idr.h           |  8 ++++--
 lib/idr.c                     | 66 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 6 deletions(-)

-- 
2.14.3
