From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: v3.7: Unloading ib_ipoib triggers circular locking dependency complaint
Date: Mon, 26 Nov 2012 10:00:45 +0200
Message-ID: <CAJZOPZJ55dqpOsnP-jbgXRrLZpyRzD2v8pg7pAAWMtWWr-m1FA@mail.gmail.com>
References: <50AF67C5.7090200@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50AF67C5.7090200-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 23, 2012 at 2:10 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Apparently unloading the ib_ipoib kernel module triggers a circular locking
> dependency complaint. Has anyone already been looking into this ?

Yes, I see that this happens here e.g when doing hot-unplug to the
underlying HW driver, seems related to the ipoib rtnl ops patches I
pushed to 3.7 -- will look into this, thanks for bringing this up.
Does anyone has an idea where the "s_active" lock is defined and what
is its role?

Or.

> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.7.0-rc6-debug+ #1 Not tainted
> -------------------------------------------------------
> rmmod/1414 is trying to acquire lock:
>  (s_active#72){++++.+}, at: [<ffffffff811baadb>]
> sysfs_addrm_finish+0x3b/0x70
>
> but task is already holding lock:
>  (rtnl_mutex){+.+.+.}, at: [<ffffffff813457a7>] rtnl_lock+0x17/0x20
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (rtnl_mutex){+.+.+.}:
>        [<ffffffff8109602a>] lock_acquire+0x8a/0x120
>        [<ffffffff81414cf9>] mutex_lock_nested+0x79/0x360
>        [<ffffffff813457a7>] rtnl_lock+0x17/0x20
>        [<ffffffffa043bb1e>] ipoib_set_mode+0xde/0xf0 [ib_ipoib]
>        [<ffffffffa044253a>] set_mode+0x3a/0x90 [ib_ipoib]
>        [<ffffffff812bcb28>] dev_attr_store+0x18/0x30
>        [<ffffffff811b8de0>] sysfs_write_file+0xe0/0x150
>        [<ffffffff8114b55b>] vfs_write+0xab/0x170
>        [<ffffffff8114b885>] sys_write+0x55/0xa0
>        [<ffffffff81420d42>] system_call_fastpath+0x16/0x1b
>
> -> #0 (s_active#72){++++.+}:
>        [<ffffffff8109595c>] __lock_acquire+0x1b9c/0x1c90
>        [<ffffffff8109602a>] lock_acquire+0x8a/0x120
>        [<ffffffff811b9ef6>] sysfs_deactivate+0x126/0x180
>        [<ffffffff811baadb>] sysfs_addrm_finish+0x3b/0x70
>        [<ffffffff811bb01f>] sysfs_remove_dir+0x9f/0xd0
>        [<ffffffff81209136>] kobject_del+0x16/0x40
>        [<ffffffff812be0dc>] device_del+0x17c/0x1c0
>        [<ffffffff8134de77>] netdev_unregister_kobject+0x67/0x80
>        [<ffffffff813345ba>] rollback_registered_many+0x16a/0x210
>        [<ffffffff81334b71>] rollback_registered+0x31/0x40
>        [<ffffffff81335138>] unregister_netdevice_queue+0x58/0xa0
>        [<ffffffff81335270>] unregister_netdev+0x20/0x30
>        [<ffffffffa0439ad1>] ipoib_remove_one+0xb1/0xf0 [ib_ipoib]
>        [<ffffffffa033c71e>] ib_unregister_client+0x4e/0x100 [ib_core]
>        [<ffffffffa0446a9d>] ipoib_cleanup_module+0x15/0x34 [ib_ipoib]
>        [<ffffffff810a279b>] sys_delete_module+0x14b/0x2b0
>        [<ffffffff81420d42>] system_call_fastpath+0x16/0x1b
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(rtnl_mutex);
>                                lock(s_active#72);
>                                lock(rtnl_mutex);
>   lock(s_active#72);
>
>  *** DEADLOCK ***
>
> 2 locks held by rmmod/1414:
>  #0:  (device_mutex){+.+.+.}, at: [<ffffffffa033c6f7>]
> ib_unregister_client+0x27/0x100 [ib_core]
>  #1:  (rtnl_mutex){+.+.+.}, at: [<ffffffff813457a7>] rtnl_lock+0x17/0x20
>
> stack backtrace:
> Pid: 1414, comm: rmmod Not tainted 3.7.0-rc6-debug+ #1
> Call Trace:
>  [<ffffffff8140ee5c>] print_circular_bug+0x1fb/0x20c
>  [<ffffffff8109595c>] __lock_acquire+0x1b9c/0x1c90
>  [<ffffffff81074c85>] ? sched_clock_local+0x25/0xa0
>  [<ffffffff8109602a>] lock_acquire+0x8a/0x120
>  [<ffffffff811baadb>] ? sysfs_addrm_finish+0x3b/0x70
>  [<ffffffff811b9ef6>] sysfs_deactivate+0x126/0x180
>  [<ffffffff811baadb>] ? sysfs_addrm_finish+0x3b/0x70
>  [<ffffffff81096942>] ? mark_held_locks+0xb2/0x130
>  [<ffffffff811baadb>] sysfs_addrm_finish+0x3b/0x70
>  [<ffffffff811bb01f>] sysfs_remove_dir+0x9f/0xd0
>  [<ffffffff81209136>] kobject_del+0x16/0x40
>  [<ffffffff812be0dc>] device_del+0x17c/0x1c0
>  [<ffffffff8134de77>] netdev_unregister_kobject+0x67/0x80
>  [<ffffffff813345ba>] rollback_registered_many+0x16a/0x210
>  [<ffffffff81334b71>] rollback_registered+0x31/0x40
>  [<ffffffff81335138>] unregister_netdevice_queue+0x58/0xa0
>  [<ffffffff81335270>] unregister_netdev+0x20/0x30
>  [<ffffffffa0439ad1>] ipoib_remove_one+0xb1/0xf0 [ib_ipoib]
>  [<ffffffffa033c71e>] ib_unregister_client+0x4e/0x100 [ib_core]
>  [<ffffffffa0446a9d>] ipoib_cleanup_module+0x15/0x34 [ib_ipoib]
>  [<ffffffff810a279b>] sys_delete_module+0x14b/0x2b0
>  [<ffffffff81212aee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81420d42>] system_call_fastpath+0x16/0x1b
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
