From: =?windows-1252?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 09:49:57 -0400
Message-ID: <2159AA50-F259-4963-BAB3-C300171C37BE@gmail.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com> <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com> <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com> <F0AFA058-856F-48A0-99A1-2FB5398B31B6@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F0AFA058-856F-48A0-99A1-2FB5398B31B6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>>> he queue pairs successfully switch from RESET to INIT, but miserab=
ly fail to switch from INIT to RTR with an EINVAL error code.
>>>=20
>>> On IBoE, are you passing in a path with a global routing info, ie a=
 GID?
>>=20
>> for example, what is the value of
>>=20
>>   qp_attr.ah_attr.is_global
>>=20
>> that you pass into modify_qp for the INIT->RTR transition?
>=20
> I use 0 for is_global, as i am only using a local subnet=85

it looks like this is my problem. Digging into IBoE it looks like it re=
quires a GRH, ego a GID.
I guess I'll have to reformat my code to make it compatible with GRHs.

On a side note, I see from rc_pingpong that ibv_query_gid requires an i=
ndex, and that this index is
asked to the user of the pingpong program. What is that index about (th=
e man page is not very explicit)?
Cannot it be deduced in any way ?

Thanks,
Xavier--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
