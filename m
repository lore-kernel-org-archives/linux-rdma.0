From: "Brian J. Murrell" <Brian.Murrell-veTT2BtV2gBXrIkS9f7CXA@public.gmane.org>
Subject: Re: compiling against lustre 1.8.2 kernel
Date: Mon, 17 May 2010 12:27:09 -0400
Message-ID: <1274113630.396.41.camel@pc.interlinx.bc.ca>
References: <AANLkTil_7L_cbglOcaHKPRmrrntXew9jwxvSrTkxNcnF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SqlwIiXK9AB2U/kj/6XM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTil_7L_cbglOcaHKPRmrrntXew9jwxvSrTkxNcnF-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-SqlwIiXK9AB2U/kj/6XM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-05-17 at 12:15 -0400, Michael Di Domenico wrote:=20
> I ran across an error when trying to compile OFED-1.4.2 agianst the
> Lustre 1.8.2 kernel on Redhat v5.4 (2.6.18-164.11.1)
>=20
> /var/tmp/ofed.topdir/BUILD/ofa_kernel_1.4.2/kernel_addons/backport/2.6.18=
-EL5.3/include/linux/sched.h:13
> error: static declaration of '__fatal_signal_pending' follows
> non-static declaration include/linux/sched.h: 1570 error: previous
> declaration of '__fatal_signal_pending' was here
>=20
> Any suggestions?

Have you checked that OFED 1.4.2 supports the RHEL5 2.6.18-164.11.1
kernel?  I don't have release notes handy so I don't know.

b.


--=-SqlwIiXK9AB2U/kj/6XM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvxblkACgkQl3EQlGLyuXD8FwCgzbRwlVRCjWDwVPdxrVx6/TtF
1akAoJubB7vDs1LNSoYiekVQ64qvkW0D
=/Iy5
-----END PGP SIGNATURE-----

--=-SqlwIiXK9AB2U/kj/6XM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
