From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 0/6] RDMA core and mlx5 fixes and
 refactoring for 4.15
Date: Wed, 18 Oct 2017 11:25:09 -0400
Message-ID: <1508340309.46071.76.camel@redhat.com>
References: <20171016054517.30643-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054517.30643-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-16 at 08:45 +0300, Leon Romanovsky wrote:
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> tags/rdma-next-2017-10-16

This branch is unpullable for me.  Trying to pull this on top of the
shared pull request brings in a ton of other stuff.  My diffstat ends
up looking like this:

[dledford@linux-ws infiniband (mlnx-shared)]$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-16
remote: Counting objects: 94, done.
remote: Compressing objects: 100% (72/72), done.
remote: Total 94 (delta 32), reused 30 (delta 21)
Unpacking objects: 100% (94/94), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma
 * tag                         rdma-next-2017-10-16 -> FETCH_HEAD
Auto-merging drivers/infiniband/hw/qedr/qedr_roce_cm.c
Merge made by the 'recursive' strategy.
 MAINTAINERS                                        |    1 +
 drivers/infiniband/Kconfig                         |    2 +-
 drivers/infiniband/core/addr.c                     |    2 +-
 drivers/infiniband/core/cm.c                       |   27 +-
 drivers/infiniband/core/cma.c                      |   11 +-
 drivers/infiniband/core/iwcm.c                     |    3 -
 drivers/infiniband/core/rw.c                       |   24 +-
 drivers/infiniband/core/sysfs.c                    |   16 +-
 drivers/infiniband/core/user_mad.c                 |   13 +-
 drivers/infiniband/core/uverbs.h                   |   35 +-
 drivers/infiniband/core/uverbs_cmd.c               |  135 +-
 drivers/infiniband/core/uverbs_ioctl_merge.c       |    2 +-
 drivers/infiniband/core/uverbs_main.c              |   22 +-
 drivers/infiniband/core/uverbs_marshall.c          |   10 +-
 drivers/infiniband/core/uverbs_std_types.c         |    3 +-
 drivers/infiniband/core/verbs.c                    |   48 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   20 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |    4 -
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |    5 +-
 drivers/infiniband/hw/cxgb3/Kconfig                |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    6 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    6 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |    3 +
 drivers/infiniband/hw/cxgb4/Kconfig                |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  292 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |  117 +-
 drivers/infiniband/hw/cxgb4/device.c               |   41 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |    2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   83 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  268 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   36 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  141 +-
 drivers/infiniband/hw/cxgb4/resource.c             |   46 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |   20 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  182 +-
 drivers/infiniband/hw/hfi1/chip.h                  |    1 +
 drivers/infiniband/hw/hfi1/debugfs.c               |    4 +-
 drivers/infiniband/hw/hfi1/driver.c                |   10 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |  486 +--
 drivers/infiniband/hw/hfi1/firmware.c              |   87 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   26 +-
 drivers/infiniband/hw/hfi1/init.c                  |   43 +-
 drivers/infiniband/hw/hfi1/mad.c                   |   10 +-
 drivers/infiniband/hw/hfi1/rc.c                    |    2 +-
 drivers/infiniband/hw/hfi1/ruc.c                   |    9 -
 drivers/infiniband/hw/hfi1/sdma.c                  |   19 +-
 drivers/infiniband/hw/hfi1/sysfs.c                 |    2 +-
 drivers/infiniband/hw/hfi1/trace.c                 |   23 +-
 drivers/infiniband/hw/hfi1/trace.h                 |   10 +
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h          |   49 +-
 drivers/infiniband/hw/hfi1/trace_rx.h              |   11 +-
 drivers/infiniband/hw/hfi1/ud.c                    |    2 -
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |    9 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   62 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   29 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   10 -
 drivers/infiniband/hw/hfi1/vnic_main.c             |    7 +-
 drivers/infiniband/hw/hns/Kconfig                  |   25 +-
 drivers/infiniband/hw/hns/Makefile                 |    8 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   16 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |    8 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |  107 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   50 +
 drivers/infiniband/hw/hns/hns_roce_common.h        |   23 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   72 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  101 +-
 drivers/infiniband/hw/hns/hns_roce_eq.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  699 ++++-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |   32 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  599 +++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |    5 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 3133 ++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         | 1165 ++++++++
 drivers/infiniband/hw/hns/hns_roce_main.c          |  342 +--
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  512 +++-
 drivers/infiniband/hw/hns/hns_roce_pd.c            |   20 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  179 +-
 drivers/infiniband/hw/i40iw/Kconfig                |    1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   20 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |    1 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |    1 +
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |    1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c             |   13 +
 drivers/infiniband/hw/i40iw/i40iw_user.h           |    1 +
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |   13 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   13 +
 drivers/infiniband/hw/mlx4/ah.c                    |    8 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    2 +
 drivers/infiniband/hw/mlx4/mcg.c                   |    1 +
 drivers/infiniband/hw/mlx5/ah.c                    |    4 -
 drivers/infiniband/hw/mlx5/cq.c                    |    2 +
 drivers/infiniband/hw/mlx5/mr.c                    |    4 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |    3 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   10 +-
 drivers/infiniband/hw/nes/nes.c                    |   33 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    9 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    7 +-
 drivers/infiniband/hw/nes/nes_nic.c                |    9 +-
 drivers/infiniband/hw/nes/nes_utils.c              |   13 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   12 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   15 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |    8 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |    4 +-
 drivers/infiniband/hw/qedr/Kconfig                 |    1 +
 drivers/infiniband/hw/qedr/Makefile                |    2 +-
 drivers/infiniband/hw/qedr/main.c                  |  118 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   31 +-
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |    6 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |  749 +++++
 drivers/infiniband/hw/qedr/qedr_iw_cm.h            |   49 +
 .../hw/qedr/{qedr_cm.c => qedr_roce_cm.c}          |   31 +-
 .../hw/qedr/{qedr_cm.h => qedr_roce_cm.h}          |    0
 drivers/infiniband/hw/qedr/verbs.c                 |  359 ++-
 drivers/infiniband/hw/qedr/verbs.h                 |    2 +
 drivers/infiniband/hw/qib/Kconfig                  |    1 +
 drivers/infiniband/hw/qib/qib.h                    |   26 +-
 drivers/infiniband/hw/qib/qib_7220.h               |    1 -
 drivers/infiniband/hw/qib/qib_diag.c               |    6 -
 drivers/infiniband/hw/qib/qib_driver.c             |    8 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |    9 -
 drivers/infiniband/hw/qib/qib_iba6120.c            |   62 +-
 drivers/infiniband/hw/qib/qib_iba7220.c            |   75 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |  179 +-
 drivers/infiniband/hw/qib/qib_mad.c                |   14 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |  128 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |    2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c             |    2 -
 drivers/infiniband/hw/qib/qib_sdma.c               |    2 +-
 drivers/infiniband/hw/qib/qib_tx.c                 |    4 -
 drivers/infiniband/hw/qib/qib_verbs.c              |    3 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |    2 -
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      |   25 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |    1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   25 +
 drivers/infiniband/sw/rdmavt/Kconfig               |    1 +
 drivers/infiniband/sw/rdmavt/qp.c                  |    1 +
 drivers/infiniband/sw/rxe/rxe_comp.c               |    4 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |   16 +-
 drivers/infiniband/sw/rxe/rxe_task.c               |    2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   14 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   42 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |   22 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    7 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |   44 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |    1 +
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |   22 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3cdev.h        |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  853 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   11 +-
 drivers/staging/lustre/lnet/Kconfig                |    2 +-
 include/rdma/ib_addr.h                             |   11 +-
 include/rdma/ib_pack.h                             |   19 +-
 include/rdma/ib_sa.h                               |   12 +-
 include/rdma/ib_verbs.h                            |   17 +-
 include/rdma/opa_addr.h                            |    6 +-
 include/rdma/rdmavt_qp.h                           |    6 +-
 165 files changed, 10122 insertions(+), 2809 deletions(-)
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.h
 rename drivers/infiniband/hw/qedr/{qedr_cm.c => qedr_roce_cm.c} (96%)
 rename drivers/infiniband/hw/qedr/{qedr_cm.h => qedr_roce_cm.h} (100%)

So, with a shared pull request, your submissions either need to be
against that shared pull request, or against my for-next, and you need
to let me know which one it is.

I can grab these out of patchworks, but even that way I still need you
to be clear about what tree/branch these are intended to be applied to.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
