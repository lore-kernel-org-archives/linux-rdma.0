From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
	offset if RMPP method
Date: Wed, 9 Jun 2010 14:51:38 -0400
Message-ID: <AANLkTikOaHg-NfKDRWKe93gIdxa_PTYJM93Ys9dVzBeC@mail.gmail.com>
References: <20100603134209.GA12225@comcast.net>
	<20100609054341.GK28549@me>
	<AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
	<20100609121036.GC20172@me>
	<AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
	<20100609124848.GE20172@me>
	<AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
	<20100609171516.GI20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609171516.GI20172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 9, 2010 at 1:15 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 11:27 Wed 09 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Wed, Jun 9, 2010 at 8:48 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> > On 08:40 Wed 09 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> I think the use of ib_get_attr_offset is being "overused". I'd ra=
ther
>> >> see this patch used as it is the simplest way to address that rat=
her
>> >> than conditionalize ib_get_attr_offset on the SA attribute or wou=
ld
>> >> you rather see a patch along those lines ?
>> >
>> > I just think that if the assertion is incorrect (and ib_get_attr_o=
ffset()
>> > is generic function) we need to remove this. That is simplest.
>>
>> The downside is that it loses the ability to catch SA records which
>> were not properly padded out.
>
> It is not run-time error, so I don't think that such sort of debuggin=
g
> is a main function of OpenSM.
>
>> It seems like a reasonable tradeoff to
>> me to not set this field on the transmit side when it's going to be
>> ignored on receive (treat it like a reserved field for this case) an=
d
>> keep the ability to catch the SA record issue which has bit the
>> community a number of times.
>
> This will cost in extra code.

Sure; that's the tradeoff. I doubt the code size difference is signific=
ant.

>> The only other approach I see to maintain this is to add an addition=
al
>> calling parameter (allribute ID) to get_attr_offset and then inside
>> check the attribute ID and return 0 for those SA attributes.
>
> Which SA attributes?

Any of the non record ones but AFAIT the only one of those going
through this code is InformInfo.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
