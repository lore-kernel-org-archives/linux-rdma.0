From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: OT: netmap - a novel framework for fast packet I/O
Date: Fri, 20 Jan 2012 09:18:44 -0500
Message-ID: <29D9DD00-7E2F-4A9D-B712-E180868DD4E2@ornl.gov>
References: <1326991841.18772.42.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326991841.18772.42.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Interesting. It totally hijacks the NIC; all traffic is captured. You w=
ould have to implement your own IP stack, Verbs stack, etc.

Scott

On Jan 19, 2012, at 11:50 AM, Yann Droneaud wrote:

> Hi,
>=20
> I have discovered today the netmap project[1] through an ACM Queue
> article[2].
>=20
> Netmap is a new interface to send and receive packets through an
> Ethernet interface (NIC). It seems to provide a raw access to network
> interface in order to process packets at high rate with a low overhea=
d.
>=20
> This is an another example of "kernel-bypass"/"zero-copy" which are c=
ore
> features of InfiniBand verbs/RDMA.
>=20
> But unlike InfiniBand verbs/RDMA, Netmap seems to have a very small A=
PI.
>=20
> Such API could be enough to build an unreliable datagram messaging
> system on "low cost" hardware (without concerns of determinism, flow
> control, etc.).
>=20
> I'm asking myself if the way netmap exposes internal NIC rings could =
be
> applicable for IB/IBoE HCA ? e.g. beyond 10GbE NIC, is netmap relevan=
t ?
>=20
> Regards.
>=20
> [1] http://info.iet.unipi.it/~luigi/netmap/
>=20
> netmap - a novel framework for fast packet I/O
> Luigi Rizzo Universit=E0 di Pisa
>=20
> [2] http://queue.acm.org/detail.cfm?id=3D2103536
>=20
> Revisiting Network I/O APIs: The netmap Framework=20
> Luigi Rizzo, 2012-01-17 =20
>=20
> --=20
> Yann Droneaud
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
