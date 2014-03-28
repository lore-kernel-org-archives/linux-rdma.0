From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 2/2] net/mlx4: make buffer larger to avoid overflow warning
Date: Fri, 28 Mar 2014 11:23:07 +0300
Message-ID: <20140328082307.GG25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

My static checker complains that the sprintf() here can overflow.

	drivers/infiniband/hw/mlx4/main.c:1836 mlx4_ib_alloc_eqs()
	error: format string overflow. buf_size: 32 length: 69

This seems like a valid complaint.  The "dev->pdev->bus->name" string
can be 48 characters long.  I just made the buffer 80 characters instead
of 69 and I changed the sprintf() to snprintf().

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8d9d6b8..1b6dbe15 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1803,7 +1803,7 @@ static void init_pkeys(struct mlx4_ib_dev *ibdev)
 
 static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 {
-	char name[32];
+	char name[80];
 	int eq_per_port = 0;
 	int added_eqs = 0;
 	int total_eqs = 0;
@@ -1833,8 +1833,8 @@ static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 	eq = 0;
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB) {
 		for (j = 0; j < eq_per_port; j++) {
-			sprintf(name, "mlx4-ib-%d-%d@%s",
-				i, j, dev->pdev->bus->name);
+			snprintf(name, sizeof(name), "mlx4-ib-%d-%d@%s",
+				 i, j, dev->pdev->bus->name);
 			/* Set IRQ for specific name (per ring) */
 			if (mlx4_assign_eq(dev, name, NULL,
 					   &ibdev->eq_table[eq])) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
