From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/i40iw: Fix error code in i40iw_create_cq()
Date: Sat, 22 Jul 2017 13:27:36 -0400
Message-ID: <a94d7fb1-5dea-784b-a55f-d491276efdae@redhat.com>
References: <20170713074722.ki7o5k5vvdjbzpff@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6labF3xAnNxjH1BHHE5l5uSfILhG1bDXN"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170713074722.ki7o5k5vvdjbzpff@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6labF3xAnNxjH1BHHE5l5uSfILhG1bDXN
Content-Type: multipart/mixed; boundary="GjeQKjo4rVhhcdmfQgHVsgoMScem2oQqV";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty
 <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>,
 linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <a94d7fb1-5dea-784b-a55f-d491276efdae@redhat.com>
Subject: Re: [PATCH] IB/i40iw: Fix error code in i40iw_create_cq()
References: <20170713074722.ki7o5k5vvdjbzpff@mwanda>
In-Reply-To: <20170713074722.ki7o5k5vvdjbzpff@mwanda>

--GjeQKjo4rVhhcdmfQgHVsgoMScem2oQqV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:47 AM, Dan Carpenter wrote:
> We accidentally forgot to set the error code if ib_copy_from_udata()
> fails.  It means we return ERR_PTR(0) which is NULL and results in a
> NULL dereference in the callers.
>=20
> Fixes: d37498417947 ("i40iw: add files for iwarp interface")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--GjeQKjo4rVhhcdmfQgHVsgoMScem2oQqV--

--6labF3xAnNxjH1BHHE5l5uSfILhG1bDXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4sIAAoJELgmozMOVy/dUmoQAKwZSe+0uIjMRCKrd3IG8zet
mZcpRX6wvwGAK0H3NeLi28THLKhfm5ZvoZmznq1qPxlNL0TSiaVDWRgwrgL3OJRe
qs5UaCZuW4CjN9XgIjMCi/e2imlXbs1bQQbiJwiOCyxHzjHkLgXUC+AtwdBrj208
1bLwpPZkzHePfj5CaM35AThgD6yO3oEFUEsQfHTyXgs+vcgavVheztpZJ9Pu5yh9
i7yCVfAIu9+1JF8B4UfA2gV4GS1zxpveOlh1w0Do7WPtOoUcmnKybOxzqsNupBE9
sBv6qBLdhkqHfFANNPrGrdlkdN8D/sJiefJ7BWlSagHGvHZVWDKwQQcXImPET73B
j1X6E8wzNQxvoeP9k0pKPlmJEVcS5P4mhECEfY+kQUxY26XH/Bn4EELFHMvggcU+
2ZtCaW00Ul5nbfbtPIlKIULU1SBxrDJMaXN4M6Pnu5FVfpF6H2e7oOKmlILdTJVF
3v7/Lgir8EwvDgS8Al2Pb1GJv9BbmzLMbBQfMDSXZ7TKIIkuHAq1JQqEhKxl3pvi
MgbCafYy086FLjJ9wi+HzaazzDewYyZUES2nOj8gWcdAvj8yv2e4eYXnSb5P6ISA
YA7AxhuQaZ60C8p41x0yjTO22YbC4dIxDAyw9wO8SGLQ8NvhOvEZrVpugoHPKLEl
J1CoBWq3lSkaGhrtBpmY
=S6ri
-----END PGP SIGNATURE-----

--6labF3xAnNxjH1BHHE5l5uSfILhG1bDXN--
