From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Mon, 10 Aug 2015 07:54:48 -0700
Message-ID: <55C8BB38.1060808@sandisk.com>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439216574-25936-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/10/15 07:23, Sagi Grimberg wrote:
> srp_destroy_qp is designed to indicate we are safe to continue with
> freeing the channel resources by modifying the qp error state,
> posting a dummy wr on the queue-pair and waiting for it to flush.
> This also holds for the channel registration pool as we are unmapping
> the memory region when handling a scsi response. Destroying the
> channel registration pool before we make sure we processed all the
> inflight IO might introduce a use-after-free of the registration pool.
>
> This use-after-free is demonstrated in the stack trace below where
> srp is trying to unmap a used FMR after the fmr_pool was already destroyed.
>
> general protection fault: 0000 [#1] SMP
> RIP: 0010:[<ffffffff8151121b>]  [<ffffffff8151121b>] _raw_spin_lock_irqsave+0x1b/0x50
> Call Trace:
>   [<ffffffffa055d88a>] ib_fmr_pool_unmap+0x1a/0xb0 [ib_core]
>   [<ffffffffa06c00ed>] srp_unmap_data+0x17d/0x250 [ib_srp]
>   [<ffffffffa06c01eb>] srp_free_req+0x2b/0x60 [ib_srp]
>   [<ffffffffa06c0c94>] srp_recv_completion+0x174/0x580 [ib_srp]
>   [<ffffffffa04580fe>] mlx4_eq_int+0x4de/0xe50 [mlx4_core]
>   [<ffffffffa0458b00>] mlx4_msi_x_interrupt+0x10/0x20 [mlx4_core]
>   [<ffffffff810abc45>] handle_irq_event_percpu+0x35/0x1b0
>   [<ffffffff810abdf2>] handle_irq_event+0x32/0x50
>   [<ffffffff810ae5cf>] handle_edge_irq+0x6f/0x120
>   [<ffffffff8100455a>] handle_irq+0x1a/0x30
>   [<ffffffff8151b475>] do_IRQ+0x45/0xb0
>   [<ffffffff8151162d>] common_interrupt+0x6d/0x6d
>   [<ffffffff813e4d2f>] cpuidle_enter_state+0x4f/0xc0
>   [<ffffffff813e4e6c>] cpuidle_idle_call+0xcc/0x210
>   [<ffffffff8100b9ea>] arch_cpu_idle+0xa/0x30
>   [<ffffffff810ab1e1>] cpu_startup_entry+0xe1/0x270
>   [<ffffffff81030b3a>] start_secondary+0x21a/0x2c0

With which kernel version has this been observed ? scsi_remove_host() 
waits until all outstanding requests have finished. srp_free_ch_ib() is 
called either before a SCSI host is registered with the SCSI core or 
after scsi_remove_host() has finished. So I don't see how the above call 
trace could be triggered with a recent kernel ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
