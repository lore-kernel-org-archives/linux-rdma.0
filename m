From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in
 uverbs =?UTF-8?Q?create=5Fflow?=
Date: Thu, 17 Oct 2013 17:29:56 +0200
Message-ID: <80c62f070af55a176923315b3fbb7b0d@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
 <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org>
 <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
 <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg@mail.gmail.com>
 <CAL1RGDW7KwSOmmsRxDokUHR-Mh1OzaQvDege5Rq7JsSU8AgEHQ@mail.gmail.com>
 <525FABA2.6000507@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525FABA2.6000507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Or,

Le 17.10.2013 11:19, Or Gerlitz a =C3=A9crit=C2=A0:
> On 16/10/2013 03:04, Roland Dreier wrote:
>> On Tue, Oct 15, 2013 at 2:34 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=20
>> wrote:
>>> Roland, after applying a small fix which was sent to you by Matan o=
n
>>> Sep 22nd + another tiny fix by Yann to Matan's patch (the two can b=
e
>>> surely squashed into one small patch), things are working OK. Yann =
is
>>> suggesting to enhance them to work and look even better and for som=
e
>>> reasons (life) he didn't get to do that on the 3-4 months the patch=
es
>>> spent on the list and went through review of Sean/Jason/Shawn and y=
ou
>>> (RD). I don't see how/why you use the term half-baked here.
>> Unless I'm misunderstanding, Yann's suggestion for enhancement is no=
t
>> user/kernel ABI compatible with what is in the tree now.  Given that
>> we should really try to find an ABI that lasts for a long time, and
>> that we already have a proposal to improve things, shouldn't we hold
>> off on freezing the new ABI for one more kernel cycle?
>>=20
>>=20
>=20
> Roland,  Yann, the uverbs extensions + flow-steering  patches spent
> many months on the list, once the review started
> we did quick fixes for all the comments and made it for 3.12-rc1 whic=
h
> was delay or two kernel cycles vs. what
> could happen if the feedback was on time (*).
>=20

"On time" is a matter of schedule, and since we don't (all) work
for the same employer, we don't have exact matching priorities.

But more than an agenda, we share the principles of code quality,
maintainability, coherency, usability.

My purpose was not to delay the wide availability of the flow steering
feature. I'm just lazily maintaining a "bound checking" patchset that=20
got
"hit" by the flow steering functions when they entered in -next.
I was not very impressed by the new interface and provided some late
feedback.
Since then, I have more time (spare time between real work and kids) an=
d
focus more on the patches submitted on the list.

But as spare time (kernel) developer, I'm not able to provide as much
valuable contributions as full time kernel developer.

> Indeed since we do want to have ABI that lasts for long, deferring th=
e
> uverbs support for extensions to 3.13 along with
> flow-steering support to user space is something we can live with,
> conditioned on commitment of Yann to quickly submit
> his fixed patches that addresses the issues Matan raised and of you
> (RD) to pick them once Yann and Matan agree
> its done into for-next so they are safe for 3.13
>=20

I can only agree to provide fixed patches for 3.13.

If I could find time and inspiration, I will try to provide
a novel scheme for command expansion that could fulfill the
what was expressed by Matan. But perhaps someone would come with
a better idea.

> Just to double check, by no means we are talking on reverting the
> whole series, flow-steering will be in
> 3.12 in the IB core and mlx4_ib
>=20

I believe it will disable by #if 0 / #endif.
It could be protected by #ifdef=20
CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
instead, but I don't know if it's acceptable practice for such piece of=
=20
code
that should be exposed in its current state.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
