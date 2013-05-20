From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 16:38:35 +0300
Message-ID: <519A275B.9070400@mellanox.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com> <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com> <519A01DD.6080906@mellanox.com> <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com> <519A1C60.4060005@mellanox.com> <CAD+HZHUKU3qq_WbaoW8NfwkoMQWQKeVS1GTGXxBRUEJOridEyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHUKU3qq_WbaoW8NfwkoMQWQKeVS1GTGXxBRUEJOridEyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/20/2013 3:58 PM, Jack Wang wrote:
> I haven't reproduced the original bug we saw in our production 
> environment
> BUG: unable to handle kernel
>   at 0000000000000008
> IP: [<ffffffffa0206c30>] ipoib_cm_tx_reap+0xe0/0x5a0 [ib_ipoib]
>  ...
> RIP: 0010:[<ffffffffa0206c30>] [<ffffffffa0206c30>] 
> ipoib_cm_tx_reap+0xe0/0x5a0 [ib_ipoib]
> RSP: 0018:ffff8825fdcbddb0  EFLAGS: 00010086
> RAX: 0000000000000246 RBX: ffff8807b59c29c0 RCX: 0000000000000000
> RDX: 4400000006000002 RSI: 0000000000000246 RDI: ffff8810026527c0
> RBP: ffff881002652000 R08: 0000000000015360 R09: dead000000200200
> R10: dead000000100100 R11: 0000000000000001 R12: 0000000000000001
> R13: 0000000000000000 R14: ffff8810026523a0 R15: ffff8810026527c0
> FS:  00007f4c9a325700(0000) GS:ffff880807c00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000008 CR3: 0000002605e3a000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/u:3 (pid: 61374, threadinfo ffff8825fdcbc000, task 
> ffff8807fd0eafb0)
> Stack:
>  ffff8820043303c0
>  ffff880807d52700
>  ffff8807fd0eafb0
>  ffff8825fdcbdde0
>
>  ffff8810026533b8
>  ffffffffa0039868
>  ffff8825fdcbdde0
>  ffff8805fd549a00
>
>  ffffffff81b9d480
>  ffff8807fd2f4000
>  ffffffffa0206b50
>  0000000000000000
>
> Call Trace:
>  [<ffffffffa0039868>] ? process_req+0xe8/0x1a0 [ib_addr]
>  [<ffffffffa0206b50>] ? ipoib_cm_tx_handler+0x2d0/0x2d0 [ib_ipoib]
>  [<ffffffff81052d64>] ? process_one_work+0x114/0x470
>  [<ffffffff81055033>] ? worker_thread+0x163/0x3e0
>  [<ffffffff81054ed0>] ? manage_workers+0x200/0x200
>  [<ffffffff81054ed0>] ? manage_workers+0x200/0x200
>  [<ffffffff8105963e>] ? kthread+0x9e/0xb0
>  [<ffffffff8167e9e4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff810595a0>] ? kthread_freezable_should_stop+0x60/0x60
>  [<ffffffff8167e9e0>] ? gs_change+0x13/0x13
>  ...
>  [<ffffffffa01fec30>] ipoib_cm_tx_reap+0xe0/0x5a0 [ib_ipoib]
>  RSP <ffff881d275f1db0>
> ---[ end trace 38ff082cbc03dd75 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
>
>
>
> , only the A variant of the crash in has been reproduced:
>
> WARNING: at lib/list_debug.c:49 __list_del_entry+0x63/0xd0()
> Hardware name: System Product Name
> list_del corruption, ffff88020dbd3080->next is LIST_POISON1 
> (dead000000100100)
> Modules linked in: ...
> Pid: 16248, comm: iperf Tainted: G        W  3.4.23-pserver+ #76
> Call Trace:
>  <IRQ>  [<ffffffff8103c21f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8103c316>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81428563>] ? do_raw_spin_lock+0xd3/0x140
>  [<ffffffff81428883>] __list_del_entry+0x63/0xd0
>  [<ffffffff81428901>] list_del+0x11/0x40
>  [<ffffffffa02f64c5>] ipoib_cm_handle_tx_wc+0x225/0x380 [ib_ipoib]
>  [<ffffffffa02eea44>] ipoib_poll+0x164/0x190 [ib_ipoib]
>  [<ffffffff815d91fd>] net_rx_action+0x13d/0x320
>  [<ffffffff81044f29>] ? __do_softirq+0x89/0x380
>  [<ffffffff81044f98>] __do_softirq+0xf8/0x380
>  [<ffffffff8174632c>] call_softirq+0x1c/0x30
>  <EOI>  [<ffffffff81004305>] do_softirq+0x95/0xd0
>  [<ffffffff815daacc>] ? dev_queue_xmit+0x29c/0xbf0
>  [<ffffffff8104461b>] local_bh_enable+0xeb/0xf0
>  [<ffffffff815daacc>] dev_queue_xmit+0x29c/0xbf0
>  [<ffffffff815da830>] ? ptype_seq_start+0xb0/0xb0
>  [<ffffffff815e0d87>] neigh_connected_output+0xc7/0x110
>  [<ffffffff8109f36d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81617386>] ip_finish_output2+0x1c6/0x460
>  [<ffffffff8161723a>] ? ip_finish_output2+0x7a/0x460
>  [<ffffffff81619033>] ip_finish_output+0xc3/0x230
>  [<ffffffff81619510>] ip_output+0xa0/0x110
>  [<ffffffff8161764d>] ip_local_out+0x2d/0x90
>  [<ffffffff816176cb>] ip_send_skb+0x1b/0x60
>  [<ffffffff8163f27b>] udp_send_skb+0x10b/0x380
>  [<ffffffff815c3a70>] ? sock_def_wakeup+0x1b0/0x1b0
>  [<ffffffff81616e90>] ? ip_append_page+0x530/0x530
>  [<ffffffff81641462>] udp_sendmsg+0x3b2/0xb50
>  [<ffffffff8173c530>] ? retint_restore_args+0x13/0x13
>  [<ffffffff8164d9a0>] ? inet_create+0x5b0/0x5b0
>  [<ffffffff815c2310>] ? sock_update_classid+0x150/0x2b0
>  [<ffffffff8164dacb>] inet_sendmsg+0x12b/0x240
>  [<ffffffff8164d9a0>] ? inet_create+0x5b0/0x5b0
>  [<ffffffff815c2272>] ? sock_update_classid+0xb2/0x2b0
>  [<ffffffff815c2310>] ? sock_update_classid+0x150/0x2b0
>  [<ffffffff815bda40>] sock_aio_write+0x190/0x1b0
>  [<ffffffff8142214e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8116e82a>] do_sync_write+0xea/0x130
>  [<ffffffff8109bfdd>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff811713d3>] ? fget_light+0x43/0x490
>  [<ffffffff813b14f3>] ? security_file_permission+0x23/0x90
>  [<ffffffff8116ee82>] vfs_write+0x172/0x190
>  [<ffffffff8116ef91>] sys_write+0x51/0x90
>  [<ffffffff81744de9>] system_call_fastpath+0x16/0x1b
> ---[ end trace 66110390802a41db ]---
>
> after apply
> commit fa16ebed31f336e41970f3f0ea9e8279f6be2d27
>   Author: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org 
> <mailto:shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>>
>   Date:   Mon Aug 13 14:39:49 2012 +0000
>
>       IB/ipoib: Add missing locking when CM object is deleted
>
> Above warning is gone, but we still see the warning at the begin of 
> this thread.
>
>
>
> 2013/5/20 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org 
> <mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>>
>
>     On 20/05/2013 15:46, Jinpu Wang wrote:
>
>         A quick test show the list_corruption warning is gone, after I
>         convert
>           all list_del(&neigh->list) to  list_del_list(&neigh->list).
>
>
>     yes, but this wasn't your original problem or was it?
>
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-rdma" in
>     the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>     <mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>

Hi Jack,

I don't understand what is the current status, that is what do you see 
now after applying the patches.
If you don't get the original bug why did you gave the trace of it? Or 
is it a new trace? It is not clear from your mail.
Please add only the trace of the current issue.

Best regards,

S.P.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
