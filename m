From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for =?UTF-8?Q?rdma=5Fucm?=
Date: Wed, 11 Sep 2013 14:36:00 +0200
Message-ID: <97104d76028c356b458509ce95b08c92@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com>
 <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523054BA.2040608-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 11.09.2013 13:32, Or Gerlitz a =C3=A9crit=C2=A0:
> On 11/09/2013 12:52, Yann Droneaud wrote:
>> Le 10.09.2013 16:41, Or Gerlitz a =C3=A9crit :
>>> +static ssize_t ucma_init_qp_attr_ex(struct ucma_file *file,
>>> +                    const char __user *inbuf,
>>> +                    int in_len, int out_len)
>>> +{
>>> +    struct rdma_ucm_init_qp_attr_ex cmd;
>>> +    struct ib_uverbs_qp_attr_ex resp;
>>> +    struct ucma_context *ctx;
>>> +    struct ib_qp_attr qp_attr;
>>> +    int ret;
>>> +
>>> +    if (out_len < sizeof(resp))
>>> +        return -ENOSPC;
>>> +
>>> +    if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
>>> +        return -EFAULT;
>>> +
>>> +    if (copy_from_user(&resp, (void __user *)(unsigned=20
>>> long)cmd.response,
>>> +               sizeof(resp)))
>>> +        return -EFAULT;
>>> +
>>=20
>>=20
>> Reading from the response buffer ? I haven't seen that before in=20
>> IB/core before.
>=20
> The intent here is to use copy_from_user just to make sure the user=20
> space
> provided buffer has enough room to hold the kernel response structure=
=2E=20
> This
> this command may be extended in the future without bumping the overal=
l
> uverbs ABI
> version we wanted to add this extra protection.

It's checking nothing ... you should not suppose the user having / not=20
having its buffer end
aligned on a page boundary, so that the kernel will detect the end of=20
buffer
when trying to read from it.

BTW, out_len is already checked against resp size ... so I don't=20
understand yet.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
