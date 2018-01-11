From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_rxe: Kernel bug during QP cleanup
Date: Thu, 11 Jan 2018 15:37:25 +0200
Message-ID: <CAG9sBKPLZTVqXT2AJjdsgzA237oEQ5aAtmVWhp=9oKx5ghnEoQ@mail.gmail.com>
References: <1515618829.2745.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515618829.2745.34.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 11:13 PM, Bart Van Assche
<Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> Hello,
>
> The below output appeared on the serial console while I was using the rdma_rxe
> driver. I don't think this is caused by the change I made to this driver (the
> patch I posted earlier on the linux-rdma mailing list). Can someone have a look
> at this?
>
> Thanks,
>
> Bart.
>
> Kernel BUG at 00000000560033f3 [verbose debug info unavailable]
> BUG: sleeping function called from invalid context at net/core/sock.c:2761
> in_atomic(): 1, irqs_disabled(): 0, pid: 7, name: ksoftirqd/0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<00000000b6e69628>] __do_softirq+0x4e/0x540
> CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 4.15.0-rc7-dbg+ #4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Call Trace:
>  dump_stack+0x85/0xbf
>  ___might_sleep+0x177/0x260
>  lock_sock_nested+0x1d/0x90
>  inet_shutdown+0x2e/0xd0
>  rxe_qp_cleanup+0x107/0x140 [rdma_rxe]
>  rxe_elem_release+0x18/0x80 [rdma_rxe]
>  rxe_requester+0x1cf/0x11b0 [rdma_rxe]
>  rxe_do_task+0x78/0xf0 [rdma_rxe]
>  tasklet_action+0x99/0x270
>  __do_softirq+0xc0/0x540
>  run_ksoftirqd+0x1c/0x70
>  smpboot_thread_fn+0x1be/0x270
>  kthread+0x117/0x130
>  ret_from_fork+0x24/0x30

Thanks Bart
If you refer to the patch in "RDMA/rxe: Fix a race condition related
to the QP error state" then yes, it doesn't look like that it adds a
bug, at least not a bug like in the above trace.
If I had to guess it looks like a race between rxe_destroy_qp() and
rxe_requester(). If the first was starts to run while the second is
already running then the reference drop in rxe_requeser() is the one
that leads to rxe_qp_cleanup().
I'll add this to the bug list and try to investigate it sometime soon
(if no one else takes it of course :))

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
