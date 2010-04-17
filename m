From: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ummunotify: fix umn-test build
Date: Sat, 17 Apr 2010 21:44:05 +0400
Message-ID: <20100417174404.GB3579@us.ibm.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100414094341.ba69842d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100414094341.ba69842d.randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Apr 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Add ummunotify.h to Kbuild list for export to userspace,
> fixing 27 build errors in umn-test.c when O=3Dbuilddir is used.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, will wrap this into V2.

Eric

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvJ82QACgkQsnv9E83jkzrrtwCgvJ1CtcloQrQ9idKWHPb+2gZt
M4YAn32kcEhDiFFTVe6uTIF2PEY1v8cd
=0JkT
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
