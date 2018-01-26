From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/16] IB/hfi1: Fix for early release of sdma
 context
Date: Fri, 26 Jan 2018 06:31:35 -0800
Message-ID: <20180126143132.6868.25921.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

With IRQF_SHARED flag set and CONFIG_DEBUG_SHIRQ enabled
module removal may result in panic in sdma_interrupt() routine
if associated sdma context was released before pci_free_irq();

[ 9198.939885] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 9198.940514] IP: sdma_make_progress+0xa5/0x450 [hfi1]
[ 9198.941114] PGD 170bdc0067 P4D 170bdc0067 PUD 172063e067 PMD 0
[ 9198.941783] Oops: 0000 [#1] SMP
.....
[ 9198.958877] CPU: 132 PID: 64173 Comm: rmmod Tainted: G           OE   4.14.0-rc4+ #1
[ 9198.961032] Hardware name: Intel Corporation S7200AP/S7200AP, BIOS S72C610.86B.01.02.0118.080620171935 08/06/2017
[ 9198.963323] task: ffff9681397f0000 task.stack: ffffae1647c40000
[ 9198.965695] RIP: 0010:sdma_make_progress+0xa5/0x450 [hfi1]
[ 9198.968082] RSP: 0018:ffffae1647c43be8 EFLAGS: 00010046
[ 9198.970503] RAX: 0000000000000000 RBX: ffff9680ce8b5ca8 RCX: 0000000000000000
[ 9198.973006] RDX: 0000000000000000 RSI: 0000000001a00d28 RDI: ffff9680ce8b5ca0
[ 9198.975546] RBP: ffffae1647c43c40 R08: ffff96814325ec00 R09: 00000000ffffffff
[ 9198.978142] R10: 000000004325e501 R11: ffff96814325ec00 R12: ffff9680ce8b5c44
[ 9198.980779] R13: ffff9680ce8b5ca0 R14: 0000000000000000 R15: ffff9680ce8b5b00
[ 9198.983462] FS:  00007f31196ba740(0000) GS:ffff96819df00000(0000) knlGS:0000000000000000
[ 9198.986231] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9198.989036] CR2: 0000000000000000 CR3: 000000170833f000 CR4: 00000000001406e0
[ 9198.991911] Call Trace:
[ 9198.994847]  sdma_engine_interrupt+0x82/0x100 [hfi1]
[ 9198.997852]  sdma_interrupt+0x61/0xc0 [hfi1]
[ 9199.000852]  __free_irq+0x1b3/0x2d0
[ 9199.003873]  free_irq+0x35/0x70
[ 9199.006909]  pci_free_irq+0x1c/0x30
[ 9199.009999]  clean_up_interrupts+0x53/0xf0 [hfi1]
[ 9199.013137]  hfi1_start_cleanup+0x117/0x190 [hfi1]
[ 9199.016315]  postinit_cleanup+0x1d/0x270 [hfi1]
[ 9199.019529]  remove_one+0x1f3/0x210 [hfi1]
[ 9199.022738]  pci_device_remove+0x39/0xc0
[ 9199.025974]  device_release_driver_internal+0x141/0x210
[ 9199.029268]  driver_detach+0x3f/0x80
[ 9199.032580]  bus_remove_driver+0x55/0xd0
[ 9199.035931]  driver_unregister+0x2c/0x50
[ 9199.039321]  pci_unregister_driver+0x2a/0xa0
[ 9199.042755]  hfi1_mod_cleanup+0x10/0xb50 [hfi1]
[ 9199.046196]  SyS_delete_module+0x171/0x250
...

Fix by exporting sdma_clean() and removing from sdma_exit().
sdma_exit() now just manipulates the engine state,
leaving the memory free to sdma_clean() which is now called
just before the dd is freed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |    1 +
 drivers/infiniband/hw/hfi1/sdma.c |   13 +++++++------
 drivers/infiniband/hw/hfi1/sdma.h |    1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 9b12826..a618eef 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1218,6 +1218,7 @@ static void __hfi1_free_devdata(struct kobject *kobj)
 	free_percpu(dd->rcv_limit);
 	free_percpu(dd->send_schedule);
 	free_percpu(dd->tx_opstats);
+	sdma_clean(dd, dd->num_sdma);
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 31c8f89..37424a8 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1276,13 +1276,15 @@ int sdma_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_engines)
 	return -ENOMEM;
 }
 
-/*
- * Clean up allocated memory.
- *
- * This routine is can be called regardless of the success of sdma_init()
+/**
+ * sdma_clean()  Clean up allocated memory
+ * @dd:          struct hfi1_devdata
+ * @num_engines: num sdma engines
  *
+ * This routine can be called regardless of the success of
+ * sdma_init()
  */
-static void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
+void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
 {
 	size_t i;
 	struct sdma_engine *sde;
@@ -1618,7 +1620,6 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 */
 		sdma_finalput(&sde->state);
 	}
-	sdma_clean(dd, dd->num_sdma);
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 374c597..46c775f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -420,6 +420,7 @@ struct sdma_engine {
 int sdma_init(struct hfi1_devdata *dd, u8 port);
 void sdma_start(struct hfi1_devdata *dd);
 void sdma_exit(struct hfi1_devdata *dd);
+void sdma_clean(struct hfi1_devdata *dd, size_t num_engines);
 void sdma_all_running(struct hfi1_devdata *dd);
 void sdma_all_idle(struct hfi1_devdata *dd);
 void sdma_freeze_notify(struct hfi1_devdata *dd, int go_idle);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
