From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] RDMA/nes: constify nes_cm_ops structure
Date: Sat, 28 Nov 2015 15:00:37 +0100
Message-ID: <1448719237-17445-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The nes_cm_ops structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/nes/nes_cm.c |    2 +-
 drivers/infiniband/hw/nes/nes_cm.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 8a3ad17..d129342 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -134,7 +134,7 @@ static void record_ird_ord(struct nes_cm_node *, u16, u16);
 /* External CM API Interface */
 /* instance of function pointers for client API */
 /* set address of this instance to cm_core->cm_ops at cm_core alloc */
-static struct nes_cm_ops nes_cm_api = {
+static const struct nes_cm_ops nes_cm_api = {
 	mini_cm_accelerated,
 	mini_cm_listen,
 	mini_cm_del_listen,
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 32a6420..147c2c8 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -423,7 +423,7 @@ struct nes_cm_core {
 
 	struct timer_list       tcp_timer;
 
-	struct nes_cm_ops       *api;
+	const struct nes_cm_ops *api;
 
 	int (*post_event)(struct nes_cm_event *event);
 	atomic_t                events_posted;

