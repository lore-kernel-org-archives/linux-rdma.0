From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Tue, 8 Sep 2009 21:09:42 +0200
Message-ID: <e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com>
References: <adaws4an4uh.fsf@cisco.com>
	 <e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	 <adaskeym5gu.fsf@cisco.com>
	 <e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
	 <adabpllmk7c.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabpllmk7c.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2009 at 7:15 PM, Roland Dreier<rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>
> =A0> The above issue does not occur with the for-next branch of the
> =A0> infiniband git tree, but does occur with 2.6.31-rc9 + aforementi=
oned
> =A0> patches.
> =A0>
> =A0> As far as I can see commit 721d67cdca5b7642b380ca0584de8dceecf61=
02f
> =A0> (http://git.kernel.org/?p=3Dlinux/kernel/git/roland/infiniband.g=
it;a=3Dcommitdiff;h=3D721d67cdca5b7642b380ca0584de8dceecf6102f)
> =A0> is not yet included in 2.6.31-rc9. Could this be related to the =
above
> =A0> issue ?
>
> Yes, that would make sense. =A0"priv->lock" -- ie the ipoib lock whos=
e
> coverage is reduced in 721d67cd -- is in the lockdep report you poste=
d.
> So it seems likely that 721d67cd makes the mad_rmpp report not trigge=
r.
> However I think the mad_rmpp code does still have a lock-lock-timer
> problem that could cause lockdep reports in the future, so I'll have =
a
> look at fixing it.
>
> Do you happen to have the full lockdep output from this test handy? =A0=
I'm
> curious to see exactly how the mad_rmpp lock gets linked to priv->loc=
k.

The full lockdep output is as follows:

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

the HARDIRQ-irq-safe lock's dependencies:
-> (&priv->lock){-.-...} ops: 0 {
   IN-HARDIRQ-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   IN-SOFTIRQ-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffff80273e41>] __lock_acquire+0x171/0x1b50
                       [<ffffffff80275876>] lock_acquire+0x56/0x80
                       [<ffffffff804f6e0c>] _spin_lock_irq+0x3c/0x50
                       [<ffffffffa043a13e>]
ipoib_mcast_join_task+0x1fe/0x380 [ib_ipoib]
                       [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                       [<ffffffff80261fa6>] kthread+0x56/0x90
                       [<ffffffff8020cf7a>] child_rip+0xa/0x20
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffffa044743c>]
__key.42387+0x0/0xffffffffffff8ba3 [ib_ipoib]
 -> (&n->list_lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6d66>] _spin_lock+0x36/0x50
                         [<ffffffff802c6761>] add_partial+0x21/0x70
                         [<ffffffff802c94ac>] __slab_free+0x1ec/0x390
                         [<ffffffff802ca395>] kmem_cache_free+0x95/0xf0
                         [<ffffffff803b5e8f>] acpi_os_release_object+0x=
9/0xd
                         [<ffffffff803dfff6>]
acpi_ut_delete_object_desc+0x48/0x4c
                         [<ffffffff803df50b>]
acpi_ut_delete_internal_obj+0x3af/0x3ba
                         [<ffffffff803df69d>]
acpi_ut_update_ref_count+0x187/0x1d9
                         [<ffffffff803df804>]
acpi_ut_update_object_reference+0x115/0x18f
                         [<ffffffff803df8e3>] acpi_ut_remove_reference+=
0x65/0x6c
                         [<ffffffff803ce78b>] acpi_ex_create_method+0x9=
b/0xaa
                         [<ffffffff803c5bad>] acpi_ds_load1_end_op+0x1b=
a/0x245
                         [<ffffffff803d9454>] acpi_ps_parse_loop+0x786/=
0x93e
                         [<ffffffff803d84f8>] acpi_ps_parse_aml+0x10d/0=
x3df
                         [<ffffffff803d732d>]
acpi_ns_one_complete_parse+0x131/0x14c
                         [<ffffffff803d7391>] acpi_ns_parse_table+0x49/=
0x8c
                         [<ffffffff803d3c86>] acpi_ns_load_table+0x7a/0=
x114
                         [<ffffffff803db80c>] acpi_load_tables+0x6d/0x1=
5a
                         [<ffffffff806e00dd>] acpi_early_init+0x60/0xf5
                         [<ffffffff806b8cdd>] start_kernel+0x372/0x429
                         [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                         [<ffffffff806b8389>] x86_64_start_kernel+0xe0/=
0xf2
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80fa04e4>] __key.25366+0x0/0x8
 ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff802c921c>] get_partial_node+0x4c/0xf0
   [<ffffffff802c9755>] __slab_alloc+0x105/0x540
   [<ffffffff802c9d96>] kmem_cache_alloc+0xf6/0x100
   [<ffffffffa0438705>] ipoib_mcast_alloc+0x25/0xb0 [ib_ipoib]
   [<ffffffffa0439a17>] ipoib_mcast_restart_task+0x1c7/0x510 [ib_ipoib]
   [<ffffffffa04376fc>] __ipoib_ib_dev_flush+0xfc/0x250 [ib_ipoib]
   [<ffffffffa0437885>] ipoib_ib_dev_flush_normal+0x15/0x20 [ib_ipoib]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&list->lock#4){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0447458>]
__key.18496+0x0/0xffffffffffff8b87 [ib_ipoib]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&device->client_data_lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03acde5>]
add_client_context+0x55/0xb0 [ib_core]
                         [<ffffffffa03ad449>]
ib_register_device+0x439/0x4b0 [ib_core]
                         [<ffffffffa040da2e>] mlx4_ib_add+0x52e/0x600 [=
mlx4_ib]
                         [<ffffffffa01ebbec>]
mlx4_add_device+0x3c/0xa0 [mlx4_core]
                         [<ffffffffa01ebd4b>]
mlx4_register_interface+0x6b/0xb0 [mlx4_core]
                         [<ffffffffa0419010>] 0xffffffffa0419010
                         [<ffffffff8020904c>] do_one_initcall+0x3c/0x17=
0
                         [<ffffffff8028002f>] sys_init_module+0xaf/0x20=
0
                         [<ffffffff8020beeb>] system_call_fastpath+0x16=
/0x1b
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03bae90>]
__key.17696+0x0/0xffffffffffff45cb [ib_core]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&port->lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03d1c74>]
ib_sa_join_multicast+0x144/0x410 [ib_sa]
                         [<ffffffffa0439e7f>]
ipoib_mcast_join+0x11f/0x1e0 [ib_ipoib]
                         [<ffffffffa043a02c>]
ipoib_mcast_join_task+0xec/0x380 [ib_ipoib]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03d5e00>]
__key.23380+0x0/0xffffffffffffcc27 [ib_sa]
  -> (&group->lock){-.-...} ops: 0 {
     IN-HARDIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     IN-SOFTIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff80273e41>] __lock_acquire+0x171/0x=
1b50
                           [<ffffffff80275876>] lock_acquire+0x56/0x80
                           [<ffffffff804f6e61>] _spin_lock_irqsave+0x41=
/0x60
                           [<ffffffffa03d1e42>]
ib_sa_join_multicast+0x312/0x410 [ib_sa]
                           [<ffffffffa0439e7f>]
ipoib_mcast_join+0x11f/0x1e0 [ib_ipoib]
                           [<ffffffffa043a02c>]
ipoib_mcast_join_task+0xec/0x380 [ib_ipoib]
                           [<ffffffff8025d593>] worker_thread+0x1a3/0x3=
00
                           [<ffffffff80261fa6>] kthread+0x56/0x90
                           [<ffffffff8020cf7a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffffa03d5e10>]
__key.23161+0x0/0xffffffffffffcc17 [ib_sa]
   -> (&cwq->lock){-.-...} ops: 0 {
      IN-HARDIRQ-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
      IN-SOFTIRQ-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff807ad9d4>] __key.23406+0x0/0x8
    -> (&q->lock){-.-.-.} ops: 0 {
       IN-HARDIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       IN-SOFTIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       IN-RECLAIM_FS-W at:
                                   [<ffffffff8027440a>]
__lock_acquire+0x73a/0x1b50
                                   [<ffffffff80275876>] lock_acquire+0x=
56/0x80
                                   [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                   [<ffffffff8026268c>]
prepare_to_wait+0x2c/0x90
                                   [<ffffffff802a1885>] kswapd+0x105/0x=
800
                                   [<ffffffff80261fa6>] kthread+0x56/0x=
90
                                   [<ffffffff8020cf7a>] child_rip+0xa/0=
x20
                                   [<ffffffffffffffff>] 0xfffffffffffff=
fff
       INITIAL USE at:
                               [<ffffffff80273e41>] __lock_acquire+0x17=
1/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6e0c>] _spin_lock_irq+0x3c=
/0x50
                               [<ffffffff804f2df3>] wait_for_common+0x4=
3/0x1a0
                               [<ffffffff804f2fe8>]
wait_for_completion+0x18/0x20
                               [<ffffffff8026220f>] kthread_create+0x9f=
/0x130
                               [<ffffffff804f0d70>] migration_call+0x36=
2/0x4fb
                               [<ffffffff806cfc64>] migration_init+0x22=
/0x58
                               [<ffffffff8020904c>] do_one_initcall+0x3=
c/0x170
                               [<ffffffff806b8590>] kernel_init+0x6d/0x=
1a8
                               [<ffffffff8020cf7a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff807ae0b8>] __key.17808+0x0/0x8
     -> (&rq->lock){-.-.-.} ops: 0 {
        IN-HARDIRQ-W at:
                                  [<ffffffffffffffff>] 0xffffffffffffff=
ff
        IN-SOFTIRQ-W at:
                                  [<ffffffffffffffff>] 0xffffffffffffff=
ff
        IN-RECLAIM_FS-W at:
                                     [<ffffffff8027440a>]
__lock_acquire+0x73a/0x1b50
                                     [<ffffffff80275876>] lock_acquire+=
0x56/0x80
                                     [<ffffffff804f6d66>] _spin_lock+0x=
36/0x50
                                     [<ffffffff80239b6d>] task_rq_lock+=
0x4d/0x90
                                     [<ffffffff8024302a>]
set_cpus_allowed_ptr+0x2a/0x190
                                     [<ffffffff802a1804>] kswapd+0x84/0=
x800
                                     [<ffffffff80261fa6>] kthread+0x56/=
0x90
                                     [<ffffffff8020cf7a>] child_rip+0xa=
/0x20
                                     [<ffffffffffffffff>] 0xfffffffffff=
fffff
        INITIAL USE at:
                                 [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                 [<ffffffff80275876>] lock_acquire+0x56=
/0x80
                                 [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                 [<ffffffff8023fa36>] rq_attach_root+0x=
26/0x110
                                 [<ffffffff806d0000>] sched_init+0x2c0/=
0x436
                                 [<ffffffff806b8ad6>] start_kernel+0x16=
b/0x429
                                 [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                                 [<ffffffff806b8389>]
x86_64_start_kernel+0xe0/0xf2
                                 [<ffffffffffffffff>] 0xfffffffffffffff=
f
      }
      ... key      at: [<ffffffff80767128>] __key.45497+0x0/0x8
      -> (&vec->lock){-.-...} ops: 0 {
         IN-HARDIRQ-W at:
                                    [<ffffffffffffffff>] 0xffffffffffff=
ffff
         IN-SOFTIRQ-W at:
                                    [<ffffffffffffffff>] 0xffffffffffff=
ffff
         INITIAL USE at:
                                   [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                   [<ffffffff80275876>] lock_acquire+0x=
56/0x80
                                   [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                   [<ffffffff80291836>] cpupri_set+0xc6=
/0x160
                                   [<ffffffff8023c567>] rq_online_rt+0x=
47/0x90
                                   [<ffffffff80238cde>] set_rq_online+0=
x5e/0x80
                                   [<ffffffff8023faf8>]
rq_attach_root+0xe8/0x110
                                   [<ffffffff806d0000>] sched_init+0x2c=
0/0x436
                                   [<ffffffff806b8ad6>] start_kernel+0x=
16b/0x429
                                   [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                                   [<ffffffff806b8389>]
x86_64_start_kernel+0xe0/0xf2
                                   [<ffffffffffffffff>] 0xfffffffffffff=
fff
       }
       ... key      at: [<ffffffff80f96004>] __key.14614+0x0/0x3c
      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80291836>] cpupri_set+0xc6/0x160
   [<ffffffff8023c567>] rq_online_rt+0x47/0x90
   [<ffffffff80238cde>] set_rq_online+0x5e/0x80
   [<ffffffff8023faf8>] rq_attach_root+0xe8/0x110
   [<ffffffff806d0000>] sched_init+0x2c0/0x436
   [<ffffffff806b8ad6>] start_kernel+0x16b/0x429
   [<ffffffff806b8289>] x86_64_start_reservations+0x99/0xb9
   [<ffffffff806b8389>] x86_64_start_kernel+0xe0/0xf2
   [<ffffffffffffffff>] 0xffffffffffffffff

      -> (&rt_b->rt_runtime_lock){-.....} ops: 0 {
         IN-HARDIRQ-W at:
                                    [<ffffffffffffffff>] 0xffffffffffff=
ffff
         INITIAL USE at:
                                   [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                   [<ffffffff80275876>] lock_acquire+0x=
56/0x80
                                   [<ffffffff804f6d66>] _spin_lock+0x36=
/0x50
                                   [<ffffffff8023ce8c>]
enqueue_task_rt+0x1ec/0x2a0
                                   [<ffffffff8023818b>] enqueue_task+0x=
5b/0x70
                                   [<ffffffff802382b8>] activate_task+0=
x28/0x40
                                   [<ffffffff8023e2a8>]
try_to_wake_up+0x1a8/0x2b0
                                   [<ffffffff8023e3e0>]
wake_up_process+0x10/0x20
                                   [<ffffffff804f0a66>]
migration_call+0x58/0x4fb
                                   [<ffffffff806cfc82>] migration_init+=
0x40/0x58
                                   [<ffffffff8020904c>]
do_one_initcall+0x3c/0x170
                                   [<ffffffff806b8590>] kernel_init+0x6=
d/0x1a8
                                   [<ffffffff8020cf7a>] child_rip+0xa/0=
x20
                                   [<ffffffffffffffff>] 0xfffffffffffff=
fff
       }
       ... key      at: [<ffffffff80767130>] __key.36636+0x0/0x8
       -> (&cpu_base->lock){-.-...} ops: 0 {
          IN-HARDIRQ-W at:
                                      [<ffffffffffffffff>] 0xffffffffff=
ffffff
          IN-SOFTIRQ-W at:
                                      [<ffffffffffffffff>] 0xffffffffff=
ffffff
          INITIAL USE at:
                                     [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                     [<ffffffff80275876>] lock_acquire+=
0x56/0x80
                                     [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                     [<ffffffff80265a7c>]
lock_hrtimer_base+0x2c/0x60
                                     [<ffffffff80265c07>]
__hrtimer_start_range_ns+0x37/0x290
                                     [<ffffffff8023cee2>]
enqueue_task_rt+0x242/0x2a0
                                     [<ffffffff8023818b>] enqueue_task+=
0x5b/0x70
                                     [<ffffffff802382b8>]
activate_task+0x28/0x40
                                     [<ffffffff8023e2a8>]
try_to_wake_up+0x1a8/0x2b0
                                     [<ffffffff8023e3e0>]
wake_up_process+0x10/0x20
                                     [<ffffffff804f0a66>]
migration_call+0x58/0x4fb
                                     [<ffffffff806cfc82>]
migration_init+0x40/0x58
                                     [<ffffffff8020904c>]
do_one_initcall+0x3c/0x170
                                     [<ffffffff806b8590>] kernel_init+0=
x6d/0x1a8
                                     [<ffffffff8020cf7a>] child_rip+0xa=
/0x20
                                     [<ffffffffffffffff>] 0xfffffffffff=
fffff
        }
        ... key      at: [<ffffffff807ae0f0>] __key.19841+0x0/0x8
       ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80265a7c>] lock_hrtimer_base+0x2c/0x60
   [<ffffffff80265c07>] __hrtimer_start_range_ns+0x37/0x290
   [<ffffffff8023cee2>] enqueue_task_rt+0x242/0x2a0
   [<ffffffff8023818b>] enqueue_task+0x5b/0x70
   [<ffffffff802382b8>] activate_task+0x28/0x40
   [<ffffffff8023e2a8>] try_to_wake_up+0x1a8/0x2b0
   [<ffffffff8023e3e0>] wake_up_process+0x10/0x20
   [<ffffffff804f0a66>] migration_call+0x58/0x4fb
   [<ffffffff806cfc82>] migration_init+0x40/0x58
   [<ffffffff8020904c>] do_one_initcall+0x3c/0x170
   [<ffffffff806b8590>] kernel_init+0x6d/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

       -> (&rt_rq->rt_runtime_lock){-.....} ops: 0 {
          IN-HARDIRQ-W at:
                                      [<ffffffffffffffff>] 0xffffffffff=
ffffff
          INITIAL USE at:
                                     [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                     [<ffffffff80275876>] lock_acquire+=
0x56/0x80
                                     [<ffffffff804f6d66>] _spin_lock+0x=
36/0x50
                                     [<ffffffff8023a231>]
update_curr_rt+0xf1/0x190
                                     [<ffffffff8023c7ef>]
dequeue_task_rt+0x1f/0x80
                                     [<ffffffff80238255>] dequeue_task+=
0xb5/0xf0
                                     [<ffffffff802382f8>]
deactivate_task+0x28/0x40
                                     [<ffffffff804f3543>]
thread_return+0x11f/0x8bc
                                     [<ffffffff804f3cf3>] schedule+0x13=
/0x40
                                     [<ffffffff80243538>]
migration_thread+0x1c8/0x2c0
                                     [<ffffffff80261fa6>] kthread+0x56/=
0x90
                                     [<ffffffff8020cf7a>] child_rip+0xa=
/0x20
                                     [<ffffffffffffffff>] 0xfffffffffff=
fffff
        }
        ... key      at: [<ffffffff80767138>] __key.45477+0x0/0x8
       ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023a4a9>] __enable_runtime+0x39/0x80
   [<ffffffff8023c548>] rq_online_rt+0x28/0x90
   [<ffffffff80238cde>] set_rq_online+0x5e/0x80
   [<ffffffff804f0a9b>] migration_call+0x8d/0x4fb
   [<ffffffff80266fcf>] notifier_call_chain+0x3f/0x80
   [<ffffffff802670c1>] raw_notifier_call_chain+0x11/0x20
   [<ffffffff804f12b1>] _cpu_up+0x126/0x12c
   [<ffffffff804f132e>] cpu_up+0x77/0x89
   [<ffffffff806b8605>] kernel_init+0xe2/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023ce8c>] enqueue_task_rt+0x1ec/0x2a0
   [<ffffffff8023818b>] enqueue_task+0x5b/0x70
   [<ffffffff802382b8>] activate_task+0x28/0x40
   [<ffffffff8023e2a8>] try_to_wake_up+0x1a8/0x2b0
   [<ffffffff8023e3e0>] wake_up_process+0x10/0x20
   [<ffffffff804f0a66>] migration_call+0x58/0x4fb
   [<ffffffff806cfc82>] migration_init+0x40/0x58
   [<ffffffff8020904c>] do_one_initcall+0x3c/0x170
   [<ffffffff806b8590>] kernel_init+0x6d/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023a231>] update_curr_rt+0xf1/0x190
   [<ffffffff8023c7ef>] dequeue_task_rt+0x1f/0x80
   [<ffffffff80238255>] dequeue_task+0xb5/0xf0
   [<ffffffff802382f8>] deactivate_task+0x28/0x40
   [<ffffffff804f3543>] thread_return+0x11f/0x8bc
   [<ffffffff804f3cf3>] schedule+0x13/0x40
   [<ffffffff80243538>] migration_thread+0x1c8/0x2c0
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

      -> (&rq->lock/1){..-...} ops: 0 {
         IN-SOFTIRQ-W at:
                                    [<ffffffffffffffff>] 0xffffffffffff=
ffff
         INITIAL USE at:
                                   [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                   [<ffffffff80275876>] lock_acquire+0x=
56/0x80
                                   [<ffffffff804f6d11>]
_spin_lock_nested+0x41/0x60
                                   [<ffffffff8023d3c2>] double_rq_lock+=
0x72/0x90
                                   [<ffffffff8023dacf>]
__migrate_task+0x6f/0x120
                                   [<ffffffff8024340d>]
migration_thread+0x9d/0x2c0
                                   [<ffffffff80261fa6>] kthread+0x56/0x=
90
                                   [<ffffffff8020cf7a>] child_rip+0xa/0=
x20
                                   [<ffffffffffffffff>] 0xfffffffffffff=
fff
       }
       ... key      at: [<ffffffff80767129>] __key.45497+0x1/0x8
      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d11>] _spin_lock_nested+0x41/0x60
   [<ffffffff8023d3c2>] double_rq_lock+0x72/0x90
   [<ffffffff8023dacf>] __migrate_task+0x6f/0x120
   [<ffffffff8024340d>] migration_thread+0x9d/0x2c0
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

      -> (&sig->cputimer.lock){......} ops: 0 {
         INITIAL USE at:
                                   [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                   [<ffffffff80275876>] lock_acquire+0x=
56/0x80
                                   [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                   [<ffffffff80263638>]
thread_group_cputimer+0x38/0xf0
                                   [<ffffffff80264e15>]
posix_cpu_timers_exit_group+0x15/0x40
                                   [<ffffffff8024c8f8>] release_task+0x=
2b8/0x3f0
                                   [<ffffffff8024de3d>] do_exit+0x58d/0=
x790
                                   [<ffffffff80280199>]
__module_put_and_exit+0x19/0x20
                                   [<ffffffff8034d442>] cryptomgr_test+=
0x32/0x50
                                   [<ffffffff80261fa6>] kthread+0x56/0x=
90
                                   [<ffffffff8020cf7a>] child_rip+0xa/0=
x20
                                   [<ffffffffffffffff>] 0xfffffffffffff=
fff
       }
       ... key      at: [<ffffffff8076ac0c>] __key.15508+0x0/0x8
      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239cc8>] update_curr+0x118/0x140
   [<ffffffff8023b4bd>] dequeue_task_fair+0x4d/0x280
   [<ffffffff80238255>] dequeue_task+0xb5/0xf0
   [<ffffffff802382f8>] deactivate_task+0x28/0x40
   [<ffffffff804f3543>] thread_return+0x11f/0x8bc
   [<ffffffff804f3cf3>] schedule+0x13/0x40
   [<ffffffff8024dde6>] do_exit+0x536/0x790
   [<ffffffff8024e07e>] do_group_exit+0x3e/0xb0
   [<ffffffff8024e102>] sys_exit_group+0x12/0x20
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

     ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239b6d>] task_rq_lock+0x4d/0x90
   [<ffffffff8023e13f>] try_to_wake_up+0x3f/0x2b0
   [<ffffffff8023e3bd>] default_wake_function+0xd/0x10
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff8023993f>] complete+0x3f/0x60
   [<ffffffff80261ea0>] kthreadd+0xb0/0x160
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

     -> (&ep->lock){......} ops: 0 {
        INITIAL USE at:
                                 [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                 [<ffffffff80275876>] lock_acquire+0x56=
/0x80
                                 [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                 [<ffffffff80304ce0>] sys_epoll_ctl+0x3=
80/0x510
                                 [<ffffffff8020beeb>]
system_call_fastpath+0x16/0x1b
                                 [<ffffffffffffffff>] 0xfffffffffffffff=
f
      }
      ... key      at: [<ffffffff80fa13d0>] __key.22538+0x0/0x10
      ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239b6d>] task_rq_lock+0x4d/0x90
   [<ffffffff8023e13f>] try_to_wake_up+0x3f/0x2b0
   [<ffffffff8023e3bd>] default_wake_function+0xd/0x10
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802388b3>] __wake_up_locked+0x13/0x20
   [<ffffffff8030444d>] ep_poll_callback+0x8d/0x120
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802399ae>] __wake_up_sync_key+0x4e/0x70
   [<ffffffff8045dd33>] sock_def_readable+0x43/0x80
   [<ffffffff804de42a>] unix_stream_connect+0x44a/0x470
   [<ffffffff8045a641>] sys_connect+0x71/0xb0
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

     ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff803043ee>] ep_poll_callback+0x2e/0x120
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802399ae>] __wake_up_sync_key+0x4e/0x70
   [<ffffffff8045dd33>] sock_def_readable+0x43/0x80
   [<ffffffff804de42a>] unix_stream_connect+0x44a/0x470
   [<ffffffff8045a641>] sys_connect+0x71/0xb0
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff8025e2ef>] __queue_work+0x1f/0x50
   [<ffffffff8025e3cf>] queue_work_on+0x4f/0x60
   [<ffffffff8025e559>] queue_work+0x29/0x60
   [<ffffffffa03d1e8d>] ib_sa_join_multicast+0x35d/0x410 [ib_sa]
   [<ffffffffa0439e7f>] ipoib_mcast_join+0x11f/0x1e0 [ib_ipoib]
   [<ffffffffa043a02c>] ipoib_mcast_join_task+0xec/0x380 [ib_ipoib]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffffa03d157a>] mcast_groups_event+0x7a/0xd0 [ib_sa]
   [<ffffffffa03d1611>] mcast_event_handler+0x41/0x70 [ib_sa]
   [<ffffffffa03acaa9>] ib_dispatch_event+0x39/0x70 [ib_core]
   [<ffffffffa040d277>] mlx4_ib_process_mad+0x4a7/0x500 [mlx4_ib]
   [<ffffffffa03c2e02>] ib_mad_completion_handler+0x302/0x760 [ib_mad]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&qp->sq.lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa040fbb9>]
mlx4_ib_post_send+0x39/0xc50 [mlx4_ib]
                         [<ffffffffa03c1505>] ib_send_mad+0x165/0x3a0 [=
ib_mad]
                         [<ffffffffa03c33ac>]
ib_post_send_mad+0x14c/0x720 [ib_mad]
                         [<ffffffffa03d0914>] send_mad+0xb4/0x110 [ib_s=
a]
                         [<ffffffffa03d0acb>]
ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
                         [<ffffffffa03d204c>]
mcast_work_handler+0x10c/0x8c0 [ib_sa]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa041609c>]
__key.21638+0x0/0xffffffffffffcf32 [mlx4_ib]
 ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffffa040fbb9>] mlx4_ib_post_send+0x39/0xc50 [mlx4_ib]
   [<ffffffffa0437e39>] ipoib_send+0x469/0x850 [ib_ipoib]
   [<ffffffffa0438e4a>] ipoib_mcast_send+0x1aa/0x3f0 [ib_ipoib]
   [<ffffffffa0434962>] ipoib_path_lookup+0x122/0x2e0 [ib_ipoib]
   [<ffffffffa04352ed>] ipoib_start_xmit+0x17d/0x440 [ib_ipoib]
   [<ffffffff8046c55d>] dev_hard_start_xmit+0x2bd/0x340
   [<ffffffff8048096e>] __qdisc_run+0x25e/0x2b0
   [<ffffffff8046ca00>] dev_queue_xmit+0x2f0/0x4c0
   [<ffffffff80472b69>] neigh_connected_output+0xa9/0xe0
   [<ffffffff80493956>] ip_finish_output+0x2e6/0x340
   [<ffffffff80493d60>] ip_mc_output+0x220/0x260
   [<ffffffff80492710>] ip_local_out+0x20/0x30
   [<ffffffff80492a0c>] ip_push_pending_frames+0x2ec/0x450
   [<ffffffff804b361f>] udp_push_pending_frames+0x13f/0x400
   [<ffffffff804b53df>] udp_sendmsg+0x33f/0x770
   [<ffffffff804bc8d5>] inet_sendmsg+0x45/0x80
   [<ffffffff8045ad2f>] sock_sendmsg+0xdf/0x110
   [<ffffffff8045aee9>] sys_sendmsg+0x189/0x320
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&base->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffff80255216>] lock_timer_base+0x36/0x70
                         [<ffffffff8025528c>] mod_timer+0x3c/0x110
                         [<ffffffff806e2dcd>] con_init+0x272/0x277
                         [<ffffffff806e1f5f>] console_init+0x22/0x36
                         [<ffffffff806b8bc8>] start_kernel+0x25d/0x429
                         [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                         [<ffffffff806b8389>] x86_64_start_kernel+0xe0/=
0xf2
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff807ad958>] __key.23060+0x0/0x8
 ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80255216>] lock_timer_base+0x36/0x70
   [<ffffffff8025528c>] mod_timer+0x3c/0x110
   [<ffffffff80255373>] add_timer+0x13/0x20
   [<ffffffff8025e283>] queue_delayed_work_on+0xa3/0xd0
   [<ffffffff8025e65c>] queue_delayed_work+0x1c/0x30
   [<ffffffffa043a49e>] ipoib_mcast_join_complete+0x1de/0x240 [ib_ipoib=
]
   [<ffffffffa03d29b2>] join_handler+0x1b2/0x1f0 [ib_sa]
   [<ffffffffa03d0f7e>] ib_sa_mcmember_rec_callback+0x6e/0x70 [ib_sa]
   [<ffffffffa03d075c>] send_handler+0xac/0xd0 [ib_sa]
   [<ffffffffa03c4fe2>] timeout_sends+0xd2/0x1d0 [ib_mad]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&sa_dev->port[i].ah_lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e0c>] _spin_lock_irq+0x3c/0x50
                         [<ffffffffa03d0345>] update_sm_ah+0xf5/0x170 [=
ib_sa]
                         [<ffffffffa03d05db>] ib_sa_add_one+0x21b/0x250=
 [ib_sa]
                         [<ffffffffa03ad453>]
ib_register_device+0x443/0x4b0 [ib_core]
                         [<ffffffffa040da2e>] mlx4_ib_add+0x52e/0x600 [=
mlx4_ib]
                         [<ffffffffa01ebbec>]
mlx4_add_device+0x3c/0xa0 [mlx4_core]
                         [<ffffffffa01ebd4b>]
mlx4_register_interface+0x6b/0xb0 [mlx4_core]
                         [<ffffffffa0419010>] 0xffffffffa0419010
                         [<ffffffff8020904c>] do_one_initcall+0x3c/0x17=
0
                         [<ffffffff8028002f>] sys_init_module+0xaf/0x20=
0
                         [<ffffffff8020beeb>] system_call_fastpath+0x16=
/0x1b
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03d5d68>]
__key.18811+0x0/0xffffffffffffccbf [ib_sa]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&tid_lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03d020e>] init_mad+0x2e/0x70 [ib_sa=
]
                         [<ffffffffa03d0a6a>]
ib_sa_mcmember_rec_query+0xfa/0x1c0 [ib_sa]
                         [<ffffffffa03d204c>]
mcast_work_handler+0x10c/0x8c0 [ib_sa]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03d5d70>]
__key.18872+0x0/0xffffffffffffccb7 [ib_sa]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (query_idr.lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffff80366f80>] idr_pre_get+0x30/0x90
                         [<ffffffffa03d088f>] send_mad+0x2f/0x110 [ib_s=
a]
                         [<ffffffffa03d0acb>]
ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
                         [<ffffffffa03d204c>]
mcast_work_handler+0x10c/0x8c0 [ib_sa]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03d5b10>]
query_idr+0x30/0xffffffffffffcf47 [ib_sa]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&idr_lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03d08a3>] send_mad+0x43/0x110 [ib_s=
a]
                         [<ffffffffa03d0acb>]
ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
                         [<ffffffffa03d204c>]
mcast_work_handler+0x10c/0x8c0 [ib_sa]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03d5d78>]
__key.18871+0x0/0xffffffffffffccaf [ib_sa]
  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80366883>] get_from_free_list+0x23/0x60
   [<ffffffff80366bf5>] idr_get_empty_slot+0x2a5/0x2d0
   [<ffffffff80366e5c>] idr_get_new_above_int+0x1c/0x90
   [<ffffffff80366ee3>] idr_get_new+0x13/0x40
   [<ffffffffa03d08b8>] send_mad+0x58/0x110 [ib_sa]
   [<ffffffffa03d0acb>] ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
   [<ffffffffa03d204c>] mcast_work_handler+0x10c/0x8c0 [ib_sa]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&mad_agent_priv->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03c3342>]
ib_post_send_mad+0xe2/0x720 [ib_mad]
                         [<ffffffffa03d0914>] send_mad+0xb4/0x110 [ib_s=
a]
                         [<ffffffffa03d0acb>]
ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
                         [<ffffffffa03d204c>]
mcast_work_handler+0x10c/0x8c0 [ib_sa]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03ca7ac>]
__key.18167+0x0/0xffffffffffffc74a [ib_mad]
  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80255216>] lock_timer_base+0x36/0x70
   [<ffffffff8025528c>] mod_timer+0x3c/0x110
   [<ffffffff80255373>] add_timer+0x13/0x20
   [<ffffffff8025e283>] queue_delayed_work_on+0xa3/0xd0
   [<ffffffff8025e65c>] queue_delayed_work+0x1c/0x30
   [<ffffffffa03c1f3a>] wait_for_response+0xea/0xf0 [ib_mad]
   [<ffffffffa03c2216>] ib_mad_complete_send_wr+0x106/0x250 [ib_mad]
   [<ffffffffa03c2453>] ib_mad_send_done_handler+0xf3/0x240 [ib_mad]
   [<ffffffffa03c2c43>] ib_mad_completion_handler+0x143/0x760 [ib_mad]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff8025e2ef>] __queue_work+0x1f/0x50
   [<ffffffff8025e3cf>] queue_work_on+0x4f/0x60
   [<ffffffff8025e559>] queue_work+0x29/0x60
   [<ffffffff8025e665>] queue_delayed_work+0x25/0x30
   [<ffffffffa03c1f3a>] wait_for_response+0xea/0xf0 [ib_mad]
   [<ffffffffa03c1f62>] ib_reset_mad_timeout+0x22/0x30 [ib_mad]
   [<ffffffffa03c209a>] ib_modify_mad+0x12a/0x190 [ib_mad]
   [<ffffffffa03c210b>] ib_cancel_mad+0xb/0x10 [ib_mad]
   [<ffffffffa03e85cf>] cm_work_handler+0x6ff/0x103c [ib_cm]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&(&rmpp_recv->timeout_work)->timer){......} ops: 0 {
     INITIAL USE at:
                           [<ffffffff80273e41>] __lock_acquire+0x171/0x=
1b50
                           [<ffffffff80275876>] lock_acquire+0x56/0x80
                           [<ffffffff80255a2d>] del_timer_sync+0x3d/0xa=
0
                           [<ffffffffa03c6e09>]
ib_cancel_rmpp_recvs+0x49/0x118 [ib_mad]
                           [<ffffffffa03c3d05>]
ib_unregister_mad_agent+0x385/0x580 [ib_mad]
                           [<ffffffffa041c5d2>]
ib_umad_close+0xd2/0x120 [ib_umad]
                           [<ffffffff802d2440>] __fput+0xd0/0x1e0
                           [<ffffffff802d256d>] fput+0x1d/0x30
                           [<ffffffff802cec1b>] filp_close+0x5b/0x90
                           [<ffffffff8024c0b4>] put_files_struct+0x84/0=
xe0
                           [<ffffffff8024c15e>] exit_files+0x4e/0x60
                           [<ffffffff8024dfb9>] do_exit+0x709/0x790
                           [<ffffffff8024e07e>] do_group_exit+0x3e/0xb0
                           [<ffffffff8024e102>] sys_exit_group+0x12/0x2=
0
                           [<ffffffff8020beeb>] system_call_fastpath+0x=
16/0x1b
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffffa03ca828>]
__key.18191+0x0/0xffffffffffffc6ce [ib_mad]
  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff80255a2d>] del_timer_sync+0x3d/0xa0
   [<ffffffffa03c6e09>] ib_cancel_rmpp_recvs+0x49/0x118 [ib_mad]
   [<ffffffffa03c3d05>] ib_unregister_mad_agent+0x385/0x580 [ib_mad]
   [<ffffffffa041c5d2>] ib_umad_close+0xd2/0x120 [ib_umad]
   [<ffffffff802d2440>] __fput+0xd0/0x1e0
   [<ffffffff802d256d>] fput+0x1d/0x30
   [<ffffffff802cec1b>] filp_close+0x5b/0x90
   [<ffffffff8024c0b4>] put_files_struct+0x84/0xe0
   [<ffffffff8024c15e>] exit_files+0x4e/0x60
   [<ffffffff8024dfb9>] do_exit+0x709/0x790
   [<ffffffff8024e07e>] do_group_exit+0x3e/0xb0
   [<ffffffff8024e102>] sys_exit_group+0x12/0x20
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&mad_queue->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa03c0b4f>]
ib_mad_post_receive_mads+0xaf/0x2c0 [ib_mad]
                         [<ffffffffa03c0f97>]
ib_mad_init_device+0x237/0x640 [ib_mad]
                         [<ffffffffa03ad453>]
ib_register_device+0x443/0x4b0 [ib_core]
                         [<ffffffffa040da2e>] mlx4_ib_add+0x52e/0x600 [=
mlx4_ib]
                         [<ffffffffa01ebbec>]
mlx4_add_device+0x3c/0xa0 [mlx4_core]
                         [<ffffffffa01ebd4b>]
mlx4_register_interface+0x6b/0xb0 [mlx4_core]
                         [<ffffffffa0419010>] 0xffffffffa0419010
                         [<ffffffff8020904c>] do_one_initcall+0x3c/0x17=
0
                         [<ffffffff8028002f>] sys_init_module+0xaf/0x20=
0
                         [<ffffffff8020beeb>] system_call_fastpath+0x16=
/0x1b
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa03ca780>]
__key.20179+0x0/0xffffffffffffc776 [ib_mad]
  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffffa040fbb9>] mlx4_ib_post_send+0x39/0xc50 [mlx4_ib]
   [<ffffffffa03c1505>] ib_send_mad+0x165/0x3a0 [ib_mad]
   [<ffffffffa03c33ac>] ib_post_send_mad+0x14c/0x720 [ib_mad]
   [<ffffffffa03d0914>] send_mad+0xb4/0x110 [ib_sa]
   [<ffffffffa03d0acb>] ib_sa_mcmember_rec_query+0x15b/0x1c0 [ib_sa]
   [<ffffffffa03d204c>] mcast_work_handler+0x10c/0x8c0 [ib_sa]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80239923>] complete+0x23/0x60
   [<ffffffffa0434fd4>] path_rec_completion+0x4b4/0x540 [ib_ipoib]
   [<ffffffffa03d103b>] ib_sa_path_rec_callback+0x4b/0x70 [ib_sa]
   [<ffffffffa03d0647>] recv_handler+0x37/0x70 [ib_sa]
   [<ffffffffa03c313e>] ib_mad_completion_handler+0x63e/0x760 [ib_mad]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&cq->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80273e41>] __lock_acquire+0x171/0x1b=
50
                         [<ffffffff80275876>] lock_acquire+0x56/0x80
                         [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0=
x60
                         [<ffffffffa040b50d>]
mlx4_ib_poll_cq+0x2d/0x820 [mlx4_ib]
                         [<ffffffffa03c2b57>]
ib_mad_completion_handler+0x57/0x760 [ib_mad]
                         [<ffffffff8025d593>] worker_thread+0x1a3/0x300
                         [<ffffffff80261fa6>] kthread+0x56/0x90
                         [<ffffffff8020cf7a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0416068>]
__key.20459+0x0/0xffffffffffffcf66 [mlx4_ib]
  -> (&srq->lock){..-...} ops: 0 {
     IN-SOFTIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff80273e41>] __lock_acquire+0x171/0x=
1b50
                           [<ffffffff80275876>] lock_acquire+0x56/0x80
                           [<ffffffff804f6e61>] _spin_lock_irqsave+0x41=
/0x60
                           [<ffffffffa04126fc>]
mlx4_ib_post_srq_recv+0x2c/0x1a0 [mlx4_ib]
                           [<ffffffffa043b6e8>]
ipoib_cm_post_receive_srq+0x98/0x120 [ib_ipoib]
                           [<ffffffffa043c222>]
ipoib_cm_dev_init+0x442/0x610 [ib_ipoib]
                           [<ffffffffa043a7c7>]
ipoib_transport_dev_init+0xa7/0x3b0 [ib_ipoib]
                           [<ffffffffa04378ee>]
ipoib_ib_dev_init+0x3e/0xd0 [ib_ipoib]
                           [<ffffffffa043416f>]
ipoib_dev_init+0x9f/0x120 [ib_ipoib]
                           [<ffffffffa043449a>]
ipoib_add_one+0x2aa/0x4d0 [ib_ipoib]
                           [<ffffffffa03acec6>]
ib_register_client+0x86/0xb0 [ib_core]
                           [<ffffffffa044a103>] 0xffffffffa044a103
                           [<ffffffff8020904c>] do_one_initcall+0x3c/0x=
170
                           [<ffffffff8028002f>] sys_init_module+0xaf/0x=
200
                           [<ffffffff8020beeb>] system_call_fastpath+0x=
16/0x1b
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffffa04160ac>]
__key.20091+0x0/0xffffffffffffcf22 [mlx4_ib]
  ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&qp_table->lock){-.....} ops: 0 {
     IN-HARDIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff80273e41>] __lock_acquire+0x171/0x=
1b50
                           [<ffffffff80275876>] lock_acquire+0x56/0x80
                           [<ffffffff804f6e0c>] _spin_lock_irq+0x3c/0x5=
0
                           [<ffffffffa01f14c2>]
mlx4_qp_alloc+0x102/0x1b0 [mlx4_core]
                           [<ffffffffa0411fcd>]
create_qp_common+0x42d/0x990 [mlx4_ib]
                           [<ffffffffa0412654>]
mlx4_ib_create_qp+0x124/0x1a0 [mlx4_ib]
                           [<ffffffffa03aaba8>] ib_create_qp+0x18/0xa0 =
[ib_core]
                           [<ffffffffa03c06ba>] create_mad_qp+0x7a/0xd0=
 [ib_mad]
                           [<ffffffffa03c10e2>]
ib_mad_init_device+0x382/0x640 [ib_mad]
                           [<ffffffffa03ad453>]
ib_register_device+0x443/0x4b0 [ib_core]
                           [<ffffffffa040da2e>]
mlx4_ib_add+0x52e/0x600 [mlx4_ib]
                           [<ffffffffa01ebbec>]
mlx4_add_device+0x3c/0xa0 [mlx4_core]
                           [<ffffffffa01ebd4b>]
mlx4_register_interface+0x6b/0xb0 [mlx4_core]
                           [<ffffffffa0419010>] 0xffffffffa0419010
                           [<ffffffff8020904c>] do_one_initcall+0x3c/0x=
170
                           [<ffffffff8028002f>] sys_init_module+0xaf/0x=
200
                           [<ffffffff8020beeb>] system_call_fastpath+0x=
16/0x1b
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffffa01fbfd8>]
__key.18883+0x0/0xffffffffffff67c2 [mlx4_core]
  ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffffa01f1370>] mlx4_qp_remove+0x30/0x80 [mlx4_core]
   [<ffffffffa0411b50>] mlx4_ib_destroy_qp+0x340/0x390 [mlx4_ib]
   [<ffffffffa03aad54>] ib_destroy_qp+0x34/0x80 [ib_core]
   [<ffffffffa043cb9a>] ipoib_cm_tx_reap+0x1fa/0x5b0 [ib_ipoib]
   [<ffffffff8025d593>] worker_thread+0x1a3/0x300
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffffa040b50d>] mlx4_ib_poll_cq+0x2d/0x820 [mlx4_ib]
   [<ffffffffa0436295>] poll_tx+0x35/0x1b0 [ib_ipoib]
   [<ffffffffa0437f75>] ipoib_send+0x5a5/0x850 [ib_ipoib]
   [<ffffffffa0438e4a>] ipoib_mcast_send+0x1aa/0x3f0 [ib_ipoib]
   [<ffffffffa0434962>] ipoib_path_lookup+0x122/0x2e0 [ib_ipoib]
   [<ffffffffa04352ed>] ipoib_start_xmit+0x17d/0x440 [ib_ipoib]
   [<ffffffff8046c55d>] dev_hard_start_xmit+0x2bd/0x340
   [<ffffffff8048096e>] __qdisc_run+0x25e/0x2b0
   [<ffffffff8046ca00>] dev_queue_xmit+0x2f0/0x4c0
   [<ffffffff80472b69>] neigh_connected_output+0xa9/0xe0
   [<ffffffff80493956>] ip_finish_output+0x2e6/0x340
   [<ffffffff80493d60>] ip_mc_output+0x220/0x260
   [<ffffffff80492710>] ip_local_out+0x20/0x30
   [<ffffffff80492a0c>] ip_push_pending_frames+0x2ec/0x450
   [<ffffffff804b361f>] udp_push_pending_frames+0x13f/0x400
   [<ffffffff804b53df>] udp_sendmsg+0x33f/0x770
   [<ffffffff804bc8d5>] inet_sendmsg+0x45/0x80
   [<ffffffff8045ad2f>] sock_sendmsg+0xdf/0x110
   [<ffffffff8045aee9>] sys_sendmsg+0x189/0x320
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff


the HARDIRQ-irq-unsafe lock's dependencies:
-> (&(&rmpp_recv->cleanup_work)->timer){+.-...} ops: 0 {
   HARDIRQ-ON-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   IN-SOFTIRQ-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffffa03ca818>]
__key.18194+0x0/0xffffffffffffc6de [ib_mad]
 -> (&cwq->lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff807ad9d4>] __key.23406+0x0/0x8
  -> (&q->lock){-.-.-.} ops: 0 {
     IN-HARDIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     IN-SOFTIRQ-W at:
                            [<ffffffffffffffff>] 0xffffffffffffffff
     IN-RECLAIM_FS-W at:
                               [<ffffffff8027440a>] __lock_acquire+0x73=
a/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6e61>] _spin_lock_irqsave+=
0x41/0x60
                               [<ffffffff8026268c>] prepare_to_wait+0x2=
c/0x90
                               [<ffffffff802a1885>] kswapd+0x105/0x800
                               [<ffffffff80261fa6>] kthread+0x56/0x90
                               [<ffffffff8020cf7a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff80273e41>] __lock_acquire+0x171/0x=
1b50
                           [<ffffffff80275876>] lock_acquire+0x56/0x80
                           [<ffffffff804f6e0c>] _spin_lock_irq+0x3c/0x5=
0
                           [<ffffffff804f2df3>] wait_for_common+0x43/0x=
1a0
                           [<ffffffff804f2fe8>] wait_for_completion+0x1=
8/0x20
                           [<ffffffff8026220f>] kthread_create+0x9f/0x1=
30
                           [<ffffffff804f0d70>] migration_call+0x362/0x=
4fb
                           [<ffffffff806cfc64>] migration_init+0x22/0x5=
8
                           [<ffffffff8020904c>] do_one_initcall+0x3c/0x=
170
                           [<ffffffff806b8590>] kernel_init+0x6d/0x1a8
                           [<ffffffff8020cf7a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff807ae0b8>] __key.17808+0x0/0x8
   -> (&rq->lock){-.-.-.} ops: 0 {
      IN-HARDIRQ-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
      IN-SOFTIRQ-W at:
                              [<ffffffffffffffff>] 0xffffffffffffffff
      IN-RECLAIM_FS-W at:
                                 [<ffffffff8027440a>]
__lock_acquire+0x73a/0x1b50
                                 [<ffffffff80275876>] lock_acquire+0x56=
/0x80
                                 [<ffffffff804f6d66>] _spin_lock+0x36/0=
x50
                                 [<ffffffff80239b6d>] task_rq_lock+0x4d=
/0x90
                                 [<ffffffff8024302a>]
set_cpus_allowed_ptr+0x2a/0x190
                                 [<ffffffff802a1804>] kswapd+0x84/0x800
                                 [<ffffffff80261fa6>] kthread+0x56/0x90
                                 [<ffffffff8020cf7a>] child_rip+0xa/0x2=
0
                                 [<ffffffffffffffff>] 0xfffffffffffffff=
f
      INITIAL USE at:
                             [<ffffffff80273e41>] __lock_acquire+0x171/=
0x1b50
                             [<ffffffff80275876>] lock_acquire+0x56/0x8=
0
                             [<ffffffff804f6e61>] _spin_lock_irqsave+0x=
41/0x60
                             [<ffffffff8023fa36>] rq_attach_root+0x26/0=
x110
                             [<ffffffff806d0000>] sched_init+0x2c0/0x43=
6
                             [<ffffffff806b8ad6>] start_kernel+0x16b/0x=
429
                             [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                             [<ffffffff806b8389>] x86_64_start_kernel+0=
xe0/0xf2
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff80767128>] __key.45497+0x0/0x8
    -> (&vec->lock){-.-...} ops: 0 {
       IN-HARDIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       IN-SOFTIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff80273e41>] __lock_acquire+0x17=
1/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6e61>] _spin_lock_irqsave+=
0x41/0x60
                               [<ffffffff80291836>] cpupri_set+0xc6/0x1=
60
                               [<ffffffff8023c567>] rq_online_rt+0x47/0=
x90
                               [<ffffffff80238cde>] set_rq_online+0x5e/=
0x80
                               [<ffffffff8023faf8>] rq_attach_root+0xe8=
/0x110
                               [<ffffffff806d0000>] sched_init+0x2c0/0x=
436
                               [<ffffffff806b8ad6>] start_kernel+0x16b/=
0x429
                               [<ffffffff806b8289>]
x86_64_start_reservations+0x99/0xb9
                               [<ffffffff806b8389>]
x86_64_start_kernel+0xe0/0xf2
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff80f96004>] __key.14614+0x0/0x3c
    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80291836>] cpupri_set+0xc6/0x160
   [<ffffffff8023c567>] rq_online_rt+0x47/0x90
   [<ffffffff80238cde>] set_rq_online+0x5e/0x80
   [<ffffffff8023faf8>] rq_attach_root+0xe8/0x110
   [<ffffffff806d0000>] sched_init+0x2c0/0x436
   [<ffffffff806b8ad6>] start_kernel+0x16b/0x429
   [<ffffffff806b8289>] x86_64_start_reservations+0x99/0xb9
   [<ffffffff806b8389>] x86_64_start_kernel+0xe0/0xf2
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (&rt_b->rt_runtime_lock){-.....} ops: 0 {
       IN-HARDIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff80273e41>] __lock_acquire+0x17=
1/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6d66>] _spin_lock+0x36/0x5=
0
                               [<ffffffff8023ce8c>] enqueue_task_rt+0x1=
ec/0x2a0
                               [<ffffffff8023818b>] enqueue_task+0x5b/0=
x70
                               [<ffffffff802382b8>] activate_task+0x28/=
0x40
                               [<ffffffff8023e2a8>] try_to_wake_up+0x1a=
8/0x2b0
                               [<ffffffff8023e3e0>] wake_up_process+0x1=
0/0x20
                               [<ffffffff804f0a66>] migration_call+0x58=
/0x4fb
                               [<ffffffff806cfc82>] migration_init+0x40=
/0x58
                               [<ffffffff8020904c>] do_one_initcall+0x3=
c/0x170
                               [<ffffffff806b8590>] kernel_init+0x6d/0x=
1a8
                               [<ffffffff8020cf7a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff80767130>] __key.36636+0x0/0x8
     -> (&cpu_base->lock){-.-...} ops: 0 {
        IN-HARDIRQ-W at:
                                  [<ffffffffffffffff>] 0xffffffffffffff=
ff
        IN-SOFTIRQ-W at:
                                  [<ffffffffffffffff>] 0xffffffffffffff=
ff
        INITIAL USE at:
                                 [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                 [<ffffffff80275876>] lock_acquire+0x56=
/0x80
                                 [<ffffffff804f6e61>]
_spin_lock_irqsave+0x41/0x60
                                 [<ffffffff80265a7c>]
lock_hrtimer_base+0x2c/0x60
                                 [<ffffffff80265c07>]
__hrtimer_start_range_ns+0x37/0x290
                                 [<ffffffff8023cee2>]
enqueue_task_rt+0x242/0x2a0
                                 [<ffffffff8023818b>] enqueue_task+0x5b=
/0x70
                                 [<ffffffff802382b8>] activate_task+0x2=
8/0x40
                                 [<ffffffff8023e2a8>] try_to_wake_up+0x=
1a8/0x2b0
                                 [<ffffffff8023e3e0>] wake_up_process+0=
x10/0x20
                                 [<ffffffff804f0a66>] migration_call+0x=
58/0x4fb
                                 [<ffffffff806cfc82>] migration_init+0x=
40/0x58
                                 [<ffffffff8020904c>] do_one_initcall+0=
x3c/0x170
                                 [<ffffffff806b8590>] kernel_init+0x6d/=
0x1a8
                                 [<ffffffff8020cf7a>] child_rip+0xa/0x2=
0
                                 [<ffffffffffffffff>] 0xfffffffffffffff=
f
      }
      ... key      at: [<ffffffff807ae0f0>] __key.19841+0x0/0x8
     ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff80265a7c>] lock_hrtimer_base+0x2c/0x60
   [<ffffffff80265c07>] __hrtimer_start_range_ns+0x37/0x290
   [<ffffffff8023cee2>] enqueue_task_rt+0x242/0x2a0
   [<ffffffff8023818b>] enqueue_task+0x5b/0x70
   [<ffffffff802382b8>] activate_task+0x28/0x40
   [<ffffffff8023e2a8>] try_to_wake_up+0x1a8/0x2b0
   [<ffffffff8023e3e0>] wake_up_process+0x10/0x20
   [<ffffffff804f0a66>] migration_call+0x58/0x4fb
   [<ffffffff806cfc82>] migration_init+0x40/0x58
   [<ffffffff8020904c>] do_one_initcall+0x3c/0x170
   [<ffffffff806b8590>] kernel_init+0x6d/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

     -> (&rt_rq->rt_runtime_lock){-.....} ops: 0 {
        IN-HARDIRQ-W at:
                                  [<ffffffffffffffff>] 0xffffffffffffff=
ff
        INITIAL USE at:
                                 [<ffffffff80273e41>]
__lock_acquire+0x171/0x1b50
                                 [<ffffffff80275876>] lock_acquire+0x56=
/0x80
                                 [<ffffffff804f6d66>] _spin_lock+0x36/0=
x50
                                 [<ffffffff8023a231>] update_curr_rt+0x=
f1/0x190
                                 [<ffffffff8023c7ef>] dequeue_task_rt+0=
x1f/0x80
                                 [<ffffffff80238255>] dequeue_task+0xb5=
/0xf0
                                 [<ffffffff802382f8>] deactivate_task+0=
x28/0x40
                                 [<ffffffff804f3543>] thread_return+0x1=
1f/0x8bc
                                 [<ffffffff804f3cf3>] schedule+0x13/0x4=
0
                                 [<ffffffff80243538>]
migration_thread+0x1c8/0x2c0
                                 [<ffffffff80261fa6>] kthread+0x56/0x90
                                 [<ffffffff8020cf7a>] child_rip+0xa/0x2=
0
                                 [<ffffffffffffffff>] 0xfffffffffffffff=
f
      }
      ... key      at: [<ffffffff80767138>] __key.45477+0x0/0x8
     ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023a4a9>] __enable_runtime+0x39/0x80
   [<ffffffff8023c548>] rq_online_rt+0x28/0x90
   [<ffffffff80238cde>] set_rq_online+0x5e/0x80
   [<ffffffff804f0a9b>] migration_call+0x8d/0x4fb
   [<ffffffff80266fcf>] notifier_call_chain+0x3f/0x80
   [<ffffffff802670c1>] raw_notifier_call_chain+0x11/0x20
   [<ffffffff804f12b1>] _cpu_up+0x126/0x12c
   [<ffffffff804f132e>] cpu_up+0x77/0x89
   [<ffffffff806b8605>] kernel_init+0xe2/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023ce8c>] enqueue_task_rt+0x1ec/0x2a0
   [<ffffffff8023818b>] enqueue_task+0x5b/0x70
   [<ffffffff802382b8>] activate_task+0x28/0x40
   [<ffffffff8023e2a8>] try_to_wake_up+0x1a8/0x2b0
   [<ffffffff8023e3e0>] wake_up_process+0x10/0x20
   [<ffffffff804f0a66>] migration_call+0x58/0x4fb
   [<ffffffff806cfc82>] migration_init+0x40/0x58
   [<ffffffff8020904c>] do_one_initcall+0x3c/0x170
   [<ffffffff806b8590>] kernel_init+0x6d/0x1a8
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff8023a231>] update_curr_rt+0xf1/0x190
   [<ffffffff8023c7ef>] dequeue_task_rt+0x1f/0x80
   [<ffffffff80238255>] dequeue_task+0xb5/0xf0
   [<ffffffff802382f8>] deactivate_task+0x28/0x40
   [<ffffffff804f3543>] thread_return+0x11f/0x8bc
   [<ffffffff804f3cf3>] schedule+0x13/0x40
   [<ffffffff80243538>] migration_thread+0x1c8/0x2c0
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (&rq->lock/1){..-...} ops: 0 {
       IN-SOFTIRQ-W at:
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff80273e41>] __lock_acquire+0x17=
1/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6d11>] _spin_lock_nested+0=
x41/0x60
                               [<ffffffff8023d3c2>] double_rq_lock+0x72=
/0x90
                               [<ffffffff8023dacf>] __migrate_task+0x6f=
/0x120
                               [<ffffffff8024340d>] migration_thread+0x=
9d/0x2c0
                               [<ffffffff80261fa6>] kthread+0x56/0x90
                               [<ffffffff8020cf7a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff80767129>] __key.45497+0x1/0x8
    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d11>] _spin_lock_nested+0x41/0x60
   [<ffffffff8023d3c2>] double_rq_lock+0x72/0x90
   [<ffffffff8023dacf>] __migrate_task+0x6f/0x120
   [<ffffffff8024340d>] migration_thread+0x9d/0x2c0
   [<ffffffff80261fa6>] kthread+0x56/0x90
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (&sig->cputimer.lock){......} ops: 0 {
       INITIAL USE at:
                               [<ffffffff80273e41>] __lock_acquire+0x17=
1/0x1b50
                               [<ffffffff80275876>] lock_acquire+0x56/0=
x80
                               [<ffffffff804f6e61>] _spin_lock_irqsave+=
0x41/0x60
                               [<ffffffff80263638>]
thread_group_cputimer+0x38/0xf0
                               [<ffffffff80264e15>]
posix_cpu_timers_exit_group+0x15/0x40
                               [<ffffffff8024c8f8>] release_task+0x2b8/=
0x3f0
                               [<ffffffff8024de3d>] do_exit+0x58d/0x790
                               [<ffffffff80280199>]
__module_put_and_exit+0x19/0x20
                               [<ffffffff8034d442>] cryptomgr_test+0x32=
/0x50
                               [<ffffffff80261fa6>] kthread+0x56/0x90
                               [<ffffffff8020cf7a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff8076ac0c>] __key.15508+0x0/0x8
    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239cc8>] update_curr+0x118/0x140
   [<ffffffff8023b4bd>] dequeue_task_fair+0x4d/0x280
   [<ffffffff80238255>] dequeue_task+0xb5/0xf0
   [<ffffffff802382f8>] deactivate_task+0x28/0x40
   [<ffffffff804f3543>] thread_return+0x11f/0x8bc
   [<ffffffff804f3cf3>] schedule+0x13/0x40
   [<ffffffff8024dde6>] do_exit+0x536/0x790
   [<ffffffff8024e07e>] do_group_exit+0x3e/0xb0
   [<ffffffff8024e102>] sys_exit_group+0x12/0x20
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239b6d>] task_rq_lock+0x4d/0x90
   [<ffffffff8023e13f>] try_to_wake_up+0x3f/0x2b0
   [<ffffffff8023e3bd>] default_wake_function+0xd/0x10
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff8023993f>] complete+0x3f/0x60
   [<ffffffff80261ea0>] kthreadd+0xb0/0x160
   [<ffffffff8020cf7a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&ep->lock){......} ops: 0 {
      INITIAL USE at:
                             [<ffffffff80273e41>] __lock_acquire+0x171/=
0x1b50
                             [<ffffffff80275876>] lock_acquire+0x56/0x8=
0
                             [<ffffffff804f6e61>] _spin_lock_irqsave+0x=
41/0x60
                             [<ffffffff80304ce0>] sys_epoll_ctl+0x380/0=
x510
                             [<ffffffff8020beeb>] system_call_fastpath+=
0x16/0x1b
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff80fa13d0>] __key.22538+0x0/0x10
    ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6d66>] _spin_lock+0x36/0x50
   [<ffffffff80239b6d>] task_rq_lock+0x4d/0x90
   [<ffffffff8023e13f>] try_to_wake_up+0x3f/0x2b0
   [<ffffffff8023e3bd>] default_wake_function+0xd/0x10
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802388b3>] __wake_up_locked+0x13/0x20
   [<ffffffff8030444d>] ep_poll_callback+0x8d/0x120
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802399ae>] __wake_up_sync_key+0x4e/0x70
   [<ffffffff8045dd33>] sock_def_readable+0x43/0x80
   [<ffffffff804de42a>] unix_stream_connect+0x44a/0x470
   [<ffffffff8045a641>] sys_connect+0x71/0xb0
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80274e05>] __lock_acquire+0x1135/0x1b50
   [<ffffffff80275876>] lock_acquire+0x56/0x80
   [<ffffffff804f6e61>] _spin_lock_irqsave+0x41/0x60
   [<ffffffff803043ee>] ep_poll_callback+0x2e/0x120
   [<ffffffff8023886a>] __wake_up_common+0x5a/0x90
   [<ffffffff802399ae>] __wake_up_sync_key+0x4e/0x70
   [<ffffffff8045dd33>] sock_def_readable+0x43/0x80
   [<ffffffff804de42a>] unix_stream_connect+0x44a/0x470
   [<ffffffff8045a641>] sys_connect+0x71/0xb0
   [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff


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
scsi host6: ib_srp: new target: id_ext 0002c9030003cca2 ioc_guid
0002c9030003cca2 pkey ffff service_id 0002c9030003cca2 dgid
fe80:0000:0000:0000:0002:c903:0003:cca3
scsi6 : SRP.T10:0002C9030003CCA2
scsi 6:0:0:0: Direct-Access     SCST_FIO disk01            102 PQ: 0 AN=
SI: 5
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdb] 2097152 512-byte hardware sectors: (1.07 GB/1.00 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 83 00 10 08
sd 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports
DPO and FUA
 sdb: unknown partition table
sd 6:0:0:0: [sdb] Attached SCSI disk
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
