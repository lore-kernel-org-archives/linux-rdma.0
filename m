From: Kees Cook <keescook@chromium.org>
Subject: [PATCH rdma-next v4 0/3] overflow.h: Add left-shift helper
Date: Wed,  1 Aug 2018 14:25:38 -0700
Message-ID: <20180801212541.22889-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Randy Dunlap <rdunlap@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This adds the left-shift overflow helper, selftests, and first usage.

-Kees

v4:
- actually fix docs typo
- rename to check_shl_overflow()
v3:
- add even more test cases (type mismatches, more signed overflows).
- fix documentation typo on argument name.
v2:
- swap out selftests with framework from Rasmus, add lots more tests.
- drop double-assignment in helper.


Jason Gunthorpe (1):
  overflow.h: Add arithmetic shift helper

Kees Cook (1):
  test_overflow: Add shift overflow tests

Leon Romanovsky (1):
  RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq

 drivers/infiniband/hw/mlx5/qp.c |   4 +-
 include/linux/overflow.h        |  31 +++++
 lib/test_overflow.c             | 198 +++++++++++++++++++++++++++++++-
 3 files changed, 231 insertions(+), 2 deletions(-)

-- 
2.17.1
