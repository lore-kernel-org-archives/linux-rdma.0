From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Fix kernel panic from skb
 destructor
Date: Thu, 22 Jun 2017 16:18:18 +0200
Message-ID: <20170622141818.GN5670@linux-x5ow.site>
References: <20170622141000.9899-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170622141000.9899-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 22, 2017 at 05:09:59PM +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In the time between rxe_send has finished and skb destructor
> called, the QP's ref count might be 0, leading to a possible
> QP destruction. This will lead to a kernel panic when the destructor
> dereferences the QP.
> 
> The operation of incrementing QP ref count at rxe_send and decrementing
> from skb destructor will prevent this crash.
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000072c
> IP: [<ffffffffa05df765>] rxe_skb_tx_dtor+0x15/0x50 [rdma_rxe]
> PGD 0 [16240.211178]
> Oops: 0002 [#1] SMP
> CPU: 3 PID: 0 Comm: swapper/3 Tainted: G           OE   4.9.0-mlnx #1
> Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
> task: ffff88042d6b1480 task.stack: ffffc90001904000
> RIP: 0010:[<ffffffffa05df765>]  [<ffffffffa05df765>] rxe_skb_tx_dtor+0x15/0x50 [rdma_rxe]
> RSP: 0018:ffff88043fcc3df0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff880429684700 RCX: ffff88042d248200
> RDX: 00000000ffffffff RSI: 00000000fffffe01 RDI: ffff880429684700
> RBP: ffff88043fcc3e00 R08: ffff88043fcda240 R09: 00000000ff2d1de6
> R10: 0000000000000000 R11: 00000000f49cf6fe R12: ffff880429684700
> R13: ffffffff81893f96 R14: ffffffff817d66f0 R15: ffff880427f74200
> FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000000072c CR3: 000000041d3df000 CR4: 00000000000006e0
> Stack:
>  ffffffff817b29cf ffff880429684700 ffff88043fcc3e18 ffffffff817b42c2
>  ffff880429684700 ffff88043fcc3e40 ffffffff817b4332 ffff880429684700
>  ffff880427f74238 ffff880427f74228 ffff88043fcc3e58 ffffffff81893f96
> Call Trace:
>  <IRQ> [16240.336345]  [<ffffffff817b29cf>] ? skb_release_head_state+0x4f/0xb0
>  [<ffffffff817b42c2>] skb_release_all+0x12/0x30
>  [<ffffffff817b4332>] kfree_skb+0x32/0x90
>  [<ffffffff81893f96>] ndisc_error_report+0x36/0x40
>  [<ffffffff817d4de1>] neigh_invalidate+0x81/0xf0
>  [<ffffffff817d68f7>] neigh_timer_handler+0x207/0x2b0
>  [<ffffffff81109295>] call_timer_fn+0x35/0x120
>  [<ffffffff81109db7>] run_timer_softirq+0x1d7/0x460
>  [<ffffffff8106155e>] ? kvm_sched_clock_read+0x1e/0x30
>  [<ffffffff810366b9>] ? sched_clock+0x9/0x10
>  [<ffffffff810cfed2>] ? sched_clock_cpu+0x72/0xa0
>  [<ffffffff818dd537>] __do_softirq+0xd7/0x289
>  [<ffffffff810a6c95>] irq_exit+0xb5/0xc0
>  [<ffffffff818dd372>] smp_apic_timer_interrupt+0x42/0x50
>  [<ffffffff818dc682>] apic_timer_interrupt+0x82/0x90
>  <EOI> [16240.395776]  [<ffffffff818da156>] ? native_safe_halt+0x6/0x10
>  [<ffffffff818d9e6e>] default_idle+0x1e/0xd0
>  [<ffffffff8103797f>] arch_cpu_idle+0xf/0x20
>  [<ffffffff818da2c5>] default_idle_call+0x35/0x40
>  [<ffffffff810e3eb5>] cpu_startup_entry+0x185/0x210
>  [<ffffffff81050433>] start_secondary+0x103/0x130
> RIP  [<ffffffffa05df765>] rxe_skb_tx_dtor+0x15/0x50 [rdma_rxe]
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
