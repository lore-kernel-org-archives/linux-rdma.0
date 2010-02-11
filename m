From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ibutils license problems + a few other minor issues
Date: Thu, 11 Feb 2010 12:11:38 -0500
Message-ID: <4B743A4A.90004@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C48260FE6AB8A92177ED73C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C48260FE6AB8A92177ED73C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The ibutils tarball as found for download on the openfabrics web site
has some licensing issues that need resolved ASAP.  The tarball in its
current form is probably illegal to distribute until the items are
fixed.  So, here's what popped up in review (done by Jay Fenlason):

The COPYING files sprinkled around in the tarball are not consistent.
Some of them contain a copy of the GPLv2, some of them contain a
statement that the package is licensed under either GPLv2 in the file
COPYING or the OFA BSD license included here in.  Of course, it doesn't
work to reference a COPYING file from within the COPYING file you are
referencing and say it has the information you aren't including here.  I
would suggest that the proper place for the statement of GPLv2 or BSD is
in possibly a LICENSE file with the COPYING file being the GPLv2 as
stated.  It also seems redundant to have multiple COPYING files and
possibly also multiple LICENSE files in a single tarball, so cleanup of
unnecessary files seems in order here.

There are a number of files who have headers that indicate they are
*not* under either GPLv2 or BSD.

ibdm/replace/regex.[ch] are LGPLv2+, so need a LGPLv2+ COPYING somewhere
ibdm/replace/{memset.c,realloc.c,malloc.c} are GPLv2+ versus GPLv2

ibdm/src/fabric_sim.cpp claims to be confidential and proprietary! It
refers to LICENSE.txt for t&c. There is no LICENSE.txt under ibdm/.
There is one under ibmtsim/utils/ though.

ibmgtsim/config/{missing,config.sub,ltmain.sh,depcomp,config.guess} is
GPLv2+
ibmgtsim/config/install-sh is X license

ibmgtsim/utils/{,un}install.sh is GPLv2+

There are also a few other minor issues with the tarball as it builds:

/usr/bin/ibnlparse has no man page

/usr/share/man/man1/ibdm-ibnl-file.1.gz
/usr/share/man/man1/ibdm-topo-file.1.gz
Are in man1, but have no corresponding executables. Perhaps
they should be in a different man section?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig8C48260FE6AB8A92177ED73C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt0OkoACgkQg6WylM+/8ZT/RACgi17uK5jxQw4npwC1PZQ8HKih
NN4AoJp1R5K8EyzVOV2sy+62lSGUePy5
=cD2p
-----END PGP SIGNATURE-----

--------------enig8C48260FE6AB8A92177ED73C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
