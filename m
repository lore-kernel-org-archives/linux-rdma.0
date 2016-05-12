From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3] IB/ipoib: Add readout of statistics using ethtool
Date: Thu, 12 May 2016 16:10:05 -0400
Message-ID: <9457c19d-364c-2b33-594c-6b1dda4b600f@redhat.com>
References: <1460715468-16235-1-git-send-email-hans.westgaard.ry@oracle.com>
 <1461237201-25738-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fuAMU6pqfOnbKDJT9CJ2qrX3tUaEPOpAg"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461237201-25738-1-git-send-email-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, INFINIBAND SUBSYSTEM <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fuAMU6pqfOnbKDJT9CJ2qrX3tUaEPOpAg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/21/2016 07:13 AM, Hans Westgaard Ry wrote:
> IPoIB collects statistics of traffic including number of packets
> sent/received, number of bytes transferred, and certain errors. This
> patch makes these statistics available to be queried by ethtool.
>=20
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Tested-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 67 ++++++++++++++++++++=
++++++++
>  1 file changed, 67 insertions(+)


Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--fuAMU6pqfOnbKDJT9CJ2qrX3tUaEPOpAg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNOMdAAoJELgmozMOVy/dt8gQAIcuntfN697SVs7fQJNNaRsc
+Y9JZdlBwZW+PxM40RVX9HFGlIvBnu0w3qLLq/hZOj05b72zCBcFHjq80RGvmEEP
+k539aJvIOAM3UUMacr+iW5P4j8PRokPZTv4IVIBkYttmB0DFKKXz6iGbPjDUiOw
RT2FtdkSMpkc+NRmDyF/aNosxTT3O4nrNGgUGURNPXXtkZdaSHM6dSpCGpqSdvVi
BPuo+4s2hn0rE+iiRFpjd6DHVzjybsfFMFiMiwBSSFVp2Pp5dBPw5DYlhGyAJTKX
kGiANUVZgajIaac/sBhIrZEvGC6kC1NQ6h1SIXlC/j3l5wXmsTxb3Ko2+Atlqmhh
lGsSklnioTmVsX8dT6d3jBkNr2JIMAo+5jUI8f46xY+ak+ZfH7QYJVFpgQlkR8rA
PwiIkG34q+BTNloHrphEVxHR6M1puQd/NhkUrNgYgPaa6vjociVclRIJJ+0Iy+jS
4owBlOn1mm6g90AE4Q/bfdJ9VFm1DoYJH6l8Dagqce+HTOB5j0b2Yue5XKwE0juR
oXSZ2E6ZqsZBjtb1bv5UlKoVkhC1waQ/lHM4Ox/luTsVCHQLbcd6OVN/eOr9m71K
b5je+xUe4wJ9+ZsNDQJSJnLNIoTdrpnmzPXEwuyWv4BFu4rYXBkDFgOewPK3ncEy
A2uAFBXMHdl8UUQjpOqd
=8c4S
-----END PGP SIGNATURE-----

--fuAMU6pqfOnbKDJT9CJ2qrX3tUaEPOpAg--
