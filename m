From: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH 0/2] Performance Improvents for Secured Mode NVMe over Fabrics and other RDMA ULPs
Date: Sun, 29 Oct 2017 18:38:19 +0200
Message-ID: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The following two patches are including performance 
optimizations for RDMA kernel ULPs that register/invalidate
per IO (e.g. NVMe over Fabrics, iSER, NFS RDMA). The patches 
improve the IOPs could be achieved by a single network 
adapter with the above ULPs, specifically for NVMe over 
Fabrics the IOPs have improved x5 for small IO reads could 
be achieved in Linux using a single network adapter.

First improvement, which is relavant to mlx5 rdma adapters, 
improves the way reg_wr is posted to the adapter by communicating 
the KLM/MTT list inline (within the work request) instead of using 
scatter-gather.

After the first bottleneck has been removed, a new bottleneck 
was uncovered for send with invaldate processing in the recieve 
path of the ConnectX-5 (mlx5) adapter, therefore a new module 
parameter was added for nvme_rdma for disabling remote 
invalidation in such case.

We are currently investigating write IOPs optimizations as
well, be tuned for more patches in the pipeline...

Idan Burstein (2):
  IB/mlx5: posting klm/mtt list inline in the send queue for reg_wr
  nvme-rdma: Add remote_invalidation module parameter

 drivers/infiniband/hw/mlx5/qp.c | 41 +++++++++++++++++++++++++++++++++++------
 drivers/nvme/host/rdma.c        | 10 ++++++++--
 2 files changed, 43 insertions(+), 8 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
