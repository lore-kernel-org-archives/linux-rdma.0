From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/5 linux-next] IB/mlx4: remove unneccessary message level.
Date: Mon, 30 Mar 2015 22:06:06 +0200
Message-ID: <1427745969-12959-3-git-send-email-fabf@skynet.be>
References: <1427745969-12959-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427745969-12959-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

KERN_WARNING is implicitely declared in pr_warn()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/hw/mlx4/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b972c0b..1298fe8 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1568,8 +1568,7 @@ static void reset_gids_task(struct work_struct *work)
 			       MLX4_CMD_TIME_CLASS_B,
 			       MLX4_CMD_WRAPPED);
 		if (err)
-			pr_warn(KERN_WARNING
-				"set port %d command failed\n", gw->port);
+			pr_warn("set port %d command failed\n", gw->port);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
-- 
1.9.1
