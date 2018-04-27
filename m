From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Fri, 27 Apr 2018 15:08:36 -0400
Message-ID: <1524856116.11756.85.camel@redhat.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
         <1524196555.11756.30.camel@redhat.com> <20180420153451.GF30433@ziepe.ca>
         <50E3FE4A-2C6E-4493-92E1-383C349FAE3A@oracle.com>
         <20180423221618.0000795d@dev.mellanox.co.il>
         <C546E163-297B-438E-AF76-CC04247ABFBA@oracle.com>
         <20180426213250.0000515d@dev.mellanox.co.il>
         <9fdd3ec4-ee91-5442-e753-25d2ecd27ea9@xsintricity.com>
         <A58D5192-06E7-46A3-869C-273E9A2BC128@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-smZmVzuNnteiOZITtEn4"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A58D5192-06E7-46A3-869C-273E9A2BC128@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc: jackm <jackm@dev.mellanox.co.il>, Jason Gunthorpe <jgg@ziepe.ca>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-smZmVzuNnteiOZITtEn4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-26 at 20:51 +0200, H=C3=A5kon Bugge wrote:
> > Jason is out this week.  I'll end up processing this one (probably late=
r
> > today).  But I=E2=80=99ll fix up the commit message to suit my tastes w=
hen I do.
>=20
> Thank you, Doug and Jack,

I reworded the commit message, let me know if you think I worded it
wrong:

commit 69f01b81539c62f3dd96f9f02138ad7b839a0c70 (HEAD -> k.o/wip/dl-for-rc)
Author: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
Date:   Wed Apr 18 16:24:50 2018 +0200

    IB/core: Make ib_mad_client_id atomic
   =20
    Currently, kernel protects access to the agent ID allocator on a per
    port basis using a spinlock, so it is impossible for two apps/threads o=
n
    the same port to get the same TID, but it is entirely possible for two
    threads on different ports to end up with the same TID.  As this can be
    confusing (regardless of it being legal according to the IB Spec 1.3,
    C13-18.1.1, in section 13.4.6.4 - TransactionID usage: "Then initiating
    a new operation, MADHeader:TransactionID shall be set to such a value
    that within that MAD the combination of TIG, SGID, and MgmtClass is
    different from that of any other currently executing operation. If the
    MAD does not have a GRH, its SLID is used in the combination in place o=
f
    an SGID." which guarantees we are legal because our different ports wil=
l
    have different SGID/SLID creating a unique tuple even if the TIDs are
    identical), and as we might want to open the TID allocator up to more
    parallel usage later, make the TID an atomic type so that no two
    allocations, regardless of port number, will be the same.
   =20
    Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
    Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
    Reviewed-by: Ira Weiny <ira.weiny@intel.com>
    Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
    Signed-off-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-smZmVzuNnteiOZITtEn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjdTQACgkQuCajMw5X
L93Kmg//d6H/DWtVRSGXTNqMeyPkvVFvCND7YP4U5ocs9EWtsa3JW43l/yXZ7IS/
ivZQeMtIdNK325+AgoGXlyIoCDqw+zjHC+5HCCRisuLNzF0Ni/gQMqnIwkMC2kOw
u5qhKEMZRxqs4WQU9VZBrWbyhDVx/QuYbrevcO/Q4bZDfUaqb6kmdTnwYMLK3R9g
WX1Xwl1sIAl9mRYI9U88VwQHHL5wPbV6gQqOB2iEELWntkuyO79ClE0ciN50sfcl
yHKV5eME/9NvctvKm8+bdviwUec3Zwla/SBrY3KPXVo6vPNsP5YcSCNYiGfNhYza
GMOwKSBREzKcAw+wKxGbDjY+tfMFT+3c7Fc7pWYxl1NzoWWb9tfgaHzgi4Hr/BJ2
/P5UPmX/i2NQyIN2HuM9N1gdB9FXlGu/RCNzUMITFU9fHMP7S/aozP4ZDkwGe4nq
VC+Uuhj00q0M1CI69HF5PcdghdpkHtErYmYDpy+zDLXk46nO2xDbyI6kNPJj7zTJ
kMLKXk91a+OwRhJwYNesvtlV3c4cKEWKE06j+n4a/QB4a10A0m3Joq/jeSOLbcyw
R4A7ZXspEVkMr+8Gkm331AtIKewu/qjGMFhsmJElHOP/ISaS7ouvh/bprzl3GFuQ
Lo+GvnPmxaVHKOEhkeEV01l3wJl1D+QzeWiGG1nw+MNiKz9rwr8=
=O4dY
-----END PGP SIGNATURE-----

--=-smZmVzuNnteiOZITtEn4--
