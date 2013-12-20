From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/15] IB/usnic: Remove extraneous if check
Date: Fri, 20 Dec 2013 12:26:42 -0800
Message-ID: <1387571206-8043-12-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove extraneous if (chunk->cnt) condition.  The code will
not go into the next for loop if chunk->cnt is 0.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_vnic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 5a50acb..74e4e5b 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -102,8 +102,6 @@ int usnic_vnic_dump(struct usnic_vnic *vnic, char *buf,
 	spin_lock(&vnic->res_lock);
 	for (i = 0; i < ARRAY_SIZE(vnic->chunks); i++) {
 		chunk = &vnic->chunks[i];
-		if (chunk->cnt == 0)
-			continue;
 		for (j = 0; j < chunk->cnt; j++) {
 			res = chunk->res[j];
 			offset += scnprintf(buf + offset, buf_sz - offset,
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
