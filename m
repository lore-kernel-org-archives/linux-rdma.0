From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Mon, 06 May 2013 10:44:41 +0200
Message-ID: <51876D79.50003@profitbricks.com>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com> <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Vasiliy,

sorry for the late reply! I was ill last week.

The main difference so far is that my patches are much easier to
understand as I don't provide back-porting and also don't put
performance improvements in between the stability fixes. I provide full
test cases + scripts which makes it simple to check if you've got the
expected/same behavior. Everything is straight forward and completely
described in the commit messages.

My work focuses on using ib_srp without the srp_tools. Just fast IO
failing + reconnect. No performance improvements. We gradually find
compromises to get a cool solution. We've e.g. agreed on detecting
connection loss upon the QP timeout only.

Today I'll release our own automatic reconnect.

Sorry Bart, but a reconnect with just the commit message
"IB/srp: Add kernel-level transport layer recovery" and no further
description isn't very trustworthy for me. I also wonder why you need s=
o
much locking.

Cheers,
Sebastian


On 03.05.2013 14:27, Vasiliy Tolstov wrote:
>=20
> 03.05.2013 15:45 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=
=D0=B5=D0=BB=D1=8C "Bart Van Assche" <bvanassche-HInyCGIudOg@public.gmane.org
> <mailto:bvanassche-HInyCGIudOg@public.gmane.org>> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
>>
>> On 04/30/13 09:34, Vasiliy Tolstov wrote:
>>>
>>> What is main difference between bvanassche repo and sriemer ?
>>
>>
>> Good question. As soon as I have the time I will try to find a singl=
e
> approach that works for everyone and post a new patch series for revi=
ew
> on the linux-rdma mailing list such that these can be included in the
> mainline kernel.
>>
>> Bart.
>=20
> Thats very good! Thans! I'm already using 3.8 with you patches and al=
l
> works very stable.
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
