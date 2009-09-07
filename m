From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Mon, 7 Sep 2009 22:27:14 +0200
Message-ID: <e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
References: <adaws4an4uh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaws4an4uh.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 7, 2009 at 5:37 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote=
:
> A new interface was added to the core workqueue API to make handling
> cancel_delayed_work() deadlocks easier, so a simpler fix for bug 1375=
7
> as below becomes possible. =A0Bart, it would be great if you could re=
test
> this, since it is what I am planning on sending upstream for 2.6.31.
> (This patch depends on 4e49627b, "workqueues: introduce
> __cancel_delayed_work()", which was merged for 2.6.31-rc9; alternativ=
ely
> my for-next branch is now rebased on top of -rc9 and has this patch p=
lus
> everything else queued for 2.6.32).

Hello Roland,

With 2.6.31-rc9 + patch 4e49627b9bc29a14b393c480e8c979e3bc922ef7 + the
patch you posted at the start of this thread the following lockdep
complaint was triggered on the SRP initiator system during SRP login:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
2.6.31-rc9 #2
------------------------------------------------------
ibsrpdm/4290 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&rmpp_recv->cleanup_work)->timer){+.-...}, at:
[<ffffffff802559f0>] del_timer_sync+0x0/0xa0

and this task is already holding:
 (&mad_agent_priv->lock){..-...}, at: [<ffffffffa03c6de8>]
ib_cancel_rmpp_recvs+0x28/0x118 [ib_mad]
which would create a new lock dependency:
 (&mad_agent_priv->lock){..-...} -> (&(&rmpp_recv->cleanup_work)->timer=
){+.-...}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&priv->lock){-.-...}
=2E.. which became HARDIRQ-irq-safe at:
  [<ffffffffffffffff>] 0xffffffffffffffff

to a HARDIRQ-irq-unsafe lock:
 (&(&rmpp_recv->cleanup_work)->timer){+.-...}
=2E.. which became HARDIRQ-irq-unsafe at:
=2E..  [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by ibsrpdm/4290:
 #0:  (&port->file_mutex){+.+.+.}, at: [<ffffffffa041c539>]
ib_umad_close+0x39/0x120 [ib_umad]
 #1:  (&mad_agent_priv->lock){..-...}, at: [<ffffffffa03c6de8>]
ib_cancel_rmpp_recvs+0x28/0x118 [ib_mad]

[ ... ]

stack backtrace:
Pid: 4290, comm: ibsrpdm Not tainted 2.6.31-rc9 #2
Call Trace:
 [<ffffffff80273b1a>] check_usage+0x3ba/0x470
 [<ffffffff80273c34>] check_irq_usage+0x64/0x100
 [<ffffffff80274c42>] __lock_acquire+0xf72/0x1b50
 [<ffffffff80275876>] lock_acquire+0x56/0x80
 [<ffffffff802559f0>] ? del_timer_sync+0x0/0xa0
 [<ffffffff80255a2d>] del_timer_sync+0x3d/0xa0
 [<ffffffff802559f0>] ? del_timer_sync+0x0/0xa0
 [<ffffffffa03c6e22>] ib_cancel_rmpp_recvs+0x62/0x118 [ib_mad]
 [<ffffffffa03c3d05>] ib_unregister_mad_agent+0x385/0x580 [ib_mad]
 [<ffffffff80272a7c>] ? mark_held_locks+0x6c/0x90
 [<ffffffffa041c5d2>] ib_umad_close+0xd2/0x120 [ib_umad]
 [<ffffffff802d2440>] __fput+0xd0/0x1e0
 [<ffffffff802d256d>] fput+0x1d/0x30
 [<ffffffff802cec1b>] filp_close+0x5b/0x90
 [<ffffffff8024c0b4>] put_files_struct+0x84/0xe0
 [<ffffffff8024c15e>] exit_files+0x4e/0x60
 [<ffffffff8024dfb9>] do_exit+0x709/0x790
 [<ffffffff80266556>] ? up_read+0x26/0x30
 [<ffffffff8020c92d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8024e07e>] do_group_exit+0x3e/0xb0
 [<ffffffff8024e102>] sys_exit_group+0x12/0x20
 [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
