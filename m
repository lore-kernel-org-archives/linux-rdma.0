From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] IB/core: extended command: add a common extended
 response header
Date: Wed, 09 Oct 2013 13:29:26 +0200
Message-ID: <0d695256ac989e7b1bcccd3a2bfafcbf@meuh.org>
References: <cover.1381177342.git.ydroneaud@opteya.com>
 <9e111d8215c1fd86b75db17f2c890f0f28e0d076.1381177342.git.ydroneaud@opteya.com>
 <5253F37C.90508@mellanox.com> <52553050.8050501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52553050.8050501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 09.10.2013 12:30, Or Gerlitz a =C3=A9crit=C2=A0:
> On 08/10/2013 14:58, Matan Barak wrote:
>> Regarding the last patch, you are right that it simplifies things fo=
r=20
>> creating new uverbs where command parts are in-lined one after=20
>> another, but the infrastructure got a bit more complex.
>>=20
>> If we're going to this direction, I think the we should also deal wi=
th=20
>> the problem of extending one of the command parts. Currently, we'll=20
>> have to put a comp_mask in the in-lined command part, consume this=20
>> command part and then continue with the other parts. It might be=20
>> better than using a pointer, but this put the burden of serializing=20
>> the command buffer into the kernel structures onto the uverb command=
=20
>> writer. We might want to avoid this.
>>=20
>> Furthermore, the comp_mask of the command is different than the=20
>> comp_mask of the response. Therefore, I don't think we should pass t=
he=20
>> command's comp_mask to the uverb as a pointer, but just pass a point=
er=20
>> to value 0 that the uverb will set.
>=20
> Guys, sounds to me it's a bit too late for patch #4 -- we have to
> leave something for the next generation to work on... we're after rc4
> and we don't want to let 3.12 have different uverbs API vs future
> kernel just for the sake of fixing the issues Yan pointed on. I
> suggest that patches 1-3 will go into 3.12 - Roland, are you willing
> to pick this up? We have Matan's ack.
>=20

The other solution is reverting the current patches (22878db, 436f2ad,=20
400dbc9) and continue to work on this subject
for 3.13: I've proposed a slightly different scheme, but it share the=20
same spirit. In the same time I feel like
we haven't find agreement on what is really needed/wanted.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
