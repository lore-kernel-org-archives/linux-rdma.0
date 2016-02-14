From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/12] IB/qib: Destroy SMI AH before de-allocating the
 protection domain
Date: Sun, 14 Feb 2016 12:11:28 -0800
Message-ID: <20160214201125.1410.41013.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If SMI AH is not destroyed before de-allocating the PD, it would result in
non-zero PD use count when de-allocating the PD, triggering a WARN_ON() at
drivers/infiniband/core/verbs.c:284 ib_dealloc_pd+0x69/0xb0 [ib_core]()
when unloading the qib driver on systems with dual-port card.

This problem has always been there in qib and was detected only after the
commit 7dd78647a2c2 ("IB/core: Make ib_dealloc_pd return void") introduced
a WARN_ON in ib_dealloc_pd() that triggers if a PD's use count is non-zero
before de-allocating the PD.

Below is the call trace from the dmesg log.

[ 7264.966129] Call Trace:
[ 7264.969652]  [<ffffffff81338470>] dump_stack+0x44/0x64
[ 7264.976181]  [<ffffffff81086bb6>] warn_slowpath_common+0x86/0xc0
[ 7264.983656]  [<ffffffff81086cfa>] warn_slowpath_null+0x1a/0x20
[ 7264.990961]  [<ffffffffa025c2d9>] ib_dealloc_pd+0x69/0xb0 [ib_core]
[ 7264.998717]  [<ffffffffa0044de8>] ib_mad_port_close+0xb8/0x120 [ib_mad]
[ 7265.006866]  [<ffffffffa0044ebf>] ib_mad_remove_device+0x6f/0xc0 [ib_mad]
[ 7265.015224]  [<ffffffffa025fc87>] ib_unregister_device+0xa7/0x140 [ib_core]
[ 7265.023738]  [<ffffffffa04b5b79>] rvt_unregister_device+0x29/0x80 [rdmavt]
[ 7265.032181]  [<ffffffffa088d2a2>] qib_unregister_ib_device+0x22/0x210 [ib_qib]
[ 7265.040993]  [<ffffffffa085f73f>] qib_remove_one+0x1f/0x250 [ib_qib]
[ 7265.048823]  [<ffffffff8137a319>] pci_device_remove+0x39/0xc0
[ 7265.055984]  [<ffffffff81466a1a>] __device_release_driver+0x9a/0x140
[ 7265.063821]  [<ffffffff81466bc8>] driver_detach+0xb8/0xc0
[ 7265.070579]  [<ffffffff81465a15>] bus_remove_driver+0x55/0xd0
[ 7265.077717]  [<ffffffff8146732c>] driver_unregister+0x2c/0x50
[ 7265.084849]  [<ffffffff813789ba>] pci_unregister_driver+0x2a/0x80
[ 7265.092366]  [<ffffffffa08921bd>] qib_ib_cleanup+0x37/0x65 [ib_qib]
[ 7265.100068]  [<ffffffff811096d0>] SyS_delete_module+0x190/0x220
[ 7265.107379]  [<ffffffff816a7bae>] entry_SYSCALL_64_fastpath+0x12/0x71

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 --
 drivers/infiniband/hw/qib/qib_mad.c     |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index ca28c19..82d7c4b 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2910,8 +2910,6 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 			spin_unlock_irqrestore(&dd->cspec->gpio_lock, flags);
 			qib_qsfp_deinit(&dd->pport[i].cpspec->qsfp_data);
 		}
-		if (dd->pport[i].ibport_data.smi_ah)
-			ib_destroy_ah(&dd->pport[i].ibport_data.smi_ah->ibah);
 	}
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 73ca2c2..0bd1837 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2496,4 +2496,7 @@ void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 
 	if (dd->pport[port_idx].cong_stats.timer.data)
 		del_timer_sync(&dd->pport[port_idx].cong_stats.timer);
+
+	if (dd->pport[port_idx].ibport_data.smi_ah)
+		ib_destroy_ah(&dd->pport[port_idx].ibport_data.smi_ah->ibah);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
