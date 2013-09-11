From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 7/9] IB/core: Add RoCE IP based addressing extensions
 for uverbs
Date: Wed, 11 Sep 2013 14:42:00 +0200
Message-ID: <fd7c56e7a7133d969b34e4a00fa6de46@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-8-git-send-email-ogerlitz@mellanox.com>
 <6d494aa8d403e0c50b16f09fbd2c3ab6@meuh.org> <52305632.1030604@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52305632.1030604-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 11.09.2013 13:38, Or Gerlitz a =C3=A9crit=C2=A0:
> On 11/09/2013 13:06, meuh-zgzEX58YAwA@public.gmane.org wrote:
>>> @@ -672,6 +821,15 @@ struct ib_uverbs_create_ah {
>>>      struct ib_uverbs_ah_attr attr;
>>>  };
>>>=20
>>> +struct ib_uverbs_create_ah_ex {
>>> +    __u32 comp_mask;
>>=20
>>=20
>> This create a hole or introduced unaligned access depending on the=20
>> 64bits ABI.
>=20
> Matan is OOO for couple of days, but this seems to me as good catch.
>=20

The way struct ib_uverbs_create_ah_ex encompass struct=20
ib_uverbs_create_ah should be clearer
(explicitly having struct ib_uverbs_create_ah as part of struct=20
ib_uverbs_create_ah_ex ?)

Specifically, I don't like the way pointer math is used to access struc=
t=20
ib_uverbs_create_ah from  struct ib_uverbs_create_ah_ex pointer.

> Anyway, note that the current upstream providers of RoCE (ocrdma,
> mlx4) don't support
> IB_USER_VERBS_CMD_CREATE_AH. This means their user space library need=
=20
> not access
> the kernel for AH creation, we will drop the extended version of the
> this command from
> the patch series altogether to reduce the volume of kernel changes an=
d
> ease with the review, thanks for the feedback so far!
>=20

Thanks for taking time to address my concerns.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
