From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
Date: Wed, 6 Apr 2011 03:10:00 -0700 (PDT)
Message-ID: <98994.25989.qm@web30103.mail.mud.yahoo.com>
References: <70B82AB4096EC24DAE01A7202D27B68B012678C04B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <70B82AB4096EC24DAE01A7202D27B68B012678C04B-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, AndrzejJaszcza <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I really appreciate such a quick support. Thanks a lot. This give me di=
rection to explore some other protocols.

On a side line,
I digged the OFED 1.3 source code mentioned in the site for with SDP te=
st was done for Chelsio adapters.
SDP ULP was not using the FMR pool at that point of time and might have=
 worked because of that.

Now I am using SLES 11 2.27.x kernel version and not sure whether 1.3.x=
 will work straight forward.

Regards,
Parav Pandit


--- On Wed, 4/6/11, Jaszcza, Andrzej <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> From: Jaszcza, Andrzej <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: RE: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
> To: "Andrea Gozzelino" <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Parav Pandit"=
 <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Date: Wednesday, April 6, 2011, 2:43 PM
> Hi,
>=20
> SDP is not officially supported on Intel NetEffect adapters
> at this moment.
>=20
> Thanks,
> Andrzej
>=20
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> On Behalf Of Andrea Gozzelino
> Sent: Wednesday, April 06, 2011 10:53 AM
> To: Parav Pandit
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
>=20
> Hi Parav,
>=20
> I study SDP on NE020 cards from IntelNetEffect in 2010
> without success.
> Please refer to bug 2027 and 2028 on bugzilla.
> You can search on the web discussions with my name in 2010
> related to SDP.
>=20
> I hope that can help you!
> Regards,
> Andrea
>=20
> Andrea Gozzelino
>=20
> PhD Universit=E0 di Padova
> Dipartimento di Fisica Galileo Galilei
> Via Marzolo, 8 - I - 35131 - Padova (PD) - Italia Ufficio @
> Padova: 138
> Tel: +39 049 8277103
>=20
> INFN - Laboratori Nazionali di Legnaro=A0=A0=A0
> (LNL)
> Viale dell'Universita' 2 - I - 35020 - Legnaro (PD)- Italia
> Ufficio @ LNL: E-101
> Tel: +39 049 8068346
> Fax: +39 049 641925
> =A0=A0=A0 =A0=A0=A0=20
>=20
> On Apr 06, 2011 10:06 AM, Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> wrote:
>=20
> > Hi,
> >=20
> > Can anyone please help in running SDP on iWarp
> adapters?
> >=20
> > Sbould I use Neteffect adapter to run SDP or change
> some configuration=20
> > on Chelsio?
> >=20
> > Regards,
> > Parav Pandit
> >=20
> >=20
> > --- On Tue, 4/5/11, Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> wrote:
> >=20
> > > From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > > Subject: Does SDP on Chelsio RNIC in ofed 1.5.2
> work?
> > > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Date: Tuesday, April 5, 2011, 6:44 PM Hi,
> > >=20
> > > I am having Chelsio T310 adapters connected via
> 10G switch in=20
> > > servers using OFED 1.5.2.
> > >=20
> > > I am trying to measure SDP performance over iWarp
> on Chelsio=20
> > > adapters.
> > > but I find below error message from the
> /var/log/messages.
> > >=20
> > > Apr=A0 5 23:28:11 linux kernel: [ 2066.238932]
> eth8:
> > > link up, 10Gbps, full-duplex
> > > Apr=A0 5 23:28:11 linux kernel: [ 2066.240016]
> > > ADDRCONF(NETDEV_CHANGE): eth8: link
> > > becomes ready
> > > Apr=A0 5 23:28:15 linux kernel: [ 2070.629530]
> iw_cxgb3:
> > > Chelsio T3 RDMA Driver -
> > > version 1.1
> > > Apr=A0 5 23:28:15 linux kernel: [ 2070.642134]
> fmr_pool:
> > > Device cxgb3_0 does not
> > > support FMRs
> > > Apr=A0 5 23:28:15 linux kernel: [ 2070.642137]
> Error creating fmr pool=20
> > > Apr=A0 5 23:28:15 linux kernel: [ 2070.642142]
> iw_cxgb3:
> > > Initialized device
> > > 0000:05:00.0
> > > Apr=A0 5 23:28:18 linux kernel: [ 2073.551607]
> > > sdp_post_recv:236 sdp_sock( 3142:2
> > > 41209:0): ib_post_recv failed. status -22
> > >=20
> > > I find some discussion on previous ofed list in
> 2008 about broken=20
> > > support for same.
> > >
> > > http://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg1072=
0.h

> > > tml
> > >=20
> > > Below link seem to calculate the SDP performance
> over Chelsio iWARP.
> > > http://hpc.ufl.edu/benchmarks/iwarp_sdp/

> > >=20
> > > Can anyone please tell me what am I missing? I
> have done SDP=20
> > > configuration from the above link.
> > >=20
> > > Regards,
> > > Parav Pandit
> > >=20
> > >=20
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-rdma"
> > in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info=20
> > at=A0 http://vger.kernel.org/majordomo-info.html

> >=20
>=20
>=20
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
>=20
> Sad Rejonowy Gdansk Polnoc w Gdansku,=20
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
> numer KRS 101882
>=20
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
>=20
> This e-mail and any attachments may contain confidential
> material for
> the sole use of the intended recipient(s). Any review or
> distribution
> by others is strictly prohibited. If you are not the
> intended
> recipient, please contact the sender and delete all
> copies.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
