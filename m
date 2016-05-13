From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Adding queue drain functions
Date: Fri, 13 May 2016 15:59:06 -0400
Message-ID: <91dabe24-d51a-ca8c-d876-f344ac7429d0@redhat.com>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eDng0w7iKoAisbmNLPIRwvU6qgCjeaVPi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160329175837.GA9868@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eDng0w7iKoAisbmNLPIRwvU6qgCjeaVPi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/29/2016 01:58 PM, Tatyana Nikolova wrote:
> Adding sq and rq drain functions, which block until all
> previously posted wr-s in the specified queue have completed.
> A completion object is signaled to unblock the thread,
> when the last cqe for the corresponding queue is processed.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/nes/nes_verbs.c | 34 +++++++++++++++++++++++++++=
+++++++
>  drivers/infiniband/hw/nes/nes_verbs.h |  2 ++
>  2 files changed, 36 insertions(+)

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--eDng0w7iKoAisbmNLPIRwvU6qgCjeaVPi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjIKAAoJELgmozMOVy/dDqAQAJskbyMdBoLgMk5Z0V2M6KQk
fn0/YoYt5ECjs7w9u8x83W6CrDebBmIZdAvNJeqi3/LVNT9+WUorPjyLECWZCTrE
y4+D0DTWKdwP4pZ1MHwbkZ00d2nrsUzbwcus7Ki4+msjlsTHfL4VVOizSR9druKo
WUxTmbUpumdofmVi4oQD2la1ZHFM/6jKbOO2BLWisOPmiImNAltC+kXeR6mfDwwW
EG8oHl86zbEmphlL0A5bM055YIEQCAczsc+JrVXfUFzTp/YBqMDzh8preVnsNNAb
ZgKA1lED0K9APqBm1ZWLrX2cW1wQg1bVzzQqfzHKb7IAgK5rWIZLLdnR9w93YZfc
UjHPYLASCdVsiR9894F5ipGa9mCB3ghfyhgjdOk7jDrbCo5VFNs3q8adaPv9McNd
Mx6YmWUgwQm3HgTZnWUholcUAsmoZ8I97CaDnviRv+wn5AYkSL/L7CQ3HrcwdQyx
3bj83x8mzzTngAZsaOmCGwxJf43fxqPzlSaDCoxqFuXt4g7s9CIfqT5wGB74Axia
JwqTHstYHOGeQqipAhIHsGBo3/XP3848Uz2Rc8/9XEDBgTe2c22/YiOlAJTZ9yzb
54J7CaGdcd2K6hCUCrbfSzTCCVidOW/cfT37i35ZExS9A9VePomYcJMBG+u0Nf8L
bbs9DXx6I+p/2GsxpCXR
=ze0H
-----END PGP SIGNATURE-----

--eDng0w7iKoAisbmNLPIRwvU6qgCjeaVPi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
