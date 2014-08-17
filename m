From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] infiniband: hw: cxgb3: cxio_hal.c:  Cleaning up missing null-terminate after strncpy call
Date: Mon, 18 Aug 2014 00:40:24 +0200
Message-ID: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index de1c61b4..5fc04e4 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -933,6 +933,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
 		netdev_p = rdev_p->t3cdev_p->lldev;
 		strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
 			T3_MAX_DEV_NAME_LEN);
+		rdev_p->dev_name[T3_MAX_DEV_NAME_LEN - 1] = '\0';
 	} else {
 		PDBG("%s t3cdev_p or dev_name must be set\n", __func__);
 		return -EINVAL;
-- 
1.7.10.4
