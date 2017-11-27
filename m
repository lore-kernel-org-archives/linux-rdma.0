From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] i40iw: remove unused 'timeval' struct member
Date: Mon, 27 Nov 2017 12:38:09 +0100
Message-ID: <20171127113819.2413554-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Mustafa Ismail <mustafa.ismail@intel.com>, Henry Orosco <henry.orosco@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There is a stale entry in i40iw_cm_tcp_context that apparently
was copied from the 'nes' driver but never used in i40iw.
I'm trying to kill off all users of timeval as part of the
y2038-safety work, so let's just remove this one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 0d5840d2c4fc..1577608fc51a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -276,8 +276,6 @@ struct i40iw_cm_tcp_context {
 	u32 mss;
 	u8 snd_wscale;
 	u8 rcv_wscale;
-
-	struct timeval sent_ts;
 };
 
 enum i40iw_cm_listener_state {
-- 
2.9.0
