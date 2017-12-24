From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] i40iw: Replace mdelay with msleep in i40iw_wait_pe_ready
Date: Sun, 24 Dec 2017 18:39:40 +0800
Message-ID: <1514111980-30502-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-rdma@vger.kernel.org

i40iw_wait_pe_ready is not called in an interrupt handler 
nor holding a spinlock.
The function mdelay in it can be replaced with msleep, 
to reduce busy wait.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index e824296..8098bc1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1285,7 +1285,7 @@ static void i40iw_wait_pe_ready(struct i40iw_hw *hw)
 			      __LINE__, statuscpu2);
 		if ((statuscpu0 == 0x80) && (statuscpu1 == 0x80) && (statuscpu2 == 0x80))
 			break;	/* SUCCESS */
-		mdelay(1000);
+		msleep(1000);
 		retrycount++;
 	} while (retrycount < 14);
 	i40iw_wr32(hw, 0xb4040, 0x4C104C5);
-- 
1.7.9.5
