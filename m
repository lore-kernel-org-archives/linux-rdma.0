From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Mon, 5 Jul 2010 21:41:44 +0300
Message-ID: <20100705184144.GH22860@me>
References: <4C2312F0.8020308@dev.mellanox.co.il>
 <20100705181143.GG22860@me>
 <AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:30 Mon 05 Jul     , Hal Rosenstock wrote:
> On Mon, Jul 5, 2010 at 2:11 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> > On 11:10 Thu 24 Jun =A0 =A0 , Yevgeny Kliteynik wrote:
> >> Event API should have been able to be used by libraries
> >> written both in C and C++.
> >
> > I don't know about such requirement.
>=20
> Are you saying it isn't a valid requirement to allow OpenSM plugins t=
o
> be C++ based ? If so, why not ?

I'm saying that there is no requirement for plugin API to support C++ -
obviously (following method names) plugin API was never developed for
using it in C++.

Why not is another question - for instance in order to not deal with
C/C++ compatibility issues (such as castings, function names limitation=
,
linking mess, etc.)

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
