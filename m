From: Doug Ledford <dledford@redhat.com>
Subject: Re: generic RDMA READ/WRITE API V8
Date: Thu, 12 May 2016 14:43:30 -0400
Message-ID: <1a3914af-45ad-0944-95f0-dd138b632014@redhat.com>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A1Bad5ptTwLPS33LHPGs3D0srTVvPcIOw"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1462291273-22403-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A1Bad5ptTwLPS33LHPGs3D0srTVvPcIOw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/03/2016 12:01 PM, Christoph Hellwig wrote:
> This series contains patches that implement a first version of a generi=
c
> API to handle RDMA READ/WRITE operations as commonly used on the target=

> (or server) side for storage protocols.
>=20
> This has been developed for the upcoming NVMe over Fabrics target, and
> extensively te=D1=95ted as part of that, although this upstream version=
 has
> additional updates over the one we're currently using.
>=20
> It hides details such as the use of MRs for iWarp devices, and will all=
ow
> looking at other HCA specifics easily in the future.
>=20
> This series contains also conversion the SRP and iSER targets to the ne=
w
> API.
>=20
> I think it's basically ready to merge now.
>=20
> I also have a git tree available at:
>=20
> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>=20
> gitweb:
>=20
> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-r=
w-api

Thanks Christoph, this has been applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--A1Bad5ptTwLPS33LHPGs3D0srTVvPcIOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNM7TAAoJELgmozMOVy/dhFYQAIa9xlhY4JZqseNR31Vf51Qp
pTS8LDk5mh2T3+yEdUwBw25Kmox6ugjcom+bhUgt7RcrPTjg4uVp+oNbXDlR8qha
s9oNcjRYn9siWojH+Vz+WK4vX4v3cUvR1HIz6Kc9gw8qD3Xbo/LCjuSiWP1mjp56
0mTQOrSSI7USw03/tlLsAGcLNGezRzdd2F2jZLi0Bbs8HJZpmmUNCHqO4yw+ws3Q
V8DZ5fSWhuvJUDz7IORWDqTm3LzwsEV0ZwxiYs4A456bJZuvxMDr5MPghKl/LkPo
XHR/fOTWlgOPi/38qz3MTZXAQn19eKzjN4QJmQTJk+2TMqy65us6A6OrMCghWjuZ
obEv9La9l3U0upXLmz/VrkjJcozUN9Or0HBlYPPU9tBetclKUXytt0kgqFrenczg
8NBManWhrMpGgh8yfS77jWbAlOkH6RcwCHxvhYDcKkJoH0+RtAxBzwGalY7oNy2s
p34VQ8Uye0Z/Xagxwq/XsxqvT9sIQlfLoihBreE1ju5OmX66TRJThSHXBlaKLCyB
RjlV8LLkUu8/oA4hXknuskjkq6Obb0n4FRC1cqzO76UeNfjveXPhSOvsoHyOhVgM
QkwNLnnQaA2usA9NZZPMCHlKgOO8xo7ZUysq2H/oG+Dprl00WKo+PzPmxZqc6IJs
tnZOhxc0qqAEfKlYuxen
=jVTv
-----END PGP SIGNATURE-----

--A1Bad5ptTwLPS33LHPGs3D0srTVvPcIOw--
