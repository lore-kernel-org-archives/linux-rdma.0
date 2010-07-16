From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path
 -when will it go upstream?
Date: Fri, 16 Jul 2010 02:13:32 -0700
Message-ID: <4C4022BC.3030401@linux.vnet.ibm.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com> <adapqysxup6.fsf@roland-alpha.cisco.com> <4C3C02B2.9040408@linux.vnet.ibm.com> <adaeif7xwwz.fsf@roland-alpha.cisco.com> <4C3D26D0.3090508@linux.vnet.ibm.com> <4C3DE512.3020903@linux.vnet.ibm.com> <4C3EF754.4060502@linux.vnet.ibm.com> <1279243768.31421.48.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279243768.31421.48.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ralph Campbell wrote:
> On Thu, 2010-07-15 at 04:56 -0700, Pradeep Satyanarayana wrote:
>> Pradeep Satyanarayana wrote:
>>> Pradeep Satyanarayana wrote:
>>>> Roland Dreier wrote:
>>>>>  > I guess I came to a premature conclusion. One set of tests ran fine and I made that
>>>>>  > conclusion. Another set of tests caused the following crash:
>>>>>
>>>>> I don't really know how to interpret this.  Is this crash new, or is it
>>>>> the same crash you were hoping this patch fixed?
>>>> This is a new crash.
>>> I see other manifestations resulting in different crashes :
>>>
>>> :mon> t
>>> [c00000074603ba20] d0000000193527ac .ipoib_neigh_flush+0x6c/0x350 [ib_ipoib]
>>> [c00000074603bb10] d000000019356dac .ipoib_mcast_free+0x74/0x2a0 [ib_ipoib]
>>> [c00000074603bbe0] d000000019358558 .ipoib_mcast_restart_task+0x3d0/0x560 [ib_ipoib]
>>> [c00000074603bd40] c0000000000c6fe4 .run_workqueue+0xf4/0x1e0
>>> [c00000074603be00] c0000000000c7190 .worker_thread+0xc0/0x180
>>> [c00000074603bed0] c0000000000ccf4c .kthread+0xb4/0xc0
>>> [c00000074603bf90] c0000000000309fc .kernel_thread+0x54/0x70
>>> 9:mon> e
>>> cpu 0x9: Vector: 300 (Data Access) at [c00000074603b720]
>>>     pc: c0000000005ac390: ._spin_lock+0x20/0xc8
>>>     lr: d0000000193527ac: .ipoib_neigh_flush+0x6c/0x350 [ib_ipoib]
>>>     sp: c00000074603b9a0
>>>    msr: 8000000000009032
>>>    dar: 3a0
>>>  dsisr: 40000000
>>>   current = 0xc000000756ce8b00
>>>   paca    = 0xc000000000f63800
>>>     pid   = 18095, comm = ipoib
>>> 9:mon>
>> Recreating the crash has been tricky. I have tried several several hundred times today
>> to unload and reload IPoIB while there is traffic and no crashes happened. I took
>> a closer look at the IPoIB CM code and I see a few things that look suspicious.
>>
>> In the ipoib_cm_send() path no priv->lock is held, whereas the priv->lock is held before 
>> calling ipoib_cm_destroy_tx(). This is true with and without Ralph's patch (fix dangling pointer).
>> Is this a potential race?
> 
> ipoib_cm_send() is only called by ipoib_start_xmit() so it is protected
> by netif_tx_lock(dev) or stopping the ipoib network device.

I still see one case in ipoib_neigh_cleanup() wherein ipoib_cm_destroy_tx() appears to be called
without netif_tx_lock(dev) held. Is that correct?

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
