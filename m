From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: OT: netmap - a novel framework for fast packet I/O
Date: Fri, 20 Jan 2012 08:20:17 -0800
Message-ID: <20120120082017.2a757283.weiny2@llnl.gov>
References: <1326991841.18772.42.camel@deela.quest-ce.net>
	<29D9DD00-7E2F-4A9D-B712-E180868DD4E2@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29D9DD00-7E2F-4A9D-B712-E180868DD4E2-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 20 Jan 2012 06:18:44 -0800
"Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org> wrote:

> Interesting. It totally hijacks the NIC; all traffic is captured. You=
 would have to implement your own IP stack, Verbs stack, etc.
>=20

Can multiple user space processes share the card?  If so, how is securi=
ty handled between them?

Ira

> Scott
>=20
> On Jan 19, 2012, at 11:50 AM, Yann Droneaud wrote:
>=20
> > Hi,
> >=20
> > I have discovered today the netmap project[1] through an ACM Queue
> > article[2].
> >=20
> > Netmap is a new interface to send and receive packets through an
> > Ethernet interface (NIC). It seems to provide a raw access to netwo=
rk
> > interface in order to process packets at high rate with a low overh=
ead.
> >=20
> > This is an another example of "kernel-bypass"/"zero-copy" which are=
 core
> > features of InfiniBand verbs/RDMA.
> >=20
> > But unlike InfiniBand verbs/RDMA, Netmap seems to have a very small=
 API.
> >=20
> > Such API could be enough to build an unreliable datagram messaging
> > system on "low cost" hardware (without concerns of determinism, flo=
w
> > control, etc.).
> >=20
> > I'm asking myself if the way netmap exposes internal NIC rings coul=
d be
> > applicable for IB/IBoE HCA ? e.g. beyond 10GbE NIC, is netmap relev=
ant ?
> >=20
> > Regards.
> >=20
> > [1] http://info.iet.unipi.it/~luigi/netmap/
> >=20
> > netmap - a novel framework for fast packet I/O
> > Luigi Rizzo Universit=E0 di Pisa
> >=20
> > [2] http://queue.acm.org/detail.cfm?id=3D2103536
> >=20
> > Revisiting Network I/O APIs: The netmap Framework=20
> > Luigi Rizzo, 2012-01-17 =20
> >=20
> > --=20
> > Yann Droneaud
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
