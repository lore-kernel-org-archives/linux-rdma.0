From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/8] uverbs extensions fixes
Date: Wed, 06 Nov 2013 17:51:49 +0100
Message-ID: <2f2cc2c0237e938586f475c2fae187cd@meuh.org>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
 <1383642320.18301.46.camel@localhost.localdomain>
 <5278F143.5070001@mellanox.com> <527A5A20.5050907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527A5A20.5050907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 06.11.2013 16:02, Or Gerlitz a =C3=A9crit=C2=A0:
> On 05/11/2013 15:23, Or Gerlitz wrote:
>> On 05/11/2013 11:05, Yann Droneaud wrote:
>>> Thanks Matan for carrying on the patchset.
>>>=20
>>> I've quite the same patchset, but the other way around, eg. enablin=
g
>>> the flow steering verbs after cleanup on the new ABI. I thought it=20
>>> would
>>> make more sense this way. Would you like me to send the patchset th=
is
>>> way, with my others patches to rename the function, which was dropp=
ed
>>> from my latest attempt in order to squeeze the patchset to bare=20
>>> minimal ?
>>=20
>> good! lets do that asap, please make sure to mark the series as V2 a=
nd=20
>> list the changes from V1 in the cover-letter
>=20
> Yann, again, we have put the patches months ago on this list, your
> initial review comments arrived only after the code was accepted, but
> aligned with them and agreed it would be better to delay the uverbs
> extensions support to 3.13 such that the API is cleaner and more
> robust.
>=20
> Roland, no way we can effort to loose another quarter just b/c Yan  i=
s
> slow to send his final proposed patch series.

Sure I'm a bit late, I was hoping to send it this morning (CET: UTC+01)=
=2E

> We are already into the 3.13 merge window and time is running out.
>=20

Not really, you may have noticed Linus is on vacation, and the 3.13=20
merge
window will be a bit delayed (I've even read "chaotic" somewhere on=20
LWN).

https://lkml.org/lkml/2013/11/3/160
http://lwn.net/Articles/571997/

But I'd like the patchset to be integrated, so that it would appears in
-next as soon as possible.

> Yann, can you send today the V2 series with the two minor comments yo=
u
> had and we agreed addressed?!
>=20

I'm planning to do it later today.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
