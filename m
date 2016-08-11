From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Race between ipoib_cm_handle_tx_wc and ipoib_cm_tx_destroy crashing.
Date: Thu, 11 Aug 2016 18:10:54 +0300
Message-ID: <CAAk-MO8ftavVagQSXte_7yRf=iwHRXk-123wWRmmJELW+RVC7Q@mail.gmail.com>
References: <57AC8799.8060003@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57AC8799.8060003-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 11, 2016 at 5:11 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
> Hello list,
>
> I've come across yet another ipoib issue. I got the following crash,
> while executing "ifdown ib0". At this time the infiniband network was working
> as expected (e.g. no issue like the ones I reported before with tx queue
> time outs, etc) :
>

I think, it is all in the same area (as i already told you), somehow
there are missing events from the FW.

The scenario here can be explained by hanged/delayed FW/HW, please see below:

> [721677.936044] ib0: timing out; 1 sends not completed

The driver waits for 5 sec for completions from the HW/FW, they didn't
come, so the driver cleans all the skb including the dma mapping.

> [721678.760114] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
> [721678.760337] IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
> [721679.081771] BUG: unable to handle kernel paging request at ffffc900358e24d8
> [721679.081776] IP: [<ffffffffa01edf20>] ipoib_dma_unmap_tx+0x20/0x170 [ib_ipoib]
> [721679.081782] PGD 1fff432067 PUD 3ffec01067 PMD 1e8f064067 PTE 0
> [721679.081785] Oops: 0000 [#1] SMP
> [721679.081819] CPU: 0 PID: 3451 Comm: qib_cq0 Tainted: G           O    4.4.14-clouder3 #26
> [721679.081821] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.2 01/16/2015
> [721679.081822] task: ffff881fee8bb700 ti: ffff881ff0144000 task.ti: ffff881ff0144000
> [721679.081823] RIP: 0010:[<ffffffffa01edf20>]  [<ffffffffa01edf20>] ipoib_dma_unmap_tx+0x20/0x170 [ib_ipoib]
> [721679.081826] RSP: 0000:ffff881fff803e00  EFLAGS: 00010286
> [721679.081827] RAX: ffffc900358e24e0 RBX: ffffc900358e24d8 RCX: 0000000000000100
> [721679.081828] RDX: 000000000000069b RSI: ffffc900358e24d8 RDI: ffff881ff25c8700
> [721679.081829] RBP: ffff881fff803e30 R08: 0000000000000002 R09: ffffc9001b7df000
> [721679.081830] R10: 00000000000aebb9 R11: 0000000000000000 R12: 0000000000000000
> [721679.081831] R13: 0000000000000000 R14: ffff881ff25c8700 R15: ffff881ff25c8000
> [721679.081832] FS:  0000000000000000(0000) GS:ffff881fff800000(0000) knlGS:0000000000000000
> [721679.081833] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [721679.081834] CR2: ffffc900358e24d8 CR3: 0000001fa3b4f000 CR4: 00000000001406f0
> [721679.081834] Stack:
> [721679.081835]  0000000000000000 ffffc900358e24d8 0000000000000000 ffff881fdf4b2c00
> [721679.081837]  0000000000000000 ffff881ff25c8000 ffff881fff803e80 ffffffffa01f5660
> [721679.081839]  ffff881ff25c9068 0000000040000059 ffff881ff25c8700 ffff881ff25c8710
> [721679.081840] Call Trace:
> [721679.081842]  <IRQ>
> [721679.081845]  [<ffffffffa01f5660>] ipoib_cm_handle_tx_wc+0x70/0x280 [ib_ipoib]

meanwhile the HW/FW returned the completion event of the send (after
the driver was waiting for it during 5 sec, and deleted that skb)
napi was called and the driver tries to unmap memory area that was
already was freed ..

-->>panic

> [721679.081848]  [<ffffffffa01ee487>] ipoib_poll+0xd7/0x160 [ib_ipoib]
> [721679.081852]  [<ffffffff8154d36c>] net_rx_action+0x1ec/0x330
> [721679.081855]  [<ffffffff81057337>] __do_softirq+0x147/0x310
> [721679.081866]  [<ffffffffa00b601f>] ? send_complete+0x1f/0x60 [ib_qib]
> [721679.081869]  [<ffffffff8161618c>] do_softirq_own_stack+0x1c/0x30
> [721679.081869]  <EOI>
> [721679.081871]  [<ffffffff810567bb>] do_softirq.part.17+0x3b/0x40
> [721679.081873]  [<ffffffff81056876>] __local_bh_enable_ip+0xb6/0xc0
> [721679.081877]  [<ffffffffa00b604b>] send_complete+0x4b/0x60 [ib_qib]
> [721679.081881]  [<ffffffff81071bdb>] kthread_worker_fn+0xbb/0x1e0
> [721679.081883]  [<ffffffff81071b20>] ? kthread_create_on_node+0x180/0x180
> [721679.081885]  [<ffffffff8107161f>] kthread+0xef/0x110
> [721679.081887]  [<ffffffff81071530>] ? kthread_park+0x60/0x60
> [721679.081889]  [<ffffffff816149ff>] ret_from_fork+0x3f/0x70
> [721679.081891]  [<ffffffff81071530>] ? kthread_park+0x60/0x60
> [721679.081892] Code: 48 8b 05 b4 63 a2 e1 eb a3 66 90 0f 1f 44 00 00 55 48 8d 46 08 48 89 e5 41 57 41 56 49 89 fe 41 55 45 31 ed 41 54 53 48 83 ec 08 <4c> 8b 3e 48 89 45 d0 41 8b 97 80 00 00 00 41 8b 87 84 00 00 00
> [721679.081909] RIP  [<ffffffffa01edf20>] ipoib_dma_unmap_tx+0x20/0x170 [ib_ipoib]
> [721679.081911]  RSP <ffff881fff803e00>
> [721679.081912] CR2: ffffc900358e24d8
>
> ipoib_dma_unmap_tx+0x20 is : struct sk_buff *skb = tx_req->skb;
> The address of tx_req is ffffc900358e24d8, which apparently
> is unmapped address.
>
> The warning message "ib0: timing out; 1 sends not completed",
> came from  ipoib_cm_tx_destroy. This means the "goto timeout"
> statement has executed, triggering the freeing of the ipoib_cm_tx
> state, eventually unmapping the vmalloced. At the time of the crash ipoib_cm_tx looks like:
>
> struct ipoib_cm_tx {
>   id = 0xffff881fdf4b2c60,
>   qp = 0xffff8801c0bc8000,
>   list = {
>     next = 0xdead000000000100,
>     prev = 0xdead000000000200
>   },
>   dev = 0xffff881ff25c8000,
>   neigh = 0x0,
>   path = 0xffff881f3f7a7500,
>   tx_ring = 0xffffc900358df000,
>   tx_head = 101722,
>   tx_tail = 101722,
>   flags = 1,
>   mtu = 65524
> }
>
> The list is dead which corresponds to the list_del(&p->list);
> in cm_tx_reap and the tx_head/tx_tail are equal, corresponding
> to the loop in ipoib_cm_tx_destroy.
>
> Reading the code in ipoib_cm_handle_tx_wc I wasn't able to figure out
> how is this function synchronized against parallel destruction of
> underlying ipoib_cm_tx, which seems to be the case here.

I think you need some debug from the HW/FW here.

>
> Regards,
> Nikolay
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
