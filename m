From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Thu, 03 May 2018 15:25:34 -0400
Message-ID: <1525375534.11756.138.camel@redhat.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
         <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
         <20180501180531.GB17027@ziepe.ca>
         <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
         <1525227892.11756.131.camel@redhat.com>
         <32E1700B9017364D9B60AED9960492BC62829957@fmsmsx120.amr.corp.intel.com>
         <af1960a1-4e05-3e7a-910b-99fd96d1a27f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PIv4YISeZ6btNQaZllwV"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <af1960a1-4e05-3e7a-910b-99fd96d1a27f@redhat.com>
Sender: stable-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Hiatt, Don" <don.hiatt@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-PIv4YISeZ6btNQaZllwV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-05-03 at 15:08 -0400, Doug Ledford wrote:
> On 5/3/2018 8:54 AM, Marciniszyn, Mike wrote:
> > > >=20
> > > > But I see Doug pulled the fix?
> > >=20
> > > It's in my wip branch, so until I merge it into the official for-rc
> > > branch, I can still fix up minor things like this.
> > >=20
> >=20
> > The patch works without the cast.
> >=20
> > How do you want to do this:
> > - A v2 -> v3 of the patch?
> > - Manually delete the cast in your wip branch?
> >=20
> > Here is the diff hunk for removing the cast from return_cnp:
> > diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hf=
i1/ud.c
> > index 9aa7d87..6ad203f 100644
> > --- a/drivers/infiniband/hw/hfi1/ud.c
> > +++ b/drivers/infiniband/hw/hfi1/ud.c
> > @@ -719,7 +719,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt=
_qp *qp, u32 remote_qpn,
> >=20
> >         lrh0 |=3D (sc5 & 0xf) << 12 | sl << 4;
> >=20
> > -       bth0 =3D (u32)pkey | (IB_OPCODE_CNP << 24);
> > +       bth0 =3D pkey | (IB_OPCODE_CNP << 24);
> >         ohdr->bth[0] =3D cpu_to_be32(bth0);
> >=20
> >         ohdr->bth[1] =3D cpu_to_be32(remote_qpn | (1 << IB_BECN_SHIFT))=
;
> >=20
> > Mike
> >=20
>=20
> I'll manually delete it in my WIP.  Thanks for getting the test results
> back :-)
>=20

Fixed in WIP, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-PIv4YISeZ6btNQaZllwV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrrYi4ACgkQuCajMw5X
L91KdA//XUjU9hooG116eYSr4Ojq07XcOJrWjsy9lvaOio5Pl3spKKqajAhnja1P
69glGq29VuZNAeKFY1DZ2bjRKOVLhhMhY2r+NPkDHlxSDbiiBzJ3MshyakgNZ4Uk
gRhmyaL3KrhaH8y6JC0VGqKSoPGpLYq4LstWi8f3cVr87PYrzKH8a05aLIg8a6AA
5z7V5mE/DlPf8FTlgMm9LVbzLkFFCtVFI3AnBoAVCRRzUvUB6xqdeLnETAj6Ia9U
dKPDtNwjH6GM6Th927qgNQxul3ovcbRxOYOZxBFQ3XuPnkBBhZSFG+Xk+UusjUVP
yKY2reN24lV4hoXJqLPqVnyv/1cXZxTkuxQmaOwZNNOl9z654tNb0TUpnSkx0Ity
oHrpE/HwfYtYt5bSuHCe/yyxUAzFMo24Jo6a3tiUSfORvZ5AHd/cpuzMR9HdNBCH
DFpK+TAeEoPbmRcl6EckEM22Oe416Ic0a6d1G1lUTzRHXVnfssi4a7EqDoWk7gVX
krS5LJiLBgPJsaP6/IjMoW4HhPFUvFLua+3x8e7qVLOVdNUysj7fvMXkTJy2eUt5
zhdAP7Beroz/DqwnZ/bJ0BEge0SmKZR8tFe1OaYyTrK0oODFufb9IjGtzGgmYeT8
Di2VcZJdPvNLjwuf7F4DI/RHiueQXylRg3J9DGq4SpBxzykcpY0=
=6hij
-----END PGP SIGNATURE-----

--=-PIv4YISeZ6btNQaZllwV--
