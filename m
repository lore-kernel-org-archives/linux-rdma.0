From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] libqedr: multiple bug fixes
Date: Sun, 11 Dec 2016 16:50:31 +0200
Message-ID: <20161211145031.GD20460@mtr-leonro.local>
References: <1481465891-14789-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481465891-14789-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 11, 2016 at 04:18:07PM +0200, Ram Amrani wrote:
> This set of patches fixes multiple bugs in qedr's user library libqedr.
>
> Ram Amrani (4):
>   libqedr: ignore inline flag in read verbs
>   libqedr: clear the flags field in the responder WC
>   libqedr: fix configuration of the EDPM extension header
>   libqedr: lower the verbosity of the destroy CQ failure message
>
>  providers/qedr/qelr_verbs.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Thanks, applied.

>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhNZ7cACgkQ5GN7iDZy
WKcnrRAAgZpiMaubu/zW319PImDjlspKF1ULxU+UTJlgLDJBhU6kVqEOUpM2uMKQ
5QRduF3nWo057UTdROwRYHsaCD5e6dJnP/q4joZbt5gPLszXyaXw43jxFBxWA24p
4W/oh2B/YL6KgkWFGmHm8U0c7YTl0eEHLqeUEEXgEiF5HNbEeDBSn01BuAx33U2C
v4npZ2L2MZ7xB453WfzyzZn+VNfXjHYLtkqcMHDz5+5UOCQEeu8ewyKjYAQCggZi
xR+TFN0N+lnxXobR5F98+iRHyM53g9jQeMSpGjvZj1y5S+gZXLatjmuS5YyUTxlk
jv9DvUZf1uxQHYVU5thn8VxJVojCM3jaiUhPlaMQglEYIgjPWF0Dom3BznVnvw1B
fF179Onf9b47OBptnUTEK+Q9pko2wS0w+PU3+4BdibVOsNm7a6RWnDOT8fGtiu3f
Xm4j4hcwYec7Kd3w4e/pjBEIVCrFddIF5rrrCd+LdQVouhj/w5yZ5qNApVnEGp30
VbjqQjnRh/NfNWwIgvMheN2qcM8UV9RVcJJcJgjwuSPVx1Vow3jL8MHA+qNQpNaB
p8HJM0+hT13fh+x3xpQ/r5oow0sY/kz61cEYDGRW1sJj12crYYfRkUi1eSW8C9vb
SvHe1JjJmyMV9XbbuEIBsk12YQYEzzHkIeDYIk4uMSsHuEJGtsQ=
=FTWZ
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
