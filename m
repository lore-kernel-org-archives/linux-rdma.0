Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719887;
	b=HtNmsaNgqL66eal6jCvgDaW9vvYxsaSOn+INEYhoOx7ap6q1ejKxfmT8cGTfKc5b2m6d
	 0SOwssD+3fvXlMsN6hzHae9QHwWOWp7CBzsz2tOzhm4YXzFDZ6pDQtVJswS/WENmkZW1E
	 LiuUpSrEoCe3XIOHmMERlCBA5I7Wee/RIgP6Pn1jiwqcK+PSrGTZlH8+qAdt1VNz0Rpee
	 N6Xz07E3YgyYAbim9Jy1WX0DqUJlEk+HHDAXcuZly4bkeeo2dXHQG1uNNYXzA8lr+RNiX
	 o+5j+YMD8Pbp0lCfslmoosixZMbIBLPRF7o3PZRDaxOs71nI3saz5caVCLDnwuMvTSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719887;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=I+pwHsz3qkhy1dA+t6EeiAPS3Qr//6LI7oTL2xtQRpU=;
	b=atiNnlLXUJv3nC0Os2HYTnmSL6Q2/0IUZ5gdb+ki/nzkW4fpjUIoPAyjnLaQS6qDylC6
	 azgJ3xdr870IEBBTWYxhR9hI4Ub8JbxBrkcJ71DTPoXMuPnAFCJTcti4SkShVMxQEv/Zl
	 shM8y1Y59K/k/v7mYzSWr8j9iIvP42aKHFp2sFX6XTrzrYXEfVprg6quxKsI5GORd4gEe
	 wdv8tBlAmaLL04oYwNRj3kVqjNvOwkPZuNntZV0zVe2uq9R406o8xWr1d/0f6e6FVFGg4
	 13zvzXcEHjC7Wj/fhKTuYaE83ZH2+hWIRdHlrcpKDLblbqWvnHnWKUL9XgFXQLTuQzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j8b9pirc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE60B606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j8b9pirc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBD01F000CA;
	Thu, 26 Nov 2026 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719886;
	bh=I+pwHsz3qkhy1dA+t6EeiAPS3Qr//6LI7oTL2xtQRpU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j8b9pircPFk3rIuQNDi7s4G8QRTI42BwZY5BHNbsIyYoWxUpBE/xByRXqxUMj4Ow0
	 4RoBzG9u5V5rTQWWdwQbSexrWf2EGs2AKCCoLCfMTqGcvYZ8u85C2VbTD+tJAufa1z
	 RLP86PaIB39TZOnwy6sFZAel7kW/gT/g7P1tFGIkHqQineQvIctiMQuRR0AtH336+s
	 avDzv+YiuTzH1bkNbT/O+NMqvkXy+atpoUUA1ErNiJVLoCSnx2KLHt8cwM3Ka/nvtE
	 Jho35KoFxGqLGcUsAEIS+TNiv2P+eDNpxZYnk1vK7obAnyptdLISeS14LybK2BIjJH
	 jimR52mK5uGwQ==
Message-ID: <sashiko-outbox-236047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Wait for all refs to drop
 when destroying RoCE QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126185344.2784303-1-jmoroni@google.com>
References: <20261126185344.2784303-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:04:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] RDMA/irdma: use-after-free from incomplete CQ scrub in
  irdma_clean_cqes() [1]
--

commit ec08c5024cb50836ff76a6f7d89b61c4ac172b85
Author: Jacob Moroni <jmoroni@google.com>

RDMA/irdma: Wait for all refs to drop when destroying RoCE QPs

This commit restores waiting on iwqp->free_qp when destroying RoCE QPs
during a device reset so that transient references from the AEQ handler
or disconnect work finish before the QP is freed.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index e07b6b40dd992..29ccd19da0321 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -592,7 +592,7 @@ static void _irdma_destroy_qp(struct ib_qp *ibqp)
>  	}
> =20
>  	irdma_qp_rem_ref(&iwqp->ibqp);
> -	if (!iwdev->rf->reset)
> +	if (!iwdev->rf->reset || iwdev->roce_mode)
>  		wait_for_completion(&iwqp->free_qp);
>  	irdma_free_lsmm_rsrc(iwqp);
>  	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);

[Severity: High]
This problem wasn't introduced by this patch, but can _irdma_destroy_qp()
leave behind stale completions for the QP on iwcq->cmpl_generated and
iwcq->resize_list [1]?

Earlier in _irdma_destroy_qp(), transitioning a kernel QP to error can
queue software flush completions onto iwcq->cmpl_generated, and earlier
irdma_resize_cq() calls can leave unpolled CQ buffers on
iwcq->resize_list.  However, irdma_clean_cqes() only scrubs the active CQ
ring:

drivers/infiniband/hw/irdma/verbs.c:irdma_clean_cqes() {
	struct irdma_cq_uk *ukcq =3D &iwcq->sc_cq.cq_uk;
	unsigned long flags;

	spin_lock_irqsave(&iwcq->lock, flags);
	irdma_uk_clean_cq(&iwqp->sc_qp.qp_uk, ukcq);
	spin_unlock_irqrestore(&iwcq->lock, flags);
}

After _irdma_destroy_qp() frees the QP, a subsequent irdma_poll_cq() can
pull those remaining entries and dereference the dangling qp_handle in
irdma_uk_cq_poll_cmpl() and irdma_process_cqe(), causing a use-after-free
of struct irdma_qp.

[1] https://sashiko.dev/#/bug/linux-e3f313d2-d1fd-48a1-8be3-bb6bfb32a341

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126185344.2784=
303-1-jmoroni@google.com?part=3D1
