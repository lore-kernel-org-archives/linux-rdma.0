From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: fix pstateinfo from returning improperly
 byteswapped value
Date: Fri, 18 Sep 2015 11:41:17 -0400
Message-ID: <55FC309D.701@redhat.com>
References: <1441776501-5881-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jalRF1uLNNSrUdL1xeSJHpcjFrchkdA32"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441776501-5881-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christian.gomez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jalRF1uLNNSrUdL1xeSJHpcjFrchkdA32
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/09/2015 01:28 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Byteswap link_width_downgrade_*_active values before sending on the wir=
e.  In
> addition properly define the Port State Info structure.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Christian Gomez <christian.gomez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Rimmer, Todd <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jalRF1uLNNSrUdL1xeSJHpcjFrchkdA32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DCeAAoJELgmozMOVy/d7m8P+wXSRJsJsGz5Q4E48jcmpxPf
VVflVJiMDjAU5+J/aJEGmgr81mQ5VtLfimFMWUXpfmEz3jf8ZxJW5xavuGCgbp++
z4tr6f3IjsO6WZeRtrIth+cixDimH5t9VmxEuivDaz+/ZzoVfdD1xc5VAVC23WB7
fmbR5wP9QzZrDWrn9QjMHIXJURbFZ1ooRjE30o0DdZ9DmpdENVwjQ6aZqtGOxyn4
xTkbrDjxMu6vaYLn0RqTgiJ8TM/DrouRFD27+aApdgrSCu9jecvqERFBGIuQi32o
mL1wsMTycbefbi/zEZb+BG6FmPQvE+HSajp5pk9PVF5OOH2jceEgIi/CWtyZTk2G
zn1EylW/6vng1uCiLEB0vbVUr3noyQXHBDBn3ds8TS5PS1d8e/XNhzIxAXhCqKyW
qwHOX9Gy6/FB2WYt7gax1uydjh3kwQtfy/ddOQlY+3HPTLmIigWljOViUKalIyrm
SFXNBuhqHG8BGFmsVkmTV+EHlEiUC0BztlImsjbfQFt/0NyTCQPIghaSYUkvi9p8
Srqh4s32WfbPsfvjZ2NI+bpeJPmZ5VG4jBH+5uenNDYQHtgqnTCWmntqJMHAPY2a
uxoAaauG5TZNBHCOXJzGAQST2+VlDLLTS48DvEfZPHQyDc1CAomVxN6CeBtNF4zQ
nEJNsDwUmtfGjm/7THsX
=WAYK
-----END PGP SIGNATURE-----

--jalRF1uLNNSrUdL1xeSJHpcjFrchkdA32--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
