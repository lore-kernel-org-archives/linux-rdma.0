From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/core: more fixes for create_flow uverbs (for
 v3.12)
Date: Thu, 10 Oct 2013 12:01:48 +0300
Message-ID: <52566CFC.3010802@mellanox.com>
References: <cover.1381351016.git.ydroneaud@opteya.com> <52565F28.8010008@mellanox.com> <f0f946728cbed9458c6b641fe96f241a@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0f946728cbed9458c6b641fe96f241a-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/10/2013 11:32, Yann Droneaud wrote:
> Le 10.10.2013 10:02, Or Gerlitz a =C3=A9crit :
>> On 10/10/2013 00:12, Yann Droneaud wrote:
>>> I've suggested reverting temporarily commit 22878db, 436f2ad, 400db=
c9
>>> for v3.12 in a previous message [1]. This proposition doesn't sound
>>> acceptable for Or.
>>>
>>> So I continue to improve them to be in a better shape for v3.12.
>>
>> Yan, we are 3-4 days before rc5 and as such renaming/beautifying
>> things or removing checks for negative values
>> against unsigned variables et al cleanups are not acceptable. You ne=
ed
>> to re-arrange the series such that ONLY the fixes
>> to the user/kernel API are targeted to 3.12 and appear as the first
>> 2-3 patches, the rest will go to 3.13 subject to review.
>>
>
> It does not only "beautifying" the code: it actually fix it.

IB/core: Rename 'flow' structs to match other uverbs structs
IB/core: Makes uverbs flow structure using names more similar to verbs =
ones
IB/core: Remove checks for negative values in create_flow uverbs

You must agree that these three patches can go to 3.13 -- also, if ther=
e are
other small fixes which do not touch the user/kernel API they can go to=
=20
3.13
too and subject to review into -stable

What you need to prepare for 3.12 are fixes that relate to user/kernel =
API
and are not fixed in the patch Matan sent on Sep 22nd=20
https://patchwork.kernel.org/patch/2924341
and relative to that patch


Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
