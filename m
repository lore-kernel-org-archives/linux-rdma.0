From: Adam Mazur <adam.mazur@tiktalik.com>
Subject: Re: CRASH 3.18-rc2, 3.17.1, isert_connect_request
Date: Tue, 04 Nov 2014 09:50:25 +0100
Message-ID: <54589351.1080007@tiktalik.com>
References: <545758C8.4050300@tiktalik.com> <54576696.4000203@dev.mellanox.co.il> <54576C00.7010406@tiktalik.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54576C00.7010406@tiktalik.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

W dniu 03.11.2014 o 12:50, Adam Mazur pisze:
> W dniu 03.11.2014 o 12:27, Sagi Grimberg pisze:
>> On 11/3/2014 12:28 PM, Adam Mazur wrote:
>>> Can someone help us with these crashes? We are not able to recreate=
 it
>>> on demand, but it takes 30 minutes to a few hours to appear the cra=
sh.
>>> We've seen it on kernel 3.17.1 and 3.18-rc2.
>>>
>>
>> Hay Adam,
>>
>> CC'ing target-devel mailing list (where iser target is maintained).
>>
>> So I stepped on this issue as well, and I actually have a fix for it
>> in the pipe. I'm planning to test it with a few other fixes for a li=
ttle
>> while longer before I submit the code.
>>
>> In general, This crash occurs due to a race between tpg shutdown (or
>> np disable) and RDMA_CM connect requests happening in parallel. iser
>> target tries to reference a tpg attribute while the np->tpg_np is
>> actually NULL.
>>
>> How many targets/initiators/portals did you use? HCA?
>
> Hi Sagi,
>
> There are about 300 targets (lvm volumes), 4 initiators, two portals.
>
> HCA by lspci:
> 05:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx
> HCA] (rev 20)
>          Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx =
HCA]
>          Flags: bus master, fast devsel, latency 0, IRQ 46
>          Memory at df500000 (64-bit, non-prefetchable) [size=3D1M]
>          Memory at de800000 (64-bit, prefetchable) [size=3D8M]
>          Capabilities: [40] Power Management version 2
>          Capabilities: [48] Vital Product Data
>          Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable- 64bit=
+
>          Capabilities: [84] MSI-X: Enable+ Count=3D32 Masked-
>          Capabilities: [60] Express Endpoint, MSI 00
>          Kernel driver in use: ib_mthca
>
>
> root@portal-1:~# mstflint -d 05:00.0 q
> Image type:      Failsafe
> FW Version:      1.2.0
> I.S. Version:    1
> Device ID:       25204
> Chip Revision:   A0
> Description:     Node             Port1            Sys image
> GUIDs:           0005ad00000c75c8 0005ad00000c75c9 0005ad00000c75cb
> Board ID:        =EE=8F=AD (MT_0260000002)
> VSD:             =EE=8F=AD
> PSID:            MT_0260000002
>
>
> root@portal-2:~# mstflint -d 05:00.0 q
> Image type:      Failsafe
> I.S. Version:    1
> Chip Revision:   A0
> Description:     Node             Port1            Sys image
> GUIDs:           0005ad00000c7010 0005ad00000c7011 0005ad00000c7013
> Board ID:        =EE=8F=AD (MT_0260000002)
> VSD:             =EE=8F=AD
> PSID:            MT_0260000002
>
>
>> Would it be possible to send you some patches to test as well?
>
> Absolutely, we can immediately test any patch on any kernel version.
>
> Thanks
> Adam


The race is supposedly caused by login ddos of initiators that are not=20
PI aware - our initiators were running kernels from 3.2 to 3.17. When=20
we've upgraded all to kernels > 3.15 new targets seem to be stable.=20
However it shows that the race is lurking somewhere as You have pointed=
=20
out. Thank You for the feedback received. Later we will try to prepare =
a=20
testcase that might expose the crash.

Best,
Adam
