From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 12/14] qedr: Update to use new udma write
 barriers
Date: Thu, 23 Feb 2017 13:49:47 +0000
Message-ID: <SN1PR07MB2207DE206738E6DD8511CEA1F8530@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-13-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-13-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, Jason, for this work.

Per this change, I don't see any need in using mmio_wc_start() in qedr.
In libqedr each buffer is flushed immediately after it is filled with
data so there is no need to do that again before filling it in the next
iteration.
wmb() is invoked to make sure that the CPU doesn't issue the doorbell befor=
e
the data was flushed (that's why I expected its implementation to be as the
kernel's i.e. sfence. See e-mail relating to 14/14).
Hence please replace the each mmio_wc_start() in the code below with
udma_to_device_barrier().

See another tiny inside.

Thanks,
Ram


> qedr uses WC memory for its '.db' mmap, so all writes to it have
> to be wrapped in the WC barriers. This upgrades the leading
> wmb to a wc_wmb() for consistency with other drivers.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
>=20
> diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
> index 95cd429e1b9b47..c8a0db2c9c1cfd 100644
> --- a/providers/qedr/qelr_verbs.c
> +++ b/providers/qedr/qelr_verbs.c
> @@ -672,9 +672,9 @@ static int qelr_update_qp_state(struct qelr_qp *qp,
>  			/* Update doorbell (in case post_recv was done before
>  			 * move to RTR)
>  			 */
> -			wmb();
> +			mmio_wc_start();
>  			writel(qp->rq.db_data.raw, qp->rq.db);
> -			wc_wmb();
> +			mmio_flush_writes();
>  			break;
>  		case QELR_QPS_ERR:
>  			break;
> @@ -1096,7 +1096,7 @@ static void doorbell_edpm_qp(struct qelr_qp *qp)
>  	if (!qp->edpm.is_edpm)
>  		return;
>=20
> -	wmb();
> +	mmio_wc_start();
>=20
>  	qp->edpm.msg.data.icid =3D qp->sq.db_data.data.icid;
>  	qp->edpm.msg.data.prod_val =3D qp->sq.db_data.data.value;
> @@ -1116,15 +1116,16 @@ static void doorbell_edpm_qp(struct qelr_qp *qp)
>  		       sizeof(uint64_t));
>=20
>  		bytes +=3D sizeof(uint64_t);
> -		/* Need to place a barrier after every 64 bytes */
> +		/* Since we rewrite the buffer every 64 bytes we need to flush
> +		   it here, otherwise the CPU could optimize alway the

alway --> away

> +		   duplicate stores. */
>  		if (bytes =3D=3D 64) {
> -			wc_wmb();
> +			mmio_flush_writes();
>  			bytes =3D 0;
>  		}
>  		offset++;
>  	}
> -
> -	wc_wmb();
> +	mmio_flush_writes();
>  }
>=20
>  int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
> @@ -1363,11 +1364,9 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ib=
v_send_wr *wr,
>  	}
>=20
>  	if (!qp->edpm.is_edpm) {
> -		wmb();
> -
> +		mmio_wc_start();
>  		writel(qp->sq.db_data.raw, qp->sq.db);
> -
> -		wc_wmb();
> +		mmio_flush_writes();
>  	}
>=20
>  	pthread_spin_unlock(&qp->q_lock);
> @@ -1446,14 +1445,13 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ib=
v_recv_wr *wr,
>=20
>  		qelr_inc_sw_prod_u16(&qp->rq);
>=20
> -		wmb();
> +		mmio_wc_start();
>=20
>  		db_val =3D le16toh(qp->rq.db_data.data.value) + 1;
>  		qp->rq.db_data.data.value =3D htole16(db_val);
>=20
>  		writel(qp->rq.db_data.raw, qp->rq.db);
> -
> -		wc_wmb();
> +		mmio_flush_writes();
>=20
>  		wr =3D wr->next;
>  	}
> @@ -1795,12 +1793,12 @@ static int qelr_poll_cq_resp(struct qelr_qp *qp, =
struct qelr_cq *cq,
>=20
>  static void doorbell_cq(struct qelr_cq *cq, uint32_t cons, uint8_t flags=
)
>  {
> -	wmb();
> +	mmio_wc_start();
>  	cq->db.data.agg_flags =3D flags;
>  	cq->db.data.value =3D htole32(cons);
>=20
>  	writeq(cq->db.raw, cq->db_addr);
> -	wc_wmb();
> +	mmio_flush_writes();
>  }
>=20
>  int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc=
)
> @@ -1816,7 +1814,7 @@ int qelr_poll_cq(struct ibv_cq *ibcq, int num_entri=
es, struct ibv_wc *wc)
>  		struct qelr_qp *qp;
>=20
>  		/* prevent speculative reads of any field of CQE */
> -		rmb();
> +		udma_from_device_barrier();
>=20
>  		qp =3D cqe_get_qp(cqe);
>  		if (!qp) {
> --
> 2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
