From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel oops
Date: Thu, 27 Jul 2017 14:46:55 +0300
Message-ID: <CAAKD3BAdB2aRk3WGdbeDYof6dUfkEwhQf27cG0FWe5DRuQ15NQ@mail.gmail.com>
References: <20170724211606.GA1705@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724211606.GA1705-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 12:16 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> Matan,
>
> I suspect your reworking series broke hot removal, I get a kernel oops
> when removing modules on 4.13-rc2.
>
> I think it is some kind of race with uverbs being removed concurrently
> with user apps closing uverbs. In this case I removed umad first which
> caused systemd to forcibly shutdown srp_daemon, which happened
> concurrently with the rmmod of ib_uverbs.
>

Hi,

Thanks for informing :)
We'll try to debug that, but I expect we'll only get to that by end of
next week.

Thanks,
Matan

> [   50.797421] general protection fault: 0000 [#1] SMP
> [   50.798400] Modules linked in: ib_srp scsi_transport_srp scsi_mod rdma_cm ib_umad ib_cm ib_uverbs iw_cm mlx4_core ib_core [last unloaded: mlx4_ib]
> [   50.800946] CPU: 0 PID: 235 Comm: srp_daemon Not tainted 4.13.0-rc2+ #2
> [   50.802178] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   50.803970] task: ffff88022e504b00 task.stack: ffffc90000178000
> [   50.805163] RIP: 0010:ib_uverbs_release_file+0x29/0x90 [ib_uverbs]
> [   50.806428] RSP: 0018:ffffc9000017bd90 EFLAGS: 00010202
> [   50.807521] RAX: 0000000000000001 RBX: ffff88022dec56c0 RCX: 0000000000000001
> [   50.808898] RDX: 732f74696e752f31 RSI: ffff88022dec56c0 RDI: ffff88022cccc000
> [   50.810349] RBP: ffffc9000017bda0 R08: 000000002dec5801 R09: 0000000180150013
> [   50.811830] R10: ffffc9000017bd80 R11: ffff88022afe5200 R12: ffff88022dec56c0
> [   50.813260] R13: ffff88022dec56e8 R14: ffff88022dec5f70 R15: ffff88022edaa020
> [   50.814830] FS:  00007fb54d287700(0000) GS:ffff880236e00000(0000) knlGS:0000000000000000
> [   50.816401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   50.817602] CR2: 00007fb54bc4c8f8 CR3: 000000022dcd9000 CR4: 00000000000406b0
> [   50.818991] Call Trace:
> [   50.819487]  uverbs_close_fd+0x5f/0xa0 [ib_uverbs]
> [   50.820416]  ib_uverbs_comp_event_close+0xa4/0xb0 [ib_uverbs]
> [   50.821539]  __fput+0xd4/0x1d0
> [   50.822202]  ____fput+0x9/0x10
> [   50.822890]  task_work_run+0x79/0xa0
> [   50.823676]  do_exit+0x362/0xa90
> [   50.824309]  ? __do_page_fault+0x203/0x430
> [   50.825140]  do_group_exit+0x42/0xb0
> [   50.825908]  SyS_exit_group+0xf/0x10
> [   50.826630]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> [   50.827591] RIP: 0033:0x7fb54c73bb98
> [   50.828340] RSP: 002b:00007ffec1987788 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [   50.829900] RAX: ffffffffffffffda RBX: 0000006aa1fe2dc0 RCX: 00007fb54c73bb98
> [   50.831303] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> [   50.832793] RBP: 00007ffec1987780 R08: 00000000000000e7 R09: ffffffffffffff98
> [   50.834288] R10: 00007fb54a446640 R11: 0000000000000246 R12: 00007fb54be4dc50
> [   50.835802] R13: 00000000ffffffff R14: 00007ffec1987680 R15: 0000000000000006
> [   50.837254] Code: 1f 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 8b 47 48 48 8d b8 10 01 00 00 e8 d4 f8 02 e1 48 8b 7b 48 48 8b 57 30 48 85 d2 74 0a <48> 83 ba b0 02 00 00 00 74 42 89 c6 48 81 c7 10 01 00 00 e8 df
> [   50.841156] RIP: ib_uverbs_release_file+0x29/0x90 [ib_uverbs] RSP: ffffc9000017bd90
> [   50.842723] ---[ end trace 68785d98b53d9203 ]---
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
