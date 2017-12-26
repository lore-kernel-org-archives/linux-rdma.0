From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/hns: Add detailed comments for mb()
 call
Date: Tue, 26 Dec 2017 09:37:39 +0200
Message-ID: <20171226073739.GA10734@mtr-leonro.local>
References: <1514209039-9388-1-git-send-email-liuyixian@huawei.com>
 <1514209039-9388-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514209039-9388-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 25, 2017 at 09:37:18PM +0800, Yixian Liu wrote:
> This patch adds more detailed comments when we call the
> memory barrier function, such as rmb, wmb and mb. Three
> mb() callers are deleted since they are unnecessary.
>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 19 ++++++++++++++-----
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 22 +++++++++++-----------
>  2 files changed, 25 insertions(+), 16 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpB/EMACgkQ5GN7iDZy
WKd6WBAApCpcqfgVPxC+c9NGQriJLyaPAoymz1ohf+SHBPjbw3sKfwcbR3Q8QgFZ
ABwbAtOJDNzCEJWTfcVs1V6ALJUNYOvZh43RYduEnjIws4Ycy/XqzUEh3aRSFMbd
yUg44upD9HEgSxKpBp/3vrULGlBZA+v4GcllMX7NqEI9UUqst17JwHF4nU+bp3/p
lwuGuX0dltedGskXvPJsz5OsKqHmmhocsN0tn3Vgc3rybz5CXMyC859sgkktCPbk
QK4wkzwihJ6OkQx7uhMDxNpKNd+XvCSm4QKC0AKMoa40DZS7saCOODuNwCR+nV4e
Ic5thoYxJFXsp/GnlRp0L0kM/e/IijFav3pP+FstPPPY3aR0Sz/YH3PONz/R8f8W
ZHkvFqlkneilpUPyyRiuCBlAbgQsFuWpHcoz5PmyNWFisSnss3d79EfkFx0/qLUV
/N+9z3nmLQqOpsYCD3jVh2KHpxUpXJ3o40W56UdxQCVIf51m5my1dOvVCyJh0zi/
zdovIGQOVjZvtWCek70ikmVFwW+lz6dCGbg0yMBlr9MCEUBVxbM7pk11ulUBuwcT
n1aQXHfNMaFtEKW46/d9A3o3o9Mweo7LoEtCd9Dd5IKyg/PvKkmvJKyLsER8wnpA
Y/EumMRF+vQksQlmHxEieh0ixXuKWZmkmhApsxqnvCOdcapMqKk=
=evlT
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
