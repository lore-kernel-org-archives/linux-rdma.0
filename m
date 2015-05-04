From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 04 May 2015 12:56:06 -0400
Message-ID: <1430758566.2407.62.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA192@ORSMSX109.amr.corp.intel.com>
	 <1430758097.2407.59.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA1D9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-dMNV1+Ef3vzHvPmsjd1+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCA1D9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-dMNV1+Ef3vzHvPmsjd1+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 16:53 +0000, Hefty, Sean wrote:
> > > >  struct ib_port_attr {
> > > >  	enum ib_port_state	state;
> > > >  	enum ib_mtu		max_mtu;
> > > >  	enum ib_mtu		active_mtu;
> > > >  	int			gid_tbl_len;
> > > > +	u64                     core_cap_flags;
> > > >  	u32			port_cap_flags;
> > > >  	u32			max_msg_sz;
> > > >  	u32			bad_pkey_cntr;
> > > > @@ -1684,6 +1705,7 @@ struct ib_device {
> > > >  	u32			     local_dma_lkey;
> > > >  	u8                           node_type;
> > > >  	u8                           phys_port_cnt;
> > > > +	u64                         *core_cap_flags; /* Per port core
> > > > capability flags */
> > >
> > > Why are the core_cap_flags duplicated in the struct and in port
> > attributes?
> >=20
> > Because the per port ib_port_attr struct is not visible to the core
> > code, it must call ib_query_port each time it wants to see it.  In orde=
r
> > to make the helpers avoid a call, you have to stash the cap_flags into
> > the ib_device struct.  In the past, the only thing there was the
> > node_type, and it was per device and not per node.  In order to make al=
l
> > of this work and not require calls into the driver all the time, that
> > has to change to a per-port array.  Eventually we could get rid of the
> > node_type element once everything is in place.
>=20
> I understand why they are in struct ib_device, but why are they duplicate=
d in struct ib_port_attr?

Because ib_query_port returns a struct, so this must be an element of
that struct or it can't be returned (without adding a new, single use
driver upcall).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-dMNV1+Ef3vzHvPmsjd1+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR6SmAAoJELgmozMOVy/dxAAP/11jiMj7RqY2xY35OTUwiseR
e5fSrKkE6JZNCnpI2oa3C6Su/7oR+7I2aDN8XCqm/nWSPczDiJiO8qsqkmTcNrb0
n2RYch9hkY6pl2UjHh/Vo36BetwB6/1YsijvQXhsLzpbhtElHBeVZllwxrfaDnLH
x375uONOMaFY6vsmKv36kei6TanjBOf1AQl+Yr5cZ6R7bjqxdCT1+EEVnpaEJPjw
3zulc7f3tluDwHYsEV6F8vZI1SKjxWDmI3P2WXodIN4g2c4Y4kdnZS6lPt9LsnJ7
BNLny9HU+rwAWLCzr1VZc14qQiPzwu1gJfpKCvECm25+2LxXhhIyXBcE4gX4yFa3
6eytHsDvU40M/FoXZgoYvQhwzDvRKqq6YxRMIgEoDkDyXoG41ojUEo0N5eTsYIzf
S1Lfg/VmU2fKRbErXctTPE3Y8399KaTBHSF0dpkBTjL7Kn+QmSDlRD+RFkfvsjgr
Acv4Ps0vBnieQPPasM6hWevuH8c+u9Vllrz5g8aoNeBVyQ+6daLAhjq9kvaA3fot
itEFzFAI8VbrMf477MIjajBNgQQ/brreksg+nSXEha3G7yQwYhjo+GMyvZ1jgBOS
OPzBfVrUxDHF4xj2U6jI6eps5dvYN4MRsLcniFiJcudLV41yuKp8oOzUClbQTYeo
ygBXFxpyW8Oz4kTYuT1s
=l5b+
-----END PGP SIGNATURE-----

--=-dMNV1+Ef3vzHvPmsjd1+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
