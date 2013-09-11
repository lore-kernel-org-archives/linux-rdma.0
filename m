From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export
 =?UTF-8?Q?ib=5Fcreate/destroy=5Fflow=20through=20uverbs?=
Date: Wed, 11 Sep 2013 17:25:33 +0200
Message-ID: <e6dbae524641d26cbf5613c1adc6d5eb@meuh.org>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
 <1377694075-29287-4-git-send-email-matanb@mellanox.com>
 <1378908269.2258.31.camel@localhost.localdomain>
 <523087CE.4080007@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523087CE.4080007-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 11.09.2013 17:10, Or Gerlitz a =C3=A9crit=C2=A0:
> On 11/09/2013 17:04, Yann Droneaud wrote:
>=20
> [...]
>>> +	int i;
>>> +	int kern_attr_size;
>>> +
>>> +	if (out_len < sizeof(resp))
>>> +		return -ENOSPC;
>>> +
>>> +	if (copy_from_user(&cmd, buf, sizeof(cmd)))
>>> +		return -EFAULT;
>>> +
>>> +	if (cmd.comp_mask)
>>> +		return -EINVAL;
>>> +
>>> +	if ((cmd.flow_attr.type =3D=3D IB_FLOW_ATTR_SNIFFER &&
>>> +	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
>>> +		return -EPERM;
>>> +
>>> +	if (cmd.flow_attr.num_of_specs < 0 ||
>> num_of_specs is unsigned ...
>=20
> sure, will send fix that eliminates this redundant check
>>=20
>>> +	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
>>> +		return -EINVAL;
>>> +
>>> +	kern_attr_size =3D cmd.flow_attr.size - sizeof(cmd) -
>>> +			 sizeof(struct ib_uverbs_cmd_hdr_ex);
>>> +
>> Please, no under/overflow. Check that cmd.flow_attr.size is bigger=20
>> than
>> sizeof(cmd) + sizeof(struct ib_uverbs_cmd_hdr_ex) before computing=20
>> kern_attr_size.
>=20
> We've got feedback on this code from Sean and Roland and Matan Barak
> from our team addressed it to the bit.
> Matan is OOO for couple of days, plus we're having few holidays here.
> This way or another (accepting the comments
> and sending fixes or arguing with you over the list), all your
> feedback will be addressed before 3.12-rc2 is out, thanks for
> looking over this!
>=20

Thanks a lot.

>>=20
>>> +	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
>> just like num_of_specs, it's unsigned !
>=20
> ditto here, will fix.
>=20
> [...]
>=20
> diff --git a/include/uapi/rdma/ib_user_verbs.h
> b/include/uapi/rdma/ib_user_verbs.h
> index 61535aa..0b233c5 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -86,7 +86,9 @@ enum {
>=20
>>> +struct ib_kern_spec {
>>> +	union {
>>> +		struct {
>>> +			__u32 type;
>>> +			__u16 size;
>>> +			__u16 reserved;
>>> +		};
>>> +		struct ib_kern_spec_eth	    eth;
>>> +		struct ib_kern_spec_ipv4    ipv4;
>>> +		struct ib_kern_spec_tcp_udp tcp_udp;
>>> +	};
>>> +};
>>> +
>> [Aside note: no IPv6 spec ?]
>=20
> indeed, but note that the way the specs are defines allow for adding
> future spec types w.o breaking anything,
> its done in TLV (Type-Length-Value) manner, see the change log of the
> IB core main patch  for flow steering
> 319a441 IB/core: Add receive flow steering support
>=20

I've noticed the TLV nature of ib_kern_spec, but a bit too late, so my=20
comments about + 1 and first element being handled differently from the=
=20
others one are rather pointless.

I will try to provide a patch to propose another way of describing the=20
data (same layout) before v3.12 release.
Hopefully I have more time since Linus hard drive broke ;)

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
