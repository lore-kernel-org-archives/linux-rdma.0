From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow
 blocking UD multicast loopback
Date: Thu, 18 Sep 2014 16:03:16 +0300
Message-ID: <541AD814.3040809@mellanox.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>	 <1410700802-27848-2-git-send-email-ogerlitz@mellanox.com>	 <1410799972.7830.25.camel@localhost.localdomain>	 <CAJ3xEMidZpzXaD=ttc5qAWZfX4DPRZxwK9YK6pPPjyDLjFMM7g@mail.gmail.com> <1411025151.7830.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411025151.7830.48.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 9/18/2014 10:25 AM, Yann Droneaud wrote:
> Le lundi 15 septembre 2014 =C3=A0 20:36 +0300, Or Gerlitz a =C3=A9cri=
t :
>> On Mon, Sep 15, 2014 at 7:52 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org=
> wrote:
>>>> --- a/include/uapi/rdma/ib_user_verbs.h
>>>> +++ b/include/uapi/rdma/ib_user_verbs.h
>>>> @@ -470,7 +470,7 @@ struct ib_uverbs_create_qp {
>>>>        __u8  sq_sig_all;
>>>>        __u8  qp_type;
>>>>        __u8  is_srq;
>>>> -     __u8  reserved;
>>>> +     __u8  create_flags;
>>>>        __u64 driver_data[0];
>>>>   };
>>>>
>>> I'm not really happy with the way "reserved" field is used by this
>>> patch: as the field wasn't check for being set to 0, any value coul=
d be
>>> given by userspace (imagine the structure lay on stack). Using it n=
ow
>>> could be dangerous. It must be double checked.
>> We are only allowing user space applications to program certain
>> aspects in the behavior of their own QPs, no risk to the system/kern=
el state.
>>
> I've checked the implementation on the most common userspace code
> accessing the uverbs API, libibverbs, and found the "reserved" field =
is
> explicitely cleared in:
>
> ibv_cmd_create_qp_ex():
>
> c7e3e61052dd7 (Sean Hefty       2013-08-01 18:04:16 +0300  651)      =
   cmd->reserved        =3D 0;
>
> ibv_cmd_create_qp():
>
> 0e0604213ed79 (Roland Dreier    2006-10-04 23:57:10 +0000  726)      =
   cmd->reserved        =3D 0;
>
> Latter commit is part of libibverbs-1.1-rc1, so before libibverbs-1.1=
,
> reserved field was not cleared.
>
> For example, mlx4_create_qp() allocate the ibv_create_qp structure on
> stack and doesn't clear reserved field:
>
> ^d049a1279b82 (Roland Dreier    2007-04-09 00:49:42 -0700 358)  struc=
t mlx4_create_qp     cmd;
>

As  you noted, in libibverbs this field is cleared since 2006 for all=20
use cases of this uverbs command . The libmlx4 code pointer you provide=
d=20
is calling into libibverbs code (ibv_cmd_create_qp) which does the zero=
ing.


> So existing userspace program using libibverbs < 1.1 is likely to bre=
ak with newer kernel if reserved field is going to be used.

as I wrote earlier, not break.

>> We've done it very successfully in the past with adding the link_lay=
er field
>> to struct ib_uverbs_query_port_resp as part of the RoCE story instea=
d of a
>> reserved field.
>>
> ib_uverbs_query_port_resp is the opposite side: the kernel is adding =
stuff
> where older userspace code don't expect to found anything, so this ex=
tra
> information is skipped by such pre-existing program.

yep, the example wasn't 1:1 to this case, understood.

> Using an unused field in the request has more chance to break than us=
ing
> an extra field in the response.
>
> Again:
>
> "Check all unused fields and flags and all the padding for whether it=
's 0,
>   and reject the ioctl if that's not the case. Otherwise your nice pl=
an for
>   future extensions is going right down the gutters since someone wil=
l
>   submit an ioctl struct with random stack garbage in the yet unused =
parts.
>   Which then bakes in the ABI that those fields can never be used for
>   anything else but garbage."
>
> As the "reserved" field was never check for being 0 in kernel side,
> ensuring it could be used in the future for other purpose, we're in
> a situation where "reserved" field is garbage when using older
> libibverbs or other userspace software that can address uverbs
> by-passing libibverbs.
>
> That's likely to break existing userspace application.

Again, applications that for some reason don't zero out this field, wil=
l=20
get their QP to potentially support some features which they will not u=
se.

Or.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
