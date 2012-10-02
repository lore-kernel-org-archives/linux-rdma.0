From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Removing unused module parameter
Date: Tue, 2 Oct 2012 15:38:16 -0500
Message-ID: <20121002203816.GA8224@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Removing unused module parameter

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c |    5 -----
 drivers/infiniband/hw/nes/nes.h |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 7140199..748db2d 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -79,11 +79,6 @@ int disable_mpa_crc = 0;
 module_param(disable_mpa_crc, int, 0644);
 MODULE_PARM_DESC(disable_mpa_crc, "Disable checking of MPA CRC");
 
-unsigned int send_first = 0;
-module_param(send_first, int, 0644);
-MODULE_PARM_DESC(send_first, "Send RDMA Message First on Active Connection");
-
-
 unsigned int nes_drv_opt = NES_DRV_OPT_DISABLE_INT_MOD | NES_DRV_OPT_ENABLE_PAU;
 module_param(nes_drv_opt, int, 0644);
 MODULE_PARM_DESC(nes_drv_opt, "Driver option parameters");
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 0418bc0..de63e76 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -172,7 +172,6 @@ extern int interrupt_mod_interval;
 extern int nes_if_count;
 extern int mpa_version;
 extern int disable_mpa_crc;
-extern unsigned int send_first;
 extern unsigned int nes_drv_opt;
 extern unsigned int nes_debug_level;
 extern unsigned int wqm_quanta;
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
