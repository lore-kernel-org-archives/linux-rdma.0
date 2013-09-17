From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for =?UTF-8?Q?rdma=5Fucm?=
Date: Tue, 17 Sep 2013 17:43:49 +0200
Message-ID: <8bb85d86eca247afa5786b7c7e4c737a@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com>
 <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com>
 <97104d76028c356b458509ce95b08c92@meuh.org> <5238289D.40608@mellanox.com>
 <bcec9d3a9a72ed1d612a4dd49b670800@meuh.org> <523871A2.8010109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523871A2.8010109-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 17.09.2013 17:13, Matan Barak a =C3=A9crit=C2=A0:
> On 17/9/2013 1:25 PM, Yann Droneaud wrote:
>> Hi,
>>=20
>> Le 17.09.2013 12:02, Matan Barak a =C3=A9crit :
>>>=20
>>> That's right - we're not checking anything here.
>>> struct ib_uverbs_qp_attr_ex contains 2 user pointers:
>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>> +       void __user *ah_attr_ex;
>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>> +       void __user *alt_ah_attr_ex;
>>>=20
>>> Those pointers should be given to rdma_init_qp_attr in order to
>>> initialize them.
>>>=20
>>> We are using pointers here in order to maintain future extendabilit=
y
>>> of the address handle structures.
>>>=20
>>=20
>> First: you can't put pointer asis in public data structure. Look to=20
>> all
>> others "command" structures
>> declared in include/uapi/rdma/ib_user_verbs.h
>=20
> Thanks for the review. Looking at other commands, I see that pointers
> (such a the response) are passed as __u64 at the command structure.

Indeed. So that 32bits and 64bits binaries use the same layout.

> Is that what you mean ? I think it's a bit odd to pass those pointers=
=20
> as
> a part of the command, as they are output only attributes. Though,
> I'll change the code to use __u64 instead of the actual __user
> pointers.
>=20

How can those pointers be output parameters ? Does kernel allocate some=
=20
pages
and putting the addresses of those in the ah_attr_ex and alt_ah_attr_ex=
=20
pointers ?

I don't buy the "maintain future extendability" argument for such=20
specific cruft.
It's not enough generic to fall in the extensible pattern.

>>=20
>> Second: if you're duplicating struct ib_uverbs_qp_attr, why not=20
>> include
>> it in struct ib_uverbs_qp_attr_ex
>> it will reduce maintenance burden, clutter, etc.
>> Or drop the unused fields in the _ex version while taking care of=20
>> being
>> at least equal size than
>> the original version.
>=20
> The extension verbs approach should be an evolution. Instead of using
> a cumbersome extended.basic.field notation, extended.field is more
> compact and readable. Using this notation will allow us to deprecate
> the basic structures when they won't be in use anymore.
> Since the basic structures shouldn't change anymore as user
> applications relay on them, I don't see a burden in maintainability
> doing it this way.
>=20

Oh ... I'm waiting to see qp_attr being deprecated</sarcasm>

>>=20
>> Same apply to struct ib_uverbs_modify_qp_ex, but struct
>> ib_uverbs_modify_qp_ex has the comp_mask as first field (introducing=
 a
>> hole).
>=20
> We'll add a reserved field to fix this hole. Thanks for that catch!
>=20

Why not putting that field after the struct ib_uverbs_modify_qp field ?
(even if I don't like the comp_mask things, I waiting for a real world=20
example).

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
