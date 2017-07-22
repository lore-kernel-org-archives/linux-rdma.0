From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] RDMA/ocrdma: Fix an error code in ocrdma_alloc_pd()
Date: Sat, 22 Jul 2017 13:29:17 -0400
Message-ID: <94260605-15c2-d088-d5b6-ded6bca77d43@redhat.com>
References: <20170713074614.obgl5mxxygcluyog@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NKhJCvLIDMBLHTbiOQKQw7tpif11Uo1vt"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170713074614.obgl5mxxygcluyog@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Selvin Xavier <selvin.xavier@broadcom.com>, Naresh Gottumukkala <bgottumukkala@emulex.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, ssh10 <mayhs11saini@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NKhJCvLIDMBLHTbiOQKQw7tpif11Uo1vt
Content-Type: multipart/mixed; boundary="hAGaOM73R71me0av14TKrewkgd1L16PVx";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Selvin Xavier <selvin.xavier@broadcom.com>,
 Naresh Gottumukkala <bgottumukkala@emulex.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock
 <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>,
 Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>,
 Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
 Artemy Kovalyov <artemyko@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
 ssh10 <mayhs11saini@gmail.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <94260605-15c2-d088-d5b6-ded6bca77d43@redhat.com>
Subject: Re: [PATCH 1/2] RDMA/ocrdma: Fix an error code in ocrdma_alloc_pd()
References: <20170713074614.obgl5mxxygcluyog@mwanda>
In-Reply-To: <20170713074614.obgl5mxxygcluyog@mwanda>

--hAGaOM73R71me0av14TKrewkgd1L16PVx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:46 AM, Dan Carpenter wrote:
> We should preserve the original "status" error code instead of resettin=
g
> it to zero.  Returning ERR_PTR(0) is the same as NULL and results in a
> NULL dereference in the callers.  I added a printk() on error instead.
>=20
> Fixes: 45e86b33ec8b ("RDMA/ocrdma: Cache recv DB until QP moved to RTR"=
)
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--hAGaOM73R71me0av14TKrewkgd1L16PVx--

--NKhJCvLIDMBLHTbiOQKQw7tpif11Uo1vt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4ttAAoJELgmozMOVy/djNAQAIHDFOOspzF30K23tTxkPXdp
FRSGwnyf/562nYS9qkWEfE4yLdfm7y4CrAfYL0z90wuYyFDWZlvsUtF4so2fX1j1
O6W5DMuHJR3UC1pCRli370jN2hE0eyIfqMdadXuesdGCAjbBC/+hyMXkaanhJ7JV
DMAPGeEzuHylkr1ihQIxyJRj8rhYVwNAzniNU+Pm+sBHO3FFJwkaYItxPB3Mgp++
A4aW0OsWdQycO0DlIjXaVpUu7zFZrYaChMaUb4d8xNEnUJTTQGt5T7oZsvutXvHD
HfLmB9J92/x94dFD1zPXs17oXAnU6BwUDv/cCQ4ebz4KescdLYDnKRaowRYAwFz0
1I36s+cmU5EDgJJVv+0GOGA5AHoAi8XrF5quL5G16k1vKSGUZ+xZzrSo2xdaIXbu
OCd1yB7nXXv+l+/LHuGiPE5zG20YKqeLxNHqEAXubqUOSdoVlccV1YfAfeMcJShL
6fb3tndwUvdZZ7rbXmMN3J3HoCHd/9gBDa/216GCY3eLVWr3yBjliOrOk6wSZrum
3cZJEJribM47LGvKOxTqJ/u69sjxFN9YrS/2xt2p9jKhdzCxVImeQ/GhUQ7fA/jo
t2F9XKQN2aA+J7nx4JMS6nrdDiEEFymNB6eAfkh9KxHYq160NLGloRoGsIOQNchM
0O8K3UKf86G/6D29DLwt
=u4k0
-----END PGP SIGNATURE-----

--NKhJCvLIDMBLHTbiOQKQw7tpif11Uo1vt--
