From: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/23] Remove deprecated create_workqueue instances
Date: Mon, 15 Aug 2016 23:23:55 +0530
Message-ID: <cover.1471283409.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise@chelsi>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set removes the instances of deprecated
create_singlethread_workqueue (scheduled for removal) in drivers/infiniband
by making the appropriate conversions.

Bhaktipriya Shridhar (23):
  drm/ttm: Remove deprecated create_singlethread_workqueue
  IB/sa : Remove deprecated create_singlethread_workqueue
  IB/mad: Remove deprecated create_singlethread_workqueue
  IB/multicast: Remove deprecated create_singlethread_workqueue
  IB/ucma: Remove deprecated create_singlethread_workqueue
  IB/cma: Remove deprecated create_singlethread_workqueue
  IB/addr: Remove deprecated create_singlethread_workqueue
  IB/iwcm: Remove deprecated create_singlethread_workqueue
  iw_cxgb3: Remove deprecated create_singlethread_workqueue
  IB/qib: Remove deprecated create_singlethread_workqueue
  iw_cxgb4: Remove deprecated create_singlethread_workqueue
  IB/mthca: Remove deprecated create_singlethread_workqueue
  i40iw_main: Remove deprecated create_singlethread_workqueue
  i40iw_cm: Remove deprecated create_singlethread_workqueue
  IB/mlx5: Remove deprecated create_singlethread_workqueue
  IB/mlx5/odp: Remove deprecated create_singlethread_workqueue
  IB/mlx4: Remove deprecated create_singlethread_workqueue
  IB/mlx4/mad: Remove deprecated create_singlethread_workqueue
  IB/mlx4/mcg: Remove deprecated create_singlethread_workqueue
  IB/nes: Remove deprecated create_singlethread_workqueue
  IB/ipoib: Remove deprecated create_singlethread_workqueue
  IB/ipoib_verbs: Remove deprecated create_singlethread_workqueue
  IB/mlx4/alias_GUID: Remove deprecated create_singlethread_workqueue

 drivers/gpu/drm/ttm/ttm_memory.c           | 7 ++-----
 drivers/infiniband/core/addr.c             | 2 +-
 drivers/infiniband/core/cma.c              | 2 +-
 drivers/infiniband/core/iwcm.c             | 2 +-
 drivers/infiniband/core/mad.c              | 2 +-
 drivers/infiniband/core/multicast.c        | 2 +-
 drivers/infiniband/core/sa_query.c         | 2 +-
 drivers/infiniband/core/ucma.c             | 3 ++-
 drivers/infiniband/hw/cxgb3/iwch_cm.c      | 2 +-
 drivers/infiniband/hw/cxgb4/cm.c           | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c     | 7 +++++--
 drivers/infiniband/hw/i40iw/i40iw_main.c   | 2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c    | 2 +-
 drivers/infiniband/hw/mlx4/mad.c           | 4 ++--
 drivers/infiniband/hw/mlx4/main.c          | 2 +-
 drivers/infiniband/hw/mlx4/mcg.c           | 4 ++--
 drivers/infiniband/hw/mlx5/mr.c            | 2 +-
 drivers/infiniband/hw/mlx5/odp.c           | 4 ++--
 drivers/infiniband/hw/mthca/mthca_catas.c  | 2 +-
 drivers/infiniband/hw/nes/nes_cm.c         | 4 ++--
 drivers/infiniband/hw/qib/qib_init.c       | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c  | 3 ++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 2 +-
 23 files changed, 35 insertions(+), 33 deletions(-)

--
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
