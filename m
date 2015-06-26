From: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] infiniband: Remove redundant NULL check before kfree
Date: Fri, 26 Jun 2015 12:39:07 +0530
Message-ID: <1435302547-40904-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

kfree(NULL) is safe and this check is probably not required

Signed-off-by: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Akhilesh Kumar <akhilesh.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 067a691..4e60b39 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2676,10 +2676,8 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		dm[i] = kmalloc(sizeof (struct mlx4_ib_demux_work), GFP_ATOMIC);
 		if (!dm[i]) {
 			pr_err("failed to allocate memory for tunneling qp update work struct\n");
-			for (i = 0; i < dev->caps.num_ports; i++) {
-				if (dm[i])
-					kfree(dm[i]);
-			}
+			for (i = 0; i < dev->caps.num_ports; i++)
+				kfree(dm[i]);
 			goto out;
 		}
 	}
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
