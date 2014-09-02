From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-3.17] IB/core: When marsheling uverbs path, clear unused fields
Date: Tue,  2 Sep 2014 15:32:34 +0300
Message-ID: <1409661154-13718-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When marsheling a user path to the kernel struct ib_sa_path, need
to zero smac, dmac and set the vlan id to the "no vlan" value.

Fixes: dd5f03b ('IB/core: Ethernet L2 attributes in verbs/cm structures')
Reported-by: Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Roland, 

Please apply this patch instead of https://patchwork.kernel.org/patch/4756711/
"[PATCH for-3.17,7/7] IB/core: When marsheling uverbs path, clear unused fields

changes from V0: 

addressed sparse complaints on casting to __be16

drivers/infiniband/core/uverbs_marshall.c:146:24: warning: cast to restricted __be16

We can simply use the non be16 0xffff value which signals "no vlan"

Or.

 drivers/infiniband/core/uverbs_marshall.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index e7bee46..abd9724 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -140,5 +140,9 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	dst->packet_life_time	= src->packet_life_time;
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
+
+	memset(dst->smac, 0, sizeof(dst->smac));
+	memset(dst->dmac, 0, sizeof(dst->dmac));
+	dst->vlan_id = 0xffff;
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
