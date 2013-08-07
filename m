From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: [PATCH] IB/qib: make qib_driver static
Date: Wed, 07 Aug 2013 20:47:38 +0200
Message-ID: <1375901258.7303.64.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

struct pci_driver qib_driver is only used in qib_init.c. Remove it from
qib.h and make it static for qib_init.c.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
---
Compile tested only.

 drivers/infiniband/hw/qib/qib.h      | 1 -
 drivers/infiniband/hw/qib/qib_init.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 4a9af79..1dd4b7c 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -89,7 +89,6 @@ struct qlogic_ib_stats {
 
 extern struct qlogic_ib_stats qib_stats;
 extern const struct pci_error_handlers qib_pci_err_handler;
-extern struct pci_driver qib_driver;
 
 #define QIB_CHIP_SWVERSION QIB_CHIP_VERS_MAJ
 /*
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 36e048e..24e802f 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1193,7 +1193,7 @@ static DEFINE_PCI_DEVICE_TABLE(qib_pci_tbl) = {
 
 MODULE_DEVICE_TABLE(pci, qib_pci_tbl);
 
-struct pci_driver qib_driver = {
+static struct pci_driver qib_driver = {
 	.name = QIB_DRV_NAME,
 	.probe = qib_init_one,
 	.remove = qib_remove_one,
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
