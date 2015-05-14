From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/core: Convert management helpers to core
 capability bits
Date: Thu, 14 May 2015 12:31:10 -0400
Message-ID: <1431621070.3276.28.camel@redhat.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
	 <1431561779-13714-6-git-send-email-ira.weiny@intel.com>
	 <5554AE23.3020909@dev.mellanox.co.il>
	 <2807E5FD2F6FDA4886F6618EAC48510E1107E715@CRSMSX101.amr.corp.intel.com>
	 <20150514162654.GA10941@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FlvxRv9oHHgDGh6RNIPF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150514162654.GA10941-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-FlvxRv9oHHgDGh6RNIPF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-14 at 12:26 -0400, ira.weiny wrote:
> On Thu, May 14, 2015 at 04:10:24PM +0000, Weiny, Ira wrote:
> > > >  static inline bool rdma_protocol_ib(struct ib_device *device, u8
> > > > port_num)  {
> > > > -	return device->query_protocol(device, port_num) =3D=3D
> > > RDMA_PROTOCOL_IB;
> > > > +	return device->port_immutable[port_num].core_cap_flags &
> > > > +RDMA_CORE_CAP_PROT_IB;
> > > >  }
> > > >
> > > >  static inline bool rdma_protocol_iboe(struct ib_device *device, u8
> > > > port_num)
> > >=20
> > > Should this helper be renamed rdma_protocol_roce (and change any
> > > consumers of this helper to use that name) ? If so, should it be done=
 in this
> > > patch or follow on patch ?
> > >=20
> >=20
> > I'll create a follow on patch.
> >=20
>=20
> Since we are going down this path perhaps someone can change all the othe=
r iboe
> references.  These counts were after changing the rdma_protocol_* names.
>=20
> 12:24:45 > grep -r iboe drivers/infiniband/ | grep -v Binary | wc -l
> 123
>=20
> 12:24:51 > grep -r iboe include/rdma | grep -v Binary | wc -l
> 4

No biggie, I'll take care of it.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-FlvxRv9oHHgDGh6RNIPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVM3OAAoJELgmozMOVy/dhgcP+QFaodlVucf8sb1rkrRhgqfh
Z0ffpSxVS1hypHhRgd+EUXT4QL0+oh9Gi3/Pm7zcQO8ZQhzYt1xvWLqgZEsPLc1U
dkxdqUoeZfRhK42i2SnVckLMRig7CuDAtjwPlJf+YO8eOX3d0+R0ATf9ThhmGROz
CZNOB4T5oKGe5QuEshjzU/mI0V0KZ87ODa+T6rJJ01O5O5ccGMxg0oid0anS1/cl
DdjtpFqVrcVznbGatmE1XdleWM74Ou8/4lJA2wsK67FAY8H41VdnNY6maBYDpklZ
Cn/w6VcRBFIAZTe4d7vvf9+/JjWa2Mnpo0Bktg6wu2hgOFLnoDBRrbU+oza41P1g
GiZTGSOj492mrWlPtbMeKQ8u1ChzmTTc0cxeasBjCDyz9t28ZHVxNXoHrPZf1ITB
WO0oqRH7N9WzxY4P5QXtB/K0KyxLZGuzVl3a6fFQTg+gJbD0obGydrSUc6/zyucz
ZqcLtfeYRHpg2WtnsrFo4uRLkql9I/CLsCo9ntIpKWZK7T64bYpX/49Fq68xN0nz
sEqZCJVseubfg5tLaOcwDh4W2X9d8EEJsuqm7cvtbvV217GV1FpQ8PO/MDw9JqYD
h45LDEmwXCj35zxIdFD2UAWwptN3mLrmGPqX/28QNzj6OERhIJQbyyUUcv+Kr0/5
jEcZ1px7/hkqTEZUZa93
=Vpfb
-----END PGP SIGNATURE-----

--=-FlvxRv9oHHgDGh6RNIPF--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
