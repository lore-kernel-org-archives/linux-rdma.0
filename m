From: Sergei Shtylyov <sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>
Subject: [PATCH 2/2] qib: use pci_dev->revision
Date: Sat, 7 May 2011 21:41:56 +0400
Message-ID: <201105072141.56328.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The driver reads PCI revision ID from the PCI configuration register while it's
already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>

---
The patch is against the recent Linus' tree.

 drivers/infiniband/hw/qib/qib_pcie.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_pcie.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
@@ -526,11 +526,8 @@ static int qib_tune_pcie_coalesce(struct
 	 */
 	devid = parent->device;
 	if (devid >= 0x25e2 && devid <= 0x25fa) {
-		u8 rev;
-
 		/* 5000 P/V/X/Z */
-		pci_read_config_byte(parent, PCI_REVISION_ID, &rev);
-		if (rev <= 0xb2)
+		if (parent->revision <= 0xb2)
 			bits = 1U << 10;
 		else
 			bits = 7U << 10;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
