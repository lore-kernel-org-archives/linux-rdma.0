From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 178581] New: v4.9-rc1: Deadlock while unloading IPoIB
Date: Wed, 19 Oct 2016 20:31:33 +0000
Message-ID: <bug-178581-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=178581

            Bug ID: 178581
           Summary: v4.9-rc1: Deadlock while unloading IPoIB
           Product: Drivers
           Version: 2.5
    Kernel Version: v4.9-rc1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bvanassche-HInyCGIudOg@public.gmane.org
        Regression: No

Created attachment 241991
  --> https://bugzilla.kernel.org/attachment.cgi?id=241991&action=edit
Lockdep output

The output produced by lockdep has been attached. Call trace from that
attachment:

Call Trace:
 [<ffffffff81329695>] dump_stack+0x68/0x93
 [<ffffffff810baafe>] print_circular_bug+0x1be/0x210
 [<ffffffff810bd31c>] __lock_acquire+0x10fc/0x1270
 [<ffffffff810bd8b9>] lock_acquire+0xe9/0x1d0
 [<ffffffff8126275a>] __kernfs_remove+0x24a/0x310
 [<ffffffff812632ae>] kernfs_remove+0x1e/0x30
 [<ffffffff8126559c>] sysfs_remove_dir+0x4c/0x80
 [<ffffffff8132bec8>] kobject_del+0x18/0x50
 [<ffffffff81450fb0>] device_del+0x190/0x240
 [<ffffffff81550a27>] netdev_unregister_kobject+0x57/0x60
 [<ffffffff81527df0>] rollback_registered_many+0x220/0x370
 [<ffffffff81527f6c>] rollback_registered+0x2c/0x40
 [<ffffffff81528e54>] unregister_netdevice_queue+0x44/0x90
 [<ffffffff81528eb7>] unregister_netdev+0x17/0x20
 [<ffffffffa02bdc47>] ipoib_remove_one+0x97/0xe0 [ib_ipoib]
 [<ffffffffa032c539>] ib_unregister_device+0xa9/0x150 [ib_core]
 [<ffffffffa036d7e5>] mlx4_ib_remove+0x65/0x250 [mlx4_ib]
 [<ffffffffa025131e>] mlx4_remove_device+0x6e/0x80 [mlx4_core]
 [<ffffffffa0251738>] mlx4_unregister_device+0x48/0x90 [mlx4_core]
 [<ffffffffa025364d>] mlx4_unload_one+0x7d/0x310 [mlx4_core]
 [<ffffffffa02539cd>] mlx4_shutdown+0x5d/0x70 [mlx4_core]
 [<ffffffff8136c768>] pci_device_shutdown+0x28/0x60
 [<ffffffff81452f70>] device_shutdown+0xd0/0x1d0
 [<ffffffff8108c7e1>] kernel_restart_prepare+0x31/0x40
 [<ffffffff8108c88d>] kernel_restart+0xd/0x50
 [<ffffffff8108cad9>] SYSC_reboot+0xf9/0x1e0
 [<ffffffff8108cc09>] SyS_reboot+0x9/0x10
 [<ffffffff8163ed2a>] entry_SYSCALL_64_fastpath+0x18/0xad

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
