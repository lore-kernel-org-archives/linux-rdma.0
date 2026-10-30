Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366871;
	b=MosuYwVMvX++FYNao6xwGpsVLFeGewHEw7mjEC11ytZZ1+NAQl84rycuwCXy0d1i/6fw
	 vtSRAGaYogZqe9kJgqdbDMtGFbMO7+TrbtYPWktt3HfRucmUcb+Q3GYEOehLkdpBoacDR
	 CxmVzbqQ+5Q+q3cM2hdbq0YISi1p7KLN3QxQvLIYtOFVCsj4a8MGbXibMXXUTuGFak6NM
	 NiOOotMuAEccYmKlls0J2ckRseJeyvH9vd8mTd3/S8uj4Q52LS3bB1V6YPvsTwWTD6iyW
	 KAEESdSmnSD80udgG2J+h2jE98nKcAiuAkA7JGQKuFVKV0lfHTle74OJsNkIfjMkI6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366871;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vVjuDtZE2WZWH5j6GBAQs3NaBeG51yhJoSz/3zqFXmI=;
	b=Fqvf79F8MhS5rk1+1asgS02EXEZC41N4xhyTDN3kejLi1Oheb1m/jtTmE+zyj2+Fpo9/
	 mS+Cgp39IO0tkBwmneMPnpT4oT2ZrG1d2NFnJ0D5/zoDRKb+iKz8bDw7g8CD1RGDPYeHS
	 iYlgkFHS7glNHAwAt/zJtHsftQD1KdHYWyLV/X92ckq4mGYCngn1PgNDKTcrLaanhuUEt
	 xd74ldhS+W68GEm481Yap8QfeZpKC4/Ut0eFSY1eujaaM47G2WlDtH3p+cC1Xj4tQeqwl
	 3S3qz/VjBpMH1icxVEoeQHscxTDPmUWsBF5dUFdIWqtPxWMy9ikmOIinKOJj0Z2GxsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH6av7LS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756FD606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH6av7LS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56F61F000C1;
	Fri, 30 Oct 2026 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793366871;
	bh=vVjuDtZE2WZWH5j6GBAQs3NaBeG51yhJoSz/3zqFXmI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TH6av7LSv3Ag87xv727UQB+5mWMPq/05ZM+fNJ9wui96WsjbkJN5rqS/10TG4zTI8
	 7J482MKsvoFkNkqfqbnBdsbQ2/Oki9EKaNyQhg9oBdXeNWFCSD/OtHgRFLqQVf1GIl
	 yexxTzbPAxXcgvOa0sKL4MCTMFSGJJo3JHY6dlETCacrxnUwv5xXx9/s3XOYtETool
	 wj8vNgGwrTC0nYnjKMhKNBrdE4dQNxXXh2Kcm0/2/Kziy1QhBcZjTp3zPs4Gedjw38
	 bl1S+3ctT0k8ZQ+dDAPYNndWGUNyLzMpkNfIt/QSlRcuoS8O/VVIjCg89y9LzU7QeR
	 XjsRpV6zBGX7g==
Message-ID: <sashiko-outbox-191059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 10/10] RDMA/mana_ib: Drain kernel receive
 and send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-11-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:27:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/mana_ib: redundant comp_handler calls and duplicated drain log=
ic in qp.c
--

commit 5e7a469ad596532936441484def77d5229b5cbff
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Drain kernel receive and send queues

This commit implements the drain_sq and drain_rq device operations for
mana_ib by transitioning RC QPs to the error state, posting a marker work
request, and waiting for its completion.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 1756e96b9c811..4854fc4c6d0dc 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -1398,3 +1398,106 @@ int mana_ib_destroy_qp(struct ib_qp *ibqp, struct=
 ib_udata *udata)
> =20
>  	return -ENOENT;
>  }
> +
> +struct mana_ib_drain_cqe {
> +	struct ib_cqe cqe;
> +	struct completion done;
> +};
> +
> +static void mana_ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct mana_ib_drain_cqe *cqe =3D container_of(wc->wr_cqe,
> +						     struct mana_ib_drain_cqe,
> +						     cqe);
> +	complete(&cqe->done);
> +}
> +
> +void mana_ib_drain_sq(struct ib_qp *ibqp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct mana_ib_drain_cqe sdrain;
> +	struct ib_rdma_wr swr =3D {
> +		.wr =3D {
> +			.next =3D NULL,
> +			.wr_cqe =3D &sdrain.cqe,
> +			.opcode =3D IB_WR_SEND,
> +		},
> +	};
> +	const struct ib_send_wr *bad_swr;
> +	struct ib_cq *cq =3D ibqp->send_cq;
> +	int ret;
> +
> +	if (ibqp->qp_type !=3D IB_QPT_RC) {
> +		ibdev_err(ibqp->device, "SQ drain is only supported for RC QPs (type %=
u)\n",
> +			  ibqp->qp_type);
> +		return;
> +	}
> +
> +	ret =3D ib_modify_qp(ibqp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to drain SQ: modify QP returned %d\n",=
 ret);
> +		return;
> +	}
> +
> +	sdrain.cqe.done =3D mana_ib_drain_qp_done;
> +	init_completion(&sdrain.done);
> +
> +	ret =3D ib_post_send(ibqp, &swr.wr, &bad_swr);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post SQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->poll_ctx !=3D IB_POLL_DIRECT && cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {
> +		while (!wait_for_completion_timeout(&sdrain.done, HZ / 10))
> +			ib_process_cq_direct(cq, -1);
> +	} else {
> +		wait_for_completion(&sdrain.done);
> +	}
> +}
> +
> +void mana_ib_drain_rq(struct ib_qp *ibqp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct mana_ib_drain_cqe rdrain;
> +	struct ib_recv_wr rwr =3D {
> +		.next =3D NULL,
> +		.wr_cqe =3D &rdrain.cqe,
> +	};
> +	struct ib_cq *cq =3D ibqp->recv_cq;
> +	int ret;
> +
> +	if (ibqp->qp_type !=3D IB_QPT_RC) {
> +		ibdev_err(ibqp->device, "RQ drain is only supported for RC QPs (type %=
u)\n",
> +			  ibqp->qp_type);
> +		return;
> +	}
> +
> +	ret =3D ib_modify_qp(ibqp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to drain RQ: modify QP returned %d\n",=
 ret);
> +		return;
> +	}
> +
> +	rdrain.cqe.done =3D mana_ib_drain_qp_done;
> +	init_completion(&rdrain.done);
> +
> +	ret =3D ib_post_recv(ibqp, &rwr, NULL);
> +	if (ret) {
> +		ibdev_err(ibqp->device, "Failed to post RQ drain WR: %d\n", ret);
> +		return;
> +	}
> +
> +	if (cq->poll_ctx !=3D IB_POLL_DIRECT && cq->comp_handler)
> +		cq->comp_handler(cq, cq->cq_context);
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT) {
> +		while (!wait_for_completion_timeout(&rdrain.done, HZ / 10))
> +			ib_process_cq_direct(cq, -1);
> +	} else {
> +		wait_for_completion(&rdrain.done);
> +	}
> +}

[Severity: Low]
Are custom mana_ib_drain_sq() and mana_ib_drain_rq() callbacks needed in
mana_ib_dev_ops, and does calling cq->comp_handler() here invoke the
completion handler twice?

When ib_modify_qp() transitions the QP to IB_QPS_ERR,
mana_ib_modify_qp_state() calls mana_add_qp_to_error_cqs() to link
qp->send_err_node and qp->recv_err_node onto the CQ error lists.

Then, when ib_post_send() and ib_post_recv() run, mana_ib_post_send_rc()
and mana_ib_post_recv_rc() already call mana_ib_notify_flush(), which
invokes ibcq->comp_handler(ibcq, ibcq->cq_context) when ibcq->poll_ctx is
not IB_POLL_DIRECT. Calling cq->comp_handler() again right after
ib_post_send() and ib_post_recv() triggers a redundant second invocation.

More broadly, since mana_ib_modify_qp(), mana_ib_post_sq() (which supports
0-SGE IB_WR_RDMA_WRITE WRs), and mana_ib_post_rq() already handle software
flushing and CQ notification via mana_ib_notify_flush(), could mana_ib
simply rely on the generic __ib_drain_sq() and __ib_drain_rq() fallbacks in
drivers/infiniband/core/verbs.c instead of duplicating them here (which
also restricts drain_rq to IB_QPT_RC even though mana_ib_post_recv_ud()
supports flushing UD and GSI receive queues)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D10
