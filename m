From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: make nesadapter->phy_lock usage consistent
Date: Wed, 21 Apr 2010 16:00:51 -0700
Message-ID: <adafx2oo1gc.fsf@roland-alpha.cisco.com>
References: <20100309215040.GA5912@ctung-MOBL>
	<adak4s0o1ny.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4s0o1ny.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org> (Roland Dreier's message
	of "Wed, 21 Apr 2010 15:56:17 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

By the way, any problem with me merging the following trivial patch for
2.6.35?


RDMA/nes: Make unnecessarily global functions static

This allows the compiler to do a bit better; on my x86-64 build:

add/remove: 0/2 grow/shrink: 1/0 up/down: 2288/-2365 (-77)
function                                     old     new   delta
nes_init_phy                                 273    2561   +2288
nes_init_1g_phy                              469       -    -469
nes_init_2025_phy                           1896       -   -1896

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c    |    4 ++--
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 8b67207..86acb7d 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1297,7 +1297,7 @@ int nes_destroy_cqp(struct nes_device *nesdev)
 /**
  * nes_init_1g_phy
  */
-int nes_init_1g_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_index)
+static int nes_init_1g_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_index)
 {
 	u32 counter = 0;
 	u16 phy_data;
@@ -1351,7 +1351,7 @@ int nes_init_1g_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_index)
 /**
  * nes_init_2025_phy
  */
-int nes_init_2025_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_index)
+static int nes_init_2025_phy(struct nes_device *nesdev, u8 phy_type, u8 phy_index)
 {
 	u32 temp_phy_data = 0;
 	u32 temp_phy_data2 = 0;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index e54f312..925e1f2 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -374,7 +374,7 @@ static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 /*
  * nes_alloc_fast_reg_mr
  */
-struct ib_mr *nes_alloc_fast_reg_mr(struct ib_pd *ibpd, int max_page_list_len)
+static struct ib_mr *nes_alloc_fast_reg_mr(struct ib_pd *ibpd, int max_page_list_len)
 {
 	struct nes_pd *nespd = to_nespd(ibpd);
 	struct nes_vnic *nesvnic = to_nesvnic(ibpd->device);
-- 
1.7.0.5


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
