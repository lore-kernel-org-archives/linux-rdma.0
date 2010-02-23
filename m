From: Roman Kononov <roman-63PA5aZBFHTyn80wtf4cgA@public.gmane.org>
Subject: Re: Oops in iscsi_conn_failure()
Date: Tue, 23 Feb 2010 13:42:59 -0600
Message-ID: <hm1b44$fa4$1@dough.gmane.org>
References: <hm15jb$or7$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <hm15jb$or7$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The same with 2.6.32.9

Feb 23 13:40:02 10.10.10.101 kernel: BUG: unable to handle kernel paging request at 00000000621ae010
Feb 23 13:40:02 10.10.10.101 kernel: IP: [<ffffffffa004110e>] iscsi_conn_failure+0x1e/0xc0 [libiscsi]
Feb 23 13:40:02 10.10.10.101 kernel: PGD 0
Feb 23 13:40:02 10.10.10.101 kernel: Oops: 0000 [#1] SMP
Feb 23 13:40:02 10.10.10.101 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0e.0/0000:03:00.0/host9/session6/iscsi_session/session6/ifacename
Feb 23 13:40:02 10.10.10.101 kernel: CPU 0
Feb 23 13:40:02 10.10.10.101 kernel: Modules linked in: ib_iser libiscsi scsi_transport_iscsi ib_mthca sata_nv
Feb 23 13:40:02 10.10.10.101 kernel: Pid: 458, comm: ib_cm/0 Not tainted 2.6.32.9.xdi #1
Feb 23 13:40:02 10.10.10.101 kernel: RIP: 0010:[<ffffffffa004110e>]  [<ffffffffa004110e>] iscsi_conn_failure+0x1e/0xc0 [libiscsi]
Feb 23 13:40:02 10.10.10.101 kernel: RSP: 0018:ffff88013e685d10  EFLAGS: 00010282
Feb 23 13:40:02 10.10.10.101 kernel: RAX: ffff880077b43368 RBX: 00000000621ae000 RCX: 0000000000000000
Feb 23 13:40:02 10.10.10.101 kernel: RDX: 000000000000000a RSI: 00000000000003f3 RDI: 00000000621ae000
Feb 23 13:40:02 10.10.10.101 kernel: RBP: ffff88007a26f400 R08: 0000000000000000 R09: 0000000000000000
Feb 23 13:40:02 10.10.10.101 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000003f3
Feb 23 13:40:02 10.10.10.101 kernel: R13: ffff88013e685fd8 R14: ffff88013e685e80 R15: ffff880028217498
Feb 23 13:40:02 10.10.10.101 kernel: FS:  00007ff4d4e306e0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Feb 23 13:40:02 10.10.10.101 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 23 13:40:02 10.10.10.101 kernel: CR2: 00000000621ae010 CR3: 000000013e465000 CR4: 00000000000006f0
Feb 23 13:40:02 10.10.10.101 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 23 13:40:02 10.10.10.101 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 23 13:40:02 10.10.10.101 kernel: Process ib_cm/0 (pid: 458, threadinfo ffff88013e684000, task ffff88013e6238e0)
Feb 23 13:40:02 10.10.10.101 kernel: Stack:
Feb 23 13:40:02 10.10.10.101 kernel:  ffff880077b4a338 ffff880077b4a338 ffff88007a26f400 ffff88013e469f78
Feb 23 13:40:02 10.10.10.101 kernel: <0> ffff88013e685fd8 ffffffffa004ff10 ffff880028210d80 ffffffff81033f26
Feb 23 13:40:02 10.10.10.101 kernel: <0> 0000000000000286 ffffffff812f7826 ffff88007a26f650 ffff88007a26f400
Feb 23 13:40:02 10.10.10.101 kernel: Call Trace:
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffffa004ff10>] ? iser_cma_handler+0x330/0x3a0 [ib_iser]
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff81033f26>] ? dequeue_task_fair+0x46/0x1a0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812f7826>] ? cma_comp_exch+0x56/0x80
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812fad11>] ? cma_ib_handler+0xe1/0x270
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812f353b>] ? cm_process_work+0x1b/0x120
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812f5813>] ? cm_work_handler+0xda3/0xfa0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812f4a70>] ? cm_work_handler+0x0/0xfa0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff812f4a70>] ? cm_work_handler+0x0/0xfa0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff8104e3db>] ? worker_thread+0xeb/0x180
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff81052020>] ? autoremove_wake_function+0x0/0x30
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff8104e2f0>] ? worker_thread+0x0/0x180
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff81051d1e>] ? kthread+0x8e/0xa0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff8100ccfa>] ? child_rip+0xa/0x20
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff81051c90>] ? kthread+0x0/0xa0
Feb 23 13:40:02 10.10.10.101 kernel:  [<ffffffff8100ccf0>] ? child_rip+0x0/0x20
Feb 23 13:40:02 10.10.10.101 kernel: Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 28 48 89 5c 24 08 48 89 6c 24 10 48 89 fb 4c 89 64 24 18 4c 89 6c
Feb 23 13:40:02 10.10.10.101 kernel: RIP  [<ffffffffa004110e>] iscsi_conn_failure+0x1e/0xc0 [libiscsi]
Feb 23 13:40:02 10.10.10.101 kernel:  RSP <ffff88013e685d10>
Feb 23 13:40:02 10.10.10.101 kernel: CR2: 00000000621ae010
Feb 23 13:40:02 10.10.10.101 kernel: ---[ end trace 06080d0ed787773c ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
