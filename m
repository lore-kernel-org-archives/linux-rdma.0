Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6C63769EC
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010466; cv=none; b=OBs/o1gnmbSsSR4YMXec1BU6OXAWZSVIOkKCUaf6xVdGpWSGzhCT52qijyw6hyR9m6oqKTbp+1VHasbIhhk9s+miBokTaOFVIXoqkvu1VWxioDe7m020ZhnJNFs56Geb5TSeGmaI0j/OHnpx5rcOoN7HYAM+yx0J8TbyGqLIKrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010466; c=relaxed/simple;
	bh=voMi8Mu9fdSxhGbgUQSmRg8sgtbwshZWNlU8gFg+MfY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W/hG2FK99U7nfYU84V5e11h6OMogJ6F52l/c/+Ap1kif3SMWczgsiU7OXD4b6QYYfhsUOC395NnT74GJwq8EWDqlwMlUyiHPlf1vVlyvq/1dVNb4bhKl80Hs3muAeDvrcxM+TnOJ34I1bnYql/2jsK5mTwmNDscu775s7R8nMZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiAQvp0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiAQvp0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAA31F0089B;
	Sat,  3 Oct 2026 06:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010465;
	bh=fM+nTMHr0JbdzHh7nk1lLc1RiWaMQy+LExA8BUG6Afo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KiAQvp0A/F+dYa9F+cZmy3fGrtlv3giJamqe+B5vHcqXHnw5SznaKL7ujNsKflxEQ
	 jggkbpoAvRq7ZuSXtcil5BWOqvy7Fhxt8LamOcPH5DRPBfxv1ht+wMwWEG9BYJtjW1
	 BLqco8hRwnEaDAzrImdH/o4s35Dqk8vCNlq+0vfam6m3b4q5oiP5AcElBclYe0e4Fs
	 EJvxMW93cC++KQZNpy14Sa+lYT37vtGj5EOOtRnYzWN8gGeFEknXeFwW9uW1hkET3W
	 PLaWLlYDIHUXHCRnNGu4hPEbz4b74MypbDJLT0TqlPvi9r31X+jwPMKHe7lXKu+xQX
	 Wbh8qVsK1fPYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-5-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:54:24 +0000
Message-Id: <20261003065424.EDAA31F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: NULL pointer dereference when arming doorbell for us=
erspace RC QPs
--

commit d94733697b534fa1d978860b21f69a9735157978
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Maintain kernel RC QP state

This commit updates mana_ib_modify_qp_state() to support RC QPs and initial=
ize
the packet, message, and frame counters. It also arms the requester receive
queue at the initial PSN so that a CQE is generated when the PSN is
acknowledged.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index edaf03372cd81..74cf80074e54f 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
[ ... ]
> @@ -1044,8 +1051,19 @@ static void mana_ib_modify_qp_state(struct ib_qp *=
ibqp, struct ib_qp_attr *attr,
>  		}
>  	}
> =20
> -	if (attr_mask & IB_QP_SQ_PSN)
> +	if (attr_mask & IB_QP_SQ_PSN) {
> +		qp->sq_ssn =3D 1;
> +		qp->sq_rsn =3D 1;
> +		qp->sq_fsn =3D 1;
>  		qp->sq_psn =3D attr->sq_psn;
> +		qp->pending_mmq_fence =3D false;
> +
> +		if (qp->ibqp.qp_type =3D=3D IB_QPT_RC) {
> +			rq =3D qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
> +			mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), rq, attr->sq_psn,
> +						     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
> +		}
> +	}
>  }

[Severity: High]
Could this lead to a NULL pointer dereference when arming the doorbell for
userspace RC QPs?

When the RDMA Connection Manager (RDMA CM) handles connection establishment=
 for
userspace RC QPs, it can call ib_modify_qp() with a NULL udata pointer. This
eventually invokes mana_ib_modify_qp_state().

Since udata is NULL during these kernel-driven CM transitions, the early re=
turn
check at the beginning of the function fails to distinguish userspace QPs, =
and
it incorrectly treats them as kernel QPs.

For userspace QPs, the kmem pointer fetched here is left uninitialized (NUL=
L).
It is then passed to mana_gd_wq_ring_doorbell_ext(), which unconditionally
dereferences it when accessing queue->gdma_dev:

mana_gd_wq_ring_doorbell_ext()
    mana_gd_ring_doorbell(gc, queue->gdma_dev->doorbell, ...)

This can result in a kernel panic that can be triggered by unprivileged
userspace applications initiating or receiving an RDMA CM connection. This
issue does not appear to be fixed in subsequent patches in the series.

Is there another way to correctly identify userspace QPs during these CM
transitions so we avoid dereferencing an uninitialized kmem pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D4
