From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the infiniband tree
Date: Mon, 4 Nov 2013 15:55:26 +1100
Message-ID: <20131104155526.10e5aed0cd9512c47a82529f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_15_55_26_+1100_TFsx_mP4jFPg50uV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Mon__4_Nov_2013_15_55_26_+1100_TFsx_mP4jFPg50uV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/infiniband/hw/ipath/ipath_user_sdma.c: In function 'ipath_user_sdma=
_pin_pages':
drivers/infiniband/hw/ipath/ipath_user_sdma.c:283:6: warning: 'j' is used u=
ninitialized in this function [-Wuninitialized]
  ret =3D get_user_pages_fast(addr, j, 0, pages);
      ^

Introduced by commit 18fec3c6bdcb ("IB/ipath: Convert
ipath_user_sdma_pin_pages() to use get_user_pages_fast()").  How did that
pass review or testing?

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Signature=_Mon__4_Nov_2013_15_55_26_+1100_TFsx_mP4jFPg50uV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdyjCAAoJEMDTa8Ir7ZwVpUAP/1PJ2JlCkkQzdQLxm0X5+qrY
GmvlI0Y8JZGc7ntnrn34IXRuwZBtRjhHeNEDtSgGhWvyUhhzycs/HLYiN1qj51S8
X+v6MgCQsOHr8SEDBWK1BcSbqjfRu39FJgqokMBZe3pkBbsRtSLu/CeSkJsUSLm9
bBt0sF5d3evwHkHmlrq+8EpCo9Yx9V477JWMZQXpjzV4Uo4ymFXHMvosY0Y8fsCj
djQu/7JXwIFEvNFpt+m5JoPdischM4yA4754hDDywBIzGd0+EPH/Ww7+09NCicl6
7rSBDFExXSVnBSN/52TwmhFoGGnlwB3By+NcCEo6YHJuiviQBOuBZczDh3LQKd89
hihZtvCn2yRpoddmiMQ9ryfaSEuJNAZE8tni1ekZHxrmjUbo+/pjIdoZ+UL8E2xU
o3ZLapT+RUd1GtZJmeF/OsDfUQLb5wVCCpwIxYdN/2xSlPsOeei6SzkKOFxlhg0h
EMwG6p4qCKFOHE4it24hjMWwtHQihVsvUXmVoqzzDmllLoMUg7tFpF/A834ywFhF
8V9svBURg7sdCtCbekqUMORYsJrIbcFAg6Y00zMi4ig/i6BWMaW+1iAvD0uK7s+0
LwsaCpnLoHP2osQ4HEjFq7pqKsZQCuXkbLRcO9PlRdOS2x8DARAUoHAIlsRjSpUa
W/PoffsPy6aCrSX7JDDx
=oP+q
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_15_55_26_+1100_TFsx_mP4jFPg50uV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
