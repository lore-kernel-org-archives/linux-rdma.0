From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: Re: [PATCH 00/23] Remove deprecated create_workqueue instances
Date: Mon, 15 Aug 2016 23:25:44 +0530
Message-ID: <CAFNHFT_qky8x=-19COb=ju1H2Y5Gxa3cNHYa9L_8Ap3LVE7_kA@mail.gmail.com>
References: <cover.1471283409.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471283409.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Leon Romanovsky <leonro@mellanox.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Steve Wise <swise@chelsi>
Cc: linux-rdma@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-rdma@vger.kernel.org

Please ignore this mail.
Bhaktipriya


On Mon, Aug 15, 2016 at 11:23 PM, Bhaktipriya Shridhar
<bhaktipriya96@gmail.com> wrote:
> This patch set removes the instances of deprecated
> create_singlethread_workqueue (scheduled for removal) in drivers/infiniband
> by making the appropriate conversions.
>
> Bhaktipriya Shridhar (23):
>   drm/ttm: Remove deprecated create_singlethread_workqueue
>   IB/sa : Remove deprecated create_singlethread_workqueue
>   IB/mad: Remove deprecated create_singlethread_workqueue
>   IB/multicast: Remove deprecated create_singlethread_workqueue
>   IB/ucma: Remove deprecated create_singlethread_workqueue
>   IB/cma: Remove deprecated create_singlethread_workqueue
>   IB/addr: Remove deprecated create_singlethread_workqueue
>   IB/iwcm: Remove deprecated create_singlethread_workqueue
>   iw_cxgb3: Remove deprecated create_singlethread_workqueue
>   IB/qib: Remove deprecated create_singlethread_workqueue
>   iw_cxgb4: Remove deprecated create_singlethread_workqueue
>   IB/mthca: Remove deprecated create_singlethread_workqueue
>   i40iw_main: Remove deprecated create_singlethread_workqueue
>   i40iw_cm: Remove deprecated create_singlethread_workqueue
>   IB/mlx5: Remove deprecated create_singlethread_workqueue
>   IB/mlx5/odp: Remove deprecated create_singlethread_workqueue
>   IB/mlx4: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mad: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mcg: Remove deprecated create_singlethread_workqueue
>   IB/nes: Remove deprecated create_singlethread_workqueue
>   IB/ipoib: Remove deprecated create_singlethread_workqueue
>   IB/ipoib_verbs: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/alias_GUID: Remove deprecated create_singlethread_workqueue
>
>  drivers/gpu/drm/ttm/ttm_memory.c           | 7 ++-----
>  drivers/infiniband/core/addr.c             | 2 +-
>  drivers/infiniband/core/cma.c              | 2 +-
>  drivers/infiniband/core/iwcm.c             | 2 +-
>  drivers/infiniband/core/mad.c              | 2 +-
>  drivers/infiniband/core/multicast.c        | 2 +-
>  drivers/infiniband/core/sa_query.c         | 2 +-
>  drivers/infiniband/core/ucma.c             | 3 ++-
>  drivers/infiniband/hw/cxgb3/iwch_cm.c      | 2 +-
>  drivers/infiniband/hw/cxgb4/cm.c           | 2 +-
>  drivers/infiniband/hw/i40iw/i40iw_cm.c     | 7 +++++--
>  drivers/infiniband/hw/i40iw/i40iw_main.c   | 2 +-
>  drivers/infiniband/hw/mlx4/alias_GUID.c    | 2 +-
>  drivers/infiniband/hw/mlx4/mad.c           | 4 ++--
>  drivers/infiniband/hw/mlx4/main.c          | 2 +-
>  drivers/infiniband/hw/mlx4/mcg.c           | 4 ++--
>  drivers/infiniband/hw/mlx5/mr.c            | 2 +-
>  drivers/infiniband/hw/mlx5/odp.c           | 4 ++--
>  drivers/infiniband/hw/mthca/mthca_catas.c  | 2 +-
>  drivers/infiniband/hw/nes/nes_cm.c         | 4 ++--
>  drivers/infiniband/hw/qib/qib_init.c       | 4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c  | 3 ++-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 2 +-
>  23 files changed, 35 insertions(+), 33 deletions(-)
>
> --
> 2.1.4
>
