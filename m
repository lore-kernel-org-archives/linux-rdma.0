From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for =?UTF-8?Q?rdma=5Fucm?=
Date: Wed, 18 Sep 2013 12:07:29 +0200
Message-ID: <698ad99050d7ece7bac8a591e4318f45@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com>
 <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com>
 <97104d76028c356b458509ce95b08c92@meuh.org> <5238289D.40608@mellanox.com>
 <bcec9d3a9a72ed1d612a4dd49b670800@meuh.org> <523871A2.8010109@mellanox.com>
 <8bb85d86eca247afa5786b7c7e4c737a@meuh.org> <52396719.4050809@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52396719.4050809-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 18.09.2013 10:40, Matan Barak a =C3=A9crit=C2=A0:
> On 17/9/2013 6:43 PM, Yann Droneaud wrote:
>> Le 17.09.2013 17:13, Matan Barak a =C3=A9crit :
>>> On 17/9/2013 1:25 PM, Yann Droneaud wrote:
>>>> Hi,
>>>>=20
>>>> Le 17.09.2013 12:02, Matan Barak a =C3=A9crit :
>>>>>=20
>>>>> That's right - we're not checking anything here.
>>>>> struct ib_uverbs_qp_attr_ex contains 2 user pointers:
>>>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>>>> +       void __user *ah_attr_ex;
>>>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>>>> +       void __user *alt_ah_attr_ex;
>>>>>=20
>>>>> Those pointers should be given to rdma_init_qp_attr in order to
>>>>> initialize them.
>>>>>=20
>>>>> We are using pointers here in order to maintain future=20
>>>>> extendability
>>>>> of the address handle structures.
>>>>>=20
>>>>=20
>>>> First: you can't put pointer asis in public data structure. Look t=
o=20
>>>> all
>>>> others "command" structures
>>>> declared in include/uapi/rdma/ib_user_verbs.h
>>>=20
>>> Thanks for the review. Looking at other commands, I see that pointe=
rs
>>> (such a the response) are passed as __u64 at the command structure.
>>=20
>> Indeed. So that 32bits and 64bits binaries use the same layout.
>>=20
>>> Is that what you mean ? I think it's a bit odd to pass those pointe=
rs=20
>>> as
>>> a part of the command, as they are output only attributes. Though,
>>> I'll change the code to use __u64 instead of the actual __user
>>> pointers.
>>>=20
>>=20
>> How can those pointers be output parameters ? Does kernel allocate=20
>> some
>> pages
>> and putting the addresses of those in the ah_attr_ex and=20
>> alt_ah_attr_ex
>> pointers ?
>=20
> No, the user allocates them and passes the addresses to the kernel.
> The kernel fills the user-allocated space. It works the exact same wa=
y
> as the response structure.
>=20

So it's not "odd to pass those pointers as part of the command" :)
The commands structure hold all the information needed to process it.

I've seen that the proposed command has pointers to others user memory=20
buffers
not part of the write() operations ... just like some ucma commands :(

This make the kernel do userspace pointer chasing ... it's not good
from maintainability point of view: it's adding complexity.

>>=20
>> I don't buy the "maintain future extendability" argument for such
>> specific cruft.
>> It's not enough generic to fall in the extensible pattern.
>=20
> I don't see why.
> struct inner1 {
> ... some fields ...
> };
> struct inner2 {
> ... some fields ...
> };
> struct outer {
> ... some fields ...
> struct inner1 in1;
> struct inner2 in2;
> ... some fields ...
> };
>=20
> Now lets say we need to extend inner1 with a new field in its bottom.
> If inner1 was inlined, outer memory layout would be changed and we'll
> get problems with new user <-> old kernel. That's a general problem
> that can be solved easily by using:
> struct outer {
> ... some fields ...
> struct inner1 *in1;
> struct inner2 *in2;
> ... some fields ...
> };
>=20
> Since we're using __u64 to pass pointers, instead of struct
> inner[1-2]* we could use __u64. That's ok.
> In our case the only usage of in[1-2] is as output parameters. The
> user allocates space only to let the kernel fills it for him.
> That's why I think putting it as a part of the response is more=20
> appropriate.
>=20

[ Currently "response" is write only. It's cleaner that way ]

The scheme presented, as I read here, is starting to look like a forest=
=20
of pointers,
a recursive octopus... and I don't like those.

I think of something like NETLINK and IOVEC as a better scheme (quite=20
like a TLV things)
But using such scheme would introduce a new ABI ... and came with its=20
own set of complexity problems.

>>>>=20
>>>> Same apply to struct ib_uverbs_modify_qp_ex, but struct
>>>> ib_uverbs_modify_qp_ex has the comp_mask as first field (introduci=
ng=20
>>>> a
>>>> hole).
>>>=20
>>> We'll add a reserved field to fix this hole. Thanks for that catch!
>>>=20
>>=20
>> Why not putting that field after the struct ib_uverbs_modify_qp fiel=
d=20
>> ?
>> (even if I don't like the comp_mask things, I waiting for a real wor=
ld
>> example).
>=20
> Since every struct starts with u32 comp_mask, I suggest putting
> required reserved field right after this comp_mask. I've reviewed thi=
s
> case again and I don't think a reserved field is needed here. The
> largest field in struct ib_uverbs_qp_dest is u32. Hence, the struct
> will be 32bit aligned. Since struct ib_uverbs_qp_dest shouldn't be
> changed anymore, as it'll change the memory layout, there's no reason
> to force struct ib_uverbs_qp_dest to be 64bit aligned.

Yes you're right.

Perhaps I was thinkig of ib_uverbs_create_ah_ex ?

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
