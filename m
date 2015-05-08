From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Fri, 08 May 2015 14:56:52 -0400
Message-ID: <1431111412.2407.463.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-QEeV/HfIEbjfKiDzgnaE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-QEeV/HfIEbjfKiDzgnaE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 19:27 +0000, Liran Liss wrote:
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>=20
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> > >
> > > In accordance with what we've been talking about, drop IBOE for ROCE.
> > >
> > > Drop the UDP off of USNIC, then define a bit for CAP_PROT_UDP_ENCAP.
> > > USNIC will be just USNIC, USNIC_UDP will be USNIC | UDP_ENCAP, ROCE v=
1
> > > will be ROCE, and ROCEv2 will be ROCE | UDP_ENCAP.
> >=20
> > USNIC_UDP is just UDP.  I don't understand why we would want 'USNIC |
> > UDP_ENCAP', or what UDP_ENCAP is intended to convey.  Nothing is being
> > encapsulated.
> >=20
>=20
> I agree that the UDP_ENCAP notion is confusing.
> We should stick to ROCE_V1 and ROCE_V2.
>=20
> > RoCEv2 is IB transport over UDP.
> >=20
> > I'm not sure what the protocol field is intended to imply.  If we want =
to
> > expose the link, network, transport, and RDMA protocols in use, shouldn=
't
> > these be separate fields or bits?  And even then, I'm not sure what use=
 this
> > has for the ULPs.  iWarp does not require Ethernet or TCP.  RoCEv2 woul=
d
> > work fine over any link.  And the core layer should not assume that a d=
evice is
> > limited to supporting only one protocol, especially at the network and
> > transport levels.  I vote for deprecating the protocol goofiness.
> >=20
> > - Sean
>=20
> The protocol notion might not have any value for ULPs, but it is useful f=
or core
> management code. Also, when we extend these notions to user-space, admins=
 will
> actually want to know what wire protocols a certain device can support, e=
ven
> just for the sake of interoperability.

So I've been thinking a bit more about the overall architecture of the
underlying patch set from Michael.  The structure of that patch set is
to a certain extent dictating this follow on patch set and so any
problems in it end up being transmitted here as well.

Sean's comments about transports I think were spot on, and they got me
doing a little thought exercise in my head.

Theoretically, if we were to take the SoftiWARP and SoftRoCE drivers, we
could merge them down to one driver that supported both iWARP and RoCE
(and we could add USNIC too I suspect).  Because all of these things
work on an Ethernet link layer, there is no reason they couldn't all be
presented on the same device.  So if you had a single verbs device that
could support all of these things, where would you need to capture and
store the relevant information?

This is what I have so far:

On a per device basis: not much to be honest, node_type IB_CA/RNIC for
back compatibility and that's pretty much it

On a per port basis: link layer (Ethernet, IB, or OPA).  Notice that I
didn't include the transport here.  Two of the above link layers
strictly imply their transport.  The third link layer could have
multiple transports.  Which brings me to my next level...

On a per queue pair basis: if (link_layer =3D=3D Ethernet) iWARP/RoCE/USNIC
                         if (qp_type =3D=3D RoCE && qp !=3D UD) RoCEv1/RoCE=
v2

On a per ah basis: if (qp_type =3D=3D RoCE && qp =3D UD) RoCEv1/RoCEv2

Michael's patch set was intended to give us a framework within which we
can start cleaning things up.  Once we get to cleaning things up, I
think the above is where we should target storing the relevant
information.

Thoughts?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-QEeV/HfIEbjfKiDzgnaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVTQb0AAoJELgmozMOVy/dIjIP/3Bp2LAsRgYjuzRUVTEcLKlh
u2PQsj+ZjjtkXnHoOfSPArpne+O0JEYG6xDO7HEW3eYwijzLgO2BEPFteWSd3GxY
oBVCpi3u2GR3msasrnnDVHrSj7P0qPVTTfTCfj7qFkxuSWxHgfR8ZrthTo7bEoGm
PZI7xh1iUlAHQrdKLfu4nFr+rqbpr/yBLzglLgQEuO43thgVvQHvjW31JQwdmUwh
NaHstz4G6dXOEC7/xuIOoUeHWqTFsRcOdUECKi/MN2hTfnjI1vXSbzSN7PGuh2jZ
8J+NyFASg8EXWl1x6ppz1SxGl5D950gaXf73LSkDLvHymMz+aVipn84TwSKTyJKq
VVGpVgghgcpGY3FC5mdw5gZu6xKApaJD+Q9nBxsKAKNWGWt5TOUK7Bqhv+A+pKgD
EXgzjDGVPelRmnSZIKbMinAbnDy836jZjKBcmm284BskXGdZo7CO/PJZIgTyc+q+
tqiZ1GZfpOMeuR+I6nTdxdLteq898B1EgarWsHpdHlt0vTWzZ0RQ8U88bXuJtTkM
A5Fsi9Zm992Wn/ft8cPltnaMkejYfPNINYf+0jHODse6O6ytprSbhbVWgcGSwKJS
KYHh+6t3T3hAX38jbtuWoFfiRZ5Rr0YvLhokkFs8CfaZ7SJgZDEiOVZnx8Kn3lGv
N3FNun7WV8bNEDu7mzJm
=zsom
-----END PGP SIGNATURE-----

--=-QEeV/HfIEbjfKiDzgnaE--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
