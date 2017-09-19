From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 10/10] rxe: Use VERBS_NAME_MATCH to match the rxe device
Date: Tue, 19 Sep 2017 15:18:51 -0600
Message-ID: <1505855931-4956-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a placeholder, it obviously cannot work this way once we
add rdma device renaming.

A synthetic modalias is produced that contains the device name,
and the existing modalias framework is used to match it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/rxe/rxe.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index d9857aac70d745..683ffaa2a8af9c 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -57,6 +57,12 @@
 #include "rxe-abi.h"
 #include "rxe.h"
 
+static const struct verbs_match_ent hca_table[] = {
+	/* FIXME: rxe needs a more reliable way to detect the rxe device */
+	VERBS_NAME_MATCH("rxe", NULL),
+	{},
+};
+
 static int rxe_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr)
 {
@@ -893,22 +899,6 @@ static void rxe_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool rxe_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[16];
-
-	/* make sure it is a rxe device */
-	if (ibv_read_sysfs_file(uverbs_sys_path, "ibdev",
-				value, sizeof(value)) < 0)
-		return false;
-
-	if (strncmp(value, "rxe", 3))
-		return false;
-
-	return true;
-}
-
 static struct verbs_device *rxe_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct rxe_device *dev;
@@ -925,7 +915,7 @@ static const struct verbs_device_ops rxe_dev_ops = {
 	.name = "rxe",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
-	.match_device = rxe_device_match,
+	.match_table = hca_table,
 	.alloc_device = rxe_device_alloc,
 	.uninit_device = rxe_uninit_device,
 	.alloc_context = rxe_alloc_context,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
