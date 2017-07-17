From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: Protect sysfs entry on ib_unregister_device
Date: Mon, 17 Jul 2017 14:03:50 -0500
Message-ID: <20170717190350.17360-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_unregister_device is not protecting removal of sysfs entries.
A call to ib_register_device in that window can result in
duplicate sysfs entry warning. Move mutex_unlock to after
ib_device_unregister_sysfs to protect against sysfs entry creation.

This issue is exposed during driver load/unload stress test.

WARNING: CPU: 5 PID: 4445 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5f/0x70
sysfs: cannot create duplicate filename '/class/infiniband/i40iw0'
Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H
BIOS F7 01/17/2014
Workqueue: i40e i40e_service_task [i40e]
Call Trace:
dump_stack+0x67/0x98
__warn+0xcc/0xf0
warn_slowpath_fmt+0x4a/0x50
? kernfs_path_from_node+0x4b/0x60
sysfs_warn_dup+0x5f/0x70
sysfs_do_create_link_sd.isra.2+0xb7/0xc0
sysfs_create_link+0x20/0x40
device_add+0x28c/0x600
ib_device_register_sysfs+0x58/0x170 [ib_core]
ib_register_device+0x325/0x570 [ib_core]
? i40iw_register_rdma_device+0x1f4/0x400 [i40iw]
? kmem_cache_alloc_trace+0x143/0x330
? __raw_spin_lock_init+0x2d/0x50
i40iw_register_rdma_device+0x2dc/0x400 [i40iw]
i40iw_open+0x10a6/0x1950 [i40iw]
? i40iw_open+0xeab/0x1950 [i40iw]
? i40iw_make_cm_node+0x9c0/0x9c0 [i40iw]
i40e_client_subtask+0xa4/0x110 [i40e]
i40e_service_task+0xc2d/0x1320 [i40e]
process_one_work+0x203/0x710
? process_one_work+0x16f/0x710
worker_thread+0x126/0x4a0
? trace_hardirqs_on+0xd/0x10
kthread+0x112/0x150
? process_one_work+0x710/0x710
? kthread_create_on_node+0x40/0x40
ret_from_fork+0x2e/0x40
---[ end trace fd11b69e21ea7653 ]---
Couldn't register device i40iw0 with driver model

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sindhu Devale <sindhu.devale-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a5dfab6..221468f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -537,10 +537,11 @@ void ib_unregister_device(struct ib_device *device)
 	}
 	up_read(&lists_rwsem);
 
-	mutex_unlock(&device_mutex);
-
 	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
+
+	mutex_unlock(&device_mutex);
+
 	ib_cache_cleanup_one(device);
 
 	ib_security_destroy_port_pkey_list(device);
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
