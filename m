From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mlx5: shift wrapping bug in mlx5_ib_get_buf_offset()
Date: Fri, 8 Nov 2013 12:52:59 +0300
Message-ID: <20131108095259.GK27977@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Eli Cohen <eli@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"page_size" is declared as u64 but the (1 << page_shift) shift will wrap
at 32 bits.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 3a53228..3020ec2 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -148,7 +148,7 @@ int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
 	u64 off_mask;
 	u64 buf_off;
 
-	page_size = 1 << page_shift;
+	page_size = 1ULL << page_shift;
 	page_mask = page_size - 1;
 	buf_off = addr & page_mask;
 	off_size = page_size >> 6;
