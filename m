From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 for-next 14/14] RDMA/bnxt_re: Remove FMR support
Date: Tue, 23 May 2017 10:19:59 +0300
Message-ID: <20170523071959.GG17751@mtr-leonro.local>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
 <1495448144-18966-15-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495448144-18966-15-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2017 at 03:15:44AM -0700, Selvin Xavier wrote:
> Some issues observed with FMR implementation
> while running stress traffic. So removing the
> FMR verbs support for now.
>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
> v2 -> v3:
> 	- Removes the FMR verbs instead of the config option
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkj4p8ACgkQ5GN7iDZy
WKdaoQ//fW1qONjxnISlkpCSbFvv8861tZoGdjdGe8uON9zqaFEH9u+PlSxrq37Q
CygXjlmiAcR4fzaZQ0qgAzhRe1ljmdqoMR9ZQ3jq/VeZZlKcwj2bAEQvAlb+CxTo
JfAREnnymSwY3xsZ0eDI3QA8wOKRAp1pZ4yS6kyXWWRcj8vSxWXi4jemf9Lh+X99
2CInJN+OSfeVgv9dkn2/TppRGd4BrMo0paywCoiGyl5XzZEJ2UuhkFPErLRBIaVH
IMSE0PPrOvqTwFcgBVg08LP0E6Xhsc1aHXRTiNbs0sNOTUw5H7dNYcQbd9jw/kR8
65Szitz8ivbOercrIqwBHkzhkrN9Rht+MSdBWlTVBEnFsPr17t9QbimW0NKg2uAc
728hDilYt2S72NGMvgQkGR2bML22+5A32GgaoiBCiJsm2TOf0UryqGnIWFT8VhfP
lOcxUXBF0tAZPNmU6CqsEeVbwNb6AFGMy92qA9rxdsyRXET69SCpSLBlt/IP0Kjk
3z+cFuBogIj54YZWEE/F8eb9piEFUSthkgAr8fS1KTL9fkSOaUT9FbrlCh+Bs5CD
UQQQmg8r35/t5u8XEQc5Qo5ggJHvNgHLlIM97vikKNjhldfZOm28PmhKeF1/e6vL
fcXwwlx/yOEb2ZAaijr1rxivf/c2oK0JdfHFuM0czV0Kc1sZxrw=
=j9KH
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
