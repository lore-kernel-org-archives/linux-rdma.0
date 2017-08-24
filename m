From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v3 19/24] IB/ipoib: Sync between remove_one to sysfs
 calls that use rtnl_lock
Date: Thu, 24 Aug 2017 16:49:58 -0400
Message-ID: <1503607798.78641.52.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
         <20170817125055.31424-20-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-20-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In order to avoid deadlock between sysfs functions (like
> create/delete
> child) and remove_one (both of them are using the sysfs lock and
> rtnl_lock) the driver will use a state mutex for sync.
> 
> That will fix traces as the following:
> schedule+0x3e/0x90
> kernfs_drain+0x75/0xf0
> ? wait_woken+0x90/0x90
> __kernfs_remove+0x12e/0x1c0
> kernfs_remove+0x25/0x40
> sysfs_remove_dir+0x57/0x90
> kobject_del+0x22/0x60
> device_del+0x195/0x230
>  pm_runtime_set_memalloc_noio+0xac/0xf0
> netdev_unregister_kobject+0x71/0x80
> rollback_registered_many+0x205/0x2f0
> rollback_registered+0x31/0x40
> unregister_netdevice_queue+0x58/0xb0
> unregister_netdev+0x20/0x30
> ipoib_remove_one+0xb7/0x240 [ib_ipoib]
> ib_unregister_device+0xbc/0x1b0 [ib_core]
> ib_unregister_mad_agent+0x29/0x30 [ib_core]
> mlx4_ib_remove+0x67/0x280 [mlx4_ib]
> INFO: task echo:24082 blocked for more than 120 seconds.
> Tainted: G           OE   4.1.12-37.5.1.el6uek.x86_64 #2
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> Call Trace:
> schedule+0x3e/0x90
> schedule_preempt_disabled+0xe/0x10
> __mutex_lock_slowpath+0x95/0x110
> ? _rcu_barrier+0x177/0x220
> mutex_lock+0x23/0x40
> rtnl_lock+0x15/0x20
> netdev_run_todo+0x81/0x1f0
> rtnl_unlock+0xe/0x10
> ipoib_vlan_delete+0x12f/0x1c0 [ib_ipoib]
> delete_child+0x69/0x80 [ib_ipoib]
> dev_attr_store+0x20/0x30
> sysfs_kf_write+0x41/0x50
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  8 +++++++-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  5 +++++
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 22 ++++++++++++++++++---
> -
>  4 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 9e738104c2a1..7aa114cf53e3 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -336,6 +336,7 @@ struct ipoib_dev_priv {
>         unsigned long flags;
>  
>         struct rw_semaphore vlan_rwsem;
> +       struct mutex        sysfs_lock; /* Protect sysfs running*/

I detest calling a mutex a lock and vice versa, so I renamed this
sysfs_mutex, and then took the patch.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
