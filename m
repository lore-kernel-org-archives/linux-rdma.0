From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/8] RDMA/rxe: Remove useless export symbol
Date: Sun, 24 Dec 2017 15:43:21 +0200
Message-ID: <20171224134328.17398-2-leon@kernel.org>
References: <20171224134328.17398-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134328.17398-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The RXE driver is standalone module and hence doesn't need to export
symbols, move this one liner to be in header file and avoid function
implementation in .c file and extra exported symbol.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 6 ------
 drivers/infiniband/sw/rxe/rxe.h | 6 +++++-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 8c3d30b3092d..b7debb6f2eac 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -77,12 +77,6 @@ void rxe_release(struct kref *kref)
 	ib_dealloc_device(&rxe->ib_dev);
 }
 
-void rxe_dev_put(struct rxe_dev *rxe)
-{
-	kref_put(&rxe->ref_cnt, rxe_release);
-}
-EXPORT_SYMBOL_GPL(rxe_dev_put);
-
 /* initialize rxe device parameters */
 static int rxe_init_device_param(struct rxe_dev *rxe)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index 6447d736d5a4..7d232611303f 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -57,6 +57,7 @@
 #include "rxe_hdr.h"
 #include "rxe_param.h"
 #include "rxe_verbs.h"
+#include "rxe_loc.h"
 
 #define RXE_UVERBS_ABI_VERSION		(1)
 
@@ -95,7 +96,10 @@ void rxe_remove_all(void);
 
 int rxe_rcv(struct sk_buff *skb);
 
-void rxe_dev_put(struct rxe_dev *rxe);
+static inline void rxe_dev_put(struct rxe_dev *rxe)
+{
+	kref_put(&rxe->ref_cnt, rxe_release);
+}
 struct rxe_dev *net_to_rxe(struct net_device *ndev);
 struct rxe_dev *get_rxe_by_name(const char *name);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
