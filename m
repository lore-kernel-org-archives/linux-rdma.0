From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 04 May 2015 12:48:17 -0400
Message-ID: <1430758097.2407.59.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA192@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zfKxktqx6sTsJVfhVNr0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCA192-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-zfKxktqx6sTsJVfhVNr0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 16:42 +0000, Hefty, Sean wrote:

> >  struct ib_port_attr {
> >  	enum ib_port_state	state;
> >  	enum ib_mtu		max_mtu;
> >  	enum ib_mtu		active_mtu;
> >  	int			gid_tbl_len;
> > +	u64                     core_cap_flags;
> >  	u32			port_cap_flags;
> >  	u32			max_msg_sz;
> >  	u32			bad_pkey_cntr;
> > @@ -1684,6 +1705,7 @@ struct ib_device {
> >  	u32			     local_dma_lkey;
> >  	u8                           node_type;
> >  	u8                           phys_port_cnt;
> > +	u64                         *core_cap_flags; /* Per port core
> > capability flags */
>=20
> Why are the core_cap_flags duplicated in the struct and in port attribute=
s?

Because the per port ib_port_attr struct is not visible to the core
code, it must call ib_query_port each time it wants to see it.  In order
to make the helpers avoid a call, you have to stash the cap_flags into
the ib_device struct.  In the past, the only thing there was the
node_type, and it was per device and not per node.  In order to make all
of this work and not require calls into the driver all the time, that
has to change to a per-port array.  Eventually we could get rid of the
node_type element once everything is in place.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-zfKxktqx6sTsJVfhVNr0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR6LRAAoJELgmozMOVy/d8hAP/25vCIzR9ycx8I9BUcX49Vjy
vtH8oX3NXaiUUxGgM/vJAR44L0i6yVJyWexgbVFkh+DrlyVGHPGdsAThSu/eBccI
rLvAZDeEHOM4kL7mRhpB+6v4J/8o6hhuTEcID1WzYsCziSVOUNUwlcj0CYxLgQnZ
/nQTvNXgq3LgXmCp0Ma6yvmDkhxTkSaGAgb10c6lZ7wvC1d3km53Hi+7leYxhxWe
Tl8t7sEREbrtwG7chxQqLne3kIaLJt3gSpsPgbuSy4HNUwIWyDfwO5FoeJP0QEpf
YlkIqBHxbRHUvcJAsAFl2EWBLqIY7evpsFj/N7bCW3Ami3f+m2f/TpwAz4AiZVq9
0IBR/CNRw3JOB/U87VBFpCZPFqptNHTSkDc95nHc4munPootZ30z1p8f5s+8FnXI
5+TmxidST5onXa7qou+jeWaxaBUw+TbAvZjDARCbOt8Yp1Cfui1BwzfLkxz1RELJ
JwqDmZeP3IEsB+H1sUmIpp7BD1LkIY2j9z4Squdi7AfsER4Afn3yjIklwCp1wvzy
JH0QzISujnWjaC4Y2WVRNWg9tsLExt/7oxM42HW1+HN552m86co6yXmCO840ZcOj
kNHRvQRB9v+UcAbyPdJYMhZ3bT1PDNBO/M1uPA6OdoG6gO1YTUeE/F9wXPWvApuv
cBAErY/9H55G/oFC+m92
=k4sr
-----END PGP SIGNATURE-----

--=-zfKxktqx6sTsJVfhVNr0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
