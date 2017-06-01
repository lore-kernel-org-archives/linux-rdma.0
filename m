From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Thu, 1 Jun 2017 12:07:42 +0000
Message-ID: <E798E910-E897-4C14-9161-BE1220D412DF@mellanox.com>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
 <20170531194426.GA23120@infradead.org>
 <20170601043013.GN5406@mtr-leonro.local>
 <09d8f6bc-5994-82d1-9a0f-59540b6c525f@synopsys.com>
 <fbb4b7cb-e3e4-b540-22e4-5d920857e8fe@synopsys.com>
 <52727D4A-F647-4924-8DF0-4D7F248626AA@mellanox.com>,<7a4e8dce-f1af-d664-bb0b-062f84b45b60@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7a4e8dce-f1af-d664-bb0b-062f84b45b60-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 1, 2017, at 2:59 PM, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org> wrote:
>=20
> Hi,
>=20
>>=20
>>> After search in /sys I found the mellanox device mlx5_0
>>=20
>>> (/sys/class/infiniband/mlx5_0/) and was able to execute ibstat on it:
>>=20
>>>=20
>>=20
>>> #  ibstat mlx5_0
>>=20
>>> CA 'mlx5_0'
>>=20
>>>       CA type: MT4121
>>=20
>>>       Number of ports: 1
>>=20
>>>       Firmware version: 16.19.21102
>>=20
>>>       Hardware version: 0
>>=20
>>>       Node GUID: 0x248a070300aa8466
>>=20
>>>       System image GUID: 0x248a070300aa8466
>>=20
>>>       Port 1:
>>=20
>>>               State: Down
>>=20
>>>               Physical state: Disabled
>>=20
>>>               Rate: 10
>>=20
>>>               Base lid: 65535
>>=20
>>>               LMC: 0
>>=20
>>>               SM lid: 0
>>=20
>>>               Capability mask: 0x2651e848
>>=20
>>>               Port GUID: 0x248a070300aa8466
>>=20
>>>               Link layer: InfiniBand
>>=20
>>> #
>>=20
>>> #
>>=20
>>> # pwd
>>=20
>>>=20
>>=20
>>> Shouldn't the device be visible in /dev?
>>=20
>> Hi Joao,
>>=20
>>=20
>>=20
>> I'm glad this solved your issue.
>>=20
>> Under dev you will not see Mellanox devices. They are visible only under=
 the sysfs path you found.
>>=20
>> In /dev you might see the mst devices if you have mst running..
>=20
> Thanks for the help Majd! I suggest the driver uses the 0 profile by defa=
ult to
> avoid this kind of meomory problems. What do you think? I can make a patc=
h for
> it if you agree.

I prefer to keep the default 2 which gives the best performance and is the =
more common use case.
We will try to make the driver more resilient and fallback to a lower profi=
le if it can't load with the default one.
>=20
> Thanks.
>=20
>>=20
>>>=20
>>=20
>>> Thanks.
>>=20
>>>=20
>>=20
>>> --
>>=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
>>=20
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>=20
>>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3Dht=
tp-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DDwIGaQ&c=3DDPL6_X_6JkXFx7A=
XWqB0tg&r=3Ds2fO0hii0OGNOv9qQy_HRXy-xAJUD1NNoEcc3io_kx0&m=3DMZ71e2hCV-Ipb5o=
Wcgk4I1Z6_Wd8shDLv1AtVKJPigw&s=3DEvobH0aYP1erS-5GZpBL5Zpabx5LMnEJWTRExwPWSd=
Y&e=3D=20
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
