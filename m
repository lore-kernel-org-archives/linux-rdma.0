From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: merge SL2VL mapping capability check
Date: Mon, 25 Jan 2010 15:19:16 -0500
Message-ID: <f0e08f231001251219m7eba67a4x1006051bc2c21db3@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100104170141.GK26940@me>
	 <f0e08f231001070538q78453f91kd47c931087dfa735@mail.gmail.com>
	 <20100112103517.GI26089@me>
	 <f0e08f231001131213r4a743d6boc1b07e9fadc773ac@mail.gmail.com>
	 <20100116202759.GA574@me>
	 <f0e08f231001230425j28ced479if608a75bb4216186@mail.gmail.com>
	 <20100125152018.GO13519@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100125152018.GO13519@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 25, 2010 at 10:20 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 07:25 Sat 23 Jan =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> It does. There's a requirement that SL2VL mapping is required whe=
n VLCap > 1.
>> >
>> > Correct, I found it in o7-4. Basically we can check both (now afte=
r
>> > switch/endport separation in the code this should be easier), but =
I
>> > would prefer to understand better an issue (if we have) first.
>> >
>> > Also same o7-4 is applicable to CA and router ports.
>>
>> I see no mention of CA and router ports in o7-4.
>
> This is the point. o7-4 is not limited by switch ports.
>
>> What are you
>> referring to here ?
>
> This was the question, why such capability check should be (was)
> ideologically different for CA ports? If 'VLCap > 1' is significant
> capability indication for switch ports this should be the same
> interpretation with CA and router ports.

The difference is due to capability mask being valid for CA and router
ports and only valid for switch port 0. Later on (at IBA 1.2.1), we
came back and said for switch external ports they were the same as
switch port 0 which was how footnote (b) came to be added but I'm not
sure about relying on the conformance to this.

-- Hal

>
>>
>> > Do you know why
>> > was VLCap > 1 condition ignored there?
>>
>> Where is the "there" that you are referring to above ?
>
> not switch ports.
>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
