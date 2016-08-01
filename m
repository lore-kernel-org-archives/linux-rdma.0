From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [IPOIB] Excessive TX packet drops due to IPOIB_MAX_PATH_REC_QUEUE
Date: Mon, 1 Aug 2016 12:46:46 +0300
Message-ID: <579F1A86.5050902@kyup.com>
References: <5799E5E6.3060104@kyup.com>
 <CAAk-MO83mJTq=E_MC=izqq8fEmVujY=5egVmKfFjxAz4jO3hHg@mail.gmail.com>
 <579F065C.602@kyup.com>
 <CAAk-MO9C7i0en5ZE=pufz6tMecUi23kL=5FR36JNfPzuO1G5-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO9C7i0en5ZE=pufz6tMecUi23kL=5FR36JNfPzuO1G5-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 08/01/2016 11:56 AM, Erez Shitrit wrote:
> The GID (9000:0:2800:0:bc00:7500:6e:d8a4) is not regular, not from
> local subnet prefix.
> why is that?

I have no idea, I checked all the relevant configs there isn't a single
place where such a GID prefix is used.

> 
> On Mon, Aug 1, 2016 at 11:20 AM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>>
>>
>> On 08/01/2016 11:01 AM, Erez Shitrit wrote:
>>> Hi Nikolay,
>>>
>>> IPoIB is a special driver because it plays in 2 "courts", in one hand
>>> it is a network driver and in the other hand it is IB driver, this is
>>> the reason for what you are seeing. (be carefull more details are
>>> coming ..)
>>>
>>> After ARP reply the kernel which threats ipoib driver as network
>>> driver (like ethernet, and doesn't aware of the IB aspect of the ipoib
>>> driver)
>>> the kernel thinks that now after it has the layer 2 address (from ARP)
>>> it can send the packets to the destination, it doesn't aware of the IB
>>> aspect which needs the AV (by Path Record) in order to get the right
>>> destination, ipoib tries to do best effort and while it asks the SM
>>> for the PathRecord it keeps theses packets (skb's) from the kernel in
>>> the neigh structure, the number of packets that are kept is 3, (3 is a
>>> good number, right after 2 .. and for almost all of the topologies we
>>> will not get more than 1 or 2 drops)
>>>
>>> Now, for your case, i think you have other problem, the connectivity
>>> with the SM is bad, or the destination is no longer exists.
>>> check that via the saquery tool (saquery PR <> <>)
>>
>> Thanks a lot for explaining this!
>>
>> Actually right after I posted that email further investigation revealed
>> that the infiniband is indeed somehow confused. So when I initiate a
>> connection from machine A, which is connected to machine B via
>> infiniband (and ipoib ipv6 connectivity) everything works as expected.
>> However, if I do the same sequence but instead of connecting to machine
>> B I connected to a container, hosted on machine B and accessible via a
>> veth address I see the following bogus path records:
>>
>> GID: 9000:0:2800:0:bc00:7500:6e:d8a4
>>   complete:     no
>>
>> Clearly, this is a wrong address, while the bottom part is a valid GUID
>> of the infiniband port of machine A, the 9000:0:2800 part isn't. Here is
>> how the the actual path record for machine A (from the point of view of
>> Machine B) looks like:
>>
>> GID: fe80:0:0:0:11:7500:6e:d8a4
>>   complete:    yes
>>   DLID:     0x004f
>>   SL:            0
>>   rate:       40.0 Gb/sec
>>
>>
>> Naturally if I do a saquery -p for 9000:0:2800:0:bc00:7500:6e:d8a4 I get
>> nothing, while for the second address it works. Further tracing revealed
>> that in ipoib_start_xmit on machine B the ipoib_cb->hwaddr is set to
>> 9000:0:2800:0:bc00:7500:6e:d8a4 which is passed as an argument to
>> ipoib_neigh_get and this function returns NULL. This causes
>> neigh_add_path to be called to add a path but results in -EINVAL. Here
>> are the respective debug messages:
>>
>> ib0: Start path record lookup for 9000:0000:2800:0000:bc00:7500:006e:d8a4
>>
>> ib0: PathRec status -22 for GID 9000:0000:2800:0000:bc00:7500:006e:d8a4
>> ib0: neigh free for 0002f3 9000:0000:2800:0000:bc00:7500:006e:d8a4
>>
>> And this is what is casuing the packet drops, since this neighbour is
>> considered dead (because it doesn't exist). For me this moves the
>> problem on a slightly different abstraction, because now it seems the
>> veth pair is somehow confusing the ipoib driver.
>>
>>
>>
>>>
>>> Thanks, Erez
>>>
>>> On Thu, Jul 28, 2016 at 2:00 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>>>> Hello,
>>>>
>>>> While investigating excessive (> 50%) packet drops on an ipoib
>>>> interface as reported by ifconfig :
>>>>
>>>> TX packets:16565 errors:1 dropped:9058 overruns:0 carrier:0
>>>>
>>>> I discovered that this is happening due to the following check
>>>> in ipoib_start_xmit failing:
>>>>
>>>> if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
>>>>                spin_lock_irqsave(&priv->lock, flags);
>>>>                __skb_queue_tail(&neigh->queue, skb);
>>>>                spin_unlock_irqrestore(&priv->lock, flags);
>>>> } else {
>>>>                ++dev->stats.tx_dropped;
>>>>                dev_kfree_skb_any(skb);
>>>> }
>>>>
>>>> With the following stacktrace:
>>>>
>>>> [1629744.927799]  [<ffffffffa048e6a1>] ipoib_start_xmit+0x651/0x6c0 [ib_ipoib]
>>>> [1629744.927804]  [<ffffffff8154ecf6>] dev_hard_start_xmit+0x266/0x410
>>>> [1629744.927807]  [<ffffffff81571b1b>] sch_direct_xmit+0xdb/0x210
>>>> [1629744.927808]  [<ffffffff8154f22a>] __dev_queue_xmit+0x24a/0x580
>>>> [1629744.927810]  [<ffffffff8154f570>] dev_queue_xmit+0x10/0x20
>>>> [1629744.927813]  [<ffffffff81557cf8>] neigh_resolve_output+0x118/0x1c0
>>>> [1629744.927828]  [<ffffffffa0003c7e>] ip6_finish_output2+0x18e/0x490 [ipv6]
>>>> [1629744.927831]  [<ffffffffa03b7374>] ? ipv6_confirm+0xc4/0x130 [nf_conntrack_ipv6]
>>>> [1629744.927837]  [<ffffffffa00052a6>] ip6_finish_output+0xa6/0x100 [ipv6]
>>>> [1629744.927843]  [<ffffffffa0005344>] ip6_output+0x44/0xe0 [ipv6]
>>>> [1629744.927850]  [<ffffffffa0005200>] ? ip6_fragment+0x9b0/0x9b0 [ipv6]
>>>> [1629744.927858]  [<ffffffffa000447c>] ip6_forward+0x4fc/0x8d0 [ipv6]
>>>> [1629744.927867]  [<ffffffffa00142ad>] ? ip6_route_input+0xfd/0x130 [ipv6]
>>>> [1629744.927872]  [<ffffffffa0001b70>] ? dst_output+0x20/0x20 [ipv6]
>>>> [1629744.927877]  [<ffffffffa0005be7>] ip6_rcv_finish+0x57/0xa0 [ipv6]
>>>> [1629744.927882]  [<ffffffffa0006374>] ipv6_rcv+0x314/0x4e0 [ipv6]
>>>> [1629744.927887]  [<ffffffffa0005b90>] ? ip6_make_skb+0x1b0/0x1b0 [ipv6]
>>>> [1629744.927890]  [<ffffffff8154c66b>] __netif_receive_skb_core+0x2cb/0xa30
>>>> [1629744.927893]  [<ffffffff8108310c>] ? __enqueue_entity+0x6c/0x70
>>>> [1629744.927894]  [<ffffffff8154cde6>] __netif_receive_skb+0x16/0x70
>>>> [1629744.927896]  [<ffffffff8154dc63>] process_backlog+0xb3/0x160
>>>> [1629744.927898]  [<ffffffff8154d36c>] net_rx_action+0x1ec/0x330
>>>> [1629744.927900]  [<ffffffff810821e1>] ? sched_clock_cpu+0xa1/0xb0
>>>> [1629744.927902]  [<ffffffff81057337>] __do_softirq+0x147/0x310
>>>> [1629744.927907]  [<ffffffffa0003c80>] ? ip6_finish_output2+0x190/0x490 [ipv6]
>>>> [1629744.927909]  [<ffffffff8161618c>] do_softirq_own_stack+0x1c/0x30
>>>> [1629744.927910]  <EOI>  [<ffffffff810567bb>] do_softirq.part.17+0x3b/0x40
>>>> [1629744.927913]  [<ffffffff81056876>] __local_bh_enable_ip+0xb6/0xc0
>>>> [1629744.927918]  [<ffffffffa0003c91>] ip6_finish_output2+0x1a1/0x490 [ipv6]
>>>> [1629744.927920]  [<ffffffffa03b7374>] ? ipv6_confirm+0xc4/0x130 [nf_conntrack_ipv6]
>>>> [1629744.927925]  [<ffffffffa00052a6>] ip6_finish_output+0xa6/0x100 [ipv6]
>>>> [1629744.927930]  [<ffffffffa0005344>] ip6_output+0x44/0xe0 [ipv6]
>>>> [1629744.927935]  [<ffffffffa0005200>] ? ip6_fragment+0x9b0/0x9b0 [ipv6]
>>>> [1629744.927939]  [<ffffffffa0002e1f>] ip6_xmit+0x23f/0x4f0 [ipv6]
>>>> [1629744.927944]  [<ffffffffa0001b50>] ? ac6_proc_exit+0x20/0x20 [ipv6]
>>>> [1629744.927952]  [<ffffffffa0033ce5>] inet6_csk_xmit+0x85/0xd0 [ipv6]
>>>> [1629744.927955]  [<ffffffff815aa56d>] tcp_transmit_skb+0x53d/0x910
>>>> [1629744.927957]  [<ffffffff815aab13>] tcp_write_xmit+0x1d3/0xe90
>>>> [1629744.927959]  [<ffffffff815aba31>] __tcp_push_pending_frames+0x31/0xa0
>>>> [1629744.927961]  [<ffffffff8159a19f>] tcp_push+0xef/0x120
>>>> [1629744.927963]  [<ffffffff8159e219>] tcp_sendmsg+0x6c9/0xac0
>>>> [1629744.927965]  [<ffffffff815c84d3>] inet_sendmsg+0x73/0xb0
>>>> [1629744.927967]  [<ffffffff81531728>] sock_sendmsg+0x38/0x50
>>>> [1629744.927969]  [<ffffffff815317bb>] sock_write_iter+0x7b/0xd0
>>>> [1629744.927972]  [<ffffffff811988ba>] __vfs_write+0xaa/0xe0
>>>> [1629744.927974]  [<ffffffff81198f29>] vfs_write+0xa9/0x190
>>>> [1629744.927975]  [<ffffffff81198e63>] ? vfs_read+0x113/0x130
>>>> [1629744.927977]  [<ffffffff81199c16>] SyS_write+0x46/0xa0
>>>> [1629744.927979]  [<ffffffff8161465b>] entry_SYSCALL_64_fastpath+0x16/0x6e
>>>> [1629744.927988] ---[ end trace 08584e4165caf3df ]---
>>>>
>>>>
>>>> IPOIB_MAX_PATH_REC_QUEUE is set to 3. If I'm reading the code correctly
>>>> if there are more than 3 outstanding packets for a neighbour this would
>>>> cause the code to drop the packets. Is this correct? Also I tried bumping
>>>
>>> yes.
>>>
>>>> IPOIB_MAX_PATH_REC_QUEUE to 150 to see what will happen and this instead
>>>
>>> it is a bad idea to move it to 150 ...
>>>
>>>> moved the dropping to occur in ipoib_neigh_dtor:
>>>>
>>>> [1629558.306405]  [<ffffffffa04788ec>] ipoib_neigh_dtor+0x9c/0x130 [ib_ipoib]
>>>> [1629558.306407]  [<ffffffffa0478999>] ipoib_neigh_reclaim+0x19/0x20 [ib_ipoib]
>>>> [1629558.306411]  [<ffffffff810ad0fb>] rcu_process_callbacks+0x21b/0x620
>>>> [1629558.306413]  [<ffffffff81057337>] __do_softirq+0x147/0x310
>>>>
>>>> Since you've taken part in the development of the said code I'd like
>>>> to ask what's the purpose of the IPOIB_MAX_PATH_REC_QUEUE limit and why
>>>> do we drop packets if there are more than this many outstanding packets,
>>>> since having 50% packet drops is a very large amount of drops?
>>>>
>>>> Regards,
>>>> Nikolay
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
