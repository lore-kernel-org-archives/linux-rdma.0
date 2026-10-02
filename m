Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D941D446821
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932388; cv=none; b=i3sX3clyuCt4iOO0JBSj0C5sijJB7D9C/k3YPLy35lbU98KkEzCO8JOPcnXJ2A5J5eBukheUtYh298ZbDmdi7Au4BrLQZH7J/GqvsHBmpyZkcQ4Ee3+Vsb/NHuSVCOgwuMRpMt8XSaonTk1cysrOgnbpRmdHf6TvfhkH9HeyUso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932388; c=relaxed/simple;
	bh=GYqF1lkqPNYhpigXCokc4TJrnSjwUyfr1Z5+pm6juHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OyM04BKg3QOS0ODa4yTK2EI2Py+utQtgMVFtk244HsFOCfrHQalqzmK3WhtDawWA5iJw+vZLIFy/tj934X7ynOulqcK9R6rGb8eM65GXaurUFqZ3eHVFrN/ZjO0+0Y1g4LscBIAerFrH3FZSSvDLcaqJv49Ir584Fl57NbhNKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btOZW1yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btOZW1yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C271F0089A;
	Fri,  2 Oct 2026 09:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932386;
	bh=1iEulYUpegWRR3djDHg64C4HAppsodOKmaGCgAFQDKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btOZW1yq1vGYKTusAdku0Q5n+mNO1XirmLNIloPAL2TNJIv4C0a+0/zks50bTBG36
	 QlvYPgBiqHrPizcKnDNC8sIXKIROBc06Wkw4ts0IGknnAxjvbI4+cvPqLh8jpa4PrW
	 nAfUfKik0CXAdE26y2h5hjwxNRSmsoTI8UtN1aDQRc2kmy9BB1jMWFGtuvqILa6My0
	 +LvFdIkygDUzSMRn7nQMG4RbQfxMFd/dZBkhWb8ABPGnPWEeB/jjNplAxb61xYpu2R
	 6TF2A6kVEcphfvIdLnrGB5CmQR8usOVj7o3JzfVXuMFKPTQWtQWHb89t69Or7/YTLg
	 sZKNItAmmYKzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-7-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:06 +0000
Message-Id: <20261002091306.85C271F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana_ib: WQE ring buffer overwrite due to missing SQ SGE boun=
ds check
--

commit 7f1f7264400f5f00c6c885de8b54ac6900f87a1f
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Post send and memory-management WRs on RC QPs

This commit implements send work request posting for RC QPs in the mana_ib
driver. It posts communication work requests to the send queue and memory
work requests to the memory management queue.

> diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana=
/wr.c
> index 5d42af91fce4a..6cc67537c6557 100644
> --- a/drivers/infiniband/hw/mana/wr.c
> +++ b/drivers/infiniband/hw/mana/wr.c
[ ... ]
> @@ -224,6 +289,287 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *=
qp, const struct ib_send_wr *
>  	return err;
>  }
> =20
> +static int mana_ib_post_sq(struct mana_ib_qp *qp, const struct ib_send_w=
r *wr)
> +{
> +	struct gdma_queue *sq =3D qp->rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER=
].kmem;
[ ... ]
> +	int err, i;
> +
> +	if (shadow_queue_full(&qp->shadow_sq))
> +		return -ENOMEM;
> +
> +	if (wr->num_sge > MAX_TX_WQE_SGL_ENTRIES)
> +		return -EINVAL;

[Severity: High]
Does this bounds check in mana_ib_post_sq() allow out-of-bounds memory writ=
es
if a kernel RDMA client provides a wr->num_sge that is larger than the QP's
negotiated maximum capacity?

Other RDMA core providers typically validate num_sge against the QP's speci=
fic
limits because clients can misuse the API.

[ ... ]
> +	wqe_req.inline_oob_size =3D INLINE_OOB_EXTRA_LARGE_SIZE;
> +	wqe_req.inline_oob_data =3D &send_oob;
> +	wqe_req.client_data_unit =3D ib_mtu_enum_to_int(qp->mtu);
> +	wqe_req.flags |=3D GDMA_WR_GENERATION_1;
> +	wqe_req.wqe_size_in_bu =3D qp->rc_qp.wqe_size_in_bu;

Because the WQE size is explicitly fixed to the QP's configured size here, =
if
wr->num_sge is larger than the QP's negotiated capacity but still less than=
 or
equal to MAX_TX_WQE_SGL_ENTRIES, mana_gd_post_work_request() will use
wqe_size_in_bu to calculate the ring buffer slot size.

Meanwhile, mana_gd_write_ib_sgl() will write the full wr->num_sge entries i=
nto
the queue. This can overwrite the adjacent WQE in the ring buffer, leading =
to
hardware memory corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D6
