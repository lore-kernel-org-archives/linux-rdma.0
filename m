From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 2/2] qib: use pci_dev->revision
Date: Mon, 9 May 2011 12:39:56 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A4888838BCBDB9@AVEXMB1.qlogic.org>
References: <201105072141.56328.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201105072141.56328.sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Shtylyov <sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The driver reads PCI revision ID from the PCI configuration register while it's
> already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Thanks for the patch.

qib: use pci_dev->revision

Acked-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sergei Shtylyov
Sent: Saturday, May 07, 2011 1:42 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-kernel
Subject: [PATCH 2/2] qib: use pci_dev->revision

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
-               u8 rev;
-
                /* 5000 P/V/X/Z */
-               pci_read_config_byte(parent, PCI_REVISION_ID, &rev);
-               if (rev <= 0xb2)
+               if (parent->revision <= 0xb2)
                        bits = 1U << 10;
                else
                        bits = 7U << 10;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
