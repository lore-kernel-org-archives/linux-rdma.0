From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Wed, 2 Jun 2010 11:30:29 -0400
Message-ID: <AANLkTinyMA8WyFPee755nelj9gxJKTP7mQChYlDkUF4J@mail.gmail.com>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
	<4C04F5E7.8030904@dev.mellanox.co.il>
	<20100601192205.GV28549@me>
	<4C057940.1020106@dev.mellanox.co.il>
	<20100602010314.GZ28549@me>
	<4C06084D.3070101@dev.mellanox.co.il>
	<20100602151806.GF28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100602151806.GF28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 2, 2010 at 11:18 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 10:29 Wed 02 Jun =C2=A0 =C2=A0 , Yevgeny Kliteynik wrote:
>>
>> Right now gcc allows you to do implicit casting in both ways, g++ do=
esn't.
>
> OpenSM is written in C, not C++.

g++ can be used as a (better) C compiler. Shouldn't compilation with
g++ be supported ?

-- Hal

>
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
