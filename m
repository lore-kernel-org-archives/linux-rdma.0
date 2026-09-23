Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB68B5304A1
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169999; cv=none; b=nBOBgpCySfKogCeE7E33ZUFLNUgiXYxPZv2VP/dGsM/pRGzd+jTov4WTDbbJZV4HeK4A0E9ib8ErJERNX1whxc19J+YSbwOl/l7TyxyX/JrJyojvmmUW0a2hZOQeUFTGp9wktcS9rcnXGElNA3ytXMYcvUkiqouwomAU1tmR+1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169999; c=relaxed/simple;
	bh=UkF9EDmiKnpFjUvhNNR34mCLaf309lzntz8yvbeEezY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ks5asAG8G38IQ38LCaNN80X3hAm4bWY3snVAkvqL4lzxH0kQWQm0f8xkTGes8vMRK2Am2CranOmzWB/pa6tVoL2ZIDNHW3KmVid4MUulX2HRhVewtnpnxRPymXWXDwtDpKYXU5ixNDtoGGwIMhe46O2dN6AjpOZAEJXC9srs8eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Am6TYSbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Am6TYSbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAF01F00893;
	Wed, 23 Sep 2026 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169997;
	bh=DXbb6mGqysd1Owj4gj4rh6veWRbvAIQVO+yhHHUkRXk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Am6TYSbT9BUdzCUO1jIJLQS18A/Jl4cB4wy1EYMkC7srP0FJxjknUHsg5fZu806A0
	 gIqDoCOYH0wO9PXc2zXSaxNqHe1AlqHYLw8kH5JpGXdHnMmnokaSrCiUW5WvtZTVA3
	 pvWwaAvGIiFEoLEzXQHVKXK3NwqezymD34wukK3xama4bLcfYH9T68Tmebo/A8PT05
	 2YLCuNq2zRwSrv8PY5LAFnGzkRlaxEzLxTUyIYBmmO6OVnI1OEWgETzYYJXBQfiIaZ
	 2kzn0Balo6skKAyJXBiMCUEIz3QQBoONwFO+WJMKv7qmIb5MKEchS9SPnz+O6d63iN
	 FbjmW13XQSqAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 5/5] RDMA/mana_ib: Poll UD completions and
 flush software error QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131155.4055875-6-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
 <20260923131155.4055875-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:26:37 +0000
Message-Id: <20260923132637.6DAF01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: missing QP error state transitions prevent SW flush =
and hang queues
- [High] RDMA/mana_ib: hardware error CQEs are silently dropped or treated =
as SUCCESS
- [Medium] RDMA/mana_ib: missing queue tail update during RECV SW flush cau=
ses resource leak
--

commit 1efb216b21b0bbf2212163e8d48231dab5d0c94a
Author: Konstantin Taranov <kotaranov@microsoft.com>
Subject: RDMA/mana_ib: Poll UD completions and flush software error QPs

This commit introduces a WC-budgeted polling context that builds WCs direct=
ly
from CQEs and published shadow entries. It also adds a software flush path
for QPs in the error state, since MANA hardware ignores doorbells for them.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 6764e2de0c9f9..3b8044b7dc8fa 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -236,126 +288,172 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq=
_notify_flags flags)
> +static void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct mana_rdma_cqe=
 *rdma_cqe,
> +			     struct mana_cq_poll *poll)
>  {

[ ... ]

> +	for (; to_complete; to_complete--)
> +		mana_complete_send(qp, poll, VENDOR_ERR_OK);
> +}

[Severity: High]
Does this code drop hardware error signals by hardcoding VENDOR_ERR_OK?

Previously, the driver extracted the error code from the hardware CQE, but =
now
it unconditionally reports success. If the hardware delivers an error, it
seems it will be incorrectly reported to the application as IB_WC_SUCCESS.

For other CQE types, mana_handle_cqe() might hit the default case and return
true without advancing the shadow queue, which could stall it.

[ ... ]

> +static void mana_flush_completions(struct mana_ib_cq *cq, struct mana_cq=
_poll *poll)
>  {

[ ... ]

> +	list_for_each_entry(qp, &cq->recv_err_qp_list, recv_err_node) {

[Severity: High]
Is this receive flush loop unreachable?

It iterates over recv_err_qp_list using recv_err_node, but looking at the
rest of the code, recv_err_node is never added to any list. If a receive
queue goes into the error state, its WQEs might hang forever because this
flush path is dead code.

> +		while (poll->produced < poll->budget &&
> +		       (wqe =3D shadow_queue_get_next_to_consume(&qp->shadow_rq))) {
> +			mana_fill_wc(qp, poll, wqe, IB_WC_RECV, VENDOR_ERR_SW_FLUSHED);
>  			shadow_queue_advance_consumer(&qp->shadow_rq);
>  		}

[Severity: Medium]
Does this receive flush path miss a queue tail update?

In the normal hardware completion path, wq->tail is advanced to free space:

handle_rq_cqe()
   wq->tail +=3D wqe->wqe_size_in_bu;

However, here we call shadow_queue_advance_consumer() without advancing the
underlying wq->tail. If the QP is recovered and reused,
mana_gd_wq_avail_space() might incorrectly see the queue as full, leading to
-ENOSPC errors.

> +		if (poll->produced =3D=3D poll->budget)
> +			return;
>  	}
>  }

> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw=
/mana/mana_ib.h
> index 0ad75799062e8..74edb6e707a17 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h

[ ... ]

> @@ -594,8 +647,7 @@ struct mana_rdma_cqe {
>  		};
>  		struct {
>  			u32 cqe_type		: 8;
> -			u32 vendor_error	: 9;
> -			u32 reserved1		: 15;
> +			u32 reserved1		: 24;
>  			u32 sge_offset		: 5;
>  			u32 tx_wqe_offset	: 27;
>  		} ud_send;

[Severity: High]
By removing the vendor_error field, the driver seems to lose the ability to
parse inline hardware errors. The vendor_error_to_wc_error() switch stateme=
nt
added in cq.c appears to be unreachable for actual hardware errors. How sho=
uld
the hardware communicate these errors without this field?

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 79c9cc9443bb6..ae2ebbcc759a2 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -891,19 +886,56 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp,=
 struct ib_qp_attr *attr,
>  	return 0;
>  }
> =20
> +static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_att=
r *attr,
> +				    int attr_mask, struct ib_udata *udata)
> +{
> +	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
> +
> +	if (udata)
> +		return;
> +
> +	if (attr_mask & IB_QP_STATE) {
> +		switch (attr->qp_state) {
> +		case IB_QPS_RESET:
> +			mana_remove_qp_from_cqs(qp, true);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (attr_mask & IB_QP_SQ_PSN)
> +		qp->sq_psn =3D attr->sq_psn;
> +}

[Severity: High]
Does mana_ib_modify_qp_state() need to handle transitions to IB_QPS_ERR?

Since neither send_err_node nor recv_err_node are added to the CQ error lis=
ts
here (or elsewhere during an error state transition for standard UD QPs), t=
he
software flushing mechanism in mana_flush_completions() will not process WQ=
Es
for QPs in the error state, causing them to hang.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131155.4055=
875-1-kotaranov@linux.microsoft.com?part=3D5
