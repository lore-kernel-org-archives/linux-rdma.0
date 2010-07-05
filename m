From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Mon, 5 Jul 2010 14:30:01 -0400
Message-ID: <AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
References: <4C2312F0.8020308@dev.mellanox.co.il>
	<20100705181143.GG22860@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705181143.GG22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 5, 2010 at 2:11 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 11:10 Thu 24 Jun =C2=A0 =C2=A0 , Yevgeny Kliteynik wrote:
>> Event API should have been able to be used by libraries
>> written both in C and C++.
>
> I don't know about such requirement.

Are you saying it isn't a valid requirement to allow OpenSM plugins to
be C++ based ? If so, why not ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
