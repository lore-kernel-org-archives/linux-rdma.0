From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ib_srpt: fix a WARN_ON() message
Date: Fri, 18 Mar 2016 08:41:59 +0300
Message-ID: <20160318054159.GE2111@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Alex Estrin <alex.estrin@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The first argument of WARN_ON() is a condition, so it means the warning
message here will just be the name without the ->qp_num information.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 1d13090..0bd3cb2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -839,7 +839,7 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (srpt_set_ch_state(ch, CH_DISCONNECTED))
 			schedule_work(&ch->release_work);
 		else
-			WARN_ONCE("%s-%d\n", ch->sess_name, ch->qp->qp_num);
+			WARN_ONCE(1, "%s-%d\n", ch->sess_name, ch->qp->qp_num);
 	}
 }
 
