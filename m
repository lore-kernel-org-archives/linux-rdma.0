From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Add support for dynamic UAR usage
Date: Sun, 24 Dec 2017 16:31:33 +0200
Message-ID: <20171224143136.12306-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From Yishai:

This series enables the user space driver to ask for a dynamic UAR
allocation and uses its internal BF (i.e. blue-flame) registers as part
of QP creation.

The motivation behind this functionality is to let the user space driver
share BF register between few QPs or to set a dedicated BF for a given QP.

The above gives an option to user space applications to utilize its
resources and performance according to its needs.

For example:
An application can improve its performance by having a dedicated BF for
collection of QPs that are running from the same thread and drop the
need to take a lock as part of its post send flow. This is not enabled
today as the kernel driver assigned BF registers in some FIFO logic and
as such QPs from different threads may share same BF and as such a lock
when accessing this BF will be needed.

The series consists from 3 patches:
The first patch extends the alloc context flow to be prepared for
working with dynamic UAR allocations.
The second patch exposes the option to dynamic allocates a UAR.
The third patch uses the given BF register from the user area as
part of QP creation instead of using some arbitrary BF register.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-12-24-5

	Thanks
---------------------------------------

Yishai Hadas (3):
  IB/mlx5: Extend UAR stuff to support dynamic allocation
  IB/mlx5: Expose dynamic mmap allocation
  IB/mlx5: Enable QP creation with a given blue flame index

 drivers/infiniband/hw/mlx5/main.c    | 141 ++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  13 +++-
 drivers/infiniband/hw/mlx5/qp.c      |  55 ++++++++++----
 include/linux/mlx5/device.h          |   2 +
 include/linux/mlx5/driver.h          |   3 +
 include/uapi/rdma/mlx5-abi.h         |   5 +-
 6 files changed, 177 insertions(+), 42 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
