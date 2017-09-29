From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] i40iw: delete some stray tabs
Date: Fri, 29 Sep 2017 10:49:43 +0300
Message-ID: <20170929074943.cs2jea5xttk2r6vm@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

These lines were indented too far by mistake.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 5230dd3c938c..9017c1cc51d4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1524,8 +1524,8 @@ static bool i40iw_port_in_use(struct i40iw_cm_core *cm_core, u16 port, bool acti
 				break;
 			}
 		}
-			if (!ret)
-				clear_bit(port, cm_core->active_side_ports);
+		if (!ret)
+			clear_bit(port, cm_core->active_side_ports);
 		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 	} else {
 		spin_lock_irqsave(&cm_core->listen_list_lock, flags);
