From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/9] IB/core: Includes flow attribute size in uverbs
 =?UTF-8?Q?create=5Fflow?=
Date: Mon, 14 Oct 2013 14:22:12 +0200
Message-ID: <ecbe487703bbfb5fa7376de49b7e619b@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <a83e37e225cd16e5a556b35dcadc7a1234519c2a.1381510045.git.ydroneaud@opteya.com>
 <525BCF21.3090706@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525BCF21.3090706-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 14.10.2013 13:01, Or Gerlitz a =C3=A9crit=C2=A0:
> On 11/10/2013 20:18, Yann Droneaud wrote:
>> In patch "IB/core: clarify overflow/underflow checks on=20
>> ib_create/destroy_flow",
>> the meaning of the size field was modified to only represent
>> the size of the flow_spec appended to the flow_attr structure.
>>=20
>> The size of the flow_attr structure must be added when
>> allocating memory for the whole flow_attr + flow_specs
>> buffer.
>=20
> wait, patch #2 fixes a problem introduced in patch #1? if this is the
> case, why not change patch #1?

You specifically asked me to rebase the patchset against Matan's patch
instead of addressing the issues with my own.

While I do think my patchset was better, I complied and used the=20
aforementioned
patch, but had to add fixes which were implicit with my patchset.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
