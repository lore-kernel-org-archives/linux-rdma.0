From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: CRASH 3.18-rc2, 3.17.1, isert_connect_request
Date: Tue, 04 Nov 2014 18:44:57 +0200
Message-ID: <54590289.9020404@dev.mellanox.co.il>
References: <545758C8.4050300@tiktalik.com> <54576696.4000203@dev.mellanox.co.il> <54576C00.7010406@tiktalik.com> <54589351.1080007@tiktalik.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54589351.1080007-yCD69WgB1YhWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Mazur <adam.mazur-yCD69WgB1YhWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/4/2014 10:50 AM, Adam Mazur wrote:
> W dniu 03.11.2014 o 12:50, Adam Mazur pisze:
>> W dniu 03.11.2014 o 12:27, Sagi Grimberg pisze:
>>> On 11/3/2014 12:28 PM, Adam Mazur wrote:
>>>> Can someone help us with these crashes? We are not able to recreat=
e it
>>>> on demand, but it takes 30 minutes to a few hours to appear the cr=
ash.
>>>> We've seen it on kernel 3.17.1 and 3.18-rc2.
>>>>
>>>
>>> Hay Adam,
>>>
>>> CC'ing target-devel mailing list (where iser target is maintained).
>>>
>>> So I stepped on this issue as well, and I actually have a fix for i=
t
>>> in the pipe. I'm planning to test it with a few other fixes for a l=
ittle
>>> while longer before I submit the code.
>>>
>>> In general, This crash occurs due to a race between tpg shutdown (o=
r
>>> np disable) and RDMA_CM connect requests happening in parallel. ise=
r
>>> target tries to reference a tpg attribute while the np->tpg_np is
>>> actually NULL.
>>>
>>> How many targets/initiators/portals did you use? HCA?
>>
>> Hi Sagi,
>>
>> There are about 300 targets (lvm volumes), 4 initiators, two portals=
=2E
>>
>> HCA by lspci:
>> 05:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx
>> HCA] (rev 20)
>>          Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx=
 HCA]
>>          Flags: bus master, fast devsel, latency 0, IRQ 46
>>          Memory at df500000 (64-bit, non-prefetchable) [size=3D1M]
>>          Memory at de800000 (64-bit, prefetchable) [size=3D8M]
>>          Capabilities: [40] Power Management version 2
>>          Capabilities: [48] Vital Product Data
>>          Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable- 64bi=
t+
>>          Capabilities: [84] MSI-X: Enable+ Count=3D32 Masked-
>>          Capabilities: [60] Express Endpoint, MSI 00
>>          Kernel driver in use: ib_mthca
>>
>>
>> root@portal-1:~# mstflint -d 05:00.0 q
>> Image type:      Failsafe
>> FW Version:      1.2.0
>> I.S. Version:    1
>> Device ID:       25204
>> Chip Revision:   A0
>> Description:     Node             Port1            Sys image
>> GUIDs:           0005ad00000c75c8 0005ad00000c75c9 0005ad00000c75cb
>> Board ID:        =EE=8F=AD (MT_0260000002)
>> VSD:             =EE=8F=AD
>> PSID:            MT_0260000002
>>
>>
>> root@portal-2:~# mstflint -d 05:00.0 q
>> Image type:      Failsafe
>> I.S. Version:    1
>> Chip Revision:   A0
>> Description:     Node             Port1            Sys image
>> GUIDs:           0005ad00000c7010 0005ad00000c7011 0005ad00000c7013
>> Board ID:        =EE=8F=AD (MT_0260000002)
>> VSD:             =EE=8F=AD
>> PSID:            MT_0260000002
>>
>>
>>> Would it be possible to send you some patches to test as well?
>>
>> Absolutely, we can immediately test any patch on any kernel version.
>>
>> Thanks
>> Adam
>
>
> The race is supposedly caused by login ddos of initiators that are no=
t
> PI aware - our initiators were running kernels from 3.2 to 3.17.

This bug has nothing to do with the initiators or their awareness to PI=
=2E
The race itself is related to PI though.

> When
> we've upgraded all to kernels > 3.15 new targets seem to be stable.
> However it shows that the race is lurking somewhere as You have point=
ed
> out.

Yea, the race is still there.

I have some patches under testing and need cleaning up before they go o=
n
the mailing list...

> Thank You for the feedback received. Later we will try to prepare a
> testcase that might expose the crash.

I think full target stack unload while lots of initiators are
connected should invoke this race...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
