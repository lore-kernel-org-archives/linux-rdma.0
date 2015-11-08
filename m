From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 2/4] staging: rdma: use kmalloc_array instead of kmalloc
Date: Sun,  8 Nov 2015 22:17:52 +0800
Message-ID: <9c21d2635419867a29994568c2dfda0b72cce63d.1446991712.git.geliangtang@163.com>
References: <6ada2cca5a646c6bea9a900a48109d10cdc45e85.1446991712.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <6ada2cca5a646c6bea9a900a48109d10cdc45e85.1446991712.git.geliangtang@163.com>
In-Reply-To: <6ada2cca5a646c6bea9a900a48109d10cdc45e85.1446991712.git.geliangtang@163.com>
References: <6ada2cca5a646c6bea9a900a48109d10cdc45e85.1446991712.git.geliangtang@163.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Marciniszyn <infinipath@intel.com>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use kmalloc_array instead of kmalloc to allocate memory for an array.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/amso1100/c2.c          | 6 ++++--
 drivers/staging/rdma/ipath/ipath_file_ops.c | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2.c b/drivers/staging/rdma/amso1100/c2.c
index 35ac536..4e6d24a 100644
--- a/drivers/staging/rdma/amso1100/c2.c
+++ b/drivers/staging/rdma/amso1100/c2.c
@@ -116,7 +116,8 @@ static int c2_tx_ring_alloc(struct c2_ring *tx_ring, void *vaddr,
 	struct c2_element *elem;
 	int i;
 
-	tx_ring->start = kmalloc(sizeof(*elem) * tx_ring->count, GFP_KERNEL);
+	tx_ring->start = kmalloc_array(tx_ring->count, sizeof(*elem),
+				       GFP_KERNEL);
 	if (!tx_ring->start)
 		return -ENOMEM;
 
@@ -165,7 +166,8 @@ static int c2_rx_ring_alloc(struct c2_ring *rx_ring, void *vaddr,
 	struct c2_element *elem;
 	int i;
 
-	rx_ring->start = kmalloc(sizeof(*elem) * rx_ring->count, GFP_KERNEL);
+	rx_ring->start = kmalloc_array(rx_ring->count, sizeof(*elem),
+				       GFP_KERNEL);
 	if (!rx_ring->start)
 		return -ENOMEM;
 
diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/staging/rdma/ipath/ipath_file_ops.c
index 13c3cd1..6187b84 100644
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c
+++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -917,15 +917,15 @@ static int ipath_create_user_egr(struct ipath_portdata *pd)
 	chunk = pd->port_rcvegrbuf_chunks;
 	egrperchunk = pd->port_rcvegrbufs_perchunk;
 	size = pd->port_rcvegrbuf_size;
-	pd->port_rcvegrbuf = kmalloc(chunk * sizeof(pd->port_rcvegrbuf[0]),
-				     GFP_KERNEL);
+	pd->port_rcvegrbuf = kmalloc_array(chunk, sizeof(pd->port_rcvegrbuf[0]),
+					   GFP_KERNEL);
 	if (!pd->port_rcvegrbuf) {
 		ret = -ENOMEM;
 		goto bail;
 	}
 	pd->port_rcvegrbuf_phys =
-		kmalloc(chunk * sizeof(pd->port_rcvegrbuf_phys[0]),
-			GFP_KERNEL);
+		kmalloc_array(chunk, sizeof(pd->port_rcvegrbuf_phys[0]),
+			      GFP_KERNEL);
 	if (!pd->port_rcvegrbuf_phys) {
 		ret = -ENOMEM;
 		goto bail_rcvegrbuf;
-- 
2.5.0
