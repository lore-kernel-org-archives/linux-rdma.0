From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] nes: remove unused 'timeval' struct member
Date: Mon, 27 Nov 2017 12:38:10 +0100
Message-ID: <20171127113819.2413554-2-arnd@arndb.de>
References: <20171127113819.2413554-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127113819.2413554-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There is a stale entry in nes_cm_tcp_context that has apparently
never been used in mainline linux.

I'm trying to kill off all users of timeval as part of the
y2038-safety work, so let's just remove this one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/nes/nes_cm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index d827d03e3941..2cf2641867d8 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -279,7 +279,6 @@ struct nes_cm_tcp_context {
 	u8  rcv_wscale;
 
 	struct nes_cm_tsa_context tsa_cntxt;
-	struct timeval            sent_ts;
 };
 
 
-- 
2.9.0
