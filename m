From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libqedr: fix queue wrapping logic
Date: Thu, 15 Dec 2016 20:38:16 +0200
Message-ID: <20161215183816.GI811@mtr-leonro.local>
References: <1481794020-28167-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481794020-28167-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 11:27:00AM +0200, Ram Amrani wrote:
> The pointer to a CQ, SQ or RQ may wrap before reaching the end of the
> queue for certain queue depths. This is fixed by using a wrapping logic
> based on a pointer rather than an index.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr_chain.c | 24 +++++++++++++-----------
>  providers/qedr/qelr_chain.h | 22 ++++++++++++----------
>  providers/qedr/qelr_verbs.c | 10 +++++-----
>  3 files changed, 30 insertions(+), 26 deletions(-)

Thanks, applied.

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhS4xgACgkQ5GN7iDZy
WKfDOhAAi1UZPprdyt1hI7FxE8yhbEvwutCLsL5IS47A28Cng9hnJRwqkiWM4W5Y
H3pm12Xg/KYQNOsepbM7/eHGBLgbEw4aiMIwyrkztw/mwZEAjbAOpEK9wfFkmEcV
Wsr2wVlVVo2WspA+I4ZKxf6VEd9pMvFa5/l56VNq1E7Sywyg4Wdto9rpKGTpJPnG
JimX30+biV+V5j4E26wRtHYuAxLvTE/afQnDEJWZQ0wFStvu0Y+i5S3mFTjRCaCz
AqE0RoJDX4SDnTLkVZjgy4Sp82XMUUEiFuDo82duZs3MpKuhtSgB0otKkLXlwu7K
ztjoDfKpiQ95pDuLYE6SwZUHbNZh+kXZRIUi41U4+Sr8XusulKazJ9g5FwBTCeMa
epjp0py7WEvgrPywnRQm5W1M4dzKyWO6HfESa6Xh+mSy8E0z2lwsTxSeLumD+wRu
JRURcWH5PQ0rcDMSPedwZvypyr7LPw8UZppljd0woNOu91zKRJ8S5LvKPabhttRO
6yJtcLtBT8z1MsVVO8Y24TJxbckGd7ccmMSS+Gr2AhC0CcFSSyIHUiupK22+4O5u
jHDeQD3LzEgLdlCC/49GI9oLiUlwR1pLZBkuH6hoSQgVObjj1xa3F+HO86neuo4F
EQLWJSrJQC6N9kH2S95B1QxKbI/6BaYfz2niQDx2wwz6E58SiJU=
=40lZ
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
