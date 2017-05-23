From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 for-next 02/14] RDMA/bnxt_re: HW workarounds for
 handling specific conditions
Date: Tue, 23 May 2017 10:23:21 +0300
Message-ID: <20170523072321.GI17751@mtr-leonro.local>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
 <1495448144-18966-3-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="doKZ0ri6bHmN2Q5y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495448144-18966-3-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--doKZ0ri6bHmN2Q5y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2017 at 03:15:32AM -0700, Selvin Xavier wrote:
> From: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> This patch implements the following HW workarounds
>
> 1. The SQ depth needs to be augmented  by 128 + 1 to avoid running
>    into an Out of order CQE issue
> 2. Workaround to handle the problem where the HW fast path engine continues
>    to access DMA memory in retranmission mode even after the WQE has
>    already been completed. If the HW reports this condition, driver detects
>    it and posts a Fence WQE. The driver stops reporting the completions
>    to stack until it receives completion  for Fence WQE.
>
> Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
> v2 -> v3 :
> 	- Fixes the memory leak pointed out by Leon
> v1 -> v2 :
> 	- Small Correction in the commit message
> 	- Fixes q_full_delta for SQ by setting it to 128
>
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c  | 373 ++++++++++++++++++++++++++----
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h  |  15 ++
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c  | 165 +++++++++++--
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h  |  17 +-
>  drivers/infiniband/hw/bnxt_re/qplib_res.h |   1 -
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c  |   5 +
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h  |   2 +
>  7 files changed, 508 insertions(+), 70 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--doKZ0ri6bHmN2Q5y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkj42gACgkQ5GN7iDZy
WKdlrg/+JCnKAewazaCWCROU3ywYcs66m0/8/yf6F7anZdJ+NZadGnZ16UaiPQMh
Dx3+yKdzNDN8w7gozwPog1xWN/Z4A7aAxBCth7dLM7CPUWJ9VIfCvq510jyoQaEl
PGf/BlNS+l5wUcpcUHtIzgxe0+pYYAdkPymh4Xlp0B88kDL5FRhmZBYonLXjF9gV
Lxq27zTXLGWL0y1MRzYYXpPJJ8Wqo/34MIdAlAPvmRW+9vpdDVF7a8Ej4luDpX76
libd5jB8ab+rGzGO258ZKKanKJUsJsncpxcc1WUCYk0z0cTx9PGCG9p4PMr165f7
LhbjMrfc3Jr0skg1LvhaeJoyZ1JW+2LSTIPEcddR8CCdC4LKCPlEiF+pKK4aS/mc
ZiVALFEB+I3d1Iz0pWie8wFEI7muZnBar6dbiuy7y9ilQZQV5pRGP4K8Y+SZIc2x
2qAPcewZ6Khl7ZqyvSDwxgVDbIBdCpZGA9icqu8jHbpSur7orQ5qBo345+L/0zxb
uVdIedAUoKMWUbZhiSEFECy78yzG+6RnXTs0OyIbShexG4gbhSTXeg19X2GOSOlA
nhgsPv/oX6rZW8vSc0ApVPsDmLrlzlA95XxYvmfefann9PqrOKUTrDplbJyDVfDo
JUrk8JqK+wiAoZW1NBy8LLlT49uJA5BfxiAtBWQ9ACvPFnA1vx8=
=eni/
-----END PGP SIGNATURE-----

--doKZ0ri6bHmN2Q5y--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
