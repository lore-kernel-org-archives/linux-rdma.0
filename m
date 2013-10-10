From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: temporarily disable =?UTF-8?Q?create=5Fflow/?=
 =?UTF-8?Q?destroy=5Fflow=20uverbs?=
Date: Thu, 10 Oct 2013 12:12:03 +0200
Message-ID: <5e07fcdfc494de9f83b56336b5c1aefa@meuh.org>
References: <1381396255-13005-1-git-send-email-ydroneaud@opteya.com>
 <525673BB.7020900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525673BB.7020900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 10.10.2013 11:30, Or Gerlitz a =C3=A9crit=C2=A0:
> On 10/10/2013 12:10, Yann Droneaud wrote:
>> create_flow/destroy_flow uverbs are under review and should
>> be considered too experimental at this point.
>>=20
>> To not expose to userspace such experimental feature,
>> the data structure and code is temporarily disabled for v3.12.
>>=20
>> The feature will be enabled after proper cleanup for v3.13.
>=20
> NAK
>=20
> The patches were on the list from April and went through review of
> Sean, Jason, Roland, Shawn and others.
>=20
> You started your review few months after the point in time we
> submitted them, and after they were accepted.
>=20
> We were very happy **and**  responsive for your feedback -- Matan sen=
t
> patch on Sep 22nd to fix few issues you pointed on.
>=20

I'm also very happy and looking forward to continue working with you
so I'm very sorry to provide the reviews so late (back in April I becam=
e
father for the second time).

I'm also very sorry bring such patch now but I feel I won't be able to
find the needed time to do the patchset rework before the deadline.
I will try to do this before the end of the week (12th october) but no=20
promise.

> If you have more point fixes, we're **before** rc5 and 2-3 patches
> that fix things can get it, Matan review your prev
> patchset which contained four patches and acked three of them.
>=20
> So you now need to re-prepare a smaller patch set advocate for Roland
> to pick it up.
>=20

I'm also afraid that the whole patchset with extended command + public=20
API fix
would be too big for v3.12-rc5 ... v3.12.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
