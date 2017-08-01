From: Matan Barak <matanb@dev.mellanox.co.il>
Subject: Re: BUG: NULL pointer dereference at ib_uverbs_comp_handler+0x20
Date: Tue, 1 Aug 2017 14:08:08 +0300
Message-ID: <CAAKD3BDFcFDVvYYsimAqqWM9w-qv0Nc4U5Y54eGNhOATSkg0tA@mail.gmail.com>
References: <216b770e-fc08-68a6-c1bf-be96d52e325e@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <216b770e-fc08-68a6-c1bf-be96d52e325e@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stephen Bates <sbates@raithlin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 8:38 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Hi,
>
> My system has been failing with recent kernels (4.12.x and 4.13-rc2)
> with a NULL pointer dereference at the stack trace given at the end of
> this email. This happens when simply running 'ib_write_bw -R <server>'
> with a Chelsio T6 (cxgb4). I've bisected (log attached) to find the
> offending commit to be:
>
> commit 1e7710f3f6563940bb6bbc94aa8eadfd344a86af
> Author: Matan Barak <matanb@mellanox.com>
>   IB/core: Change completion channel to use the reworked objects schema
>
> Reverting this commit (and the dependent commits db1b5ddd53365 and
> e0fcc61113c that also fix other bugs with this commit) from v4.12.3
> fixes the issue.
>
> I did the bisect with the userspace libraries in Debian Stretch but I
> also had this bug with rdma-core v14. I was pretty sure v4.12 kernels
> worked for me in the past but likely only before I upgraded from Jessie
> to Stretch.
>
> Thanks,
>
> Logan
>

Hi Logan,

I've tried to reproduce this in my setup (ConnectX 4, RoCE mode) using
1e7710f3f6563940bb6bbc94aa8eadfd344a86af as the kernel's head.
I've used d779dd9a9e8f as rdma-core user-space and the latest perftest bits.
I couldn't reproduce this problem.
I'll try to review this commit again, but please provide more information.
For example, do you see the iwpm_register_pid error when these commits
are reverted?
Does this also happen when using the plain rdma-cm examples (ucmatose,
rping)? Does it happen in a plain verbs application (ibv_rc_pingpong)?
I assume you use iWarp, right? Did you test other modes?
Did you reproduce this issue with your ConnectX 4 as well?
Could you please reproduce it with KASAN as well?

PS, e0fcc61113c isn't a bug fix, it's just a simple refactor.

Regards,
Matan

>
> PS. As a side rant, this bug was found after a very *frustrating* day of
> what was supposed to be the 20 minute task of getting my RDMA cards
> plugged in again. I tried with both CX4s and the T6s (and I'm still not
> sure if my CX4s work yet). Instead, it turns out there's a whole mess of
> bugs in the kernel I had to go up against. I went back and forth between
> different versions of the userspace libraries because I was sure 4.11
> worked -- but it turned out 4.11.10+, 4.12.x and who knows what other
> stable kernels are currently broken by the bug fixed in [1]. And there
> was a whole other bug that broke things that was fixed in the 4.12-rc
> series that I had to carefully bisect around to find the one reported
> above. So frustrating!!
>
> [1] 5a7a88f1b488e4ee49eb3d5b82612d4d9ffdf2c3
>
> --
>
> [   53.320439] iwpm_register_pid: Unable to send a nlmsg (client = 2)
> [   54.738579] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000058
> [   54.747439] IP: _raw_spin_lock_irqsave+0x10/0x30
> [   54.752719] PGD 0
> [   54.752721] P4D 0
> [   54.755049]
> [   54.759109] Oops: 0002 [#1] SMP
> [   54.762699] Modules linked in:
> [   54.766195] CPU: 0 PID: 5 Comm: kworker/u16:0 Not tainted
> 4.13.0-rc2.direct #708
> [   54.774536] Hardware name: Supermicro SYS-7047GR-TRF/X9DRG-QF, BIOS
> 3.0a 12/05/2013
> [   54.783182] Workqueue: iw_cxgb4 process_work
> [   54.788036] task: ffff880276a5ee80 task.stack: ffffc900000c4000
> [   54.794728] RIP: 0010:_raw_spin_lock_irqsave+0x10/0x30
> [   54.800552] RSP: 0018:ffffc900000c7c70 EFLAGS: 00010046
> [   54.806473] RAX: 0000000000000000 RBX: 0000000000000002 RCX:
> 0000000000000000
> [   54.814524] RDX: 0000000000000001 RSI: 0000000000000058 RDI:
> 0000000000000058
> [   54.822583] RBP: ffff880470484600 R08: 0000000000000001 R09:
> 0000000000000001
> [   54.830663] R10: 0000000000000040 R11: ffff88047420b400 R12:
> 0000000000000282
> [   54.838744] R13: ffffc900000c7dc0 R14: 0000000000000001 R15:
> ffff880470484600
> [   54.846825] FS:  0000000000000000(0000) GS:ffff880277c00000(0000)
> knlGS:0000000000000000
> [   54.855997] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   54.862522] CR2: 0000000000000058 CR3: 0000000001e0a000 CR4:
> 00000000000406f0
> [   54.870602] Call Trace:
> [   54.873442]  ? ib_uverbs_comp_handler+0x20/0xe0
> [   54.878610]  ? flush_qp+0x6e/0x2b0
> [   54.882514]  ? c4iw_modify_qp+0x11c2/0x1870
> [   54.887295]  ? close_con_rpl+0xe7/0x170
> [   54.891686]  ? kfree_skb+0x33/0x90
> [   54.895592]  ? skb_dequeue+0x52/0x60
> [   54.899690]  ? process_work+0x4a/0x60
> [   54.903887]  ? process_one_work+0x1c2/0x3e0
> [   54.908664]  ? worker_thread+0x47/0x3d0
> [   54.913056]  ? kthread+0xfc/0x130
> [   54.916864]  ? create_worker+0x180/0x180
> [   54.921353]  ? kthread_create_on_node+0x40/0x40
> [   54.926521]  ? ret_from_fork+0x22/0x30
> [   54.930811] Code: c0 74 05 e8 b3 1c 73 ff 48 89 d8 5b c3 0f 1f 40 00
> 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 9c 5b fa 31 c0 ba 01 00
> 00 00 <f0> 0f b1 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 9c 09 73 ff 48
> [   54.952099] RIP: _raw_spin_lock_irqsave+0x10/0x30 RSP: ffffc900000c7c70
> [   54.959598] CR2: 0000000000000058
> [   54.963405] ---[ end trace 896cfe0234c949d2 ]---
> [  102.633421] random: crng init done
>
