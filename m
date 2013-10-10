From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/core: more fixes for =?UTF-8?Q?create=5Fflow?=
 =?UTF-8?Q?=20uverbs=20=28for=20v=33=2E=31=32=29?=
Date: Thu, 10 Oct 2013 10:32:35 +0200
Message-ID: <f0f946728cbed9458c6b641fe96f241a@meuh.org>
References: <cover.1381351016.git.ydroneaud@opteya.com>
 <52565F28.8010008@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52565F28.8010008-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 10.10.2013 10:02, Or Gerlitz a =C3=A9crit=C2=A0:
> On 10/10/2013 00:12, Yann Droneaud wrote:
>> I've suggested reverting temporarily commit 22878db, 436f2ad, 400dbc=
9
>> for v3.12 in a previous message [1]. This proposition doesn't sound
>> acceptable for Or.
>>=20
>> So I continue to improve them to be in a better shape for v3.12.
>=20
> Yan, we are 3-4 days before rc5 and as such renaming/beautifying
> things or removing checks for negative values
> against unsigned variables et al cleanups are not acceptable. You nee=
d
> to re-arrange the series such that ONLY the fixes
> to the user/kernel API are targeted to 3.12 and appear as the first
> 2-3 patches, the rest will go to 3.13 subject to review.
>=20

It does not only "beautifying" the code: it actually fix it.
In its current form, the code is not acceptable and should not go in=20
v3.12.

I've made a review of this code but no patch actually fix all the size
computation issues.

http://marc.info/?i=3D1378908269.2258.31.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
http://marc.info/?i=3Dfe9240e87dd3b48d363be6ce8dcac3b3-zgzEX58YAwA@public.gmane.org

Even if I move the "renaming" patches later, the data structure name=20
must
be updated throughout the code, this will make the patchset still a bit=
=20
large
for v3.12-rc5.

I really understand it's too big for v3.12, that's why I've proposed to=
=20
revert
the current code for v3.12 and push all of this in v3.13.

> Also - does git am removes the "Link: yyy" line  you added in your
> patches while applying them? if not, please place
> below the --- line so we will not carry them in the kernel log.
>=20

I've added them on purpose so they are kept in the kernel log.
I'm following a good advice found in comments[1] of
"What's missing from our changelogs" article[2]

[1] http://lwn.net/Articles/560392/
[2] http://lwn.net/Articles/560617/

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
