From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Mon, 30 Apr 2018 13:10:49 -0400
Message-ID: <1525108249.11756.93.camel@redhat.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
         <1524196555.11756.30.camel@redhat.com> <20180420153451.GF30433@ziepe.ca>
         <50E3FE4A-2C6E-4493-92E1-383C349FAE3A@oracle.com>
         <20180423221618.0000795d@dev.mellanox.co.il>
         <20180430144930.GB26895@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fsORuf+usU5/Vibvb5vC"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180430144930.GB26895@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, jackm <jackm@dev.mellanox.co.il>
Cc: =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-fsORuf+usU5/Vibvb5vC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-04-30 at 08:49 -0600, Jason Gunthorpe wrote:
> On Mon, Apr 23, 2018 at 10:16:18PM +0300, jackm wrote:
>=20
> > > > TIDs need to be globally unique on the entire machine. =20
> > Jason, that is not exactly correct.
>=20
> The expecation for /dev/umad users is that they all receive locally
> unique TID prefixes. The kernel may be OK to keep things port-specific
> but it is slightly breaking the API we are presenting to userspace to
> allow them to alias..
>=20
> Jason

Would people be happier with this commit message then:

IB/core: Make ib_mad_client_id atomic
 =20
Currently, the kernel protects access to the agent ID allocator on a per
port basis using a spinlock, so it is impossible for two apps/threads on
the same port to get the same TID, but it is entirely possible for two
threads on different ports to end up with the same TID. =20

As this can be confusing (regardless of it being legal according to the
IB Spec 1.3, C13-18.1.1, in section 13.4.6.4 - TransactionID usage),
and as the rdma-core user space API for /dev/umad devices implies unique
TIDs even across ports, make the TID an atomic type so that no two
allocations, regardless of port number, will be the same.

Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>


--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-fsORuf+usU5/Vibvb5vC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrnThkACgkQuCajMw5X
L93grBAAlcuVjyVohByp3vHuSNDyjvMn66qPcY9XMiAejp0N6xIykq/7ztLkqtqm
PNj0fYEVbUfGKdueMz6SWFVf/dMHtZMuWrYZ18cG6nuRsO/UfHDfvDM/acIKXUPE
bTGnZIsa/jqFmLPYW0at0+ww54aAZXchYlWgM24pWBdeqWDx+jVtY7XhGpzE1g/8
5byLP7VP9wkrSyI+ozhXpUOxJrH2mdUqB7an9WiuFt4TZjd1seEchYp+ywlavX8+
wAxpLhP+leQcV3hFI1fgGfKaK0VrjWUfGho2GGuHlaCmKnXqUthEWs9cnms/k+I9
R/hsipt3ZtOfesfkfYFgzqAjLyPj8qikphWVd0/qdHv4W1cKrplpnMNv+pkPSSyc
DVzzh1FaJF8TUTzBlTQdSL+L/nL50+b2ROJeOoGK/7lbOL4aH78ltf9j4TogC+Do
myHoC6V1SI5/0xHsl39ZSEdAGX95Ou3CAd+JVVScHiGwvZbTR1q1B6nxZDadXJlM
k0HGufN8L0IIldQKIsITCxmFG98hgJgu9EgWUVPQuHomdAnkiatr7SuRYYkkNdAj
V91qHAs6O/nq8zr+EYL7iTRhYFPeqY3HakNWBgBeJh/+lbyOfFeHhFwTYG0/X26b
bJL+uziVG7mwZUMNsAGolqo4Yi+yfoVLUFMu4UPvRcThCfIIKMM=
=Mwa9
-----END PGP SIGNATURE-----

--=-fsORuf+usU5/Vibvb5vC--
