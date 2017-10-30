From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libqedr: fix inline data copy
Date: Mon, 30 Oct 2017 14:59:55 +0200
Message-ID: <1509368395-16738-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Advance target pointer during data copy.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 4a74c50..7db0fb3 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -874,7 +874,7 @@ static void swap_wqe_data64(uint64_t *p)
 	__be64 *bep=(__be64 *)p;
 	int i;
 
-	for (i = 0; i < ROCE_WQE_ELEM_SIZE / sizeof(uint64_t); i++, p++)
+	for (i = 0; i < ROCE_WQE_ELEM_SIZE / sizeof(uint64_t); i++, p++, bep++)
 		*bep = htobe64(*p);
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
