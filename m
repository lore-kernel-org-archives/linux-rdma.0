From: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] amso1100: Add missing memset
Date: Wed, 14 Apr 2010 17:20:15 +0300
Message-ID: <20100414142015.GA16260@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_rnic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index dd05c48..bac9856 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -155,6 +155,8 @@ static int c2_rnic_query(struct c2_dev *c2dev, struct ib_device_attr *props)
 	if (err)
 		goto bail2;
 
+	memset(props, 0, sizeof *props);
+
 	props->fw_ver =
 		((u64)be32_to_cpu(reply->fw_ver_major) << 32) |
 		((be32_to_cpu(reply->fw_ver_minor) & 0xFFFF) << 16) |
-- 
1.7.0.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
