From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bug 176901] New: Running ib_rdma_bw over rxe loopback triggers a
 kernel oops
Date: Fri, 7 Oct 2016 08:58:08 +0530
Message-ID: <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA@mail.gmail.com>
References: <bug-176901-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bug-176901-11804-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This bug is fixed with my patch [1] and Doug ack also about merging fix.

[1] https://patchwork.kernel.org/patch/9354863/

On Fri, Oct 7, 2016 at 4:53 AM,  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=176901
>
>             Bug ID: 176901
>            Summary: Running ib_rdma_bw over rxe loopback triggers a kernel
>                     oops
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: v4.8.0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Infiniband/RDMA
>           Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
>           Reporter: bvanassche-HInyCGIudOg@public.gmane.org
>         Regression: No
>
> After I ran the following commands in a virtual machine:
>
> modprobe rdma_rxe
> rxe_cfg add eth0
> modprobe ib_uverbs
> ib_send_bw &
> ib_send_bw 192.168.123.238
>
> the following output appeared on the system console:
>
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81023060>] check_addr+0x30/0x60
> PGD 39751067 PUD 30689067 PMD 0
> Oops: 0000 [#1] SMP
> Modules linked in: ib_uverbs ib_srp(O) scsi_transport_srp(O) scst_local(O)
> iscsi_scst(O) ib_srpt(O) scst_vdisk(O) scst(O) libcrc32c dlm configfs rdma_rxe
> ip6_udp_tunnel udp_tunnel crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd
> virtio_console virtio_balloon serio_raw virtio_rng i2c_piix4 acpi_cpufreq
> button iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext4 jbd2 mbcache
> virtio_net virtio_blk psmouse drm_kms_helper syscopyarea sysfillrect sysimgblt
> fb_sys_fops ttm virtio_pci drm floppy [last unloaded: scsi_transport_srp]
> CPU: 3 PID: 2941 Comm: ib_send_bw Tainted: G           O    4.8.0-debug+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
> task: ffff8800388fa7c0 task.stack: ffff88002cdd8000
> RIP: 0010:[<ffffffff81023060>]  [<ffffffff81023060>] check_addr+0x30/0x60
> RSP: 0018:ffff88002cddbb78  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000087654321 RCX: 0000000000001000
> RDX: 00000000042a1000 RSI: ffff88003294cac8 RDI: ffffffff819b7189
> RBP: ffff88002cddbba8 R08: 0000000000000000 R09: ffff88003294cac8
> R10: 0000000000000001 R11: 0000000000000020 R12: 0000000000000000
> R13: 0000000000000020 R14: ffff88003294cac8 R15: ffff8800393e6fc8
> FS:  00007fea71eaf740(0000) GS:ffff88003fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000003bc65000 CR4: 00000000001406e0
> Stack:
>  ffffffff81023188 ffff880039a34050 ffff88003941f188 ffff880033b2f000
>  ffffffff81c222a0 0000000000000000 ffff88002cddbc20 ffffffff814f5fca
>  ffff88003294cac8 ffff8800393e6fc8 ffff880000000020 0000000000000020
> Call Trace:
>  [<ffffffff81023188>] ? nommu_map_sg+0x88/0xf0
>  [<ffffffff814f5fca>] ib_umem_get+0x4ea/0x520
>  [<ffffffffa02418e1>] rxe_mem_init_user+0x41/0x2d0 [rdma_rxe]
>  [<ffffffff810acabd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffffa023eb2c>] rxe_reg_user_mr+0x9c/0x150 [rdma_rxe]
>  [<ffffffffa03463b6>] ib_uverbs_reg_mr+0x146/0x330 [ib_uverbs]
>  [<ffffffffa03414fd>] ib_uverbs_write+0x1fd/0x460 [ib_uverbs]
>  [<ffffffffa03413b0>] ? ib_uverbs_write+0xb0/0x460 [ib_uverbs]
>  [<ffffffff81647f42>] ? _raw_spin_unlock+0x22/0x30
>  [<ffffffff8115630a>] ? handle_mm_fault+0x61a/0x12e0
>  [<ffffffff811ab823>] __vfs_write+0x23/0x120
>  [<ffffffff811ac6f9>] ? rw_verify_area+0x49/0xb0
>  [<ffffffff811ac943>] vfs_write+0xb3/0x1b0
>  [<ffffffff810aca28>] ? trace_hardirqs_on_caller+0x128/0x1b0
>  [<ffffffff811adc54>] SyS_write+0x44/0xa0
>  [<ffffffff816486c0>] entry_SYSCALL_64_fastpath+0x23/0xc1
> Code: 48 8b 86 38 03 00 00 48 85 c0 74 1f 4c 8b 00 48 8d 74 0a ff b8 01 00 00
> 00 4c 39 c6 76 33 b8 fe ff ff ff 49 39 c0 77 13 31 c0 c3 <4c> 8b 04 25 00 00 00
> 00 eb e9 b8 01 00 00 00 c3 55 48 89 fe 48
> RIP  [<ffffffff81023060>] check_addr+0x30/0x60
>  RSP <ffff88002cddbb78>
> CR2: 0000000000000000
>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
