From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] dapl: ucm provider changes for large CM UD alltoall
 scaling
Date: Fri, 22 May 2015 21:42:17 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76B66@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tested on 1200n, 28ppn cluster, MPI AlltoAll 
Intel MPI, UD mode, static and dynamic, over 500m connections.

Arlin Davis (5):
  ucm: optimizations for large scale UD communication management
  ucm: check for AH caching when destroying via UD extension
  ucm: allocate/free AH hash table for UD endpoint types
  ucm: add device support for new port space hash table
  ucm: CM changes for UD extended port space and indexer

 dapl/openib_common/dapl_ib_common.h |   15 +-
 dapl/openib_common/ib_extensions.c  |   14 +-
 dapl/openib_common/qp.c             |   32 +-
 dapl/openib_ucm/cm.c                | 1255 +++++++++++++++++++++++------------
 dapl/openib_ucm/dapl_ib_util.h      |   37 +-
 dapl/openib_ucm/device.c            |  153 ++++-
 6 files changed, 1030 insertions(+), 476 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
