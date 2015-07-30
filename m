From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with pd->local_dma_lkey
Date: Thu, 30 Jul 2015 17:22:14 -0600
Message-ID: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
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

All patches are compile tested. I've done basic testing up to and including
the IPoIB patch, the rest required specialized setups I don't have access to,
but are fairly straightforward.

Jason Gunthorpe (12):
  IB/core: Guarantee that a local_dma_lkey is available
  IB/mad: Remove ib_get_dma_mr calls
  IB/ipoib: Remove ib_get_dma_mr calls
  IB/mlx4: Remove ib_get_dma_mr calls
  IB/mlx5: Remove ib_get_dma_mr calls
  IB/iser: Use pd->local_dma_lkey
  iser-target: Remove ib_get_dma_mr calls
  IB/srp: Use pd->local_dma_lkey
  IB/srp: Do not create an all physical insecure rkey by default
  ib_srpt: Remove ib_get_dma_mr calls
  net/9p: Remove ib_get_dma_mr calls
  rds/ib: Remove ib_get_dma_mr calls

 drivers/infiniband/core/mad.c                | 26 ++-------------
 drivers/infiniband/core/mad_priv.h           |  1 -
 drivers/infiniband/core/verbs.c              | 47 +++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/mad.c             | 23 +++-----------
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  1 -
 drivers/infiniband/hw/mlx5/main.c            | 13 --------
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  1 -
 drivers/infiniband/hw/mlx5/mr.c              |  5 ++-
 drivers/infiniband/ulp/ipoib/ipoib.h         |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c   | 18 ++---------
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |  8 ++---
 drivers/infiniband/ulp/iser/iser_memory.c    |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  2 +-
 drivers/infiniband/ulp/isert/ib_isert.c      | 33 +++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  1 -
 drivers/infiniband/ulp/srp/ib_srp.c          | 33 ++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h          |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 +++------
 drivers/infiniband/ulp/srpt/ib_srpt.h        |  1 -
 include/rdma/ib_mad.h                        |  1 -
 include/rdma/ib_verbs.h                      |  9 ++----
 net/9p/trans_rdma.c                          | 26 ++-------------
 net/rds/ib.c                                 |  8 -----
 net/rds/ib.h                                 |  2 --
 net/rds/ib_cm.c                              |  4 +--
 net/rds/ib_recv.c                            |  6 ++--
 net/rds/ib_send.c                            |  8 ++---
 29 files changed, 112 insertions(+), 189 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
