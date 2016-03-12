From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA power failure write atomicity
Date: Fri, 11 Mar 2016 20:14:40 -0500
Message-ID: <CADPSxAh-Fn8cHekiXeBa6+1rNDM=N0y5wQHDFtM4BxxH0wjzBg@mail.gmail.com>
References: <56E20734.4030208@vlnb.net>
	<0E25BAE6-9091-4B28-A2A9-2F41BD97145A@gmail.com>
	<56E36247.7060605@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E36247.7060605-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are several factors that make this problem hard. For many modern
servers, DMA data is written to last level cache via DDIO, i.e., it
will not go to the NVDIMM unless the remote CPU flushes the cache /
cache lines. On servers where data is written to DRAM (or to an NVDIMM
attached to memory bus), the data can (probably) still be buffered by
the CPU's memory controller.

I am not sure how much control RDMA NICs have over these factors.
AFAIK, there is no PCIe command to flush either cache lines or memory
controller buffers, so flushing to DRAM this is beyond what RDMA NICs
can currently accomplish.

--Anuj (rdma_guy)

On Fri, Mar 11, 2016 at 7:26 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> w=
rote:
> I'm aware of this proposal. Unfortunately, it is quite orthogonal to =
my question,
> because it is about how to ensure persistence of RDMA writes. Atomici=
ty it is
> mentioning as well as general RDMA atomicity is atomicity with regard=
 of parallel
> commands acting on the same locations. However, I'm asking about powe=
r failure
> atomicity, which is something different.
>
> For instance, you are doing RDMA WRITE of 10 bytes of data. If a powe=
r failure happen
> while this operation is in progress, what data will end up on the tar=
get location? All
> 10 bytes new? All 10 bytes old? Or mix of 5 bytes new and five bytes =
old? Power failure
> atomicity I mean is guarantee that the data either old, or new, never=
 mix of old and
> new data.
>
> Thanks,
> Vlad
>
> Asgeir Eiriksson wrote on 03/10/2016 05:33 PM:
>> Vladislav,
>>
>> This is an area of active R&D
>>
>> You might be interested in the following (at ietf.org):
>>
>> Title           : RDMA Durable Write Commit
>>         Authors         : Tom Talpey
>>                                Jim Pinkerton
>>                           <>
>>       Filename      : draft-talpey-rdma-commit-00.txt
>>       Pages          : 24
>>       Date            : 2016-02-19
>>
>> Regards,
>>
>> =E2=80=98Asgeir
>>
>>
>>> On Mar 10, 2016, at 3:45 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> w=
rote:
>>>
>>> Hello,
>>>
>>> I'm currently considering to use NVDIMM behind RDMA and wonder what=
 is RDMA power
>>> failure write atomicity? I mean, what is minimal size and alignment=
 guaranteed to be
>>> written atomically in face of power failure (or some other similar =
failure), i.e.
>>> either written in full, or not written at all?
>>>
>>> For memory writes on Intel it is 8 bytes with 8 bytes alignment. Is=
 there anything like
>>> this for RDMA? Or different vendors/implementation have so differen=
t expectations and
>>> promises, so you can not assume anything >1 byte?
>>>
>>> I can't find such info anywhere.
>>>
>>> Thanks,
>>> Vlad
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
