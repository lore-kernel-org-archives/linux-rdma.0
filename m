From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Mon, 5 Jul 2010 14:49:12 -0400
Message-ID: <AANLkTina2lO8M65L465jXjO1ukaAudUO1ZNk8opfKtQc@mail.gmail.com>
References: <4C2312F0.8020308@dev.mellanox.co.il>
	<20100705181143.GG22860@me>
	<AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
	<20100705184144.GH22860@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705184144.GH22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 5, 2010 at 2:41 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 14:30 Mon 05 Jul =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Mon, Jul 5, 2010 at 2:11 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> > On 11:10 Thu 24 Jun =C2=A0 =C2=A0 , Yevgeny Kliteynik wrote:
>> >> Event API should have been able to be used by libraries
>> >> written both in C and C++.
>> >
>> > I don't know about such requirement.
>>
>> Are you saying it isn't a valid requirement to allow OpenSM plugins =
to
>> be C++ based ? If so, why not ?
>
> I'm saying that there is no requirement for plugin API to support C++=
 -
> obviously (following method names) plugin API was never developed for
> using it in C++.
>
> Why not is another question - for instance in order to not deal with
> C/C++ compatibility issues (such as castings, function names limitati=
on,
> linking mess, etc.)

Seems to me like being able to build plugins in C++ would be very
useful and that the remaining issues to accomplish it seem relatively
minor. Are you opposed to moving in this direction ?

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
