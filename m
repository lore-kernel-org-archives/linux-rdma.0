Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F2D2609FD
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010710; cv=none; b=oQZ3hwVfP2LqzbYozWSLkZAzvNsjurBbeYzCqklnHOhsjiv5rvZwe+rfROLXlrmY/LQZaP0CFXpTHmF+CYTk5aNk/AL0UTS4RyO1friXWlyiAHqiW36CWRqhx/vO+eHkR9zv3qm3lTc4bSGC8+CJ4sQ/Fei9y8pnkGoQf5UUIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010710; c=relaxed/simple;
	bh=PqAul3DnMaLTEQM18n2PnJeSZX/O90RoAsNCcFq3c84=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XDCuKazn9qea7VHaRTqtpxYIpg1zzw0pGV9l6YMqMeEPT0R2ScHR/99XA+e/JLn3NDp8LTWEEHw63f2k07vVVmI0GU/PakByqWTSUp+KuV54kGzM955TPJgpFwK3pop+BTwOPFkjPpNb2AhHEd3EBDGPuEbx1Geb/iMHF1C5tks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjMIwdKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjMIwdKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7430C1F0089B;
	Sat,  3 Oct 2026 06:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010709;
	bh=p/igggVOK1CZIPgQLrvZJdA0k7g9PvUpCmBtQgGXh0U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UjMIwdKGSAoi9q3OwNnp1PKKAh/qzMcx30aeqDvUOHo9SPESkKRDYnNkbJOl2DvNE
	 1+DjtmrzJ15HDncpDQINHISgkAZ5K4X69qJYcl0bRwyWWyNzk3Bm7DvipSBTRquo6z
	 nlmMHy50C6fyrH60hbOagVELKNKw23s7PfvP9Pl5Fkx8cJgnA7Kk37QDXMCkf0ep7W
	 rWoKufib54xQBqyD8UkUuZX2FCUqByHfGUpUP2K13+8kTwcyfivDDI4JE06R/a3YAt
	 bAo6VRlNaDj/EGpz23FDrX/xYtO06uJKJn/9h0EQ8HX4bAW2jwQfAcE+7WjngLZvL+
	 Iq9phIc6uWRuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 08/10] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-9-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:58:29 +0000
Message-Id: <20261003065829.7430C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: Use-after-free of UC QPs on CQ error lists
--

commit c99026ba35e2170c2d6c2bf5a5f090a5f44a790e
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Flush and notify CQs when kernel QPs enter ERR

This commit completes the RC software flush path by adding a kernel QP
to the CQ error lists when it transitions to the ERR state. It also invokes
the CQ handlers after the transition to flush pending work requests.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 74cf80074e54f..1a1764d51552e 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
[ ... ]
> @@ -1028,15 +1046,16 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibq=
p, struct ib_qp_attr *attr,
>  	return 0;
>  }
> =20
> -static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_att=
r *attr,
> +static bool mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_att=
r *attr,
>  				    int attr_mask, struct ib_udata *udata)
>  {
>  	struct mana_ib_dev *mdev =3D container_of(ibqp->device, struct mana_ib_=
dev, ib_dev);
>  	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
>  	struct gdma_queue *rq;
> +	bool notify =3D false;
> =20
>  	if (udata)
> -		return;
> +		return false;
> =20
>  	if (attr_mask & IB_QP_PATH_MTU)
>  		qp->mtu =3D attr->path_mtu;
> @@ -1049,6 +1068,11 @@ static void mana_ib_modify_qp_state(struct ib_qp *=
ibqp, struct ib_qp_attr *attr,
>  		default:
>  			break;
>  		}
> +		qp->state =3D attr->qp_state;
> +		if (attr->qp_state =3D=3D IB_QPS_ERR) {
> +			mana_add_qp_to_error_cqs(qp);
> +			notify =3D true;
> +		}
>  	}

[Severity: High]
Can this inadvertently link user-created UC QPs into the CQ's error lists,
leading to a use-after-free when the QP is destroyed?

Although UC QPs are created by user space, RDMA Connection Manager (CM)
manages connection teardowns and errors from the kernel. When an error
occurs or the connection is aborted, CM calls ib_modify_qp() via
cma_modify_qp_err() with udata =3D NULL.

This bypasses the earlier udata check and mistakenly adds the UC QP to
the CQ's error lists.

Would it make sense to update mana_ib_destroy_uc_qp() to call
mana_remove_qp_from_cqs(), similar to how RC, UD, and GSI QPs are handled?
Currently, it omits this cleanup:

drivers/infiniband/hw/mana/qp.c:mana_ib_destroy_uc_qp() {
    ...
	mana_table_remove_qp(mdev, qp);
	/* Ignore return code as there is not much we can do about it.
	 * The error message is printed inside.
	 */
	mana_ib_gd_destroy_rnic_qp(mdev, qp);
	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
    ...
}

Because of this omission, the RDMA core frees the QP memory while the freed
QP's list nodes remain linked in the CQ's error lists.

A subsequent CQ poll or flush event will iterate over the freed QP, resulti=
ng
in a use-after-free read or list corruption.

Additionally, since UC QPs do not allocate shadow queues, attempting to flu=
sh
them in mana_flush_completions() will cause a division-by-zero
(queue->consumer % queue->size) because queue->size is 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D8
