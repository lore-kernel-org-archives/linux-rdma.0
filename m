From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Possible circular locking when unloading device driver
Date: Mon, 12 Oct 2015 11:19:53 +0300
Message-ID: <561B6D29.10001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey,

I stepped on this lockdep circular locking complaint on 4.3-rc when
unloading the device driver (mlx5 in my case). Has anyone seen this?

I have seen such warnings with kernfs_mutex when deleting iscsi
devices on the fly.

I wander if kernfs_remove() should use mutex_lock_nested?

output:
kernel:  (s_active#78){++++.+}, at: [<ffffffff8123d317>] 
kernfs_remove+0x27/0x40
kernel:
         but task is already holding lock:
kernel:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81433847>] rtnl_lock+0x17/0x20
kernel:
         which lock already depends on the new lock.
kernel:
         the existing dependency chain (in reverse order) is:
kernel:
         -> #1 (rtnl_mutex){+.+.+.}:
kernel:        [<ffffffff810bfdbf>] __lock_acquire+0xc1f/0x1090
kernel:        [<ffffffff810c0303>] lock_acquire+0xd3/0x1f0
kernel:        [<ffffffff81515cc0>] mutex_lock_nested+0x60/0x3a0
kernel:        [<ffffffff81433847>] rtnl_lock+0x17/0x20
kernel:        [<ffffffffa04e5646>] ipoib_set_mode+0x96/0xf0 [ib_ipoib]
kernel:        [<ffffffffa04ed8ab>] set_mode+0x3b/0x80 [ib_ipoib]
kernel:        [<ffffffff8139a940>] dev_attr_store+0x20/0x30
kernel:        [<ffffffff8123f6bf>] sysfs_kf_write+0x4f/0x70
kernel:        [<ffffffff8123ebc3>] kernfs_fop_write+0x153/0x180
kernel:        [<ffffffff811c5534>] __vfs_write+0x34/0xf0
kernel:        [<ffffffff811c583a>] vfs_write+0xaa/0x120
kernel:        [<ffffffff811c634d>] SyS_write+0x5d/0xc0
kernel:        [<ffffffff8151a1f2>] entry_SYSCALL_64_fastpath+0x12/0x76
kernel:
         -> #0 (s_active#78){++++.+}:
kernel:        [<ffffffff810bf167>] check_prev_add+0x527/0x560
kernel:        [<ffffffff810bfdbf>] __lock_acquire+0xc1f/0x1090
kernel:        [<ffffffff810c0303>] lock_acquire+0xd3/0x1f0
kernel:        [<ffffffff8123d163>] __kernfs_remove+0x2b3/0x390
kernel:        [<ffffffff8123d317>] kernfs_remove+0x27/0x40
kernel:        [<ffffffff8123faea>] sysfs_remove_dir+0x5a/0x90
kernel:        [<ffffffff8129b992>] kobject_del+0x22/0x60
kernel:        [<ffffffff8139bd62>] device_del+0x192/0x220
kernel:        [<ffffffff8143f251>] netdev_unregister_kobject+0x71/0x80
kernel:        [<ffffffff8141ba51>] rollback_registered_many+0x1e1/0x2c0
kernel:        [<ffffffff8141bbd1>] rollback_registered+0x31/0x40
kernel:        [<ffffffff8141bc38>] unregister_netdevice_queue+0x58/0xb0
kernel:        [<ffffffff8141be00>] unregister_netdev+0x20/0x30
kernel:        [<ffffffffa04e31a1>] ipoib_remove_one+0xa1/0xe0 [ib_ipoib]
kernel:        [<ffffffffa043c591>] ib_unregister_device+0xc1/0x160 
[ib_core]
kernel:        [<ffffffffa04631f9>] mlx5_ib_remove+0x19/0x50 [mlx5_ib]
kernel:        [<ffffffffa0076068>] mlx5_remove_device+0x68/0x80 [mlx5_core]
kernel:        [<ffffffffa00760be>] mlx5_unregister_interface+0x3e/0x70 
[mlx5_core]
kernel:        [<ffffffffa04737fc>] mlx5_ib_cleanup+0x10/0x814 [mlx5_ib]
kernel:        [<ffffffff810f67aa>] SyS_delete_module+0x17a/0x1c0
kernel:        [<ffffffff8151a1f2>] entry_SYSCALL_64_fastpath+0x12/0x76
kernel:
         other info that might help us debug this:
kernel:  Possible unsafe locking scenario:
kernel:        CPU0                    CPU1
kernel:        ----                    ----
kernel:   lock(rtnl_mutex);
kernel:                                lock(s_active#78);
kernel:                                lock(rtnl_mutex);
kernel:   lock(s_active#78);
kernel:
          *** DEADLOCK ***
kernel: 4 locks held by modprobe/1662:
kernel:  #0:  (intf_mutex){+.+.+.}, at: [<ffffffffa007609d>] 
mlx5_unregister_interface+0x1d/0x70 [mlx5_core]
kernel:  #1:  (device_mutex){+.+.+.}, at: [<ffffffffa043c4ff>] 
ib_unregister_device+0x2f/0x160 [ib_core]
kernel:  #2:  (lists_rwsem){+++++.}, at: [<ffffffffa043c513>] 
ib_unregister_device+0x43/0x160 [ib_core]
kernel:  #3:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81433847>] 
rtnl_lock+0x17/0x20
kernel:
         stack backtrace:
kernel: CPU: 3 PID: 1662 Comm: modprobe Tainted: G             L 
4.3.0-rc3-debug+ #67
kernel: Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
kernel:  ffffffff820fb120 ffff88080b62f998 ffffffff8129915b 0000000000000000
kernel:  ffffffff8215fe60 ffff88080b62f9e8 ffffffff810bd7dd ffff880810ee2d00
kernel:  ffff88080b62fa08 ffff880810ee3458 ffff880810ee3430 ffff880810ee3458
kernel: Call Trace:
kernel:  [<ffffffff8129915b>] dump_stack+0x4f/0x74
kernel:  [<ffffffff810bd7dd>] print_circular_bug+0x20d/0x310
kernel:  [<ffffffff810bf167>] check_prev_add+0x527/0x560
kernel:  [<ffffffff810bfdbf>] __lock_acquire+0xc1f/0x1090
kernel:  [<ffffffff810c0303>] lock_acquire+0xd3/0x1f0
kernel:  [<ffffffff8123d317>] ? kernfs_remove+0x27/0x40
kernel:  [<ffffffff810be94d>] ? trace_hardirqs_on+0xd/0x10
kernel:  [<ffffffff8123d163>] __kernfs_remove+0x2b3/0x390
kernel:  [<ffffffff8123d317>] ? kernfs_remove+0x27/0x40
kernel:  [<ffffffff810be94d>] ? trace_hardirqs_on+0xd/0x10
kernel:  [<ffffffff8123d30f>] ? kernfs_remove+0x1f/0x40
kernel:  [<ffffffff8123face>] ? sysfs_remove_dir+0x3e/0x90
kernel:  [<ffffffff81515ad7>] ? __mutex_unlock_slowpath+0xc7/0x190
kernel:  [<ffffffff8123d317>] kernfs_remove+0x27/0x40
kernel:  [<ffffffff8123faea>] sysfs_remove_dir+0x5a/0x90
kernel:  [<ffffffff8129b992>] kobject_del+0x22/0x60
kernel:  [<ffffffff8139bd62>] device_del+0x192/0x220
kernel:  [<ffffffff8143f251>] netdev_unregister_kobject+0x71/0x80
kernel:  [<ffffffff8141ba51>] rollback_registered_many+0x1e1/0x2c0
kernel:  [<ffffffff8141bbd1>] rollback_registered+0x31/0x40
kernel:  [<ffffffff8141bc38>] unregister_netdevice_queue+0x58/0xb0
kernel:  [<ffffffff8141be00>] unregister_netdev+0x20/0x30
kernel:  [<ffffffffa04e31a1>] ipoib_remove_one+0xa1/0xe0 [ib_ipoib]
kernel:  [<ffffffffa043c591>] ib_unregister_device+0xc1/0x160 [ib_core]
kernel:  [<ffffffffa04631f9>] mlx5_ib_remove+0x19/0x50 [mlx5_ib]
kernel:  [<ffffffffa0076068>] mlx5_remove_device+0x68/0x80 [mlx5_core]
kernel:  [<ffffffffa00760be>] mlx5_unregister_interface+0x3e/0x70 
[mlx5_core]
kernel:  [<ffffffffa04737fc>] mlx5_ib_cleanup+0x10/0x814 [mlx5_ib]
kernel:  [<ffffffff810f67aa>] SyS_delete_module+0x17a/0x1c0
kernel:  [<ffffffff81003017>] ? trace_hardirqs_on_thunk+0x17/0x19
kernel:  [<ffffffff811e80b0>] ? generic_show_options+0x180/0x180
kernel:  [<ffffffff8151a1f2>] entry_SYSCALL_64_fastpath+0x12/0x76
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
