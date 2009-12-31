From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
	received from network
Date: Thu, 31 Dec 2009 09:48:45 -0500
Message-ID: <f0e08f230912310648m4b03b9bdq92394a61866f0e26@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20091229150528.GV26940@me>
	 <20091229150735.GX26940@me>
	 <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
	 <20091230162745.GZ26940@me>
	 <f0e08f230912300856v188d5900u9d82c94f5f9ae4a6@mail.gmail.com>
	 <20091230194335.GB26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091230194335.GB26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 30, 2009 at 2:43 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:56 Wed 30 Dec =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Yes but why would SMA mess up attribute modifier though ?
>
> How could I know? :)
>
>> So is this
>> just detecting OpenSM bug with AM ?
>
> It is not for OpenSM internal bugs detecting. It is "don't trust to
> information from a network", in this specific case attribute modifier
> elements are used as pointers indexes (sl2vl tables),

Yes, I noticed that but...

> so OpenSM don't need to crash due to broken SMAs or other sort of att=
ack.

I thought this was only done when these issues are actually found and
in general we are relying on compliance. Is there a specific known
issue here ?

If we are worrying about this as a general principle, there are more
places to bullet proof like this. I am wondering about why the
exception here.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
