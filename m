Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229F1D9663
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616514; cv=none; b=D9txp+2/dI0gs1jDtdI1+20tiOrH+hABdvx+0hApFODb8+rMl+9fTI7V+blTnVbgo2kRoQG3vUIDvnkuZld3rqPoAKkde9x6Dj93vTxfVhw5X1d+AB/8IqRJK3jswbKuc5mdqWimyJPsqeYBJqi8c0Mep46IBPEe3+ENgJz8OEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616514; c=relaxed/simple;
	bh=dm7Hf+zwQ8rb65JM+sKNegkjNT/MFvcQcgse5baUVu0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KhU21HgrOnjrZxQ6FobcxKurMRAZZEX7PomApM6mfB0O2gum21HCEGwIrBKWaJGC+ewubk9YQ9/Zd70V08nE7BaL65k7CSmOOdHqWijtIzdO/rLXbJTuNf7bw0nbCV/cbkbE4SNku8VsIfQIa3TjiwV+vtXZJMWlYRNAumwIZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W66oVizO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W66oVizO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4805F1F000FF;
	Sat, 10 Oct 2026 07:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616513;
	bh=8/TXzWw1Au50eXpr3o+nv+EpXkDiOAgHON/zteQ+vu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W66oVizO2iE3jtrucMvm21CYh2UD5j69QAv8hISfF56flwSQWLZ0y8wsOEZ6fnLuZ
	 FxIei0POTGVfmpzJbumcfqctxwXL6anh2Pjk8Uot4VfO1YFnyc9zCFraJMCS0xuYxl
	 w71xLw5RJeCOk2dk8y29Iu+6rrriMmJiprXWHBsa9JbbYamHudWtdE2reoFuwdZLoy
	 K7RDMvfLIsKebOYDJjDriqESaZaDyBsLRQsb2m8/N9PtTj/PXzZXbDp1hPxAfz43hM
	 D5/k2laMp0IErSWzLGmwNEfYpcnOELXOIJ87uemwNs2lrWcHlfHS8Ssr3n+nfZejRP
	 vy7Gf1pdI1/cw==
Message-ID: <sashiko-outbox-166306@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 08/10] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-9-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:15:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rdma/mana_ib: dead code - qp->state is write-only and never read
--

commit 77c71a02dc85cc117e4f58d2a8f85635639fc4ac
Author: Konstantin Taranov <kotaranov@microsoft.com>

    RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR
   =20
    Complete the RC software flush path by adding a kernel QP to the CQ
    error lists when it transitions to the ERR state.
   =20
    Invoke the CQ handlers after the transition to flush pending work
    requests.

> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw=
/mana/mana_ib.h
> index 55899b1e2f868..a72bed94c08d7 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -271,6 +271,7 @@ struct mana_ib_qp {
>  	bool pending_mmq_fence;
>  	bool sq_sig_all;
>  	enum ib_mtu mtu;
> +	enum ib_qp_state state;
> =20
>  	/* Serializes receive WR posting. */
>  	spinlock_t rq_lock;

[ ... ]

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 74cf80074e54f..31e91cc657ac7 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -1049,6 +1071,11 @@ static void mana_ib_modify_qp_state(struct ib_qp *=
ibqp, struct ib_qp_attr *attr,
>  		default:
>  			break;
>  		}
> +		qp->state =3D attr->qp_state;

[Severity: Low]
Is this state field ever read?=20

It appears to be write-only in the driver, including in subsequent patches =
in
the series. Could this field be removed to save memory and avoid unnecessary
instructions?

> +		if (attr->qp_state =3D=3D IB_QPS_ERR) {
> +			mana_add_qp_to_error_cqs(qp);
> +			notify =3D true;
> +		}
>  	}
> =20
>  	if (attr_mask & IB_QP_SQ_PSN) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D8
