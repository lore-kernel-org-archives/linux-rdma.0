From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Mon, 15 Mar 2010 09:25:37 +0200
Message-ID: <4B9DE0F1.8070000@dev.mellanox.co.il>
References: <20100310155749.GA25964@vlad-laptop> <A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A27E2E88-63A0-45EE-9A70-F95B2A0C25AD-U0mLk4xYmo8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

H=E5kon Bugge wrote:
> Hi Vlad,
>=20
> Did you consider my input in http://www.mail-archive.com/linux-rdma@v=
ger.kernel.org/msg02803.html wrt. to these enhancements?
>=20
> =20
>=20
> Thanks, H=E5kon
>=20

Hi H=E5kon,
ConnectX devices do not support, currently, PCIe atomic operations.

Regards,
Vladimir

> On Mar 10, 2010, at 16:57 , Vladimir Sokolovsky wrote:
>=20
>> Hi Roland,
>>
>> This patchset adds support for the following enhanced atomic
>> operations:
>> - Masked atomic compare and swap
>> - Masked atomic fetch and add
>>
>> These operations enable using a smaller amount of memory when using
>> multiple locks by using portions of a 64 bit value in an atomic
>> operation.
>> For some applications the memory savings are very significant. One
>> example is fine grain lock implementations for huge data sets. In
>> other cases, the benefit is the ability to update multiple fields wi=
th
>> a single io operation.
>>
>> Vladimir Sokolovsky(2):
>> IB/core: Add support for enhanced atomic operations
>> mlx4/IB: Add support for enhanced atomic operations
>>
>> changes from V2:
>> - patch #1:=20
>>  Updated description
>>  Renamed:
>>        IB_WR_ATOMIC_MASKED_CMP_AND_SWP -> IB_WR_MASKED_ATOMIC_CMP_AN=
D_SWP
>>        IB_WR_ATOMIC_MASKED_FETCH_AND_ADD -> IB_WR_MASKED_ATOMIC_FETC=
H_AND_ADD
>>  In the ib_send_wr struct the new fields added before the rkey field
>>
>> - patch #2:
>>  Set IB_DEVICE_MASKED_ATOMIC flag with other flags that get set for
>>  all devices
>>
>> Regards,
>> Vladimir
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> H=E5kon Bugge
> Haakon.bugge-U0mLk4xYmo8@public.gmane.org
> +47 924 84 514
>=20
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
