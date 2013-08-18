From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/22] ucm: ib_ucm_event(): returns ENOSPC instead of ENOMEM
Date: Sun, 18 Aug 2013 20:28:41 +0200
Message-ID: <d79df5b0063f1e2e9d448b3d712bbc050cf7ebc1.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When output buffer is too small, others infiniband functions returns
ENOSPC.
This patch changes ib_ucm_event() to returns ENOSPC just like others
functions.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..e462208 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -432,7 +432,7 @@ static ssize_t ib_ucm_event(struct ib_ucm_file *file,
 
 	if (uevent->data) {
 		if (cmd.data_len < uevent->data_len) {
-			result = -ENOMEM;
+			result = -ENOSPC;
 			goto done;
 		}
 		if (copy_to_user((void __user *)(unsigned long)cmd.data,
@@ -444,7 +444,7 @@ static ssize_t ib_ucm_event(struct ib_ucm_file *file,
 
 	if (uevent->info) {
 		if (cmd.info_len < uevent->info_len) {
-			result = -ENOMEM;
+			result = -ENOSPC;
 			goto done;
 		}
 		if (copy_to_user((void __user *)(unsigned long)cmd.info,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
