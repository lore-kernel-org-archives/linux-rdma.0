From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/11] libbnxtre: convert cpu to le all over
 the place
Date: Sun, 29 Jan 2017 09:09:52 +0200
Message-ID: <20170129070952.GB6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-7-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jwJ6bIT+r2BZUD+c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-7-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jwJ6bIT+r2BZUD+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:37PM -0500, Devesh Sharma wrote:
> User library should take care of endian-ness when reading
> or writing data to the device.
> This patch also adds a warning message and fails the call if
> access to any unsupported object is attempted.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxtre/db.c     |  2 +-
>  providers/bnxtre/memory.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  providers/bnxtre/verbs.c  | 24 ++++++++++++++++--------
>  3 files changed, 62 insertions(+), 9 deletions(-)

I have two questions regarding this patch.
1. Why don't you introduce the proper ordering immediately and don't
defer such conversion to patch #6?
2. Why does bnxt_re_le64_to_host return values while you are not checking it
anywhere?

Thanks

>
> diff --git a/providers/bnxtre/db.c b/providers/bnxtre/db.c
> index b705c8b..fc22e0d 100644
> --- a/providers/bnxtre/db.c
> +++ b/providers/bnxtre/db.c
> @@ -43,8 +43,8 @@ static void bnxt_re_ring_db(struct bnxt_re_dpi *dpi,
>  {
>  	uint64_t *dbval = (uint64_t *)&hdr->indx;
>
> -	/*TODO: cpu_to_le64 */
>  	pthread_spin_lock(&dpi->db_lock);
> +	*dbval = htole64(*dbval);
>  	iowrite64(dpi->dbpage, dbval);
>  	/* write barrier */
>  	wmb();
> diff --git a/providers/bnxtre/memory.h b/providers/bnxtre/memory.h
> index a7a7d90..4360914 100644
> --- a/providers/bnxtre/memory.h
> +++ b/providers/bnxtre/memory.h
> @@ -109,4 +109,49 @@ static inline void bnxt_re_incr_head(struct bnxt_re_queue *que)
>  	que->head = bnxt_re_incr(que->head, que->depth);
>  }
>
> +/* Memory byte order conversion functions. */
> +#if __BYTE_ORDER == __BIG_ENDIAN
> +static inline int bnxt_re_host_to_le64(uint64_t *src, int bytes)
> +{
> +	int qwords, indx;
> +
> +	if (!bytes || bytes < 8)
> +		return -EINVAL;
> +
> +	qwords = bytes / sizeof(uint64_t);
> +	for (indx = 0; indx < qwords; indx++) {
> +		if (*(src + indx))
> +			*(src + indx) = htole64(*(src + indx));
> +	}
> +
> +	return qwords;
> +}
> +
> +static inline int bnxt_re_le64_to_host(uint64_t *src, int bytes)
> +{
> +	int qwords, indx;
> +
> +	if (!bytes || bytes < 8)
> +		return -EINVAL;
> +
> +	qwords = bytes / sizeof(uint64_t);
> +	for (indx = 0; indx < qwords; indx++) {
> +		if (*(src + indx))
> +			*(src + indx) = le64toh(*(src + indx));
> +	}
> +
> +	return qwords;
> +}
> +#else
> +static inline int bnxt_re_host_to_le64(uint64_t *src, int bytes)
> +{
> +	return 0;
> +}
> +
> +static inline int bnxt_re_le64_to_host(uint64_t *src, int bytes)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif
> diff --git a/providers/bnxtre/verbs.c b/providers/bnxtre/verbs.c
> index c2340af..adb9b23 100644
> --- a/providers/bnxtre/verbs.c
> +++ b/providers/bnxtre/verbs.c
> @@ -262,8 +262,9 @@ static uint8_t bnxt_re_poll_err_scqe(struct bnxt_re_qp *qp,
>  	ibvwc->wc_flags = 0;
>  	ibvwc->wr_id = swrid->wrid;
>  	ibvwc->qp_num = qp->qpid;
> -	ibvwc->opcode = (spsn->opc_spsn >> BNXT_RE_PSNS_OPCD_SHIFT) &
> -			 BNXT_RE_PSNS_OPCD_MASK;
> +	ibvwc->opcode = (le32toh(spsn->opc_spsn) >>
> +			BNXT_RE_PSNS_OPCD_SHIFT) &
> +			BNXT_RE_PSNS_OPCD_MASK;
>  	ibvwc->byte_len = 0;
>
>  	bnxt_re_incr_head(qp->sqq);
> @@ -301,8 +302,9 @@ static uint8_t bnxt_re_poll_success_scqe(struct bnxt_re_qp *qp,
>  		ibvwc->wc_flags = 0;
>  		ibvwc->qp_num = qp->qpid;
>  		ibvwc->wr_id = swrid->wrid;
> -		ibvwc->opcode = (spsn->opc_spsn >> BNXT_RE_PSNS_OPCD_SHIFT) &
> -				 BNXT_RE_PSNS_OPCD_MASK;
> +		ibvwc->opcode = (le32toh(spsn->opc_spsn) >>
> +				BNXT_RE_PSNS_OPCD_SHIFT) &
> +				BNXT_RE_PSNS_OPCD_MASK;
>  		if (ibvwc->opcode == IBV_WC_RDMA_READ ||
>  		    ibvwc->opcode == IBV_WC_COMP_SWAP ||
>  		    ibvwc->opcode == IBV_WC_FETCH_ADD)
> @@ -473,8 +475,8 @@ static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
>
>  	while (nwc) {
>  		cqe = cqq->va + cqq->head * bnxt_re_get_cqe_sz();
> +		bnxt_re_le64_to_host((uint64_t *)cqe, cqq->stride);
>  		hdr = cqe + sizeof(struct bnxt_re_req_cqe);
> -		/* TODO: LE to CPU cqe & hdr */
>  		if (!bnxt_re_is_cqe_valid(cq, hdr))
>  			break;
>  		type = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_TYPE_SHIFT) &
> @@ -708,6 +710,9 @@ static int bnxt_re_check_qp_limits(struct bnxt_re_context *cntx,
>  	struct ibv_device_attr devattr;
>  	int ret;
>
> +	if (attr->qp_type == IBV_QPT_UD)
> +		return -ENOSYS;
> +
>  	ret = bnxt_re_query_device(&cntx->ibvctx, &devattr);
>  	if (ret)
>  		return ret;
> @@ -1019,7 +1024,8 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
>  	nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
>  	psns->flg_npsn = nxt_psn;
>  	qp->sq_psn = nxt_psn;
> -	/* TODO: cpu_to_le64(psns) */
> +
> +	*(uint64_t *)psns = htole64(*(uint64_t *)psns);
>  }
>
>  static void bnxt_re_fill_wrid(struct bnxt_re_wrid *wrid, struct ibv_send_wr *wr,
> @@ -1154,9 +1160,9 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  			break;
>  		}
>
> -		/* TODO: cpu_to_le64(wqe) */
>  		bnxt_re_fill_wrid(wrid, wr, bytes, qp->cap.sqsig);
>  		bnxt_re_fill_psns(qp, psns, wr->opcode, bytes);
> +		bnxt_re_host_to_le64((uint64_t *)sqe, sq->stride);
>  		bnxt_re_incr_tail(sq);
>  		wr = wr->next;
>  		wmb(); /* write barrier */
> @@ -1188,6 +1194,7 @@ static int bnxt_re_build_rqe(struct bnxt_re_qp *qp, struct ibv_recv_wr *wr,
>  			       BNXT_RE_HDR_WS_SHIFT);
>  	rwr->wrid = qp->rqq->tail;
>
> +	/* Fill wrid */
>  	wrid->wrid = wr->wr_id;
>  	wrid->bytes = len; /* N.A. for RQE */
>  	wrid->sig = 0; /* N.A. for RQE */
> @@ -1227,7 +1234,8 @@ int bnxt_re_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
>  			*bad = wr;
>  			return ENOMEM;
>  		}
> -		/* TODO: cpu_to_le64(rqe)*/
> +
> +		bnxt_re_host_to_le64((uint64_t *)rqe, rq->stride);
>  		bnxt_re_incr_tail(rq);
>  		wr = wr->next;
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jwJ6bIT+r2BZUD+c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliNlUAACgkQ5GN7iDZy
WKfgWRAA0YocrL+ySDSR4oGHx7Qdl2I3bdp2bP+FpYMDbLwyZ1igBgXU+F5D2yOn
qPuH/kbp90cBiKGfcpjkGN7/yizo3CTQFRHWsaiXEEAKyWYRJTzk87kN+Yff0xmV
8hKc6vKzb2t8oBuOeZ8IpxSg9LesW1F1994oOSeE5Gud0x+sniEGsV+rBlRfQHBW
dLvUWrpttJbnaKE77c3mjaSpPcy+wvu1fSEGCE3Hn3M1q7Hc933OxFUhp62KHPZa
L1p0TG3Pur1KgK1z4eCjXkzd/b/ZJT1L/CuIsNKRRNJZAEhvZZc14oJpK/aP7A/l
3eXUrgGUcspo4NvGCUr1rxUamxvIG7a3dssJ/1uNB7lAJdzdbCRTwhBM0+U6yPEt
e+UYr2eubVWCstzQAqYVk3/H7arAlyLB5fC9IrfmkxJwipxmeXGez7U1FjKfI5Dw
3pmv8xQqjotkPOkToHijHfQXWUAT/PDYyRQ5WPHD5uvSojgk09dLZ/vfl4/mxVqA
dRRE/3Vfuz0/2DvmrgTcDqHFIsYS7nAeSrq9iLTP4D/cbU/wdDVHi/9f5R78RPu2
15ejICP851L0to+EskbV0cRMrVebo6nm9Iw5cgBZ5mLHUOqbhnPaIgEiXXWxKV9S
beYOGewCc7+w/+cG3/ZgALKLLDKNOlUoumDEeAOidehmtSlKySM=
=g/zm
-----END PGP SIGNATURE-----

--jwJ6bIT+r2BZUD+c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
