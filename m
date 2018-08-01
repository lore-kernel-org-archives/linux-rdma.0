From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/3] overflow.h: Add arithmetic shift helper
Date: Tue, 31 Jul 2018 17:00:36 -0700
Message-ID: <20180801000039.44314-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This adds the shift overflow helper, selftests, and first usage.

-Kees

Jason Gunthorpe (1):
  overflow.h: Add arithmetic shift helper

Kees Cook (1):
  test_overflow: Add shift overflow tests

Leon Romanovsky (1):
  RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq

 drivers/infiniband/hw/mlx5/qp.c |   5 +-
 include/linux/overflow.h        |  31 +++++++
 lib/test_overflow.c             | 140 +++++++++++++++++++++++++++++++-
 3 files changed, 174 insertions(+), 2 deletions(-)

-- 
2.17.1
