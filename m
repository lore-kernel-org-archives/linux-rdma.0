From: Sergei Shtylyov <sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>
Subject: [PATCH 1/2] ipath: use pci_dev->revision, again
Date: Sat, 7 May 2011 21:39:37 +0400
Message-ID: <201105072139.37992.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers to use
pci_device->revision) already converted this driver to using the 'revision'
field of 'struct pci_dev' but commit bb9171448deb1f7ece27674e2e431e4f267fd453
(IB/ipath: Misc changes to prepare for IB7220 introduction) later reverted that
change for some strange reason. Now restore the change...

Signed-off-by: Sergei Shtylyov <sshtylyov-hkdhdckH98+B+jHODAdFcQ@public.gmane.org>

---
The patch is against the recent Linus' tree.

 drivers/infiniband/hw/ipath/ipath_driver.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_driver.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_driver.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -398,7 +398,6 @@ static int __devinit ipath_init_one(stru
 	struct ipath_devdata *dd;
 	unsigned long long addr;
 	u32 bar0 = 0, bar1 = 0;
-	u8 rev;
 
 	dd = ipath_alloc_devdata(pdev);
 	if (IS_ERR(dd)) {
@@ -540,13 +539,7 @@ static int __devinit ipath_init_one(stru
 		goto bail_regions;
 	}
 
-	ret = pci_read_config_byte(pdev, PCI_REVISION_ID, &rev);
-	if (ret) {
-		ipath_dev_err(dd, "Failed to read PCI revision ID unit "
-			      "%u: err %d\n", dd->ipath_unit, -ret);
-		goto bail_regions;	/* shouldn't ever happen */
-	}
-	dd->ipath_pcirev = rev;
+	dd->ipath_pcirev = pdev->revision;
 
 #if defined(__powerpc__)
 	/* There isn't a generic way to specify writethrough mappings */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
