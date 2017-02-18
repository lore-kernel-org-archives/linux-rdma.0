From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 00/29] IB/mlx: Fine-tuning for several function
 implementations
Date: Sat, 18 Feb 2017 21:45:51 +0100
Message-ID: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 21:34:32 +0100

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (29):
  Use kcalloc() in mlx4_ib_alloc_pv_bufs()
  Improve another size determination in mlx4_ib_alloc_pv_bufs()
  Improve another size determination in mlx4_ib_alloc_demux_ctx()
  Improve another size determination in alloc_pv_object()
  Fix a typo in a comment line
  Delete three unnecessary return statements
  Split a condition check in handle_slaves_guid_change()
  Delete an unnecessary check before the function call "kfree" in free_pv_object()
  Move an assignment out of a check in forward_trap()
  Enclose 15 expressions for the sizeof operator by parentheses
  Use kmalloc_array() in three functions
  Enclose 17 expressions for the sizeof operator by parentheses
  Split a condition check in five functions
  Delete an unnecessary variable in __mlx4_ib_query_gid()
  Delete an unnecessary return statement in do_slave_init()
  Improve another size determination in do_slave_init()
  Improve another size determination in mlx4_ib_add()
  Delete an unnecessary variable initialisation in mlx4_ib_add()
  Delete an unnecessary variable assignment in mlx4_ib_add()
  Delete an error message for a failed memory allocation in mlx4_ib_add()
  Delete unnecessary braces in mlx4_ib_add()
  Use kmalloc_array() in alloc_proxy_bufs()
  Improve size determinations in create_qp_common()
  Delete unwanted spaces behind usages of the sizeof operator
  Add spaces for better code readability
  Enclose 14 expressions for the sizeof operator by parentheses
  Use kmalloc_array() in create_kernel_qp()
  Less function calls in create_kernel_qp() after error detection
  Use kmalloc_array() in create_srq_kernel()

 drivers/infiniband/hw/mlx4/mad.c  |  72 ++++++++--------
 drivers/infiniband/hw/mlx4/main.c | 164 ++++++++++++++++++++----------------
 drivers/infiniband/hw/mlx4/qp.c   | 173 +++++++++++++++++++-------------------
 drivers/infiniband/hw/mlx5/qp.c   |  66 ++++++++++-----
 drivers/infiniband/hw/mlx5/srq.c  |   5 +-
 5 files changed, 261 insertions(+), 219 deletions(-)

-- 
2.11.1
