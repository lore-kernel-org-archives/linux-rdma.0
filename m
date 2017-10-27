From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/2] IB/rxe: don't crash, if allocation of crc algorithm failed
Date: Fri, 27 Oct 2017 17:59:23 +0200
Message-ID: <20171027155923.36156-1-tbogendoerfer@suse.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Following crash happens, if crc algorithm couldn't be allocated:

[ 1087.989072] rdma_rxe: loaded
[ 1097.855397] PCLMULQDQ-NI instructions are not detected.
[ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
[ 1097.901248] BUG: unable to handle kernel
[ 1097.901249] NULL pointer dereference
[ 1097.901250]  at 0000000000000046
[...]

Reason is that rxe->tfm is assigned the error return, which will then
be used for crypto_free_shash() in rxe_cleanup. Fix by using a
temporay variable and assigning it rxe->tfm after allocation succeeded.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index ff77f4f66970..d03002b9d84d 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1192,6 +1192,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	int err;
 	int i;
 	struct ib_device *dev = &rxe->ib_dev;
+	struct crypto_shash *tfm;
 
 	strlcpy(dev->name, "rxe%d", IB_DEVICE_NAME_MAX);
 	strlcpy(dev->node_desc, "rxe", sizeof(dev->node_desc));
@@ -1289,12 +1290,13 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->get_hw_stats = rxe_ib_get_hw_stats;
 	dev->alloc_hw_stats = rxe_ib_alloc_hw_stats;
 
-	rxe->tfm = crypto_alloc_shash("crc32", 0, 0);
-	if (IS_ERR(rxe->tfm)) {
+	tfm = crypto_alloc_shash("crc32", 0, 0);
+	if (IS_ERR(tfm)) {
 		pr_err("failed to allocate crc algorithm err:%ld\n",
-		       PTR_ERR(rxe->tfm));
-		return PTR_ERR(rxe->tfm);
+		       PTR_ERR(tfm));
+		return PTR_ERR(tfm);
 	}
+	rxe->tfm = tfm;
 
 	err = ib_register_device(dev, NULL);
 	if (err) {
-- 
2.12.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
