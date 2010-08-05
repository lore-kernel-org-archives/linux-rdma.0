From: Dan Carpenter <error27@gmail.com>
Subject: [PATCH 4/42 v2] drivers/infiniband/hw/nes: Adjust confusing if
	indentation
Date: Fri, 6 Aug 2010 01:48:32 +0200
Message-ID: <20100805234831.GK9031@bicker>
References: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: Faisal Latif <faisal.latif@intel.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

I think the white space is meant to look like this.  I did look at
whether the "sq_cqes = 0;" should only be done if netif_queue_stopped().
In the end I decided this was what was intended, but it would be
better if someone more familiar with the code reviewed it.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2: changed different indents

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 57874a1..293977b 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2737,9 +2737,9 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 				nesnic->sq_tail &= nesnic->sq_size-1;
 				if (sq_cqes > 128) {
 					barrier();
-				/* restart the queue if it had been stopped */
-				if (netif_queue_stopped(nesvnic->netdev))
-					netif_wake_queue(nesvnic->netdev);
+					/* restart the queue if it had been stopped */
+					if (netif_queue_stopped(nesvnic->netdev))
+						netif_wake_queue(nesvnic->netdev);
 					sq_cqes = 0;
 				}
 			} else {
