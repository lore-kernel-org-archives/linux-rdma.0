From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] IPoIB and IB core fixes for 4.7
Date: Mon, 6 Jun 2016 20:02:15 -0400
Message-ID: <302ea695-7b9f-7c94-4930-acdb77ae8649@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8iKd26Og8rHnvju19cjBLJdX9OSedDhbK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8iKd26Og8rHnvju19cjBLJdX9OSedDhbK
Content-Type: multipart/mixed; boundary="3xcj9j7Ab3kp8WT0GGhcfCRUbh10Xq1M1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <302ea695-7b9f-7c94-4930-acdb77ae8649-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] IPoIB and IB core fixes for 4.7
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--3xcj9j7Ab3kp8WT0GGhcfCRUbh10Xq1M1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find below the patches with fixes for IPoIB and IB core.
>=20
> This patchset is generated against Linus's v4.7-rc1 tag.
>=20
> Available in the "topic/fixes-ib" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/fixes-ib
>=20
> Thanks
>=20
> Aviv Heller (1):
>   IB/core: Fix removal of default GID cache entry
>=20
> Eli Cohen (1):
>   IB/core: Fix query port failure in RoCE
>=20
> Erez Shitrit (2):
>   IB/IPoIB: Don't update neigh validity for unresolved entries
>   IB/IPoIB: Fix race between ipoib_remove_one to sysfs functions
>=20
> Mark Bloch (3):
>   IB/IPoIB: Disable bottom half when dealing with device address
>   IB/core: Fix incorrect array allocation
>   IB/core: Initialize sysfs attributes before sysfs create group
>=20
>  drivers/infiniband/core/cache.c                | 10 ++++++++--
>  drivers/infiniband/core/device.c               |  3 +++
>  drivers/infiniband/core/sysfs.c                | 10 ++++++++--
>  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  4 ++++
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  8 ++++----
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 15 ++++++++++-----
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  6 +++---
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  6 ++++++
>  9 files changed, 47 insertions(+), 16 deletions(-)
>=20

Thanks Leon, I applied 5 of the 7 (the two rejected patches were replied
to individually).


--3xcj9j7Ab3kp8WT0GGhcfCRUbh10Xq1M1--

--8iKd26Og8rHnvju19cjBLJdX9OSedDhbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVg8HAAoJELgmozMOVy/dtQAP/2P4TfEC6OyRs8JeoRbJtV5d
Cqz2sakZ2HoyJC/HZ5NmGwxVHhOhpWkk0f2a3NdYkUrPn8PYL3dKKWkYVFyNR/sx
MO7abUue51TPDJofI7090rRLejeU+WkPMsBitDLKH3m/15oHQRNCJkB/qgwmw1Gl
JNtjO5ST3a3xmgzo1DMg9wBI5lVzPtujFsj3Su9V6QbIj6GmieAx64uvgB1zXIy5
cD3QAIUT1t056NJQowS7ZMuFZtrYOE2j+Wph46vLGba8/OV5BV8nO0qWXI0mSY9n
KGdZwEIgNChb+1WHcf5ulfp9QMO/cxDbe8uGsa27gdsYelMBRTKq33CCdKA6kQlf
hDjYm02elwlPFGAdgIEj0TIoMG/KPTVIZEeK/6R59gPy7cv9FL+l/9jA/m3FAKid
OiD8QUwnp/bC8Ep63baX7nReY/yMQqXWxENQmptO7nHBZ96GUb3aHwtaCKBp9lFI
exh18BZESUWtLH9rrkCyxfjx74ewhUyWyzc7NFFSoMwRSBTTiGAsmdfJ/waWzX8L
2X+wAMf/Fu6kdeTYdfkA1aZPXRrXT6xkx+A4zGMA3itgSi/jn0FOLvHeAEyvWwl3
URtjQ1GY7HJlmwU81w0J6GioyANBqN+LyyX9Hbay/L/jTjauPcJa1YJv3axza4N2
svsyL3H/HniTiDziNlRK
=442C
-----END PGP SIGNATURE-----

--8iKd26Og8rHnvju19cjBLJdX9OSedDhbK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
