Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAD33D410C;
	Fri,  9 Oct 2026 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534819; cv=none; b=olqngRqZd++Z+v3MPybP8t/NBaJ5tNzlmGz3dwdRyYVQ17LZTryZ70tBS8qNBh/MCRgn77pG4/XxIBkTr3MNXWu9JXEY5m6TkDfNCMmVlt/P/9OejGGlzv/ooUVaTnkd9WxPvIRJhs+6Hz7L2evbx7P2d6RtHyNQccEq6ugaglM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534819; c=relaxed/simple;
	bh=n5BrO2f+BSSxXxilLwcrQNqBy4td6k5P5s1mOZQJTb4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sKGdMvL/XFPc7cVzh+2r/aDsQxvDR0qZh13t93aAwZWitVRZYwjBGjpdKPu+BitexQV6jd+8PIzEWPG9jSCwgqmKT5Jx1SNCIn6pqLcolBeFDrt39IYQwwRW6sQUs/TfH3eNpdHAEe4Y6YhgOuXiEW7l18T7vEds5HEFS7Epvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kU/KZbAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kU/KZbAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A211F00893;
	Fri,  9 Oct 2026 08:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791534818;
	bh=PzDn7KdPLT3gxWYvd9RFWCJQb0rR8adAZzAh0TZVtB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kU/KZbAl3z6E9xQRFUnyRf96W6Ut5JYkjPIKqR0KMFlGjHHUYcL5b01q70Fj46XnX
	 +RBrvcGKLdRsa8cSRDPDafgRfslONA2SpO6svp3PadDJ1w93RbDx4j1MUVghncVE7l
	 CH5JfBsB2t/29MxgoF+yo1D2Xn2S8qlReuTKpxfdBZPllujh/hfJQLqINXxwUqBjJc
	 nkCPyRRnXfXTJvWXe6V92icHKhG5xIwWNDuO7Nhyyo1sjBR6W1HkTJVKTy2wSNas1L
	 ncwWZJNhRlN1ysG1Ei71hFUifCqPMSUcL+9I+rcIm2ygPrguyMBEk9mhUwp8qbsGoK
	 AVyyDFz+rpmAQ==
Message-ID: <sashiko-outbox-165094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net: mana: Add support to process throttled
 EQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
References: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 08:33:37 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mana: RDMA queue stalls due to dropped throttle events
--

commit 49b4827fa426b6ae0b8759a5984d01f44b8db5e1
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Add support to process throttled EQEs

This commit adds support for processing throttled EQEs of type 4 when an
event queue nears full capacity. The driver advertises the
GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE capability and attempts to schedu=
le
the CQs associated with a throttled EQE. CQs are tracked in a new child_cq
array initialized when creating a CQ.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..b8e5ad2c6d312 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -747,6 +747,18 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
>  	gc->service_wq =3D NULL;
>  }
> =20
> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
> +{
> +	struct gdma_queue *cq;
> +	u8 i;
> +
> +	for (i =3D 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
> +		cq =3D rcu_dereference(eq->eq.child_cq[i]);
> +		if (cq && cq->cq.callback)
> +			cq->cq.callback(cq->cq.context, cq);

[Severity: High]
When a GDMA_EQE_THROTTLE event is processed, this function attempts to noti=
fy
the CQs. Will RDMA CQs receive these notifications?

RDMA CQs do not appear to be added to child_cq, which might cause their
notifications to be entirely dropped and result in RDMA queue stalls.

> +	}
> +}
> +

[ ... ]

> @@ -1063,17 +1080,41 @@ static void mana_gd_create_cq(const struct gdma_q=
ueue_spec *spec,
>  			      struct gdma_queue *queue)
>  {
>  	u32 log2_num_entries =3D ilog2(spec->queue_size / GDMA_CQE_SIZE);
> +	struct gdma_queue *parent;
> +	u8 i;
> =20
>  	queue->head |=3D INITIALIZED_OWNER_BIT(log2_num_entries);
> -	queue->cq.parent =3D spec->cq.parent_eq;
> +	parent =3D spec->cq.parent_eq;
> +	queue->cq.parent =3D parent;
>  	queue->cq.context =3D spec->cq.context;
>  	queue->cq.callback =3D spec->cq.callback;
> +
> +	if (!parent)
> +		return;
> +
> +	/* For throttled EQE store the child CQ */
> +	for (i =3D 0; i < GDMA_EQ_MAX_CHILD_CQ; i++)
> +		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
> +			rcu_assign_pointer(parent->eq.child_cq[i], queue);
> +			return;
> +		}

[Severity: High]
Does this logic handle RDMA CQs correctly?

RDMA CQs are created with a NULL parent_eq (via mana_ib_create_kernel_queue=
),
which causes this function to return early without populating the child_cq
array.

Additionally, if an EQ has more than GDMA_EQ_MAX_CHILD_CQ (which is 2) CQs
attached, which is common in RDMA workloads, this loop will silently return
without adding the additional CQs. Can this lead to lost completions?

>  }

[ ... ]

> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index c610fc1067e0d..03fe9395604d6 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -776,7 +785,8 @@ enum {
>  	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
>  	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
>  	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
> -	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
> +	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
> +	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE)

[Severity: High]
Since this patch globally advertises throttling support, the hardware might
send throttle events on RDMA EQs when they are heavily loaded.

Given that RDMA EQs are initialized with a log2_throttle_limit in
mana_ib_create_eqs(), will enabling this capability cause RDMA workloads to
stall if their throttle events are dropped due to the missing child_cq mapp=
ing
in mana_gd_create_cq()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008083315.3060=
76-1-sahilchandna@linux.microsoft.com?part=3D1
