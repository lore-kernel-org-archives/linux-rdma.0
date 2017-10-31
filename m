From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Subject: [PATCH v2] IB/rxe: don't crash, if allocation of crc algorithm failed
Date: Tue, 31 Oct 2017 11:16:46 +0100
Message-ID: <20171031101647.45111-1-tbogendoerfer@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
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
temporary variable and assigning it rxe->tfm after allocation succeeded.

Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
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
