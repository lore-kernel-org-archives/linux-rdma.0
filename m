From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] staging: rdma: shift wrapping bug in c2_get_dma_mr()
Date: Tue, 19 Jan 2016 13:13:34 -0500
Message-ID: <569E7CCE.5020709@redhat.com>
References: <20160108114936.GA3802@mwanda> <20160108132932.GA5658@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x5hcpMXkninCGO4SrscS5gBTUGnCLOJd6"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160108132932.GA5658@lst.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Steve Wise <swise@opengridcomputing.com>, Amitoj Kaur Chawla <amitoj1606@gmail.com>, Matan Barak <matanb@mellanox.com>, Geliang Tang <geliangtang@163.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x5hcpMXkninCGO4SrscS5gBTUGnCLOJd6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/08/2016 08:29 AM, Christoph Hellwig wrote:
> Looks fine.
>=20
> Doug: what's the status of the staged out drivers?  I thought we were
> going to delete them for 4.5?
>=20

I am.  They will be going away shortly.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--x5hcpMXkninCGO4SrscS5gBTUGnCLOJd6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnnzOAAoJELgmozMOVy/dUDIQAIjPXIqa3TIaGe8vyUKqZOK7
AMVo5udwIBRYpTdSskD/ey/OOlnY9NIsP6SwW0y2bMRvm2fiV0xBxj7Lg043najH
hbIxEWx2ySRNGgZgHKwDdQpdfZSRgBoiG62JhpEyayUXbT4++E8T3cLLbHf+5wAR
gMWvsAh4vbrkGXIKeQ/x4I1+Y/Gfnh/raJawDNqsu+yVfh8GbPJksSReqf7O2fWc
aT8WxJZCfuSO4orRUFKSGY+SpXErS+nUDnR0uGd94fNzu+j503YSVxXb0p0dCDSG
We3Wml7wAIkkwfsn1RoPWcB4GELf+yrzNiRydQMAxAbRGyCKtagx1FZoy1fyLuyL
QbI1MaD8HxzyRQTk7S4+0abAYjU8MxPve7cBybXRGnxxIF0pqpqFTSLe1p7P/lXg
htPsSYHaTaNdPc3AbiOvFkDIxHXbg65rHkFtLW3KwUYDnaNO5x80Cld6WZcIoCMT
I3IgfI0jA65oJokKfVgt/N/PwGRoX1I/ScZ+I8uN7xO27HxSnpKN1zjcF78WkWDC
OxCAdgh8a8OiyttnhNzTEqQ1XYiU1+JlKmgMqn/N8+Y7+VpoczujFiPctUxNBbcO
/d/dN1nlk516SS6EFLEIR9d4u54BZcqJq9DTlS+kvM+DwInsyIwZ8cW9/anTVkRc
79vGbEHHg0OVVXE6pY9Z
=FUMX
-----END PGP SIGNATURE-----

--x5hcpMXkninCGO4SrscS5gBTUGnCLOJd6--
