From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Rebase notice
Date: Tue, 7 Jun 2016 11:55:38 -0400
Message-ID: <4f8649f7-839c-a6a9-f713-bd8fdda83c20@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wQ7quqfjDMTfQWiexEpdfhHDRGgmpbbR5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wQ7quqfjDMTfQWiexEpdfhHDRGgmpbbR5
Content-Type: multipart/mixed; boundary="OduOCfe7L9bV7RLlWue0cu7R2NQ8eKocj"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <4f8649f7-839c-a6a9-f713-bd8fdda83c20-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Rebase notice

--OduOCfe7L9bV7RLlWue0cu7R2NQ8eKocj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

My k.o trees are intended not to be rebased.  However, a bad patch made
its way in last night (I probably should have waited to push my work
last night until today, after all it was late when I quit).  I ended up
rebasing the k.o/for-4.7-rc branch today.  This is just a friendly
heads-up in case anyone's normal pull mechanism for that branch will get
tripped up by a rebase.


--OduOCfe7L9bV7RLlWue0cu7R2NQ8eKocj--

--wQ7quqfjDMTfQWiexEpdfhHDRGgmpbbR5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVu56AAoJELgmozMOVy/d/ZYP/jMeA3tInx5Xsuz2xDFHB/Lf
/9a8kColE9sT++Jd9jaSkiD8gp0uzSYMbnZCp/EzihXvEhyj2cXkCFSIbI2qzhUp
HOpVX5LiekLmjdC/onFgblyrD6wQMZIYsAqMKsberN5KiqkNtShFtNS/DYr3sHzq
bRf9KOf6h5gZJgXTlndsGDj97NxsVcqiDMZoPREXjssxwza9cHriDgP3FeC11Bpb
eug3efGn0VXUsivmaTys7HxJ/B/lamb3vb3GvfhwaiuTgaJm8tccuUeuUT/TNsEU
aotHCZWJQaZWLSBzc9N/wr+Vrf/Hhl8ZI+8XcyIZ/6FzqjjtBwA8qmmpFEaLYSqD
wvq5WR10aGF9gRpl7IsAYG4DdLS4+B9jxJkFg84UBaggnoOBQNlHniykycvy+JTq
AGhtwWMdF6tIzK1ULfAR4ED/MTFQQsdsuzUs46/NunMXiBHZKuuKbMp4uBC04BB7
/53XBe7F8chjujRx9R1lvl233khcKeJ+sTYLKNBzKS8WemEF2bUpz7PY5KD7BQoC
ChFsGlIYQi7tLUGxyp9EAA+/aBlif2+Y5XrGnswQVb0rm9BRZoMCrLMsdqCOUVXz
ZCqFkzfm7BmOEr/Zr5nYZf/RFpN4r9u21QDokE28LpRm2zvgHodxF7XLx8/1ETh0
hOhmsv+3UaD5EZGabyAH
=CR64
-----END PGP SIGNATURE-----

--wQ7quqfjDMTfQWiexEpdfhHDRGgmpbbR5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
