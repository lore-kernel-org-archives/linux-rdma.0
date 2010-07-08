From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Thu, 8 Jul 2010 09:22:53 -0400
Message-ID: <AANLkTil4EITCrMK2MbCBOYQhfF8wgHL9m1TmPgDJuQo3@mail.gmail.com>
References: <4C2312F0.8020308@dev.mellanox.co.il>
	<20100705181143.GG22860@me>
	<AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
	<20100705184144.GH22860@me>
	<AANLkTina2lO8M65L465jXjO1ukaAudUO1ZNk8opfKtQc@mail.gmail.com>
	<20100705225227.GI22860@me>
	<AANLkTinWEuCtSSfVc1Ti0SjgmUl3vnEY-DDd1nkWtlne@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A116CA8F@orsmsx501.amr.corp.intel.com>
	<adamxu4mtov.fsf@roland-alpha.cisco.com>
	<20100707135825.GK22860@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707135825.GK22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 7, 2010 at 9:58 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 10:00 Tue 06 Jul =C2=A0 =C2=A0 , Roland Dreier wrote:
>>
>> Seems that anyone who cared could already easily write a tiny shim i=
n C
>> and then write the rest of their plugin in C++. =C2=A0Or are there d=
eeper
>> issues than names of methods?
>
> I think that it is likely deeper. For instance if C++ stuff will use
> OpenSM structures, functions, include files, etc.. So this will
> automatically will add some limitations for using normal C in OpenSM
> core code.

Perhaps but are these significant ? AFAIK we been living with them
since the early days of OpenSM.

> I highly suspect that all those "requirements" are resulted by using =
C++
> in some third party's *proprietary* plugs.

It's not just "some third party's "proprietary" plugs."

C++ use has been in open source in OpenFabrics for quite some time now
in ibutils.

Also, since "extern C" has been in the header files since the early
days, there can be many out of tree uses in C++ code.

> Which is fine in general, but
> completely unrelated to OpenSM development - I don't think that we sh=
ould
> care.

IMHO if users want to use C++ with OpenSM related development then we
should and need to care.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
