From: Eric B Munson <emunson-CVBTeua0HjReoWH0uzbU5w@public.gmane.org>
Subject: Userspace MMU Notification
Date: Thu, 19 Aug 2010 17:32:06 +0100
Message-ID: <20100819163206.GA3194@mgebm.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dykman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

During the .35 merge window I attempted to merge the ummunotify driver and
was told by Linus that he didn't like the approach.  At that point several
members of the RDMA community were hashing out a way to do the same thing
that would get Linus' blessing.  I haven't seen anything about it since and
I am curious if any decisions were made.

Thanks,
--=20
Eric B Munson
IBM Linux Technology Center
ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMbVyGAAoJEH65iIruGRnNDmUIAJeShepa+Si39JLnrbaVHjQM
EVaS8CYod6nuUFdxz//NUtG4QF/kb7q0KDPgfRwsD7pkgR8KHLasiE+pdtbxEzxR
fmgK5jsH28U++npFaP0Zh3yLCejPkuOu5fAVgFYknMNEIDnnCNoEpMPUs9+pP6vm
6N2XnhKQrcapQZemtFBmbaA61gmIO4DWwgiW3d/zkNTbEACQqxexy9RBW2osBZ2S
n9Nzy0N5o3i9PA7XrjVTXqvDV3n3MDM43Uzn+8YLK/AyYbOSGMhuiAFmP9jGq3KW
Mgg8KDRvefXXLoP5xhOVimTj2EN0xVJ5k6N8KfzRexZJqZtZI9tQbVYgMbPXo0I=
=O3PS
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
