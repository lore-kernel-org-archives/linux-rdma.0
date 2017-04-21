From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 05/17] IB/mlx4: Delete four unnecessary return statements
Date: Fri, 21 Apr 2017 20:33:31 +0200
Message-ID: <c7dc6218-7cab-06ea-bca9-d534c607bbea@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 13:10:14 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement in the affected functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/mlx4/mad.c  | 3 ---
 drivers/infiniband/hw/mlx4/main.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d8c27e3ed69a..cf33efce69d2 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1173,7 +1173,6 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 out:
 	kfree(in_mad);
 	kfree(out_mad);
-	return;
 }
 
 void handle_port_mgmt_change_event(struct work_struct *work)
@@ -2140,7 +2139,6 @@ void mlx4_ib_tunnels_update_work(struct work_struct *work)
 	mlx4_ib_tunnels_update(dmxw->dev, dmxw->slave, (int) dmxw->port,
 			       dmxw->do_init);
 	kfree(dmxw);
-	return;
 }
 
 static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
@@ -2268,7 +2266,6 @@ static void mlx4_ib_master_tunnels(struct mlx4_ib_dev *dev, int do_init)
 	/* initialize or tear down tunnel QPs for the master */
 	for (i = 0; i < dev->dev->caps.num_ports; i++)
 		mlx4_ib_tunnels_update(dev, mlx4_master_func_num(dev->dev), i + 1, do_init);
-	return;
 }
 
 int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0ac670765466..232f556b1121 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3109,7 +3109,6 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 	}
 out:
 	kfree(dm);
-	return;
 }
 
 static void mlx4_ib_handle_catas_error(struct mlx4_ib_dev *ibdev)
-- 
2.12.2
