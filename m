From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] IB/ipath: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.304.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: infinipath@qlogic.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c 2011-11-13 11:07:26.560156736 +0100
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c 2011-11-28 19:51:35.998484248 +0100
@@ -264,7 +264,7 @@ static int init_chip_first(struct ipath_
 	 * Allocate full portcnt array, rather than just cfgports, because
 	 * cleanup iterates across all possible ports.
 	 */
-	dd->ipath_pd = kzalloc(sizeof(*dd->ipath_pd) * dd->ipath_portcnt,
+	dd->ipath_pd = kcalloc(dd->ipath_portcnt, sizeof(*dd->ipath_pd),
 			       GFP_KERNEL);
 
 	if (!dd->ipath_pd) {
diff -u -p a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c 2011-11-13 11:07:26.580157050 +0100
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c 2011-11-28 19:51:33.611773039 +0100
@@ -2037,7 +2037,7 @@ int ipath_register_ib_device(struct ipat
 	 * the LKEY).  The remaining bits act as a generation number or tag.
 	 */
 	idev->lk_table.max = 1 << ib_ipath_lkey_table_size;
-	idev->lk_table.table = kzalloc(idev->lk_table.max *
+	idev->lk_table.table = kcalloc(idev->lk_table.max,
 				       sizeof(*idev->lk_table.table),
 				       GFP_KERNEL);
 	if (idev->lk_table.table == NULL) {
