From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v4 9/9] selinux: Add a cache for quicker retreival of
 PKey SIDs
Date: Wed, 9 Nov 2016 09:04:55 +0200
Message-ID: <20161109070455.GF27883@leon.nu>
References: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
 <1478639185-47521-10-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3oCie2+XPXTnK5a5"
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478639185-47521-10-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, liranl@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--3oCie2+XPXTnK5a5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 08, 2016 at 11:06:25PM +0200, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj@mellanox.com>
>
> It is likely that the SID for the same PKey will be requested many
> times. To reduce the time to modify QPs and process MADs use a cache to
> store PKey SIDs.
>
> This code is heavily based on the "netif" and "netport" concept
> originally developed by James Morris <jmorris@redhat.com> and Paul Moore
> <paul@paul-moore.com> (see security/selinux/netif.c and
> security/selinux/netport.c for more information)
>
> issue: 736423
> Change-Id: I176c3079d5d84d06839b4f750100ac47a6081e94

It doesn't belong to commit message.

> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

--3oCie2+XPXTnK5a5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYIsqXAAoJEORje4g2clintVwP/jLkWFgE/+kE9TMZszjjEkGX
acV1ZHDEFIdsatLztMqsdAD9hMvnMpGTOB/0EmMmIeVePkdPSTZRKo7ts+RCfu07
eZeN3UuCrZ1z4uvC7CREAPsv0q5XUU3Z5jbINNHQIsCte3bJN6xFjAJcdHhBhPPr
R4od1JNyG1ZlXiYRUIYhwzXnRPePEoQeEwVivAlrMjdcgPu4U4j0T3nlR4QAJb8G
m2+CmZD/VneCzDJTZkhePbJoDVUkvUFUFLbd3MXSNBrYRDvb0nPypfGhzgLTldLQ
V9+R0cIelrdG/FNj1J8+YAeOphav9sS2j8p76cY+5hjlx1IzOJCKQB5UEqT5j21X
9wq1ODXUmlYJ0KwoftLnk16yrTEJZzYK42NStZw3Y50ID8vuBRVkhDgC99Nsv6v+
mM2LIoKKSB+yFgC33EaKPIewaieEpVuBHJP80AyfqiHtyU4IhOFUlSaVW7J1Bz5G
v4/mISojGL56BCfJDD3WF6sOSOHRZCsaqlRSr1RCa0glvmGcm44OwRifGFsLIyhW
sdxwCqHZhO63dfLbr06B0sEnzCRbaPGNrq89DqgxqYK6U+uuNaNI3l/OJgOx4Dn2
FUYMLRO/QBw2jKWD5Gvog9TyAIDsjm2pMaVUkC/3QEDJVG8hxx5JhTo2osoKA3ZY
LTnUr+G3ov2qdtNyYkXj
=uWFs
-----END PGP SIGNATURE-----

--3oCie2+XPXTnK5a5--
