From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: Hang in cm_destroy_id
Date: Mon, 28 Mar 2016 11:13:58 +0300
Message-ID: <56F8E7C6.7020107@kyup.com>
References: <56F52268.5050207@kyup.com>
 <CAAk-MO9ZyH04C7qrQ9u9MNCOe1MO-6akvdz=-QE747ATDZnyUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO9ZyH04C7qrQ9u9MNCOe1MO-6akvdz=-QE747ATDZnyUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 03/27/2016 08:53 AM, Erez Shitrit wrote:
> Hi Nikolay,
> 
> looks like some cm event/packet was missing, no idea what/how we need
> to debug this.
> 
> On Fri, Mar 25, 2016 at 2:35 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>> Hello,
>>
>> I have an infiniband network which was running in connected mode but due
>> to some misconfiguration the infiniband nodes couldn't communicate with
>> the opensm and I was seeing a lot of messages such as:
> 
> What do you mean with misconfiguration? what was the configuration of
> the sm before and after you changed that ?

I just spoke with our netsys guys so here is what they tell me:
The network was running fine in CM, then a new device was added to the
network and OpenSM went on to do a fabric sweep to develop a new routing
table. During this time, reportedly, due to some configuration option in
OpenSM it disabled the whole network, causing nodes to lose
connectivity. From this point the queue stopped and transmit timeout
messages started appearing and after the time out the hungtask watchdog
rebooted the nodes. Does this help?


> 
> something caused the cm to get out of sync in its one or more open cm
> connections ..
> 
>>
>> 2745676.137840] ib0: queue stopped 1, tx_head 599, tx_tail 556
>> [2745677.137564] ib0: transmit timeout: latency 137170 msecs
>> [2745677.137735] ib0: queue stopped 1, tx_head 599, tx_tail 556
>>
>> Now this is all fine and dandy until I started seeing splats such as:
>>
>> [2745677.407573] INFO: task kworker/u24:0:8332 blocked for more than 120
>> seconds.
>> [2745677.407748]       Tainted: P        W  O    4.4.1-clouder2 #69
>> [2745677.407916] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [2745677.408087] kworker/u24:0   D ffff8801445dbaf8     0  8332      2
>> 0x00000000
>> [2745677.408353] Workqueue: ipoib_wq ipoib_cm_rx_reap [ib_ipoib]
>> [2745677.408565]  ffff8801445dbaf8 ffff88046d730d00 ffff880216218d00
>> 0000000000000000
>> [2745677.408916]  0000000000000004 0000000000000004 0000000000000004
>> 000000000000049a
>> [2745677.409267]  0000000000000090 0000000000000001 0000000000000002
>> 0000000000000000
>> [2745677.409612] Call Trace:
>> [2745677.409773]  [<ffffffff8134e12b>] ? find_next_bit+0xb/0x10
>> [2745677.409935]  [<ffffffff813399d1>] ? cpumask_next_and+0x21/0x40
>> [2745677.410099]  [<ffffffff810d8628>] ? load_balance+0x1f8/0x8e0
>> [2745677.410262]  [<ffffffff81679b67>] schedule+0x47/0x90
>> [2745677.410422]  [<ffffffff8167cab6>] schedule_timeout+0x136/0x1c0
>> [2745677.410585]  [<ffffffff8167ac03>] wait_for_completion+0xb3/0x120
>> [2745677.410749]  [<ffffffff810cb5c0>] ? try_to_wake_up+0x3b0/0x3b0
>> [2745677.410914]  [<ffffffffa02c6c0f>] cm_destroy_id+0x8f/0x310 [ib_cm]
>> [2745677.411080]  [<ffffffffa02c6fd0>] ib_destroy_cm_id+0x10/0x20 [ib_cm]
>> [2745677.411251]  [<ffffffffa0668357>]
>> ipoib_cm_free_rx_reap_list+0xa7/0x110 [ib_ipoib]
>> [2745677.411422]  [<ffffffffa06683d5>] ipoib_cm_rx_reap+0x15/0x20 [ib_ipoib]
>> [2745677.411591]  [<ffffffff810bb798>] process_one_work+0x178/0x500
>> [2745677.411759]  [<ffffffff810bcd92>] worker_thread+0x132/0x630
>> [2745677.411928]  [<ffffffff810cb5d2>] ? default_wake_function+0x12/0x20
>> [2745677.412096]  [<ffffffff810e08e6>] ? __wake_up_common+0x56/0x90
>> [2745677.412263]  [<ffffffff810bcc60>] ? create_worker+0x1d0/0x1d0
>> [2745677.412430]  [<ffffffff810bcc60>] ? create_worker+0x1d0/0x1d0
>> [2745677.412598]  [<ffffffff810bcc60>] ? create_worker+0x1d0/0x1d0
>> [2745677.412766]  [<ffffffff810c1777>] kthread+0xd7/0xf0
>> [2745677.412933]  [<ffffffff810ca3ee>] ? schedule_tail+0x1e/0xd0
>> [2745677.413100]  [<ffffffff810c16a0>] ?
>> kthread_freezable_should_stop+0x80/0x80
>> [2745677.413270]  [<ffffffff8167de2f>] ret_from_fork+0x3f/0x70
>> [2745677.413439]  [<ffffffff810c16a0>] ?
>> kthread_freezable_should_stop+0x80/0x80
>>
>>
>> And having kernel.hung_task_panic sysctl set to 1 caused a lot of
>> machines to reboot. In any case I don't think it's normal to have hung
>> tasks when your network is out. This happens due to the
>> wait_for_completion(&cm_id_priv->comp); never returning in cm_destroy_id
>> function. I saw there is one place where the cm_id refcount is
>> decremented via normal atomic_dec and not cm_deref_id under
>> cm_req_handle's rejected label. I dunno if this is correct or now, but
>> there definitely seems to be some refcounting problem. I've since moved
>> away from CM due to this thing (and the network got eventually fixed)
>> but I thought I'd do a bug-report so that this can be fixed
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
