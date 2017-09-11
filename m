From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/core: fix incorrect fall-through on switch statement
Date: Mon, 11 Sep 2017 17:03:13 +0100
Message-ID: <20170911160313.28240-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where mbox_status is OCRDMA_MBX_STATUS_FAILED and
add_status is OCRDMA_MBX_STATUS_FAILED err_num is assigned -EAGAIN
however the case OCRDMA_MBX_STATUS_FAILED is missing a break and
falls through to the default case which then re-assigns err_num
to -EFAULT.   Fix this so that err_num is assigned to -EAGAIN
for the add_status OCRDMA_MBX_STATUS_FAILED case and -EFAULT
otherwise.

Detected by CoverityScan CID#703125 ("Missing break in switch")

Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index dcb5942f9fb5..65b166cc7437 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -252,7 +252,10 @@ static int ocrdma_get_mbx_errno(u32 status)
 		case OCRDMA_MBX_ADDI_STATUS_INSUFFICIENT_RESOURCES:
 			err_num = -EAGAIN;
 			break;
+		default:
+			err_num = -EFAULT;
 		}
+		break;
 	default:
 		err_num = -EFAULT;
 	}
-- 
2.14.1
