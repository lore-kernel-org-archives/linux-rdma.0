From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 10/11] libbnxtre: Add support for SRQ in user
 lib
Date: Tue, 31 Jan 2017 14:42:28 +0200
Message-ID: <20170131124228.GR6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-11-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6aLNMpa4RfPduGT7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-11-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6aLNMpa4RfPduGT7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:41PM -0500, Devesh Sharma wrote:
> This patch adds support for shared receive
> queue. Following are the changes:
>  - Add ABI for user/kernel information exchange.
>  - Add function to handle SRQ ARMing and DB-ring.
>  - Add function to create/destroy SRQ.
>  - Add function to query/modify SRQ.
>  - Add function to post RQE on a SRQ.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxtre/abi.h   |  27 +++++
>  providers/bnxtre/db.c    |  18 ++++
>  providers/bnxtre/main.h  |  20 +++-
>  providers/bnxtre/verbs.c | 261 +++++++++++++++++++++++++++++++++++++++++------
>  4 files changed, 288 insertions(+), 38 deletions(-)
>
> diff --git a/providers/bnxtre/abi.h b/providers/bnxtre/abi.h
> index 451af08..e6fb9e4 100644
> --- a/providers/bnxtre/abi.h
> +++ b/providers/bnxtre/abi.h
> @@ -216,6 +216,7 @@ struct bnxt_re_mr_resp {
>  	struct ibv_reg_mr_resp resp;
>  };
>
> +/* CQ */
>  struct bnxt_re_cq_req {
>  	struct ibv_create_cq cmd;
>  	__u64 cq_va;
> @@ -263,6 +264,7 @@ struct bnxt_re_term_cqe {
>  	__u64 rsvd1;
>  };
>
> +/* QP */
>  struct bnxt_re_qp_req {
>  	struct ibv_create_qp cmd;
>  	__u64 qpsva;
> @@ -354,6 +356,19 @@ struct bnxt_re_rqe {
>  	__u64 rsvd[2];
>  };
>
> +/* SRQ */
> +struct bnxt_re_srq_req {
> +	struct ibv_create_srq cmd;
> +	__u64 srqva;
> +	__u64 srq_handle;
> +};
> +
> +struct bnxt_re_srq_resp {
> +	struct ibv_create_srq_resp resp;
> +	__u32 srqid;
> +	__u32 rsvd;
> +};
> +
>  struct bnxt_re_srqe {
>  	__u32 srq_tag; /* 20 bits are valid */
>  	__u32 rsvd1;
> @@ -384,6 +399,18 @@ static inline uint32_t bnxt_re_get_rqe_hdr_sz(void)
>  	return sizeof(struct bnxt_re_brqe) + sizeof(struct bnxt_re_rqe);
>  }
>
> +static inline uint32_t bnxt_re_get_srqe_hdr_sz(void)
> +{
> +	return sizeof(struct bnxt_re_brqe) + sizeof(struct bnxt_re_srqe);
> +}
> +
> +static inline uint32_t bnxt_re_get_srqe_sz(void)
> +{
> +	return sizeof(struct bnxt_re_brqe) +
> +	       sizeof(struct bnxt_re_srqe) +

You introduced the inline function exactly for this.

> +	       BNXT_RE_MAX_INLINE_SIZE;
> +}
> +

--6aLNMpa4RfPduGT7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliQhjQACgkQ5GN7iDZy
WKfPLg/7Bh0lC6B4Ps0v2qE1soIGaPED178fS7OwXsZSOKv3rf2uob7adi18Scvv
ksWmtzXsiwIApzhjqxKYGqsAGVU8acjp4ImEuVxh2u/uSYSwBkii764MKpJ+Wp/i
q6VIRc2YaBLm10CE+EOleOTuERpccSew1q282iBTEsBwSzY79oBdACXEYrrf78uq
bq2WXDu3BRWGfBXvjRJ/1/vSJPdpA5sRpU0yMw+wIUF4CHSVQqs8RQFqJe7R0vIV
j9EraqeHcUEAEtTGmJVnInpvE0gZIKvu6dM9l2h5Q8LRLpzqdGjqISB0ujagVn0c
ToBZOwyENNoqBHeVB63Ui6/FvuA1nN8tnvNmhu4ESXJZuAermA3ZJy2/WdFJYKYK
dcy6FyfVV5GAJhnbsScShi32G48NVsxbbiv2EUu0pSkON72NRYy10kELS7HDtmks
7aQTfhPRX5ltH8nQumGTWjAiaqjDNi0mhJtJ9IbEf+UG88oEPeYQbTT9UPnezqjj
cPaHEL1Y38LtXP1teHMw49vZO0y2uiifTJDOD+bzvlK2eEnPrfNFgbAJEZmtH9VB
IK/QYdvT9aTbTthhAbtkw4qoCx/VQxM+EwiaFbDygLhFevQn7ZUEhi4IFnv+n+FZ
VUfwlGKdQTvD5/FpzxALaLaUVpoQ+omRgyg/coKCv2r0kdH6JPw=
=nZDT
-----END PGP SIGNATURE-----

--6aLNMpa4RfPduGT7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
