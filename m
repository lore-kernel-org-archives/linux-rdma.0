From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: State of ipoib cm mode
Date: Mon, 1 Aug 2016 11:08:17 +0300
Message-ID: <CAAk-MO9HP-uicX2TyzFVYDGFT5NnG4exQqrBrHzZ6TE5-QFLxg@mail.gmail.com>
References: <57988FF1.9050405@kyup.com> <20160727115450.GA9717@redhat.com>
 <5798A3A0.8070301@kyup.com> <CAH_0vi9btY8PaDXnZOoP98hW_ZKkb6q11Fs+bEr_1VgRFgZjFQ@mail.gmail.com>
 <CAJFSNy7seqPM3rF_OaXQnTGgTBTNTAYjXCxkPHBs11Od__8P0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFSNy7seqPM3rF_OaXQnTGgTBTNTAYjXCxkPHBs11Od__8P0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Serge Ryabchun <serge.ryabchun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Nikolay,

There are few issues here, the tx_timeout is part of the error flow of
the driver, it happened mostly because the HW is much faster than the
SW/CPU, it is temporary occasion that should be freed after a short
time (not including bugs ..)

according your issue, please check with your HW vendor, i think that
it misses a completion.
that can lead to a livelock ..

Thanks, Erez


On Wed, Jul 27, 2016 at 7:35 PM, Nikolay Borisov
<n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org> wrote:
> On Wed, Jul 27, 2016 at 7:05 PM, Serge Ryabchun
> <serge.ryabchun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Nikolay,
>>
>> very similar behavior we have experienced an half a year ago with CX2 and
>> CX3 and QDR Mellanox switches.
>> It was fixed by this patch -
>> http://www.spinics.net/lists/linux-rdma/msg23811.html. Not fixed really but
>> at least it can move multicast QP from SQE to RTS state and restore
>> connectivity.
>
> Thanks for chiming in. According to git describe this patch made it to
> 4.1 and the kernel I'm using is 4.4. So in my case this behavior is
> happening despite this patch being applied. One other element is that
> I'm seeing this with qlogic cards (ib_qib driver). Unfortunately I'm
> not able to pinpoint whether this is a problem of the card driver or
> with the middleware ib_ipoib driver.
>
>>
>> It really was fixed replacing PSUs in the chassis by the more powerful. It
>> appeared that Mellanox ASIC is very sensitive to the power. Under heavy
>> loading those PSUs became slightly unstable and as a result built-in switch
>> on the same PSUs produced damaged frames.
>>
>> --
>> Regards,
>> Serge
>>
>>
>> On Wed, Jul 27, 2016 at 2:05 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>>>
>>> [Resending with the linux-rdma list cc'ed + some additional information]
>>>
>>> On 07/27/2016 02:54 PM, Michael S. Tsirkin wrote:
>>> > On Wed, Jul 27, 2016 at 01:41:53PM +0300, Nikolay Borisov wrote:
>>> >> Hello,
>>> >>
>>> >> I've been running some production servers with ipoib cm but have
>>> >> observed various hangs, e.g. :
>>> >>
>>> >> http://www.spinics.net/lists/linux-rdma/msg34577.html
>>> >> http://www.spinics.net/lists/linux-rdma/msg37011.html
>>> >> http://thread.gmane.org/gmane.linux.drivers.rdma/38899
>>> >>
>>> >> Other people have also confirmed that there is a latent bug, which is
>>> >> very hard to debug (e.g. here:
>>> >> http://www.spinics.net/lists/linux-rdma/msg37022.html). Essentially
>>> >>
>>> >> As the person who originally wrote the code and considering that git
>>> >> blame indicates most of it hasn't been touched does that mean it's
>>> >> considered stable? Also do you happen to have a hunch as to what might
>>> >> be causing such stalls?
>>> >>
>>> >> Regards,
>>> >> Nikolay
>>> >
>>> > Please repost copying a mailing list.
>>> > I have a general policy against responding to off-list mail.
>>>
>>> Ok.
>>>
>>> In addition to that, here is the state of a node which has been hung for
>>> about 2 days now - no infiniband multicast connectivity, this is similar
>>> to the issue observed in the first mailing list entry I have referenced,
>>> but this time I managed to obtain the state of the ipoib_cm_rx and
>>> ib_cm_id structs (as well as any other structs which are referenced from
>>> those):
>>>
>>>
>>> struct ipoib_cm_rx {
>>>   id = 0xffff8802128fa600,
>>>   qp = 0xffff880100e94000,
>>>   rx_ring = 0x0,
>>>   list = {
>>>     next = 0xffff88055f02bdd8,
>>>     prev = 0xffff88055f02bdd8
>>>   },
>>>   dev = 0xffff880661f68000,
>>>   jiffies = 4367003834,
>>>   state = IPOIB_CM_RX_FLUSH,
>>>   recv_count = 0
>>> }
>>>
>>> struct ib_cm_id {
>>>   cm_handler = 0xffffffffa01e7b60 <ipoib_cm_rx_handler>,
>>>   context = 0xffff880660f11780,
>>>   device = 0xffff8800378e4000,
>>>   service_id = 216172782113783824,
>>>   service_mask = 18446744073709551615,
>>>   state = IB_CM_IDLE,
>>>   lap_state = IB_CM_LAP_UNINIT,
>>>   local_id = 1741978561,
>>>   remote_id = 3782023797,
>>>   remote_cm_qpn = 1
>>> }
>>>
>>> And the backtrace is like that:
>>>
>>> PID: 28224  TASK: ffff88064bdb5280  CPU: 5   COMMAND: "kworker/u24:2"
>>>  #0 [ffff88055f02bc28] __schedule at ffffffff8160fc6a
>>>  #1 [ffff88055f02bc70] schedule at ffffffff816103dc
>>>  #2 [ffff88055f02bc88] schedule_timeout at ffffffff81613642
>>>  #3 [ffff88055f02bd08] wait_for_completion at ffffffff816118df
>>>  #4 [ffff88055f02bd68] cm_destroy_id at ffffffffa01d3759 [ib_cm]
>>>  #5 [ffff88055f02bdc0] ib_destroy_cm_id at ffffffffa01d3a10 [ib_cm]
>>>  #6 [ffff88055f02bdd0] ipoib_cm_free_rx_reap_list at ffffffffa01e7675
>>> [ib_ipoib]
>>>  #7 [ffff88055f02be18] ipoib_cm_rx_reap at ffffffffa01e7705 [ib_ipoib]
>>>  #8 [ffff88055f02be28] process_one_work at ffffffff8106bdf9
>>>  #9 [ffff88055f02be68] worker_thread at ffffffff8106c4a9
>>> #10 [ffff88055f02bed0] kthread at ffffffff8107161f
>>> #11 [ffff88055f02bf50] ret_from_fork at ffffffff816149ff
>>>
>>> ffffffffa01d3759 is wait_for_completion(&cm_id_priv->comp);
>>>
>>> Can you advise what other information might be helpful to debug this ?
>>>
>>> Regards,
>>> Nikolay
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
