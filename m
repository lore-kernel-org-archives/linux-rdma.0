From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Mon, 5 Jul 2010 19:29:52 -0400
Message-ID: <AANLkTinWEuCtSSfVc1Ti0SjgmUl3vnEY-DDd1nkWtlne@mail.gmail.com>
References: <4C2312F0.8020308@dev.mellanox.co.il>
	<20100705181143.GG22860@me>
	<AANLkTilUABmkKA8W-vIVWyTuDR8Gte9jtxmDUL1SiAte@mail.gmail.com>
	<20100705184144.GH22860@me>
	<AANLkTina2lO8M65L465jXjO1ukaAudUO1ZNk8opfKtQc@mail.gmail.com>
	<20100705225227.GI22860@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705225227.GI22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 5, 2010 at 6:52 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 14:49 Mon 05 Jul =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Seems to me like being able to build plugins in C++ would be very
>> useful
>
> For what it should be useful? Any example?

Any management plug in application.

>> and that the remaining issues to accomplish it seem relatively
>> minor. Are you opposed to moving in this direction ?
>
> OpenSM is written in C, not C++, I'm pretty fine with it and don't se=
e
> any reason to get C++ direction.

That's OpenSM but why limit plug in writers to C ?

-- Hal

> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
