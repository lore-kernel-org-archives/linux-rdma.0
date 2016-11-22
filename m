From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 9/9] selinux: Add a cache for quicker retreival of PKey
 SIDs
Date: Tue, 22 Nov 2016 23:21:12 +0000
Message-ID: <VI1PR0501MB2429BE9BBEB80693B3136F98C4B40@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com>
 <1479843638-67136-10-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1611230948300.3895@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/22/2016 4:53 PM, James Morris wrote:=0A=
> On Tue, 22 Nov 2016, Dan Jurgens wrote:=0A=
>=0A=
>> +static int sel_pkey_sid_slow(u64 subnet_prefix, u16 pkey_num, u32 *sid)=
=0A=
>> +{=0A=
>> +	int ret =3D -ENOMEM;=0A=
>> +	struct sel_pkey *pkey;=0A=
>> +	struct sel_pkey *new =3D NULL;=0A=
>> +	unsigned long flags;=0A=
>> +=0A=
>> +	spin_lock_irqsave(&sel_pkey_lock, flags);=0A=
>> +	pkey =3D sel_pkey_find(subnet_prefix, pkey_num);=0A=
>> +	if (pkey) {=0A=
>> +		*sid =3D pkey->psec.sid;=0A=
>> +		spin_unlock_irqrestore(&sel_pkey_lock, flags);=0A=
>> +		return 0;=0A=
>> +	}=0A=
>> +=0A=
>> +	ret =3D security_pkey_sid(subnet_prefix, pkey_num, sid);=0A=
>> +	if (ret !=3D 0)=0A=
>> +		goto out;=0A=
>> +=0A=
>> +	new =3D kzalloc(sizeof(*new), GFP_ATOMIC);=0A=
>> +	if (!new)=0A=
>> +		goto out;=0A=
>> +=0A=
>> +	new->psec.subnet_prefix =3D subnet_prefix;=0A=
>> +	new->psec.pkey =3D pkey_num;=0A=
>> +	new->psec.sid =3D *sid;=0A=
>> +	sel_pkey_insert(new);=0A=
>> +=0A=
>> +out:=0A=
>> +	spin_unlock_irqrestore(&sel_pkey_lock, flags);=0A=
>> +	if (unlikely(ret))=0A=
>> +		kfree(new);=0A=
>> +=0A=
>> +	return ret;=0A=
> The error handling is messed up here.=0A=
>=0A=
> You'll return 0 on kzalloc failure.=0A=
>=0A=
> Also, if security_pkey_sid fails, you'll attempt to kfree 'new', and you =
=0A=
> don't need an unlikely() in a slow path.=0A=
>=0A=
>=0A=
Right.  I'll remove the if/kfree in the out path completely.  There's no wa=
y ret becomes non-zero after the kzalloc.  If the kzalloc fails I'll still =
have it return 0, the SID retrieved is valid, it just won't be added the ca=
che so returning with an error is overkill.=0A=
=0A=
Thank you for your review.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
