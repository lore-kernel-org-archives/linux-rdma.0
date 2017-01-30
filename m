From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/11] libbnxtre: Add support for posting and
 polling
Date: Mon, 30 Jan 2017 08:59:38 +0200
Message-ID: <20170130065938.GI6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-5-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ilsi/0vOxQ+fn9lZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-5-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Ilsi/0vOxQ+fn9lZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:35PM -0500, Devesh Sharma wrote:
> This patch adds code to support ibv_post_recv(),
> ibv_post_send(), ibv_poll_cq() and ibv_arm_cq()
> routines. With this patch applications are able
> to enqueue RQE or WQE ring doorbells and poll for
> completions from CQ. Currently, this code do not
> support SRQ, UD service and and flush completions.
> Following are the major changes:
>
>  - Added most of the enums to handle device specific
>    opcodes, masks, shifts and data structures.
>  - Added a new file to define DB related routines.
>  - Added routines to handle circular queue operations.
>  - Added enums and few utility functions.
>  - Added bnxt_re_post_recv().
>  - Add code to build and post SQEs for RDMA-WRITE,
>    RDMA-READ, SEND through bnxt_re_post_send() routine.
>  - Fixed couple of bugs in create-qp and modify-qp.
>  - bnxt_re_create_qp() now check the limits.
>  - Add polling support for RC send completions.
>  - Add polling support for RC Recv completions.
>  - Add support to ARM completion queue.
>  - Cleanup CQ while QP is being destroyed.
>  - Add utility functions to convert chip specific
>    completion codes to IB stack specific codes.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxtre/CMakeLists.txt |   1 +
>  providers/bnxtre/abi.h          | 189 +++++++++++-

Please use standard name for this file., there is long standing goal to
reuse kernel headers for this file.

It should be providername-abi.h (the same as in the kernel).

>  providers/bnxtre/db.c           |  92 ++++++
>  providers/bnxtre/main.c         |   1 +
>  providers/bnxtre/main.h         | 184 ++++++++++-
>  providers/bnxtre/memory.c       |   4 +
>  providers/bnxtre/memory.h       |  31 ++
>  providers/bnxtre/verbs.c        | 663 +++++++++++++++++++++++++++++++++++++---
>  8 files changed, 1124 insertions(+), 41 deletions(-)
>  create mode 100644 providers/bnxtre/db.c

<snip>

> +	qesize += (bnxt_re_get_sqe_hdr_sz() >> 4);
> +	hdr->rsv_ws_fl_wt |= (qesize & BNXT_RE_HDR_WS_MASK) <<
> +			      BNXT_RE_HDR_WS_SHIFT;
> +#if 0
> +	if (qp_typ == IBV_QPT_UD) {
> +	}
> +#endif

Please don't add dead code.

> +	return len;
> +}
> +
> +static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
> +				  struct ibv_send_wr *wr, uint8_t is_inline)
> +{
> +	struct bnxt_re_rdma *sqe = ((void *)wqe + sizeof(struct bnxt_re_bsqe));
> +	uint32_t len;
> +
> +	len = bnxt_re_build_send_sqe(qp, wqe, wr, is_inline);
> +	sqe->rva_lo = wr->wr.rdma.remote_addr & 0xFFFFFFFFUL;
> +	sqe->rva_hi = (wr->wr.rdma.remote_addr >> 32);
> +	sqe->rkey = wr->wr.rdma.rkey;
> +
> +	return len;

Return type mismatch.

> +}
> +

--Ilsi/0vOxQ+fn9lZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliO5FkACgkQ5GN7iDZy
WKf4cQ/9ErdMp3HKQx59hEn2qC67EyLNPY9CzZjr2o5D4kJ9i8jomq6WegIf39Lh
V5R17xr882KFfu0Q/K3QoGqReYXJ1CPZ8CBGRd0LCvBGcQtL9IvS2HH30KhychAP
eHkpilrbl6H2zLk1RgCvpbtEzdt6CrDRC7/l8fTdi6+2fAPkGXLPhAEQr4Ldfdni
CPmFHd60X48p39pI6n6nPJLdH/knzD4AWnN9Wk5lhtgz8Lij9/YCXRlala/Bqhs7
taKTBbEqeem3NLsT+gkba7nUF5jpzGVqNeKVsjt6TlYUwG06fa8yT3vAd/BgKSUx
6ieyvBNHgDBpKtvYlI5hApwN+yc0ix4PDSR0izqSF8lXVfgzhBvOC3+7JpW6htvY
8gwLZ6DAG56ulMVjExmvnuppUegDebtc5cI7oJhKx+kk7gmhaXwQETHJLp2eEL8u
fRs9f4kI6fb0MU/7v9xkVWEMoemdysng2XmPglHMYmbnNRVdXQN3d9ZeFrrmFOa+
ny5Z3R7dQr/bBCC/uMJDr/jrW1FqokqXRVOdR2DsAy0n4sPou/7nr6/Vy3+BKMNV
h55W87k/eM2eD2d7PURwOtpOOuGqI4iwzixypMDb4RPIqaAbVEHLBuWV9PPz0rh0
uLVMH6YRxh1/6/4PpUW+dHoR0iG/AmVuzLeDfRnoUBH1YjHHMq4=
=mlLZ
-----END PGP SIGNATURE-----

--Ilsi/0vOxQ+fn9lZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
