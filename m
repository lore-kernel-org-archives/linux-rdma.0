From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with pd->local_dma_lkey
Date: Wed, 22 Jul 2015 17:34:33 -0600
Message-ID: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

This series moves dealing with the safe all physical mr:

  ib_get_dma_mr(pd,IB_ACCESS_LOCAL_WRITE);

Into ib_alloc_pd, and in the process makes the global local_dma_lkey functionality
broadly enabled for all ULPs.

The remaining users of ib_get_dma_mr are all unsafe:
 drivers/infiniband/ulp/iser/iser_verbs.c:
	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
				   IB_ACCESS_REMOTE_WRITE |
				   IB_ACCESS_REMOTE_READ);

 drivers/infiniband/ulp/srp/ib_srp.c:
	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
				    IB_ACCESS_LOCAL_WRITE |
				    IB_ACCESS_REMOTE_READ |
				    IB_ACCESS_REMOTE_WRITE);

 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:
	int acflags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
		mr = ib_get_dma_mr(hdev->ibh_pd, acflags);

 net/rds/iw.c:
		rds_iwdev->mr = ib_get_dma_mr(rds_iwdev->pd,
					IB_ACCESS_REMOTE_READ |
					IB_ACCESS_REMOTE_WRITE |
					IB_ACCESS_LOCAL_WRITE);

 net/sunrpc/xprtrdma/svc_rdma_transport.c:
		if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
					newxprt->sc_cm_id->port_num) &&
		    !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
			dma_mr_acc |= IB_ACCESS_REMOTE_WRITE;
		newxprt->sc_phys_mr =
			ib_get_dma_mr(newxprt->sc_pd, dma_mr_acc);

 net/sunrpc/xprtrdma/verbs.c:
	case RPCRDMA_ALLPHYSICAL:
		ia->ri_ops = &rpcrdma_physical_memreg_ops;
		mem_priv = IB_ACCESS_LOCAL_WRITE |
				IB_ACCESS_REMOTE_WRITE |
				IB_ACCESS_REMOTE_READ;
		ia->ri_bind_mem = ib_get_dma_mr(ia->ri_pd, mem_priv);

Calling ib_get_dma_mr with IB_ACCESS_REMOTE_* flags is considered to be a
serious security problem and should not be done without the user directly
opting in to an off-by-default scheme. The call allows the peer on the QP
unrestricted access to local physical memory if they can guess the rkey value.

A future series will cause the kernel to be tainted by the above call sites to
promote migrating away from this.

To Migrate:
 * If ib_get_dma_mr was being used to get an lkey then use
   local_dma_lkey instead (I belive this series gets all of those cases).

   If the lkey is being used for RDMA_READ, and iWarp support is required then
   iWarp must be detected and FRMR must be used to create a limited temporary
   MR just for the RDMA_READ. (eg NFS, RDS)

 * If ib_get_dma_mr was being used to get an rkey then use FRMR to cerate
   limited temporary MR's (eg SRP, iSER, etc)

Doug, this needs to be sequenced after the mlx5 patch:
 https://patchwork.kernel.org/patch/6829351/

All patches are compile tested. I've done basic testing up to and including
the IPoIB patch, the rest required specialized setups I don't have access to,
but are fairly straightforward. Feel free to take whatever subset of this gets
tested/ack'd before the next cycle.

Sagi, IB/iser should have special attention paid, as it is less clear to me if
it got everything.

Jason Gunthorpe (10):
  IB/core: Guarantee that a local_dma_lkey is available
  IB/mad: Remove ib_get_dma_mr calls
  IB/ipoib: Remove ib_get_dma_mr calls
  IB/mlx4: Remove ib_get_dma_mr calls
  IB/mlx5: Remove ib_get_dma_mr calls
  IB/iser: Use pd->local_dma_lkey
  iser-target: Remove ib_get_dma_mr calls
  IB/srp: Use pd->local_dma_lkey
  ib_srpt: Remove ib_get_dma_mr calls
  net/9p: Remove ib_get_dma_mr calls

 drivers/infiniband/core/mad.c                | 26 +++---------------
 drivers/infiniband/core/mad_priv.h           |  1 -
 drivers/infiniband/core/verbs.c              | 40 ++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx4/mad.c             | 23 +++-------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  1 -
 drivers/infiniband/hw/mlx5/main.c            | 13 ---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  1 -
 drivers/infiniband/hw/mlx5/mr.c              |  5 ++--
 drivers/infiniband/ulp/ipoib/ipoib.h         |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c   | 18 +++----------
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |  8 +++---
 drivers/infiniband/ulp/iser/iser_memory.c    |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  2 +-
 drivers/infiniband/ulp/isert/ib_isert.c      | 33 ++++++++---------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  1 -
 drivers/infiniband/ulp/srp/ib_srp.c          |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 +++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h        |  1 -
 include/rdma/ib_mad.h                        |  1 -
 include/rdma/ib_verbs.h                      |  2 ++
 net/9p/trans_rdma.c                          | 26 ++----------------
 23 files changed, 75 insertions(+), 151 deletions(-)

-- 
2.1.4
