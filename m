From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: Hang in ipoib_mcast_stop_thread
Date: Mon, 6 Jun 2016 15:36:55 +0300
Message-ID: <57556E67.4050904@kyup.com>
References: <57553DE7.2060009@kyup.com>
 <CAAk-MO_6GMm1AHay4uQ4yZ8HHcH_Dk=Ls5gKSVZUCejexDahLQ@mail.gmail.com>
 <57556866.8040703@kyup.com> <20160606122558.GB10894@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160606122558.GB10894-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06/06/2016 03:25 PM, Yuval Shaia wrote:
> On Mon, Jun 06, 2016 at 03:11:18PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 06/06/2016 02:51 PM, Erez Shitrit wrote:
>>> Hi Nikolay
>>>
>>> What was the scenario? (Do you have a way to reproduce that?)
>>
>> I have no way of reliably reproducing that, but I have experienced
>> misteryous hangs in the ipoib stack e.g.
>>
>> https://marc.info/?l=linux-rdma&m=145915284709901
>>
>> when the connection to the infiniband network is lost. Unfortunately I
>> cannot even figure out where to being debugging this ;(
>>
>> As a matter of fact I currently have one server which complains:
>>
>> ib0: transmit timeout: latency 139718550 msecs
>> ib0: queue stopped 1, tx_head 242, tx_tail 114
> 
> What i can tell from our experience is that this issue is not new, we have
> it with older kernels (<3).
> Also, not sure it is an issue with HCA vendor as we see it with CX3.

Are you using ipoib or pure RDMA?

> 
> This is a very slippery bug which we find it hard to reproduce.
> 
>>
>> yet, "iblinkinfo" can show all the nodes in the infiniband network.
>>
>>> Which IB card are you using?
>>
>> ibstat
>> CA 'qib0'
>> 	CA type: InfiniPath_QLE7342
>> 	Number of ports: 2
>> 	Firmware version:
>> 	Hardware version: 2
>> 	Node GUID: 0x001175000077b918
>> 	System image GUID: 0x001175000077b918
>> 	Port 1:
>> 		State: Active
>> 		Physical state: LinkUp
>> 		Rate: 40
>> 		Base lid: 68
>> 		LMC: 0
>> 		SM lid: 61
>> 		Capability mask: 0x07610868
>> 		Port GUID: 0x001175000077b918
>> 		Link layer: InfiniBand
>>
>>
>>
>>>
>>> Thanks, Erez
>>>
>>> On Mon, Jun 6, 2016 at 12:09 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>>>> Hello,
>>>>
>>>> [Tejun, I have cc'ed you since I'm not familiar with the internals of
>>>> the workqueue code and cannot comment whether the the mcast_task was
>>>> queued or and whether there were any tasks in the workqueue based on the
>>>> structures I've presented below, could you please comment on that?]
>>>>
>>>> I've been running an infiniband network on 4.4.10 and recently due to
>>>> the infiniband failing (I presume) and having the following in my logs:
>>>>
>>>> [128340.462147] ib0: transmit timeout: latency 45014865 msecs
>>>> [128340.462151] ib0: queue stopped 1, tx_head 711, tx_tail 583
>>>> [128341.461122] ib0: transmit timeout: latency 45015864 msecs
>>>> [128341.461126] ib0: queue stopped 1, tx_head 711, tx_tail 583
>>>> [128342.461053] ib0: transmit timeout: latency 45016864 msecs
>>>> [128342.461056] ib0: queue stopped 1, tx_head 711, tx_tail 583
>>>>
>>>> I had various commands hang due to rtnl_lock being held by an ip
>>>> command, trying to shutdown the infiniband interface:
>>>>
>>>> PID: 30572 TASK: ffff881bb6bf6e00 CPU: 15 COMMAND: "ip"
>>>> #0 [ffff88027f50b390] __schedule at ffffffff81631421
>>>> #1 [ffff88027f50b430] schedule at ffffffff81631cc7
>>>> #2 [ffff88027f50b450] schedule_timeout at ffffffff81634c89
>>>> #3 [ffff88027f50b4e0] wait_for_completion at ffffffff81632d73
>>>> #4 [ffff88027f50b550] flush_workqueue at ffffffff8106c761
>>>> #5 [ffff88027f50b620] ipoib_mcast_stop_thread at ffffffffa02e0bf2 [ib_ipoib]
>>>> #6 [ffff88027f50b650] ipoib_ib_dev_down at ffffffffa02de7d6 [ib_ipoib]
>>>> #7 [ffff88027f50b670] ipoib_stop at ffffffffa02dc208 [ib_ipoib]
>>>> #8 [ffff88027f50b6a0] __dev_close_many at ffffffff81562692
>>>> #9 [ffff88027f50b6c0] __dev_close at ffffffff81562716
>>>> #10 [ffff88027f50b6f0] __dev_change_flags at ffffffff815630fc
>>>> #11 [ffff88027f50b730] dev_change_flags at ffffffff81563207
>>>> #12 [ffff88027f50b760] do_setlink at ffffffff81576f5f
>>>> #13 [ffff88027f50b860] rtnl_newlink at ffffffff81578afb
>>>> #14 [ffff88027f50bb10] rtnetlink_rcv_msg at ffffffff81577ae5
>>>> #15 [ffff88027f50bb90] netlink_rcv_skb at ffffffff8159a373
>>>> #16 [ffff88027f50bbc0] rtnetlink_rcv at ffffffff81577bb5
>>>> #17 [ffff88027f50bbe0] netlink_unicast at ffffffff81599e98
>>>> #18 [ffff88027f50bc40] netlink_sendmsg at ffffffff8159aabe
>>>> #19 [ffff88027f50bd00] sock_sendmsg at ffffffff81548ce9
>>>> #20 [ffff88027f50bd20] ___sys_sendmsg at ffffffff8154ae78
>>>> #21 [ffff88027f50beb0] __sys_sendmsg at ffffffff8154b059
>>>> #22 [ffff88027f50bf40] sys_sendmsg at ffffffff8154b0a9
>>>> #23 [ffff88027f50bf50] entry_SYSCALL_64_fastpath at ffffffff81635c57
>>>>
>>>>
>>>> So clearly ipoib_mcast_stop_thread has hung on trying to stop the
>>>> multicast thread. Here is the state of the ipoib_wq:
>>>>
>>>> struct workqueue_struct {
>>>>   pwqs = {
>>>>     next = 0xffff883ff1196770,
>>>>     prev = 0xffff883ff1196770
>>>>   },
>>>>   list = {
>>>>     next = 0xffff883fef5bea10,
>>>>     prev = 0xffff883fef201010
>>>>   },
>>>>   mutex = {
>>>>     count = {
>>>>       counter = 1
>>>>     },
>>>>     wait_lock = {
>>>>       {
>>>>         rlock = {
>>>>           raw_lock = {
>>>>             val = {
>>>>               counter = 0
>>>>             }
>>>>           }
>>>>         }
>>>>       }
>>>>     },
>>>>     wait_list = {
>>>>       next = 0xffff883fef200c28,
>>>>       prev = 0xffff883fef200c28
>>>>     },
>>>>     owner = 0x0,
>>>>     osq = {
>>>>       tail = {
>>>>         counter = 0
>>>>       }
>>>>     }
>>>>   },
>>>>   work_color = 1,
>>>>   flush_color = 0,
>>>>   nr_pwqs_to_flush = {
>>>>     counter = 1
>>>>   },
>>>>   first_flusher = 0xffff88027f50b568,
>>>>   flusher_queue = {
>>>>     next = 0xffff883fef200c60,
>>>>     prev = 0xffff883fef200c60
>>>>   },
>>>>   flusher_overflow = {
>>>>     next = 0xffff883fef200c70,
>>>>     prev = 0xffff883fef200c70
>>>>   },
>>>>   maydays = {
>>>>     next = 0xffff883fef200c80,
>>>>     prev = 0xffff883fef200c80
>>>>   },
>>>>   rescuer = 0xffff883feb073680,
>>>>   nr_drainers = 0,
>>>>   saved_max_active = 1,
>>>>   unbound_attrs = 0xffff883fef2b5c20,
>>>>   dfl_pwq = 0xffff883ff1196700,
>>>>   wq_dev = 0x0,
>>>>   name =
>>>> "ipoib_wq\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>>>>   rcu = {
>>>>     next = 0x0,
>>>>     func = 0x0
>>>>   },
>>>>   flags = 131082,
>>>>   cpu_pwqs = 0x0,
>>>>
>>>> Also the state of the mcast_task member:
>>>>
>>>> crash> struct ipoib_dev_priv.mcast_task ffff883fed6ec700
>>>>   mcast_task = {
>>>>     work = {
>>>>       data = {
>>>>         counter = 3072
>>>>       },
>>>>       entry = {
>>>>         next = 0xffff883fed6ec888,
>>>>         prev = 0xffff883fed6ec888
>>>>       },
>>>>       func = 0xffffffffa02e1220 <ipoib_mcast_join_task>
>>>>     },
>>>>     timer = {
>>>>       entry = {
>>>>         next = 0x0,
>>>>         pprev = 0x0
>>>>       },
>>>>       expires = 0,
>>>>       function = 0xffffffff8106dd20 <delayed_work_timer_fn>,
>>>>       data = 18446612406880618624,
>>>>       flags = 2097164,
>>>>       slack = -1
>>>>     },
>>>>     wq = 0x0,
>>>>     cpu = 0
>>>>   }
>>>>
>>>>
>>>> flush_workqueue is essentially waiting on
>>>> wait_for_completion(&this_flusher.done) in flush_workqueue, which
>>>> apparently never returned. I'm assuming this is due to the general
>>>> unavailability of the infiniband network. However, I think it's wrong,
>>>> in case of infiniband being down, the whole server to be rendered
>>>> unresponsive, due to rtnl_lock being held. Do you think it is possible
>>>> to rework this code to prevent it hanging in case the workqueue cannot
>>>> be flushed? Furthermore, do you think it's feasible to put code in
>>>> ipoib_mcast_join_task to detect such situations and not re-arm itself
>>>> and then use cancel_delayed_work_sync ?
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
