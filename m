From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Fri, 3 Apr 2015 08:39:44 +0000
Message-ID: <1428050408201.35668@mellanox.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
	 <1427992506.22575.80.camel@opteya.com>
	 <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>,<1428007208.22575.104.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428007208.22575.104.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday, April 2, 2015 11:40 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m> wrote:
> Le jeudi 02 avril 2015 =E0 16:44 +0000, Shachar Raindel a =E9crit :
>> > -----Original Message-----
>> > From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
>> > Sent: Thursday, April 02, 2015 7:35 PM
>=20
>> > Another related question: as the large memory range could be regis=
tered
>> > by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAND)=
,
>> > what's prevent the kernel to map a file as the result of mmap(0, .=
=2E.)
>> > in this  region, making it available remotely through IBV_WR_RDMA_=
READ /
>> > IBV_WR_RDMA_WRITE ?
>> >
>>
>> This is not a bug. This is a feature.
>>
>> Exposing a file through RDMA, using ODP, can be done exactly like th=
is.
>> Given that the application explicitly requested this behavior, I don=
't
>> see why it is a problem.
>=20
> If the application cannot choose what will end up in the region it ha=
s
> registered, it's an issue !
>=20
> What might happen if one library in a program call mmap(0, size, ...)=
 to
> load a file storing a secret (a private key), and that file ends up
> being mapped in an registered but otherwise free region (afaict, the
> kernel is allowed to do it) ?
> What might happen if one library in a program call call mmap(0,
> size, ..., MAP_ANONYMOUS,...) to allocate memory, call mlock(), then
> write in this location a secret (a passphrase), and that area ends up
> in the memory region registered for on demand paging ?
>=20
> The application haven't choose to disclose these confidential piece o=
f
> information, but they are available for reading/writing by remote
> through RDMA given it knows the rkey of the memory region (which is a
> 32bits value).
>=20
> I hope I'm missing something, because I'm not feeling confident such
> behavor is a feature.

What we are aiming for is the possibility to register the entire proces=
s' address=20
space for RDMA operations (if the process chooses to use this feature).
This is similar to multiple threads accessing the same address space. I=
'm sure=20
you wouldn't be complaining about the ability of one thread to access t=
he secret=20
passphrase mmapped by another thread in your example.

> I'm trying to understand how the application can choose what is expos=
ed
> through RDMA if it registers a very large memory region for later use
> (but do not actually explicitly map something there yet): what's the
> consequences ?
>=20
>    void *start =3D sbrk(0);
>    size_t size =3D ULONG_MAX - (unsigned long)start;
>=20
>    ibv_reg_mr(pd, start, size, IB_ACCESS_ON_DEMAND)

The consequences are exactly as you wrote. Just as giving a non-ODP rke=
y=20
to a remote node allows the node to access the registered memory behind=
 that=20
rkey, giving an ODP rkey to a remote node allows that node to access th=
e=20
virtual address space behind that rkey.

Regards,
Haggai--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
