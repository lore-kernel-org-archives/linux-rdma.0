From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/cq: Don't process more than the given budget
Date: Sun, 12 Mar 2017 21:25:29 +0200
Message-ID: <20170312192529.GF2079@mtr-leonro.local>
References: <1489014358-13638-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489014358-13638-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 09, 2017 at 01:05:58AM +0200, Sagi Grimberg wrote:
> The caller might not want this overhead.
>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/core/cq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 2746d2eb3d52..21d1a38af489 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -29,7 +29,8 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
>  {
>  	int i, n, completed = 0;
>
> -	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> +	while ((n = ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
> +			budget - completed), cq->wc)) > 0) {
>  		for (i = 0; i < n; i++) {
>  			struct ib_wc *wc = &cq->wc[i];
>

I agree with Bart, comment is welcome.
Not everyone will remember that budget can be -1 and (budget - completed) can be -1.

Anyway,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljFoKgACgkQ5GN7iDZy
WKdsIA/9EU7YTYnTDbg0DRHAa03CnERJ51rD3NOKWS9+MbruIAvgCaHK51YLcF9g
fLPbHxHbLrOudLHUfaMxk26BTfYN4SMPQ3/3Ao/zyBLHtVpsc3fF4CtO2+KHmSEP
c5BwM6z94WjbloRTBnx2Z9yqxLMJiHUxOoEEdvp4K4NcBi8jCDurHicySsg6YDO6
3l4wHoUABWXpAsLvmHoHA6LpZt7QBQ2hz7AWpsXzLYxZt9rpeSrr0M455JOIQXNh
Y0/0i4Uur7Ftszcn457S0RaxRwPrKrap4gKSxtITqdfQdIBzYJhHnNUVSRV6fm92
8NqkvydbFLIPuWw9epZVOlBlIS86rLVdUQXi0T4YE6Tz1x4wOnJGtF1CTYPNkijX
LdzilXiNOAnBjIGDANujQFhpiIymMRHLR7zIRcD4IWcQ8GlE26iSplZMtP4blSVU
Kl9ZUOTz2Jl6cy2Ayxe9L93PGqozWK37/8fB+IrYe3IjcVavyPOcsRYuDZjKjpTn
i5v6bd4RjPLsbn7fkhEqzpgzkHp8AedpzVu+FwoYUM84lAVHmN0EhinlTVqAfLuF
p8ztKV7sjyi4fXzEzZkqr6+K3q1TrZwti2T+K7Tw2Koqelqjo1wvBeGwwXNW3Y5s
s2OVpVAzzYXU3AbD9d4+9gLVhn0kEZajLUqVOV0ipLLd0/nm9Oo=
=A//a
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
