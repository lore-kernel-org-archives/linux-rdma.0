From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 02/12] IB/hfi1: Convert the macro AHG_HEADER_SET
 into an inline function
Date: Wed, 27 Sep 2017 18:21:18 +0300
Message-ID: <20170927152118.GG2297@mtr-leonro.local>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
 <20170926140009.15601.38666.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926140009.15601.38666.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 07:00:11AM -0700, Dennis Dalessandro wrote:
> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> AHG_HEADER_SET macro doesn't conform to the coding standards as it can
> affect the control flow. Convert the macro AHG_HEADER_SET into an inline
> function ahg_header_set().
>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/user_sdma.c |   58 ++++++++++++++++++++++----------
>  drivers/infiniband/hw/hfi1/user_sdma.h |   29 +++++++++++-----
>  2 files changed, 59 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> index c0c0e04..4ea29ed 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> @@ -1254,20 +1254,25 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
>  				struct user_sdma_txreq *tx, u32 datalen)
>  {
>  	u32 ahg[AHG_KDETH_ARRAY_SIZE];
> -	int diff = 0;
> +	int idx = 0;
>  	u8 omfactor; /* KDETH.OM */
>  	struct hfi1_user_sdma_pkt_q *pq = req->pq;
>  	struct hfi1_pkt_header *hdr = &req->hdr;
>  	u16 pbclen = le16_to_cpu(hdr->pbc[0]);
>  	u32 val32, tidval = 0, lrhlen = get_lrh_len(*hdr, pad_len(datalen));
> +	size_t array_size = ARRAY_SIZE(ahg);
>
>  	if (PBC2LRH(pbclen) != lrhlen) {
>  		/* PBC.PbcLengthDWs */
> -		AHG_HEADER_SET(ahg, diff, 0, 0, 12,
> -			       cpu_to_le16(LRH2PBC(lrhlen)));
> +		idx = ahg_header_set(ahg, idx, array_size, 0, 0, 12,
> +				     (__force u16)cpu_to_le16(LRH2PBC(lrhlen)));

This "__force" looks suspicious to me and I think you have an error here by
using cpu_to_le16 instead of cpu_to_be16.

Thanks

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLwe4ACgkQ5GN7iDZy
WKeXJRAAsUvGt6UEJoLbLYlTwAbtapQZKsfxaoo5YMThQ9sI2w/ukexJvwtjjCS5
0UR5pZK+72cgiMw91F5AeOADo7XJ868FNgItrzD6V57TNgyGzGhvXnnRE7VK6t07
IMmXPlpH9HtCR8y+rj7Dw3/INj7Md6F9jWGFo1XMaBThfBLO1mRevM1Mp5vMNSbQ
qrJKQUb9wjIEBPU8Ewd3/w9V97hC2fdRkcTe8oAFKMji2clnxKjoKVXR39Bq3Za4
tFWsAyFqLDuP8Szfec62V1bu2SEv8P74ede61nVAJMC6E79VW+LsEmLVpgILugAv
J+Q5pOB7NTN7pvHnaWsBDU2Nn8ZjfCB9aqwdOUZ/k4NXXCUFvmgZqW/tQO+o32Zx
QZzC78H/37fPPgGLJ+UsGgwL54oiYewfheECrxvTXnIey/2piqBtlaQk0yeFsyEZ
C+RYGyjBh1d4+gup/hkQDj6cnKOpHwbsmLxcEMA9faabLU15ch19C9DbRoVVbV98
nyOItQMKsdiUavyr94z/X66/NVKTZ/dXiJ89dEJ+oVPWlKfK4UhcUIEA8OVzyxgn
m/xkkde+/Pf/Jnzx3lknmr29zxgxbJPHFzf1IVk+nWKE9vQAmIzEoh9u+RjeowvS
FURBSEafmkyTweWRZHG2ifWPaI1gUI6BP1x+u84LEaGit2suVyU=
=sOTK
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
