From: Adam Mazur <adam.mazur-yCD69WgB1YhWk0Htik3J/w@public.gmane.org>
Subject: Re: CRASH 3.18-rc2, 3.17.1, isert_connect_request
Date: Mon, 03 Nov 2014 12:50:24 +0100
Message-ID: <54576C00.7010406@tiktalik.com>
References: <545758C8.4050300@tiktalik.com> <54576696.4000203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54576696.4000203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

W dniu 03.11.2014 o 12:27, Sagi Grimberg pisze:
> On 11/3/2014 12:28 PM, Adam Mazur wrote:
>> Can someone help us with these crashes? We are not able to recreate =
it
>> on demand, but it takes 30 minutes to a few hours to appear the cras=
h.
>> We've seen it on kernel 3.17.1 and 3.18-rc2.
>>
>
> Hay Adam,
>
> CC'ing target-devel mailing list (where iser target is maintained).
>
> So I stepped on this issue as well, and I actually have a fix for it
> in the pipe. I'm planning to test it with a few other fixes for a lit=
tle
> while longer before I submit the code.
>
> In general, This crash occurs due to a race between tpg shutdown (or
> np disable) and RDMA_CM connect requests happening in parallel. iser
> target tries to reference a tpg attribute while the np->tpg_np is
> actually NULL.
>
> How many targets/initiators/portals did you use? HCA?

Hi Sagi,

There are about 300 targets (lvm volumes), 4 initiators, two portals.

HCA by lspci:
05:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx=20
HCA] (rev 20)
         Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx HC=
A]
         Flags: bus master, fast devsel, latency 0, IRQ 46
         Memory at df500000 (64-bit, non-prefetchable) [size=3D1M]
         Memory at de800000 (64-bit, prefetchable) [size=3D8M]
         Capabilities: [40] Power Management version 2
         Capabilities: [48] Vital Product Data
         Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable- 64bit+
         Capabilities: [84] MSI-X: Enable+ Count=3D32 Masked-
         Capabilities: [60] Express Endpoint, MSI 00
         Kernel driver in use: ib_mthca


root@portal-1:~# mstflint -d 05:00.0 q
Image type:      Failsafe
=46W Version:      1.2.0
I.S. Version:    1
Device ID:       25204
Chip Revision:   A0
Description:     Node             Port1            Sys image
GUIDs:           0005ad00000c75c8 0005ad00000c75c9 0005ad00000c75cb
Board ID:        =EE=8F=AD (MT_0260000002)
VSD:             =EE=8F=AD
PSID:            MT_0260000002


root@portal-2:~# mstflint -d 05:00.0 q
Image type:      Failsafe
I.S. Version:    1
Chip Revision:   A0
Description:     Node             Port1            Sys image
GUIDs:           0005ad00000c7010 0005ad00000c7011 0005ad00000c7013
Board ID:        =EE=8F=AD (MT_0260000002)
VSD:             =EE=8F=AD
PSID:            MT_0260000002


> Would it be possible to send you some patches to test as well?

Absolutely, we can immediately test any patch on any kernel version.

Thanks
Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
