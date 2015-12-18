From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 6/7] staging/o2iblnd: Avoid calling ib_query_device
Date: Fri, 18 Dec 2015 10:59:49 +0200
Message-ID: <1450429190-5898-7-git-send-email-ogerlitz@mellanox.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450429190-5898-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead, use the cached copy of the attributes present on the device.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 7c730e3..7231ef8 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2070,32 +2070,13 @@ static int kiblnd_net_init_pools(kib_net_t *net, __u32 *cpts, int ncpts)
 
 static int kiblnd_hdev_get_attr(kib_hca_dev_t *hdev)
 {
-	struct ib_device_attr *attr;
-	int rc;
-
 	/* It's safe to assume a HCA can handle a page size
 	 * matching that of the native system */
 	hdev->ibh_page_shift = PAGE_SHIFT;
 	hdev->ibh_page_size  = 1 << PAGE_SHIFT;
 	hdev->ibh_page_mask  = ~((__u64)hdev->ibh_page_size - 1);
 
-	LIBCFS_ALLOC(attr, sizeof(*attr));
-	if (attr == NULL) {
-		CERROR("Out of memory\n");
-		return -ENOMEM;
-	}
-
-	rc = ib_query_device(hdev->ibh_ibdev, attr);
-	if (rc == 0)
-		hdev->ibh_mr_size = attr->max_mr_size;
-
-	LIBCFS_FREE(attr, sizeof(*attr));
-
-	if (rc != 0) {
-		CERROR("Failed to query IB device: %d\n", rc);
-		return rc;
-	}
-
+	hdev->ibh_mr_size = hdev->ibh_ibdev->attrs.max_mr_size;
 	if (hdev->ibh_mr_size == ~0ULL) {
 		hdev->ibh_mr_shift = 64;
 		return 0;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
