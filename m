From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in
 uverbs =?UTF-8?Q?create=5Fflow?=
Date: Tue, 15 Oct 2013 19:07:56 +0200
Message-ID: <f3777e997bd9642e3fd692e59f34486a@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
 <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org>
 <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le 15.10.2013 18:44, Roland Dreier a =C3=A9crit=C2=A0:
> On Tue, Oct 15, 2013 at 7:08 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
=20
> wrote:
>> But, in the mean time, we failed at providing the required=20
>> fixes/cleanups
>> before v3.12-rc5.
>> We have not agreed on a definitive, small, urgent patchset for=20
>> v3.12-rc5.
>> And I think, and it's easy to think so, that Linus will be very upse=
t=20
>> to see
>> more
>> than a couple of patches for the Infiniband subsystem for v3.12-rc6.=
=20
>> If
>> there's a v3.12-rc6.
>>=20
>> So instead of fighting to squeeze the last good patch hunk for v3.12=
,=20
>> we
>> should think
>> on what command/response scheme we need for v3.13.
>=20
> I agree.  So as I said before, I think the best idea is just to
> disable the half-baked command extension stuff before 3.12, and get
> things right for 3.13.
>=20

At least, every voices seems to acknowledge that the current command
extension scheme need some work. But I have the feeling the amount
of work is not known.

> Do you still think the patch you provided to disable the new stuff is=
=20
> good?
>=20

This one : https://patchwork.kernel.org/patch/3015021/

I don't think is good ... adding a bunch of #if 0 / #endif is never=20
good.
But it's smaller than a revert and, perhaps, politically more appealing=
=2E

Regarding the technical details, the kernel compiles without warning.

It was "NACK"'ed by Or Gerlitz who would like to see my improvements=20
applied
ASAP. But in the mean time Matan Barack expressed concerns over the=20
scheme as
it is currently, even with my improvements.

YMMV.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
