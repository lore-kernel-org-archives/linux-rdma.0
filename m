From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
	received from network
Date: Mon, 4 Jan 2010 14:12:20 -0500
Message-ID: <f0e08f231001041112k4cb7742bwb5ae7cade8704082@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20091229150528.GV26940@me>
	 <20091229150735.GX26940@me>
	 <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
	 <20091230162745.GZ26940@me>
	 <f0e08f230912300856v188d5900u9d82c94f5f9ae4a6@mail.gmail.com>
	 <20091230194335.GB26940@me>
	 <f0e08f230912310648m4b03b9bdq92394a61866f0e26@mail.gmail.com>
	 <20100103170236.GF26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100103170236.GF26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 3, 2010 at 12:02 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 09:48 Thu 31 Dec =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> I thought this was only done when these issues are actually found an=
d
>> in general we are relying on compliance.
>
> OpenSM can rely on compliance in many cases, but it cannot crash (or
> become nonoperational in any other way) relying on compliance.

I think that's fine as a general principle but isn't practical. There
are many cases where OpenSM relies on SMA/PMA/SA client compliance
(without such checking/overhead).

>> Is there a specific known
>> issue here ?
>>
>> If we are worrying about this as a general principle, there are more
>> places to bullet proof like this.
>
> Likely so and it would be good to fix all of them.

Have you done a code review/inspection for such cases ?

>> I am wondering about why the
>> exception here.
>
> It is not exception.

I think there are more unprotected cases than protected ones.

-- Hal

> I found this one, so fixed.

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
