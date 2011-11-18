From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 21:29:54 +0000 (GMT)
Message-ID: <1321651794.93443.YahooMailNeo@web24714.mail.ird.yahoo.com>
References: <20111118.011708.677233058349078554.davem@davemloft.net> <20111118.015519.1069441245022002863.davem@davemloft.net> <1321638150.65099.YahooMailNeo@web24701.mail.ird.yahoo.com> <20111118.141246.1415928404544076848.davem@davemloft.net>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111118.141246.1415928404544076848.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:
> From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>

> Date: Fri, 18 Nov 2011 17:42:30 +0000 (GMT)
>=20
>>  I could apply also your second patch to linux-2.6.39.4 manually. So
>>  you don't need to write another version.=A0 Now I'll try to test it
>>  with the new OFED drivers...
>=20
> Thanks for all of your testing so far.

Hello David!

Oh, no! Please don't thank me. That's as if my grandma would have thank=
ed after I've eaten her tasty cake... :)
I thank you and Roland very much for the fast and professional help! Yo=
u did a very good job!
I still can't use OpenMPI over the ConnectX adapter (another error) but=
 that's not for the SPARC list I think.

I think you've eliminated the BUG we talk about. :)
Again: I've applied the patch against 2.6.39.4 manually. I can't say if=
 it also works with linux-3.1.1 because of OFED-1.5.4-rc4 .

Now if I run 'ibv_devinfo' I get no kernel BUG messages anymore and my=20
system doesn't hang if I use one of the ibv_*_pingpong utilities:
---
cluster1:~# ibv_rc_pingpong -n 1000000
=A0 local address:=A0 LID 0x0006, QPN 0x04004e, PSN 0x411c25, GID ::
=A0 remote address: LID 0x0003, QPN 0x0c004a, PSN 0xc6aa3d, GID ::
8192000000 bytes in 19.59 seconds =3D 3345.20 Mbit/sec
1000000 iters in 19.59 seconds =3D 19.59 usec/iter

cluster2:~# ibv_rc_pingpong -n 1000000 cluster1
=A0 local address:=A0 LID 0x0003, QPN 0x0c004a, PSN 0xc6aa3d, GID ::
=A0 remote address: LID 0x0006, QPN 0x04004e, PSN 0x411c25, GID ::
8192000000 bytes in 19.60 seconds =3D 3344.02 Mbit/sec
1000000 iters in 19.60 seconds =3D 19.60 usec/iter
---

BTW: If you need someone in the future for testing a SPARC64 patch - ju=
st write me!

Regards and have a nice weekend,
Lukas


PS: That's the whole conversation:
http://thread.gmane.org/gmane.linux.drivers.rdma/10157
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
