From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for rdma_ucm
Date: Wed, 18 Sep 2013 11:40:57 +0300
Message-ID: <52396719.4050809@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com> <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com> <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com> <97104d76028c356b458509ce95b08c92@meuh.org> <5238289D.40608@mellanox.com> <bcec9d3a9a72ed1d612a4dd49b670800@meuh.org> <523871A2.8010109@mellanox.com> <8bb85d86eca247afa5786b7c7e4c737a@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8bb85d86eca247afa5786b7c7e4c737a-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17/9/2013 6:43 PM, Yann Droneaud wrote:
> Le 17.09.2013 17:13, Matan Barak a =C3=A9crit :
>> On 17/9/2013 1:25 PM, Yann Droneaud wrote:
>>> Hi,
>>>
>>> Le 17.09.2013 12:02, Matan Barak a =C3=A9crit :
>>>>
>>>> That's right - we're not checking anything here.
>>>> struct ib_uverbs_qp_attr_ex contains 2 user pointers:
>>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>>> +       void __user *ah_attr_ex;
>>>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>>>> +       void __user *alt_ah_attr_ex;
>>>>
>>>> Those pointers should be given to rdma_init_qp_attr in order to
>>>> initialize them.
>>>>
>>>> We are using pointers here in order to maintain future extendabili=
ty
>>>> of the address handle structures.
>>>>
>>>
>>> First: you can't put pointer asis in public data structure. Look to=
 all
>>> others "command" structures
>>> declared in include/uapi/rdma/ib_user_verbs.h
>>
>> Thanks for the review. Looking at other commands, I see that pointer=
s
>> (such a the response) are passed as __u64 at the command structure.
>
> Indeed. So that 32bits and 64bits binaries use the same layout.
>
>> Is that what you mean ? I think it's a bit odd to pass those pointer=
s as
>> a part of the command, as they are output only attributes. Though,
>> I'll change the code to use __u64 instead of the actual __user
>> pointers.
>>
>
> How can those pointers be output parameters ? Does kernel allocate so=
me
> pages
> and putting the addresses of those in the ah_attr_ex and alt_ah_attr_=
ex
> pointers ?

No, the user allocates them and passes the addresses to the kernel. The=
=20
kernel fills the user-allocated space. It works the exact same way as=20
the response structure.

>
> I don't buy the "maintain future extendability" argument for such
> specific cruft.
> It's not enough generic to fall in the extensible pattern.

I don't see why.
struct inner1 {
	... some fields ...
};
struct inner2 {
	... some fields ...
};
struct outer {
	... some fields ...
	struct inner1 in1;
	struct inner2 in2;
	... some fields ...
};

Now lets say we need to extend inner1 with a new field in its bottom.
If inner1 was inlined, outer memory layout would be changed and we'll=20
get problems with new user <-> old kernel. That's a general problem tha=
t=20
can be solved easily by using:
struct outer {
	... some fields ...
	struct inner1 *in1;
	struct inner2 *in2;
	... some fields ...
};

Since we're using __u64 to pass pointers, instead of struct inner[1-2]*=
=20
we could use __u64. That's ok.
In our case the only usage of in[1-2] is as output parameters. The user=
=20
allocates space only to let the kernel fills it for him.
That's why I think putting it as a part of the response is more appropr=
iate.

>
>>>
>>> Second: if you're duplicating struct ib_uverbs_qp_attr, why not inc=
lude
>>> it in struct ib_uverbs_qp_attr_ex
>>> it will reduce maintenance burden, clutter, etc.
>>> Or drop the unused fields in the _ex version while taking care of b=
eing
>>> at least equal size than
>>> the original version.
>>
>> The extension verbs approach should be an evolution. Instead of usin=
g
>> a cumbersome extended.basic.field notation, extended.field is more
>> compact and readable. Using this notation will allow us to deprecate
>> the basic structures when they won't be in use anymore.
>> Since the basic structures shouldn't change anymore as user
>> applications relay on them, I don't see a burden in maintainability
>> doing it this way.
>>
>
> Oh ... I'm waiting to see qp_attr being deprecated</sarcasm>

Wasn't 386 arch deprecated after ~20 years?

>
>>>
>>> Same apply to struct ib_uverbs_modify_qp_ex, but struct
>>> ib_uverbs_modify_qp_ex has the comp_mask as first field (introducin=
g a
>>> hole).
>>
>> We'll add a reserved field to fix this hole. Thanks for that catch!
>>
>
> Why not putting that field after the struct ib_uverbs_modify_qp field=
 ?
> (even if I don't like the comp_mask things, I waiting for a real worl=
d
> example).

Since every struct starts with u32 comp_mask, I suggest putting require=
d=20
reserved field right after this comp_mask. I've reviewed this case agai=
n=20
and I don't think a reserved field is needed here. The largest field in=
=20
struct ib_uverbs_qp_dest is u32. Hence, the struct will be 32bit=20
aligned. Since struct ib_uverbs_qp_dest shouldn't be changed anymore, a=
s=20
it'll change the memory layout, there's no reason to force struct=20
ib_uverbs_qp_dest to be 64bit aligned.

>
> Regards.
>
Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
