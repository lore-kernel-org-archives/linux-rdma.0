From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: OT: netmap - a novel framework for fast packet I/O
Date: Thu, 19 Jan 2012 17:50:41 +0100
Message-ID: <1326991841.18772.42.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have discovered today the netmap project[1] through an ACM Queue
article[2].

Netmap is a new interface to send and receive packets through an
Ethernet interface (NIC). It seems to provide a raw access to network
interface in order to process packets at high rate with a low overhead.

This is an another example of "kernel-bypass"/"zero-copy" which are cor=
e
features of InfiniBand verbs/RDMA.

But unlike InfiniBand verbs/RDMA, Netmap seems to have a very small API=
=2E

Such API could be enough to build an unreliable datagram messaging
system on "low cost" hardware (without concerns of determinism, flow
control, etc.).

I'm asking myself if the way netmap exposes internal NIC rings could be
applicable for IB/IBoE HCA ? e.g. beyond 10GbE NIC, is netmap relevant =
?

Regards.

[1] http://info.iet.unipi.it/~luigi/netmap/

netmap - a novel framework for fast packet I/O
Luigi Rizzo Universit=C3=A0 di Pisa

[2] http://queue.acm.org/detail.cfm?id=3D2103536

Revisiting Network I/O APIs: The netmap Framework=20
Luigi Rizzo, 2012-01-17 =20

--=20
Yann Droneaud


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
