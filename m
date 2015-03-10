From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: replace deprecated ifconfig in doc
Date: Tue, 10 Mar 2015 13:47:02 +0100
Message-ID: <1425991622.3991.5.camel@opteya.com>
References: <20150308163614.1cb3da70@urahara>
	 <1425902790.3991.3.camel@opteya.com> <20150309112932.2dbbdccb@urahara>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150309112932.2dbbdccb@urahara>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 09 mars 2015 =C3=A0 11:29 -0700, Stephen Hemminger a =C3=A9cri=
t :
> On Mon, 09 Mar 2015 13:06:30 +0100
> Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> > Le dimanche 08 mars 2015 =C3=A0 16:36 -0700, Stephen Hemminger a =C3=
=A9crit :
> > > The ifconfig command has been deprecated for many years.
> > > To encourage new users not to continue using it and learning
> > > iproute2; the ifconfig should not be used in examples.
> > >=20
> > > Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
> > >=20
> > >=20
> > > --- a/Documentation/filesystems/nfs/nfs-rdma.txt	2014-09-28 16:27=
:20.393505440 -0700
> > > +++ b/Documentation/filesystems/nfs/nfs-rdma.txt	2015-03-08 16:33=
:21.483985810 -0700
> > > @@ -187,8 +187,10 @@ Check RDMA and NFS Setup
> > >      To further test the InfiniBand software stack, use IPoIB (th=
is
> > >      assumes you have two IB hosts named host1 and host2):
> > > =20
> > > -    host1$ ifconfig ib0 a.b.c.x
> > > -    host2$ ifconfig ib0 a.b.c.y
> > > +    host1$ ip link set dev ib0 up
> > > +    host1$ ip address add dev ib0 a.b.c.x
> > > +    host2$ ip link set dev ib0 up
> >=20
> > I don't think we need to "up" the device twice.
>=20
> You need to do it on each host.
>=20

Oops, missed that. Sorry.

> > > +    host2$ ip address add dev ib0 a.b.c.y
> > >      host1$ ping a.b.c.y
> > >      host2$ ping a.b.c.x
> > > =20
> > > @@ -229,7 +231,8 @@ NFS/RDMA Setup
> > > =20
> > >      $ modprobe ib_mthca
> > >      $ modprobe ib_ipoib
> > > -    $ ifconfig ib0 a.b.c.d
> > > +    $ ip li set dev ib0 up
> >=20
> > s/li/link ?
>=20
> ip commands support shorthand.
>=20

Yes, sure, but here, it's looking more like a typo.
It should be consistent throughout the document.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
