From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Tue, 25 Apr 2017 20:58:49 +0300
Message-ID: <20170425175849.GS14088@mtr-leonro.local>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="owpTafYe/1tj88Rh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8992bd28-667f-94b1-e582-106e6b41aa4b-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--owpTafYe/1tj88Rh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2017 at 03:15:28PM -0700, Bart Van Assche wrote:
> ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
> than what fits into a single MR. .map_mr_sg() must not attempt to
> map more SG-list elements than what fits into a single MR.
> Hence make sure that mlx5_ib_sg_to_klms() does not write outside
> the MR klms[] array.
>
> Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Bart,

Thanks a lot, it indeed looks right.
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--owpTafYe/1tj88Rh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj/jlkACgkQ5GN7iDZy
WKfDlhAAlm/5g5G0zpE4roTyGDuPsOOB67+EzyihCe36OgCHhpkEhmE8qPYIxdjO
wy0fBpmPZuKVDLKMsrpckY+Fgu+0Rzsnf5Qlyf9TB2z6xfl56XdnYBfvJWKo1zPo
jWG1LYUVbM4mCBns/yTqIEhGBWAArJ9j7vt2Afe2ruPNZle8iqMJSvbPueRx77bO
OoWfZjTSmwkQxnmGZnocUyf1fmaw9niaa4vw3XhnPtnRC0hg13uX85u/MSBWRO9C
KtTaj5gO69Xc7EzrAq8tuyRL/MXRLrwtuS1b2hGp/0gcVBMdDKzO+Ux44sp5tEz6
NzQ8OyNTcdGon0ofEnagMueaOoiIoYl1hOQNmbkVMwMKJJZtAvKtNCdqr/1r0YpM
NN26az+DuAw7ivZdwnRKcFfYA/u52dAMgwva/8nL6WsJtl7/0JGpd/rtoDDOK/V8
DXBM2OKndG0W9TJFBAphU5hgF+Vo8JgK2PpDZdoKiQY0PKQ2N/zmD3ySZBZwYjL6
dcWQWfld7ya/qoB0cnQAnwwpTuK8wMOFJHt1gj7Ym5IullKS8eNnBMGyLJAkZCyD
bsbUY7wU2+6gHmotfAvdUV3b32ywYP3Cu2YEFtxsVAD1t2PdiqkF0j7FK6334fqL
pKpxtSOOwlYNk6u+R5ap16sP/5E9v7IwTqc8IeFL1bz1JLrZwDc=
=T5+L
-----END PGP SIGNATURE-----

--owpTafYe/1tj88Rh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
