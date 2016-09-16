From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Fri, 16 Sep 2016 08:02:34 +0200
Message-ID: <77c92767-f26c-ba03-9b03-8b74c6212e7b@sandisk.com>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473424587-13818-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/09/2016 02:36 PM, Christoph Hellwig wrote:
> This series adds support to the RDMA core to implicitly allocate the required
> CQEs when creating a QP.

Hello Christoph,

Have you already had the chance to test the ib_srpt changes included
in this patch series? I'm asking because running srp-test on top of
a kernel that includes this patch series triggers an OOM message I
had not yet encountered while testing ib_srp or ib_srpt:

ion-dev-ib-ini:~ # ~bart/software/infiniband/srp-test/run_tests -f xfs
SRP LUN /sys/class/scsi_device/19:0:0:1 / sdt: removing /dev/dm-0: done
SRP LUN /sys/class/scsi_device/19:0:0:2 / sdv: removing /dev/dm-1: done
Unloaded the ib_srp kernel module
Unloaded the ib_srpt kernel module
Configured SRP target driver
Running test /home/bart/software/infiniband/srp-test/tests/01 ...
Connection to 10.60.180.187 closed by remote host.
Connection to 10.60.180.187 closed.


The ssh connection was closed by the OOM killer.


>From the netconsole output:

[  286.878805] ------------[ cut here ]------------
[  286.878901] WARNING: CPU: 7 PID: 53 at drivers/infiniband/core/cq.c:196 ib_free_cq+0xc0/0xf0 [ib_core]
[  286.886153] CPU: 7 PID: 53 Comm: kworker/7:0 Not tainted 4.8.0-rc6-dbg+ #1
[  286.886206] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
[  286.886259] Workqueue: srp_remove srp_remove_work [ib_srp]
[  286.887924] Call Trace:
[  286.887988]  [<ffffffff81322945>] dump_stack+0x68/0x93
[  286.888046]  [<ffffffff81062e76>] __warn+0xc6/0xe0
[  286.888105]  [<ffffffff81062f48>] warn_slowpath_null+0x18/0x20
[  286.888177]  [<ffffffffa04e5e90>] ib_free_cq+0xc0/0xf0 [ib_core]
[  286.888237]  [<ffffffffa027b787>] srp_free_ch_ib.isra.39+0xa7/0x1a0 [ib_srp]
[  286.888301]  [<ffffffffa027bc04>] srp_remove_work+0xd4/0x1f0 [ib_srp]
[  286.888362]  [<ffffffff81080425>] process_one_work+0x1f5/0x690
[  286.888472]  [<ffffffff81080909>] worker_thread+0x49/0x490
[  286.888591]  [<ffffffff810870ea>] kthread+0xea/0x100
[  286.888652]  [<ffffffff8162b5bf>] ret_from_fork+0x1f/0x40
[  286.889383] ---[ end trace 57bd282839f289df ]---
[ ... ]
[  295.458538] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x0:0xe41d2d03000a85b1, t_port_id 0xe41d2d03000a85b0:0xe41d2d03000a85b0 and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0xe41d2
d03000a85b1)
[  295.658698] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x516d0a00032d1de4:0x2c90300a02dc1, t_port_id 0xe41d2d03000a85b0:0xe41d2d03000a85b0 and it_iu_len 260 on port 1 (guid=0xfe80000000000
000:0xe41d2d03000a6d51)
[  295.660820] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x516d0a00032d1de4:0x2c90300a02dc2, t_port_id 0xe41d2d03000a85b0:0xe41d2d03000a85b0 and it_iu_len 260 on port 1 (guid=0xfe80000000000
000:0xe41d2d03000a6d51)
[  305.335833] systemd-udevd invoked oom-killer: gfp_mask=0x27000c0(GFP_KERNEL_ACCOUNT|__GFP_NOTRACK), order=2, oom_score_adj=-1000
[  305.335904] systemd-udevd cpuset=/ mems_allowed=0
[  305.336037] CPU: 10 PID: 567 Comm: systemd-udevd Tainted: G        W       4.8.0-rc6-dbg+ #1
[  305.336088] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
[  305.336789] Call Trace:
[  305.336847]  [<ffffffff81322945>] dump_stack+0x68/0x93
[  305.336907]  [<ffffffff811d47e9>] dump_header+0x57/0x229
[  305.337022]  [<ffffffff811591bd>] oom_kill_process+0x20d/0x3e0
[  305.337078]  [<ffffffff811598f2>] out_of_memory+0x512/0x530
[  305.337192]  [<ffffffff8115eeab>] __alloc_pages_nodemask+0xe5b/0x1000
[  305.337252]  [<ffffffff81060312>] copy_process.part.45+0x102/0x1ac0
[  305.337418]  [<ffffffff81061eb1>] _do_fork+0xe1/0x6d0
[  305.337588]  [<ffffffff81062524>] SyS_clone+0x14/0x20
[  305.337642]  [<ffffffff81002c93>] do_syscall_64+0x53/0x120
[  305.337697]  [<ffffffff8162b45a>] entry_SYSCALL64_slow_path+0x25/0x25

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
