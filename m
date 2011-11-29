From: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Subject: [PATCH] IB/qib: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.306.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
---

diff -u -p a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
--- a/drivers/infiniband/hw/qib/qib_init.c 2011-11-13 11:07:26.730159415 +0100
+++ b/drivers/infiniband/hw/qib/qib_init.c 2011-11-28 19:51:23.644920442 +0100
@@ -116,7 +116,7 @@ int qib_create_ctxts(struct qib_devdata
 	 * Allocate full ctxtcnt array, rather than just cfgctxts, because
 	 * cleanup iterates across all possible ctxts.
 	 */
-	dd->rcd = kzalloc(sizeof(*dd->rcd) * dd->ctxtcnt, GFP_KERNEL);
+	dd->rcd = kcalloc(dd->ctxtcnt, sizeof(*dd->rcd), GFP_KERNEL);
 	if (!dd->rcd) {
 		qib_dev_err(dd, "Unable to allocate ctxtdata array, "
 			    "failing\n");
@@ -1435,9 +1435,8 @@ int qib_setup_eagerbufs(struct qib_ctxtd
 	egrperchunk = rcd->rcvegrbufs_perchunk;
 	size = rcd->rcvegrbuf_size;
 	if (!rcd->rcvegrbuf) {
-		rcd->rcvegrbuf =
-			kzalloc(chunk * sizeof(rcd->rcvegrbuf[0]),
-				GFP_KERNEL);
+		rcd->rcvegrbuf = kcalloc(chunk, sizeof(rcd->rcvegrbuf[0]),
+					 GFP_KERNEL);
 		if (!rcd->rcvegrbuf)
 			goto bail;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
