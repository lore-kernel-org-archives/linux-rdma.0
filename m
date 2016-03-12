From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: RDMA power failure write atomicity
Date: Fri, 11 Mar 2016 16:26:47 -0800
Message-ID: <56E36247.7060605@vlnb.net>
References: <56E20734.4030208@vlnb.net> <0E25BAE6-9091-4B28-A2A9-2F41BD97145A@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0E25BAE6-9091-4B28-A2A9-2F41BD97145A-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm aware of this proposal. Unfortunately, it is quite orthogonal to my=
 question,
because it is about how to ensure persistence of RDMA writes. Atomicity=
 it is
mentioning as well as general RDMA atomicity is atomicity with regard o=
f parallel
commands acting on the same locations. However, I'm asking about power =
failure
atomicity, which is something different.

=46or instance, you are doing RDMA WRITE of 10 bytes of data. If a powe=
r failure happen
while this operation is in progress, what data will end up on the targe=
t location? All
10 bytes new? All 10 bytes old? Or mix of 5 bytes new and five bytes ol=
d? Power failure
atomicity I mean is guarantee that the data either old, or new, never m=
ix of old and
new data.

Thanks,
Vlad

Asgeir Eiriksson wrote on 03/10/2016 05:33 PM:
> Vladislav,
>=20
> This is an area of active R&D
>=20
> You might be interested in the following (at ietf.org):
>=20
> Title           : RDMA Durable Write Commit
>         Authors         : Tom Talpey
>                                Jim Pinkerton
>                           <>
> 	Filename      : draft-talpey-rdma-commit-00.txt
> 	Pages          : 24
> 	Date            : 2016-02-19
>=20
> Regards,
>=20
> =E2=80=98Asgeir
>=20
>=20
>> On Mar 10, 2016, at 3:45 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
>>
>> Hello,
>>
>> I'm currently considering to use NVDIMM behind RDMA and wonder what =
is RDMA power
>> failure write atomicity? I mean, what is minimal size and alignment =
guaranteed to be
>> written atomically in face of power failure (or some other similar f=
ailure), i.e.
>> either written in full, or not written at all?
>>
>> For memory writes on Intel it is 8 bytes with 8 bytes alignment. Is =
there anything like
>> this for RDMA? Or different vendors/implementation have so different=
 expectations and
>> promises, so you can not assume anything >1 byte?
>>
>> I can't find such info anywhere.
>>
>> Thanks,
>> Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
