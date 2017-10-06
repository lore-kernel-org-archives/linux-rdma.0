From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 24/47] IB/mthca: Fix indentation
Date: Fri,  6 Oct 2017 14:33:10 -0700
Message-ID: <20171006213333.6721-25-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index e36a9bc52268..f3e80dec1334 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -473,11 +473,11 @@ static int mthca_init_icm(struct mthca_dev *mdev,
 		goto err_unmap_eqp;
 	}
 
-       mdev->cq_table.table = mthca_alloc_icm_table(mdev, init_hca->cqc_base,
-						    dev_lim->cqc_entry_sz,
-						    mdev->limits.num_cqs,
-						    mdev->limits.reserved_cqs,
-						    0, 0);
+	mdev->cq_table.table = mthca_alloc_icm_table(mdev, init_hca->cqc_base,
+						     dev_lim->cqc_entry_sz,
+						     mdev->limits.num_cqs,
+						     mdev->limits.reserved_cqs,
+						     0, 0);
 	if (!mdev->cq_table.table) {
 		mthca_err(mdev, "Failed to map CQ context memory, aborting.\n");
 		err = -ENOMEM;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
