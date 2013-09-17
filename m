From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export
 =?UTF-8?Q?ib=5Fcreate/destroy=5Fflow=20through=20uverbs?=
Date: Tue, 17 Sep 2013 15:00:03 +0200
Message-ID: <fe9240e87dd3b48d363be6ce8dcac3b3@meuh.org>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
 <1377694075-29287-4-git-send-email-matanb@mellanox.com>
 <1378908269.2258.31.camel@localhost.localdomain>
 <52384C9D.6050900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52384C9D.6050900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 17.09.2013 14:35, Matan Barak a =C3=A9crit=C2=A0:
> On 11/9/2013 5:04 PM, Yann Droneaud wrote:
>> Le mercredi 28 ao=C3=BBt 2013 =C3=A0 15:47 +0300, Matan Barak a =C3=A9=
crit :
>>> From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>=20
>>> Implement ib_uverbs_create_flow and ib_uverbs_destroy_flow to
>>> support flow steering for user space applications.
>>>=20
>>> Change-Id: I0bc6dbe26f4776d00f95b6200ff43ccb24000e31
>>> Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>=20
>> Seen this in linux-next as commit
>> 436f2ad05a0b65b1467ddf51bc68171c381bf844
>>=20

>>=20
>> Please, no under/overflow. Check that cmd.flow_attr.size is bigger=20
>> than
>> sizeof(cmd) + sizeof(struct ib_uverbs_cmd_hdr_ex) before computing
>> kern_attr_size.
>=20
> This introduces code duplication since we check that value and then
> compute it. Since this value has an upper and lower limits and both
> boundaries are checked, why is this problematic ?
>=20

Cause negative value says: "I don't take care of checking bounds:
Checking bound is a thing for pedantic security researchers
who never wrote real code but write poems in reaction to the non-sense
of life"

Please, check user input first, don't miss the chance to catch error=20
early.

>=20
>>=20
>> cmd.flow_attr.size is certainly less then in_len, so you probably me=
an
>> cmd.flow_attr.size > (in_len - sizeof(cmd) - sizeof(struct
>> ib_uverbs_cmd_hdr_ex)).
>=20
> It's not certainly less than in_len, as the user initializes
> cmd.flow_attr.size. Currently, our version of libibverbs place the
> entire command size on cmd.flow_attr.size.
>=20

I would prefer to push out the fixed known size of the command,
and use this size to hold only the sum of the TLV sizes.

Then you can get more information from the .size field.

>>=20
>>> +	    kern_attr_size < 0 || kern_attr_size >
>>> +	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
>>> +		return -EINVAL;
>>> +
>>=20
>> let's make kern_attr_size unsigned.
>=20
> I think that it's not a good idea since we're iterating until we've
> got to num_of_specs or we've got an invalid size in one of the spec
> structures. Since we have an upper limit to kern_attr_size, I don't
> think it's problematic to keep it as int.
>=20

I think it's not a good idea to iterate until the iterator get negative=
=2E
Probably a matter of taste or experience.
If there's an invalid size for TLV, check it before subtract. Not after=
=2E
Otherwise it's not bound checking, it's error recovery.

>>=20
>> And be stricter: kern_attr_size !=3D cmd.flow_attr.num_of_specs *
>> sizeof(struct ib_kern_spec) might be welcome.
>=20
> The structures are TLV, so I can only check upper limit but not the
> exact size without traversing them.
>=20

OK.

>>> diff --git a/include/uapi/rdma/ib_user_verbs.h=20
>>> b/include/uapi/rdma/ib_user_verbs.h
>>> index 61535aa..0b233c5 100644
>>> --- a/include/uapi/rdma/ib_user_verbs.h
>>> +++ b/include/uapi/rdma/ib_user_verbs.h
>>> @@ -86,7 +86,9 @@ enum {
>>=20
>>> +struct ib_kern_flow_attr {
>>> +	__u32 type;
>>> +	__u16 size;
>>> +	__u16 priority;
>>> +	__u8  num_of_specs;
>>> +	__u8  reserved[2];
>>> +	__u8  port;
>>> +	__u32 flags;
>>> +	/* Following are the optional layers according to user request
>>> +	 * struct ib_flow_spec_xxx
>>> +	 * struct ib_flow_spec_yyy
>>> +	 */
>>> +};
>>> +
>>> +struct ib_uverbs_create_flow  {
>>> +	__u32 comp_mask;
>>=20
>> Alignment notice: There's a hole here on 64bits system with stricter
>> alignment rules.
>=20
> Thanks! Do you recommend adding a u32 reserved field ?
>=20

Sure it must be added.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
