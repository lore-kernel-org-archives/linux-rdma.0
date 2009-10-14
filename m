From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_updn.c: Reduce temporary allocation of
	cas_per_sw
Date: Wed, 14 Oct 2009 10:36:20 -0400
Message-ID: <f0e08f230910140736i6b8f83ecl7dcd78d8c0b392f8@mail.gmail.com>
References: <20091014131435.GA23890@comcast.net> <20091014132911.GB13830@me>
	 <f0e08f230910140633i43bd7648w1feba7c2be6c0d11@mail.gmail.com>
	 <20091014143423.GC13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091014143423.GC13830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 10:34 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 09:33 Wed 14 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Wed, Oct 14, 2009 at 9:29 AM, Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
>> > On 09:14 Wed 14 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> Also, combine malloc/memset into calloc
>> >
>> > Any special reason for malloc/calloc change?
>>
>> It's a little more concise and efficient to calloc rather than
>> malloc/memset.
>
> Why do you think so? Normally calloc() is malloc() + memset() - you
> just get extra call and extra check.
>
>> Any reason not to do this ?
>
> Above.
>
> calloc() can be nicer in some cases and pretty common, feel free to u=
se
> it when appropriate. But I don't think that we need to make a global
> malloc() -> calloc() conversion without any good reason.

The generated code is slightly smaller.

What do you consider appropriate/good reason ?

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
