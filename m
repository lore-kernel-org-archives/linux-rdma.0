From: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH resend] RDMA/nes: corrected firmware version update
Date: Thu, 15 Jul 2010 16:53:29 +0200
Message-ID: <20100715144920.1344.27343.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now firmware version is read from correct place

Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 0abd4f2..f179586 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -520,7 +520,7 @@ static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	memset(props, 0, sizeof(*props));
 	memcpy(&props->sys_image_guid, nesvnic->netdev->dev_addr, 6);
 
-	props->fw_ver = nesdev->nesadapter->fw_ver;
+	props->fw_ver = nesdev->nesadapter->firmware_version;
 	props->device_cap_flags = nesdev->nesadapter->device_cap_flags;
 	props->vendor_id = nesdev->nesadapter->vendor_id;
 	props->vendor_part_id = nesdev->nesadapter->vendor_part_id;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
