From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 for v3.15 0/4] uverbs ABI fixes
Date: Mon,  5 May 2014 19:33:20 +0200
Message-ID: <cover.1399309513.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find four updated patches which fix some issues regarding missing
explicit padding at end of structure exchanged between kernel and userspace.

These makes i386 userspace libraries and x86_64 kernel disagree about
the size of the structures.

I've made a review of all others drivers. I've identified the following
structures as part of ABI:

  cxgb3/iw_cxgb3.o     struct iwch_create_cq_req
  cxgb3/iw_cxgb3.o     struct iwch_create_cq_resp
  cxgb3/iw_cxgb3.o     struct iwch_create_qp_resp
  cxgb3/iw_cxgb3.o     struct iwch_reg_user_mr_resp

  cxgb4/iw_cxgb4.o     struct c4iw_alloc_ucontext_resp
  cxgb4/iw_cxgb4.o     struct c4iw_create_cq_resp
  cxgb4/iw_cxgb4.o     struct c4iw_create_qp_resp

  ehca/ib_ehca.o       struct ehca_create_cq_resp
  ehca/ib_ehca.o       struct ehca_create_qp_resp
  ehca/ib_ehca.o       struct ipzu_queue_resp

  mlx4/mlx4_ib.o       struct mlx4_ib_alloc_ucontext_resp
  mlx4/mlx4_ib.o       struct mlx4_ib_alloc_ucontext_resp_v3
  mlx4/mlx4_ib.o       struct mlx4_ib_create_cq
  mlx4/mlx4_ib.o       struct mlx4_ib_create_qp
  mlx4/mlx4_ib.o       struct mlx4_ib_create_srq
  mlx4/mlx4_ib.o       struct mlx4_ib_resize_cq

  mlx5/mlx5_ib.o       struct mlx5_ib_alloc_pd_resp
  mlx5/mlx5_ib.o       struct mlx5_ib_alloc_ucontext_req_v2
  mlx5/mlx5_ib.o       struct mlx5_ib_alloc_ucontext_resp
  mlx5/mlx5_ib.o       struct mlx5_ib_create_cq
  mlx5/mlx5_ib.o       struct mlx5_ib_create_qp
  mlx5/mlx5_ib.o       struct mlx5_ib_create_qp_resp
  mlx5/mlx5_ib.o       struct mlx5_ib_create_srq
  mlx5/mlx5_ib.o       struct mlx5_ib_resize_cq

  mthca/ib_mthca.o     struct mthca_alloc_ucontext_resp
  mthca/ib_mthca.o     struct mthca_create_cq
  mthca/ib_mthca.o     struct mthca_create_qp
  mthca/ib_mthca.o     struct mthca_create_srq
  mthca/ib_mthca.o     struct mthca_reg_mr
  mthca/ib_mthca.o     struct mthca_resize_cq

  nes/iw_nes.o         struct nes_alloc_pd_resp
  nes/iw_nes.o         struct nes_alloc_ucontext_req
  nes/iw_nes.o         struct nes_alloc_ucontext_resp
  nes/iw_nes.o         struct nes_create_cq_req
  nes/iw_nes.o         struct nes_create_cq_resp
  nes/iw_nes.o         struct nes_create_qp_req
  nes/iw_nes.o         struct nes_create_qp_resp
  nes/iw_nes.o         struct nes_mem_reg_req

  ocrdma/ocrdma.o      struct ocrdma_alloc_pd_uresp
  ocrdma/ocrdma.o      struct ocrdma_alloc_ucontext_resp
  ocrdma/ocrdma.o      struct ocrdma_create_cq_ureq
  ocrdma/ocrdma.o      struct ocrdma_create_cq_uresp
  ocrdma/ocrdma.o      struct ocrdma_create_qp_ureq
  ocrdma/ocrdma.o      struct ocrdma_create_qp_uresp
  ocrdma/ocrdma.o      struct ocrdma_create_srq_uresp

  usnic/usnic_verbs.o  struct usnic_ib_create_qp_cmd
  usnic/usnic_verbs.o  struct usnic_ib_create_qp_resp
  usnic/usnic_verbs.o  struct usnic_transport_spec

It seems that amso1100/iw_c2.o, ipath/ib_ipath.o and qib/ib_qib.o don't
make use of structure to exchange data with userspace: they use single
values, either u32 or u64.

I've used 'pahole' to compare structure layout from x86_64 against the one
use for i386 and identified the 4 defects addressed by this patchset:
2 issues in mlx5 and 2 issues in cxgb4 drivers.

Additionally, as reported by Dan Carpenter[1], in one case, stack information
can be leaked by the kernel to userspace due to implicit padding being not
initialized.

Unfortunately, the data structure cannot be fixed alone as it would break
existing applications. So in order to remain compatible with i386 libraries,
providers (hw) functions are modified to use the input length to guess the
expected format of the command in order to check the content of the reserved
field for future usage. Others are modified to not write the padding field in
response to make the kernel able to handle gracefully i386 userspace on x86_64.

Optionnaly, for full coherency, patches against the userspace libraries
(libcxgb4[2] and libmlx5[3]) were submitted to update the data structures
on userspace side.

I haven't be able to test the patches as I don't have (access to)
the required HCAs. For each driver, the patchset should be tested in
3 x 2 setups:
- i386 userspace / i386 kernel,
- i386 userspace / x86_64 kernel,
- x86_64 userspace / x86_64 kernel,
with patched and unpatched userspace library.

Regards.

Changes from v0 [4]:
- simplified handling of non-padded structures in mlx5
- address coding style issues reported by checkpatch.pl
- fixed malformed patches which were hand-edited

[1] http://marc.info/?i=20140328082428.GH25192@mwanda
[2] http://marc.info/?i=cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[3] http://marc.info/?i=1399239713-18152-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[4] http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (4):
  RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_cq
  RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_srq
  RDMA/cxgb4: add missing padding at end of struct c4iw_create_cq_resp
  RDMA/cxgb4: add missing padding at end of struct
    c4iw_alloc_ucontext_resp

 drivers/infiniband/hw/cxgb4/cq.c       |  4 ++--
 drivers/infiniband/hw/cxgb4/provider.c |  5 +++--
 drivers/infiniband/hw/cxgb4/user.h     |  2 ++
 drivers/infiniband/hw/mlx5/cq.c        | 13 ++++++++++++-
 drivers/infiniband/hw/mlx5/srq.c       | 14 +++++++++++++-
 drivers/infiniband/hw/mlx5/user.h      |  2 ++
 6 files changed, 34 insertions(+), 6 deletions(-)

-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
