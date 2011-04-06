From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
Date: Wed, 6 Apr 2011 10:53:29 +0200 (CEST)
Message-ID: <4199273.1302080009059.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <163069.2884.qm@web30104.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <163069.2884.qm-SXRxc0gE9ROvuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Parav,

I study SDP on NE020 cards from IntelNetEffect in 2010 without success.
Please refer to bug 2027 and 2028 on bugzilla.
You can search on the web discussions with my name in 2010 related to
SDP.

I hope that can help you!
Regards,
Andrea

Andrea Gozzelino

PhD Universit=C3=A0 di Padova=20
Dipartimento di Fisica Galileo Galilei
Via Marzolo, 8 - I - 35131 - Padova (PD) - Italia
Ufficio @ Padova: 138
Tel: +39 049 8277103

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 - I - 35020 - Legnaro (PD)- Italia
Ufficio @ LNL: E-101
Tel: +39 049 8068346
=46ax: +39 049 641925
	=09

On Apr 06, 2011 10:06 AM, Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
>=20
> Can anyone please help in running SDP on iWarp adapters?
>=20
> Sbould I use Neteffect adapter to run SDP or change some configuratio=
n
> on Chelsio?
>=20
> Regards,
> Parav Pandit
>=20
>=20
> --- On Tue, 4/5/11, Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Subject: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
> > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Date: Tuesday, April 5, 2011, 6:44 PM
> > Hi,
> >=20
> > I am having Chelsio T310 adapters connected via 10G switch
> > in servers using OFED 1.5.2.
> >=20
> > I am trying to measure SDP performance over iWarp on
> > Chelsio adapters.
> > but I find below error message from the /var/log/messages.
> >=20
> > Apr=C2=A0 5 23:28:11 linux kernel: [ 2066.238932] eth8:
> > link up, 10Gbps, full-duplex
> > Apr=C2=A0 5 23:28:11 linux kernel: [ 2066.240016]
> > ADDRCONF(NETDEV_CHANGE): eth8: link
> > becomes ready
> > Apr=C2=A0 5 23:28:15 linux kernel: [ 2070.629530] iw_cxgb3:
> > Chelsio T3 RDMA Driver -
> > version 1.1
> > Apr=C2=A0 5 23:28:15 linux kernel: [ 2070.642134] fmr_pool:
> > Device cxgb3_0 does not
> > support FMRs
> > Apr=C2=A0 5 23:28:15 linux kernel: [ 2070.642137] Error
> > creating fmr pool
> > Apr=C2=A0 5 23:28:15 linux kernel: [ 2070.642142] iw_cxgb3:
> > Initialized device
> > 0000:05:00.0
> > Apr=C2=A0 5 23:28:18 linux kernel: [ 2073.551607]
> > sdp_post_recv:236 sdp_sock( 3142:2
> > 41209:0): ib_post_recv failed. status -22
> >=20
> > I find some discussion on previous ofed list in 2008 about
> > broken support for same.
> >
> > http://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg10720.=
html
> >=20
> > Below link seem to calculate the SDP performance over
> > Chelsio iWARP.
> > http://hpc.ufl.edu/benchmarks/iwarp_sdp/
> >=20
> > Can anyone please tell me what am I missing? I have done
> > SDP configuration from the above link.
> >=20
> > Regards,
> > Parav Pandit
> >=20
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


					=09

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
