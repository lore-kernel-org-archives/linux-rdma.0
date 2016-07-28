From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: [IPOIB] Excessive TX packet drops due to IPOIB_MAX_PATH_REC_QUEUE
Date: Thu, 28 Jul 2016 14:00:54 +0300
Message-ID: <5799E5E6.3060104@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, 

While investigating excessive (> 50%) packet drops on an ipoib 
interface as reported by ifconfig :

TX packets:16565 errors:1 dropped:9058 overruns:0 carrier:0

I discovered that this is happening due to the following check 
in ipoib_start_xmit failing: 

if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
               spin_lock_irqsave(&priv->lock, flags);
               __skb_queue_tail(&neigh->queue, skb);
               spin_unlock_irqrestore(&priv->lock, flags);
} else {
               ++dev->stats.tx_dropped;
               dev_kfree_skb_any(skb);
}

With the following stacktrace: 

[1629744.927799]  [<ffffffffa048e6a1>] ipoib_start_xmit+0x651/0x6c0 [ib_ipoib]
[1629744.927804]  [<ffffffff8154ecf6>] dev_hard_start_xmit+0x266/0x410
[1629744.927807]  [<ffffffff81571b1b>] sch_direct_xmit+0xdb/0x210
[1629744.927808]  [<ffffffff8154f22a>] __dev_queue_xmit+0x24a/0x580
[1629744.927810]  [<ffffffff8154f570>] dev_queue_xmit+0x10/0x20
[1629744.927813]  [<ffffffff81557cf8>] neigh_resolve_output+0x118/0x1c0
[1629744.927828]  [<ffffffffa0003c7e>] ip6_finish_output2+0x18e/0x490 [ipv6]
[1629744.927831]  [<ffffffffa03b7374>] ? ipv6_confirm+0xc4/0x130 [nf_conntrack_ipv6]
[1629744.927837]  [<ffffffffa00052a6>] ip6_finish_output+0xa6/0x100 [ipv6]
[1629744.927843]  [<ffffffffa0005344>] ip6_output+0x44/0xe0 [ipv6]
[1629744.927850]  [<ffffffffa0005200>] ? ip6_fragment+0x9b0/0x9b0 [ipv6]
[1629744.927858]  [<ffffffffa000447c>] ip6_forward+0x4fc/0x8d0 [ipv6]
[1629744.927867]  [<ffffffffa00142ad>] ? ip6_route_input+0xfd/0x130 [ipv6]
[1629744.927872]  [<ffffffffa0001b70>] ? dst_output+0x20/0x20 [ipv6]
[1629744.927877]  [<ffffffffa0005be7>] ip6_rcv_finish+0x57/0xa0 [ipv6]
[1629744.927882]  [<ffffffffa0006374>] ipv6_rcv+0x314/0x4e0 [ipv6]
[1629744.927887]  [<ffffffffa0005b90>] ? ip6_make_skb+0x1b0/0x1b0 [ipv6]
[1629744.927890]  [<ffffffff8154c66b>] __netif_receive_skb_core+0x2cb/0xa30
[1629744.927893]  [<ffffffff8108310c>] ? __enqueue_entity+0x6c/0x70
[1629744.927894]  [<ffffffff8154cde6>] __netif_receive_skb+0x16/0x70
[1629744.927896]  [<ffffffff8154dc63>] process_backlog+0xb3/0x160
[1629744.927898]  [<ffffffff8154d36c>] net_rx_action+0x1ec/0x330
[1629744.927900]  [<ffffffff810821e1>] ? sched_clock_cpu+0xa1/0xb0
[1629744.927902]  [<ffffffff81057337>] __do_softirq+0x147/0x310
[1629744.927907]  [<ffffffffa0003c80>] ? ip6_finish_output2+0x190/0x490 [ipv6]
[1629744.927909]  [<ffffffff8161618c>] do_softirq_own_stack+0x1c/0x30
[1629744.927910]  <EOI>  [<ffffffff810567bb>] do_softirq.part.17+0x3b/0x40
[1629744.927913]  [<ffffffff81056876>] __local_bh_enable_ip+0xb6/0xc0
[1629744.927918]  [<ffffffffa0003c91>] ip6_finish_output2+0x1a1/0x490 [ipv6]
[1629744.927920]  [<ffffffffa03b7374>] ? ipv6_confirm+0xc4/0x130 [nf_conntrack_ipv6]
[1629744.927925]  [<ffffffffa00052a6>] ip6_finish_output+0xa6/0x100 [ipv6]
[1629744.927930]  [<ffffffffa0005344>] ip6_output+0x44/0xe0 [ipv6]
[1629744.927935]  [<ffffffffa0005200>] ? ip6_fragment+0x9b0/0x9b0 [ipv6]
[1629744.927939]  [<ffffffffa0002e1f>] ip6_xmit+0x23f/0x4f0 [ipv6]
[1629744.927944]  [<ffffffffa0001b50>] ? ac6_proc_exit+0x20/0x20 [ipv6]
[1629744.927952]  [<ffffffffa0033ce5>] inet6_csk_xmit+0x85/0xd0 [ipv6]
[1629744.927955]  [<ffffffff815aa56d>] tcp_transmit_skb+0x53d/0x910
[1629744.927957]  [<ffffffff815aab13>] tcp_write_xmit+0x1d3/0xe90
[1629744.927959]  [<ffffffff815aba31>] __tcp_push_pending_frames+0x31/0xa0
[1629744.927961]  [<ffffffff8159a19f>] tcp_push+0xef/0x120
[1629744.927963]  [<ffffffff8159e219>] tcp_sendmsg+0x6c9/0xac0
[1629744.927965]  [<ffffffff815c84d3>] inet_sendmsg+0x73/0xb0
[1629744.927967]  [<ffffffff81531728>] sock_sendmsg+0x38/0x50
[1629744.927969]  [<ffffffff815317bb>] sock_write_iter+0x7b/0xd0
[1629744.927972]  [<ffffffff811988ba>] __vfs_write+0xaa/0xe0
[1629744.927974]  [<ffffffff81198f29>] vfs_write+0xa9/0x190
[1629744.927975]  [<ffffffff81198e63>] ? vfs_read+0x113/0x130
[1629744.927977]  [<ffffffff81199c16>] SyS_write+0x46/0xa0
[1629744.927979]  [<ffffffff8161465b>] entry_SYSCALL_64_fastpath+0x16/0x6e
[1629744.927988] ---[ end trace 08584e4165caf3df ]---


IPOIB_MAX_PATH_REC_QUEUE is set to 3. If I'm reading the code correctly 
if there are more than 3 outstanding packets for a neighbour this would 
cause the code to drop the packets. Is this correct? Also I tried bumping 
IPOIB_MAX_PATH_REC_QUEUE to 150 to see what will happen and this instead 
moved the dropping to occur in ipoib_neigh_dtor:

[1629558.306405]  [<ffffffffa04788ec>] ipoib_neigh_dtor+0x9c/0x130 [ib_ipoib]
[1629558.306407]  [<ffffffffa0478999>] ipoib_neigh_reclaim+0x19/0x20 [ib_ipoib]
[1629558.306411]  [<ffffffff810ad0fb>] rcu_process_callbacks+0x21b/0x620
[1629558.306413]  [<ffffffff81057337>] __do_softirq+0x147/0x310

Since you've taken part in the development of the said code I'd like 
to ask what's the purpose of the IPOIB_MAX_PATH_REC_QUEUE limit and why 
do we drop packets if there are more than this many outstanding packets, 
since having 50% packet drops is a very large amount of drops? 

Regards, 
Nikolay 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
