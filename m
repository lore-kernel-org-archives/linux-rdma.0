From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Only put mmap_info ref if it exists
Date: Wed, 14 Dec 2016 11:51:26 -0500
Message-ID: <e2ff83ab-15f2-4ecc-f816-e87cba5f6fdb@redhat.com>
References: <1478033052-147252-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5oWuBWO7TqoFgaodkFSw4cBopuUoSG6E6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478033052-147252-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5oWuBWO7TqoFgaodkFSw4cBopuUoSG6E6
Content-Type: multipart/mixed; boundary="clesIljopbDkpX6DVKimb6IdwlBaGCnda";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <e2ff83ab-15f2-4ecc-f816-e87cba5f6fdb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Only put mmap_info ref if it exists
References: <1478033052-147252-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
In-Reply-To: <1478033052-147252-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>

--clesIljopbDkpX6DVKimb6IdwlBaGCnda
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/1/2016 4:44 PM, Jim Foraker wrote:
> rvt_create_qp() creates qp->ip only when a qp creation request comes fr=
om
> userspace (udata is not NULL).  If we exceed the number of available
> queue pairs however, the error path always attempts to put a kref to th=
is
> structure.  If the requestor is inside the kernel, this leads to a cras=
h.
>=20
> We fix this by checking that qp->ip is not NULL before caling kref_put(=
).
>=20
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--clesIljopbDkpX6DVKimb6IdwlBaGCnda--

--5oWuBWO7TqoFgaodkFSw4cBopuUoSG6E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXiOAAoJELgmozMOVy/dvbIP/1R2a2HigJQBJ1jaVnZcsMVc
vyRnYxoObyIA7wFYh9AwW3NXQZz5n5VaRFVstXAjH91EtxK8oW63yFL2EqUv0Dvm
dG6JwF/el9QA6fLhTDclr6T4yDVUV8/szz2vDJItBmdklbjpFv7LkMle76YAQ4kw
9eV0Rg8BUwJvObffzO4x60cdX81hLhsNeyjY4/gMIMVNPCFACMRfcAX76Kh59nNc
qAVWZksNAxXAVxPiVgHZ3bGL/JX05Y/M4XF2nHjxxksDdmurF7vKttG5qWREKWc/
h9luI/yZpZX7BM5tRVxtfPmbQQUqJbC+S8X3AWHfAaHL/+5yBG3HeyUMJl912Q5D
X2K797Yl1DBvbPW3JD5MEQ16MwIZHDiDaZyzr175oYLDXonKPsCwJxt+hNAiybrs
MLbgRDDRLEXUsixrQep9C/t+glPvdCfkvzUwv39v7PmKWN/XeBhh02kOAcTwTfmL
v/KpYpI+gU6hfS/xffif26uPcDQGfRdDOqqhmfg6qg4bmAZJgqZ3KPMAOsqkdEWy
2cpgX4+msGnkgWuFNLWHgOF/SqqfrcRH6vh3SyfmDYJIHpyKFWiyY5M6r2FGmrZi
Vvg9MIbGpGY7NLRwz3qqljLok1leUoNqIzSspZPCyDeAn36c6Z7hZjGPWa7W9SWM
zJ/ju51nFcVkXP37W+AQ
=QMeJ
-----END PGP SIGNATURE-----

--5oWuBWO7TqoFgaodkFSw4cBopuUoSG6E6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
