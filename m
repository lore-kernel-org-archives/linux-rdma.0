From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma_connect() "timeout"
Date: Wed, 18 Jul 2012 19:16:06 +0200
Message-ID: <1342631766.19395.48.camel@test.quest-ce.net>
References: <1342624372.19395.35.camel@test.quest-ce.net>
	 <1828884A29C6694DAF28B7E6B8A8237346A6A5AA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A6A5AA-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 18 juillet 2012 =C3=A0 15:49 +0000, Hefty, Sean a =C3=A9cri=
t :
> > Is there a way to setup the timeout in rdma_connect() ?
>=20
> For IB, the timeout is based on the packet lifetime in the path recor=
d returned by the SA. =20
> The rdma_cm will retry a CM REQ the maximum number of times (15).
> =20

According to the OpenSM default configuration (/usr/sbin/opensm
--create-config <config>) :

  # The subnet_timeout code that will be set for all the ports
  # The actual timeout is 4.096usec * 2^<subnet_timeout>
  subnet_timeout 18

  # The code of maximal time a packet can live in a switch
  # The actual time is 4.096usec * 2^<packet_life_time>
  # The value 0x14 disables this mechanism
  packet_life_time 0x12

Despite the notation, they are the same values.

It gives me:

 4.096 * 10^-6 * 2^18 =3D 1.074 s

 15 * subnet timeout / packet life time =3D 16.106 s ...=20

This is a lot less than 98 s.

Where does come the difference ?

> > Is there a way to change the CM parameters ? e.g. "Service Timeout"=
 to
> > wait for moving from "REP wait" state to "Timeout" state, and the n=
umber
> > of send "REQ" retries (From 12.9.5 "Communication Establishement an=
d
> > Release - Active") ?
>=20
> There is no direct way to change the timeout parameter.  You would ne=
ed to adjust the subnet timeout values at the SA.

Is it subnet_timeout or packet_life_time ?

Thanks for your answers.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
