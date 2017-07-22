From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/ipoib: Let lower driver handle get_stats64
 call
Date: Sat, 22 Jul 2017 13:11:40 -0400
Message-ID: <0db1b2ff-2ff9-76f1-2949-5d6fdb8b4390@redhat.com>
References: <20170612074521.15785-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="66LW4WDEickTr2j7nWF6V03Fr3A14633m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612074521.15785-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--66LW4WDEickTr2j7nWF6V03Fr3A14633m
Content-Type: multipart/mixed; boundary="kQpb4avG9hqAE2dt2ucoLXT9GQtOsmhWF";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <0db1b2ff-2ff9-76f1-2949-5d6fdb8b4390-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/ipoib: Let lower driver handle get_stats64
 call
References: <20170612074521.15785-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170612074521.15785-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--kQpb4avG9hqAE2dt2ucoLXT9GQtOsmhWF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/12/2017 3:45 AM, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The driver checks if the lower level driver supports get_stats, and if
> so calls it to get the updated statistics, otherwise takes from the
> current netdevice stats object.
>=20
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This has been accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--kQpb4avG9hqAE2dt2ucoLXT9GQtOsmhWF--

--66LW4WDEickTr2j7nWF6V03Fr3A14633m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4dMAAoJELgmozMOVy/dpdcP+gJXGZfsNCed3uY3Ja1BZWNs
tagcyBuSd3IID32B1o/YzLTrOhZ1Y5DGqdGvMXu/yI7Pz1RhMKmX3hgctYMrA1NM
NjHRCSz2z/9az+xKsVad4bfv9pvTcBeaPE7SEbImsNd5Q+3T8rBaboNbVNwCxhnC
cm6eA/hVxffBjh01m5C7Z2RvB4+cz7EttJ9lFL6+cKbTQO4aGoAPyq3r4EChKas3
eZLPHLzL/+c35X/dQAMfm1epe3IHLXRyoOSNiaVhzhq4Re6Q4AGwQ5baNb9ognt6
cSokgFISXJ1HRIFzIkkoUe0r6Ry/T31Yd7WB+3+nUZK37GU42Jcd5QqCGmxpkW+P
9D9pG7ROMvAMnxupoKJBSoyAuySI6HasrDry6W3QKDtzFwc++Gl8xMG1rWCNf5sy
SZ/HrHXMRbYhS1nF9tWTkHIo6LWeDBh96qgIEsWhhZNwKBcHO22xMl66ez6TuEzU
7Db/HN7Z+QWsC1oWnIqdFE7lJzSK3KBhSAOsHSzvtcenN9DriK4kcLMKIyS41l3g
RsPYzLi5t7HvhRYgt1ZSIwL6uuI+4YUCwv8b9Zi4x0dUpk7kVTkMWP69mVN60m4a
X2Z/cPAlzUkzubwrDDPimSbOEhrkXiVKHpycW8xX7bQflkCJVa9jymQroqSeMXgY
2A7G058swvySlfPH9cjw
=DJBg
-----END PGP SIGNATURE-----

--66LW4WDEickTr2j7nWF6V03Fr3A14633m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
