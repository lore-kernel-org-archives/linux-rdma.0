From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] rdma: amso1100: c2_provider: Use netdev_dbg()
Date: Sat, 6 Feb 2016 20:41:14 +0530
Message-ID: <20160206151114.GA18959@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, gregkh@linuxfoundation.org, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-rdma@vger.kernel.org

Replace generic pr_debug() with netdev_dbg() for net devices.

Found using Coccinelle. The semantic patch used to find this is as
follows:

//<smpl>
@@
expression e;
identifier f,i;
position p;
@@

f(...,struct net_device *i,...) {
  ...
-  pr_debug@p(e);
+  netdev_dbg(i, e);
  ...
}
//</smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/staging/rdma/amso1100/c2_provider.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/staging/rdma/amso1100/c2_provider.c
index e44ad22..75a7de5 100644
--- a/drivers/staging/rdma/amso1100/c2_provider.c
+++ b/drivers/staging/rdma/amso1100/c2_provider.c
@@ -659,7 +659,7 @@ static int c2_pseudo_up(struct net_device *netdev)
 	if (!ind)
 		return 0;
 
-	pr_debug("adding...\n");
+	netdev_dbg(netdev, "adding...\n");
 	for_ifa(ind) {
 #ifdef DEBUG
 		u8 *ip = (u8 *) & ifa->ifa_address;
@@ -684,7 +684,7 @@ static int c2_pseudo_down(struct net_device *netdev)
 	if (!ind)
 		return 0;
 
-	pr_debug("deleting...\n");
+	netdev_dbg(netdev, "deleting...\n");
 	for_ifa(ind) {
 #ifdef DEBUG
 		u8 *ip = (u8 *) & ifa->ifa_address;
-- 
1.9.1
