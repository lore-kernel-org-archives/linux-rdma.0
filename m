From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
 offset if RMPP method
Date: Thu, 10 Jun 2010 08:18:00 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E19256345C10B@orsmsx501.amr.corp.intel.com>
References: <20100603134209.GA12225@comcast.net> <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
 <20100609121036.GC20172@me>
 <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
 <20100609124848.GE20172@me>
 <AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
 <20100609171516.GI20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609171516.GI20172@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 11:27 Wed 09 Jun     , Hal Rosenstock wrote:
>> On Wed, Jun 9, 2010 at 8:48 AM, Sasha Khapyorsky
>> <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>>> On 08:40 Wed 09 Jun     , Hal Rosenstock wrote:
>>>>
>>>> I think the use of ib_get_attr_offset is being "overused". I'd
>>>> rather see this patch used as it is the simplest way to address
>>>> that rather than conditionalize ib_get_attr_offset on the SA
>>>> attribute or would you rather see a patch along those lines ?
>>>
>>> I just think that if the assertion is incorrect (and
>>> ib_get_attr_offset() is generic function) we need to remove this.
>>> That is simplest.


The ASSERT() in ib_get_attr_offset() is only valid for the debug case; no runtime impact for the 'normal' build.


>>
>> The downside is that it loses the ability to catch SA records which
>> were not properly padded out.
>
> It is not run-time error, so I don't think that such sort of debugging
> is a main function of OpenSM.
>
>> It seems like a reasonable tradeoff to
>> me to not set this field on the transmit side when it's going to be
>> ignored on receive (treat it like a reserved field for this case) and
>> keep the ability to catch the SA record issue which has bit the
>> community a number of times.
>
> This will cost in extra code.
>
>> The only other approach I see to maintain this is to add an
>> additional calling parameter (allribute ID) to get_attr_offset and
>> then inside
>> check the attribute ID and return 0 for those SA attributes.
>
> Which SA attributes?
>
> Sasha

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
