From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Protect sysfs entry on ib_unregister_device
Date: Wed, 16 Aug 2017 11:48:42 -0400
Message-ID: <1502898522.33760.14.camel@redhat.com>
References: <20170717190350.17360-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170717190350.17360-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-17 at 14:03 -0500, Shiraz Saleem wrote:
> ib_unregister_device is not protecting removal of sysfs entries.
> A call to ib_register_device in that window can result in
> duplicate sysfs entry warning. Move mutex_unlock to after
> ib_device_unregister_sysfs to protect against sysfs entry creation.
> 
> This issue is exposed during driver load/unload stress test.
> 
> WARNING: CPU: 5 PID: 4445 at fs/sysfs/dir.c:31
> sysfs_warn_dup+0x5f/0x70
> sysfs: cannot create duplicate filename '/class/infiniband/i40iw0'
> Hardware name: Gigabyte Technology Co., Ltd. To be filled by
> O.E.M./Q87M-D2H
> BIOS F7 01/17/2014
> Workqueue: i40e i40e_service_task [i40e]
> Call Trace:
> dump_stack+0x67/0x98
> __warn+0xcc/0xf0
> warn_slowpath_fmt+0x4a/0x50
> ? kernfs_path_from_node+0x4b/0x60
> sysfs_warn_dup+0x5f/0x70
> sysfs_do_create_link_sd.isra.2+0xb7/0xc0
> sysfs_create_link+0x20/0x40
> device_add+0x28c/0x600
> ib_device_register_sysfs+0x58/0x170 [ib_core]
> ib_register_device+0x325/0x570 [ib_core]
> ? i40iw_register_rdma_device+0x1f4/0x400 [i40iw]
> ? kmem_cache_alloc_trace+0x143/0x330
> ? __raw_spin_lock_init+0x2d/0x50
> i40iw_register_rdma_device+0x2dc/0x400 [i40iw]
> i40iw_open+0x10a6/0x1950 [i40iw]
> ? i40iw_open+0xeab/0x1950 [i40iw]
> ? i40iw_make_cm_node+0x9c0/0x9c0 [i40iw]
> i40e_client_subtask+0xa4/0x110 [i40e]
> i40e_service_task+0xc2d/0x1320 [i40e]
> process_one_work+0x203/0x710
> ? process_one_work+0x16f/0x710
> worker_thread+0x126/0x4a0
> ? trace_hardirqs_on+0xd/0x10
> kthread+0x112/0x150
> ? process_one_work+0x710/0x710
> ? kthread_create_on_node+0x40/0x40
> ret_from_fork+0x2e/0x40
> ---[ end trace fd11b69e21ea7653 ]---
> Couldn't register device i40iw0 with driver model
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sindhu Devale <sindhu.devale-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This got missed for my previous pull request, sorry about that. 
Applied for this one.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
