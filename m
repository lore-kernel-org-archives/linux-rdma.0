From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: v3.14-rc3: Shutdown triggers poison overwritten complaint
Date: Mon, 17 Feb 2014 14:06:01 +0100
Message-ID: <53020939.70102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

While testing kernel 3.14-rc3 I noticed the call stack below. Had anyone
else perhaps already noticed this ? The test I ran was to change the
mlx4 port type a few times while the ib_ipoib kernel module was loaded.

Thanks,

Bart.

=============================================================================
BUG kmalloc-1024 (Tainted: G    B D     ): Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff880817841ab0-0xffff880817841ab0. First byte 0x6a instead of 0x6b
INFO: Allocated in ib_umad_add_one+0x6e/0x4f0 [ib_umad] age=43184 cpu=0 pid=3820
	__slab_alloc+0x448/0x4fa
	__kmalloc+0x1f7/0x2b0
	ib_umad_add_one+0x6e/0x4f0 [ib_umad]
	ib_register_device+0x424/0x4e0 [ib_core]
	mlx4_ib_add+0x8b4/0x10c0 [mlx4_ib]
	mlx4_add_device+0x3d/0x90 [mlx4_core]
	mlx4_register_device+0x5b/0x90 [mlx4_core]
	mlx4_change_port_types+0x119/0x160 [mlx4_core]
	set_port_type+0x1cc/0x270 [mlx4_core]
	dev_attr_store+0x18/0x30
	sysfs_kf_write+0x44/0x60
	kernfs_fop_write+0xd5/0x150
	vfs_write+0xba/0x1e0
	SyS_write+0x49/0xa0
	tracesys+0xd0/0xd5
INFO: Freed in ib_umad_close+0x130/0x140 [ib_umad] age=0 cpu=5 pid=5141
	__slab_free+0x3c/0x29e
	kfree+0x250/0x290
	ib_umad_close+0x130/0x140 [ib_umad]
	__fput+0xea/0x230
	____fput+0xe/0x10
	task_work_run+0xac/0xe0
	do_notify_resume+0x9f/0xc0
	int_signal+0x12/0x17
INFO: Slab 0xffffea00205e1000 objects=24 used=24 fp=0x          (null) flags=0x2000000000004080
INFO: Object 0xffff880817841a68 @offset=6760 fp=0xffff8808178469a0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
