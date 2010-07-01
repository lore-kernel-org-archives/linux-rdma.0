From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: if qib_init() fails, driver fails to clean up properly
Date: Thu, 01 Jul 2010 13:25:45 -0700
Message-ID: <20100701202544.17064.62649.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If qib_init() fails, the driver fails to free memory, unregister device
files, and unregister with the PCIe framework. The driver will unload
without error but a subsequent driver load will cause the system to panic.
This was found by changing the 7220 code to load the serdes microcode
separately and not installing the microcode file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_init.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 7831ff8..a873dd5 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1289,8 +1289,18 @@ static int __devinit qib_init_one(struct pci_dev *pdev,
 
 	if (qib_mini_init || initfail || ret) {
 		qib_stop_timers(dd);
+		flush_scheduled_work();
 		for (pidx = 0; pidx < dd->num_pports; ++pidx)
 			dd->f_quiet_serdes(dd->pport + pidx);
+		if (qib_mini_init)
+			goto bail;
+		if (!j) {
+			(void) qibfs_remove(dd);
+			qib_device_remove(dd);
+		}
+		if (!ret)
+			qib_unregister_ib_device(dd);
+		qib_postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
 		goto bail;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
