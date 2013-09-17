From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for rdma_ucm
Date: Tue, 17 Sep 2013 18:13:38 +0300
Message-ID: <523871A2.8010109@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com> <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com> <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com> <97104d76028c356b458509ce95b08c92@meuh.org> <5238289D.40608@mellanox.com> <bcec9d3a9a72ed1d612a4dd49b670800@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bcec9d3a9a72ed1d612a4dd49b670800-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17/9/2013 1:25 PM, Yann Droneaud wrote:
> Hi,
>
> Le 17.09.2013 12:02, Matan Barak a =C3=A9crit :
>>
>> That's right - we're not checking anything here.
>> struct ib_uverbs_qp_attr_ex contains 2 user pointers:
>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>> +       void __user *ah_attr_ex;
>> +       /* represents: struct ib_uverbs_ah_attr_ex * __user */
>> +       void __user *alt_ah_attr_ex;
>>
>> Those pointers should be given to rdma_init_qp_attr in order to
>> initialize them.
>>
>> We are using pointers here in order to maintain future extendability
>> of the address handle structures.
>>
>
> First: you can't put pointer asis in public data structure. Look to a=
ll
> others "command" structures
> declared in include/uapi/rdma/ib_user_verbs.h

Thanks for the review. Looking at other commands, I see that pointers=20
(such a the response) are passed as __u64 at the command structure. Is=20
that what you mean ? I think it's a bit odd to pass those pointers as a=
=20
part of the command, as they are output only attributes. Though, I'll=20
change the code to use __u64 instead of the actual __user pointers.

>
> Second: if you're duplicating struct ib_uverbs_qp_attr, why not inclu=
de
> it in struct ib_uverbs_qp_attr_ex
> it will reduce maintenance burden, clutter, etc.
> Or drop the unused fields in the _ex version while taking care of bei=
ng
> at least equal size than
> the original version.

The extension verbs approach should be an evolution. Instead of using a=
=20
cumbersome extended.basic.field notation, extended.field is more compac=
t=20
and readable. Using this notation will allow us to deprecate the basic=20
structures when they won't be in use anymore.
Since the basic structures shouldn't change anymore as user application=
s=20
relay on them, I don't see a burden in maintainability doing it this wa=
y.

>
> Same apply to struct ib_uverbs_modify_qp_ex, but struct
> ib_uverbs_modify_qp_ex has the comp_mask as first field (introducing =
a
> hole).

We'll add a reserved field to fix this hole. Thanks for that catch!

>
> Regards.
>
Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
