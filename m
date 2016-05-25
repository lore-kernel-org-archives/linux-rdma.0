From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: Re: [PATCH v8 05/22] IB/hns: Add initial profile resource
Date: Wed, 25 May 2016 16:34:10 -0400
Message-ID: <4df9ef7d-dad2-d6e2-9b9b-eaf695224690@redhat.com>
References: <bfc140ec-2691-8266-cc7d-0c96224b3cab@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="E9Ek93V2gfDFC0fECT5J3GRfxljIPunql"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bfc140ec-2691-8266-cc7d-0c96224b3cab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E9Ek93V2gfDFC0fECT5J3GRfxljIPunql
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable




-------- Forwarded Message --------
Subject: Re: [PATCH v8 05/22] IB/hns: Add initial profile resource
Date: Wed, 25 May 2016 15:00:13 -0400
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Organization: Red Hat, Inc.
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 05/25/2016 11:05 AM, Lijun Ou wrote:
> This patch mainly configured some profile resoure. For example,
> vendor_id, hardware version, and some data structure sizes so on.

> +/* Address shift 32bit with the special hardware address operation of =
RoCEE */
> +#define ADDR_SHIFT_32				32
> +

When I said you need to document the address shifts, this is not what I
had in mind.  Anyone can tell that this is a 32 bit address shift,
that's obvious.  The question is *why* is it a 32bit shift?


> +				((u64)le32_to_cpu(roce_readl(hr_dev->reg_base +
> +					     ROCEE_SYS_IMAGE_GUID_H_REG)) <<
> +					     ADDR_SHIFT_32);

And here's a usage of it that really doesn't need to be a #define.  If
you have a u64 and you are reading two u32s, then it is OK to shift by
the literal 32.  In fact, when you need an explanation in this case is
if you *don't* shift it by 32.  So this one is OK to use a literal 32
and you don't need a define.

However, in a later patch, you add a shift by 12.  And you add the same
silly comment in front of it.  That does nothing to tell the reader that
the *real* reason you have a fixed ADDR_SHIFT_12 is that you have a
register on this hardware (maybe more than one, I only saw the one) that
assumes the address written to it is shifted as though the system uses a
4K page size even if it uses some other page size.  *That's* the sort of
explanation you need for a hard shift of 12 in your address shift comment=
s.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--E9Ek93V2gfDFC0fECT5J3GRfxljIPunql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRgxCAAoJELgmozMOVy/dzdYQAKazddimwC0dwhZ9xJCTM3R0
74/NBBH8gl/aTUvdydFwFVxq44/F35HDLZ3XYsO9uWuhBdd4HmrA8fJvhTOIbQjk
sfBrqGXEidfWXmO7cXstL8PrCETdlre0UPQ3CgYjqboL2+hYFtCyzq5KZ+ZH/qsY
oePftJ2pifcy23D++oUJNAE7w8OtUxRjr8sT2/NxsIAzVNXBMDBOXnJWrGqz9ERN
2qfuVVHA0WoxslvjdPy5gFYAJxDHiiLHSIqtjoTqWoBPK/VnY0fFmCoLxgnJBpRm
qh8yLdIw29eZk13FF4Rm4GD5FkyLu+Nv3MnKh+Uu2Tqjv+RukzefOrIXyuwRPY5O
JKZowAGv38E6VptXnqen9KFL1XI6sH2hUnQsFHPw1k5q8n/Bq+gPUwsirYojE65E
qN66YXWrZeyOVAILLOX4xM4DeJMdDLZaS0qpvQ/NwXSLrT8Y44xiW1bg4BaCOipa
cdSBAtsqCN40SKvpJXPETJLI8DFNbFcPQBFSp1VkmLDjgRGhdX0qGvIxYgouDAk5
j3HYorNeb+er3Duw2uHN714DVU8Hvmb9E56TyYUfyg28JbcvhjBvfA+jBO5PY+c1
8DkLhWSCVOSrTpqAnTwdyD6ZcC3IaLyDxdVucXnkh2hJ/Tyv9XtNzEqRn2eRYbcz
pdfap/5Z0L0cffh3vFvl
=ayzP
-----END PGP SIGNATURE-----

--E9Ek93V2gfDFC0fECT5J3GRfxljIPunql--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
