From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: When LMC is used who decides which path is used?
Date: Fri, 19 Dec 2014 19:04:43 +0100
Message-ID: <549468BB.2010303@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="unTMbDl3BXcQfJWXUddSig9gihNaFupdD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--unTMbDl3BXcQfJWXUddSig9gihNaFupdD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

When LMC is used, the subnet manager may program alternate paths through
the subnet for these various LIDs.
This is done by the routing algorithm, that programs the LFTs of the
switches to forward different LIDs on different ports.

Assume we have an algorithm that is programming alternative paths, can
someone please explain how will different nodes get to choose different
paths when LMC > 0?

Consider the following example:
Node N1 and node N2 wants to communicate with node N3 and node N3 can be
reached either on LID 6 or LID 7 if LMC=3D1.
DLID 6 is routed through port 1 (p1) on switch 2 (sw2) and port 1 (p1)
on switch 1 (sw1)
DLID 7 is routed through port 2 (p2) on switch 2 (sw2) and port 2 (p2)
on switch 1 (sw1)

                 -----------
                 |sw1      |
                 |    p1 p2|
                 -----------
                 /  /   \  \
          -----------   -----------
          |sw2 p1 p2|   |      sw3|
          |         |   |         |
          -----------   -----------
             /   /         \
            N1  N2         N3
LIDs:       2   4          6
LIDs:       3   5          7


Which entity (SM, user app etc) is responsible for determine and decide
that node N1 is better to send traffic to DLID 6 and node N2 is better
to send traffic to DLID 7 (so that the two communications use different
paths)?

Vangelis


--unTMbDl3BXcQfJWXUddSig9gihNaFupdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUlGjDAAoJEEuGx9KTo03qpmcH/1nlDh2lCnBIFDIdOd1dnArM
Xely3EI1V2oBmhI3yNlnQwu6E1FaB8A9WA3Ucoy0Er79FDgzN+I5KC7y+rml7kxy
1qPxxYwB8mxn7m915kR8Ca64umtWbHRiHEpHyVaILAnpD0jDZuUTe3b2Ep1ptq+2
sJgGuGXz46atAyQR+afizgFn6gUzqiZ1c4CEGzkkSqA2YuvUiHY9v1Ig1Ho5hEsG
7Wp2/xvqrYeKiJ57S9s0b1P7paihCQ8+ZjFtPZbpg2zuJR5LsryIxOeBF1ULC25h
ao01a/ohOenWDS9Q5/pKMVB03AAYGxRrtgHyI6Xl6VHXrlYaakBt837R5NgECFE=
=wwoS
-----END PGP SIGNATURE-----

--unTMbDl3BXcQfJWXUddSig9gihNaFupdD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
