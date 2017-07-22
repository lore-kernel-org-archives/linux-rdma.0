From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Fix modify_qp failure
Date: Sat, 22 Jul 2017 14:17:56 -0400
Message-ID: <bafa2001-1597-71ea-eb68-f939b806dc63@redhat.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uJSrBHXQCeJnGhgocAxRRO9cPbK1jsixi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500043291-19768-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uJSrBHXQCeJnGhgocAxRRO9cPbK1jsixi
Content-Type: multipart/mixed; boundary="iOw96QAoI8keD10ilsE6AVHN2mutdv3Wq";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Message-ID: <bafa2001-1597-71ea-eb68-f939b806dc63-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Fix modify_qp failure
References: <1500043291-19768-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1500043291-19768-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--iOw96QAoI8keD10ilsE6AVHN2mutdv3Wq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/14/2017 10:41 AM, Mustafa Ismail wrote:
> Commit 5ecce4c9b17b("Check port number supplied by user verbs cmds") ca=
uses
> modify_qp to fail because port_num is only valid when the mask is set.
>=20
> Additionally, for iWARP, the port_num is not initialized which also
> causes modify_qp to fail.
>=20
> This series fixes both issues.
>=20
> Changes to V2:
> * Add reviewed-by
> * Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>=20
> Mustafa Ismail (2):
>   RDMA/uverbs: Fix the check for port number
>   RDMA/core: Initialize port_num in qp_attr
>=20
>  drivers/infiniband/core/cma.c        | 2 ++
>  drivers/infiniband/core/uverbs_cmd.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--iOw96QAoI8keD10ilsE6AVHN2mutdv3Wq--

--uJSrBHXQCeJnGhgocAxRRO9cPbK1jsixi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5bUAAoJELgmozMOVy/dVYsP/i0zgTr9GT/QVVDEjirxEonS
41Hv4BsIDmchOOhMz/SGEr3m3Tx+Z02oUWqieDUKp22LaRmzCLIcNDtNMtUxtQZG
eCqyOanbKblN3kOOKJrIJoQhJQWTLyKCYfbBfwr7wkmgLA+JfuARUdv6YpSEKRCC
je1sXaI0DEtLoBT4WVZkgrlc/O4VGLcEvtpoZHgH+OAsaEFSx9c6CX1SMj1KEO6y
uOnEdyYHRJWIaT1dKMv+dhUvj65NYinmN7+v0wznF2MZnvUumN+6bOvdwn8Ng5V3
hKAqJLUC8zBrBHop3yzm3+yPX0ZJjyTUNVUjPgll32/Ov2X9jTfw/Ri/842Csl8S
a3fTK+ekZwVHtet7zxaR3EH3H+wZwpHPhC7D1v+m26FZBtb7GMOZfgZnSdIikNbv
GLH7LBvepDaOXjcPnVzXEvEzWYfGzXHdlhrNL/ezNdtggxHMUn/mFqS4ateJAO5M
bO66WP5nihM09HFWBSc/SYQubSwn3Vu7TJ4TrJxvq7JNWa76mwKOKEGrPoPXt/OS
3nmyMt/MgWHT0Utm8TLxUEePjodlTMJaNQ7NXtBUQpMeUQuocH+bqTeZ/NNEd7gh
V3zcFRNmCOJtcXImM2qSoE3UI8BQDuYCH5/W2WcUtRoziAXu1nBOUyyGKwJIS25e
eT8Do8dEsXjEL7P/8k8g
=MJhO
-----END PGP SIGNATURE-----

--uJSrBHXQCeJnGhgocAxRRO9cPbK1jsixi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
