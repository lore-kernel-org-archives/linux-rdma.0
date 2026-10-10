Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0917123BD06
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616321; cv=none; b=Dr9ARyyn5chUr9NTZaT7ogFmvAKbZ43vFRSII3z0lRdY24tBuO5weCgFxxleKLUXx3zCH8YnITAXcyJ6Tdj/SF6w1IsewiXAiMQ4RQ/iZ4Cutocly6smt+zeTPescikBwC9Q5dXUmqspNdJCBc8GaOC+frYiyG5yq7ivXaJdCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616321; c=relaxed/simple;
	bh=XUoWV3yLpr/OvZunlAEW7RDROw10Wl1zUOSwxcNAS8o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rK9rbkqgzCHyco4VN8Asnsz4YBOEsNcNoYxjs2HdPA+X7KFysY/J+vWTHG7JNFuD8Xwtn/TgWfg/joWxD8G3COtrScpwHayepm03hXpM0xHPRbw+UDHPa+IPuV7/KIFLn/4NkUkMJDF0r/qW8oJA9SMMKw8uXc1nvjU3PN7+EFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdgrU200; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdgrU200"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D811F000FF;
	Sat, 10 Oct 2026 07:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616319;
	bh=6qEwRXMHjaTVg4daSrKjHE99kwr2LE3A0Uc4k8fM0Ls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hdgrU200DMvh1pX8JXVTVRxRgAFJwhfmVjo0REt7Y33xVz92PybfTiwewxlatIqds
	 +P6AipZSIa1OVX7JCuVQlRLk64jIToc0oflFpnGcBApw+Ip3eCtRWPplz+2zXTw3n/
	 SpoIC/HWw6RnMvmRbloTYiT5rPRKtPDBvc+iJFI14Gt2hhiMn9TXi+Y9kIZaYU/TRd
	 bv3lmfY6f5cxbmx1itIVGanc/I5TB0q5xOeGti5Mx9S7L6ia4Y/8Z/4ginAkGH24Gh
	 s3CgQmzm2TS48dsxZ9yOZ/7pSkfT11wBLbQwYHVYYZVc8MFwzcX9ftfMTsCBz9SO3Y
	 byf6bAba3NOuw==
Message-ID: <sashiko-outbox-166303@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 07/10] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-8-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:11:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana_ib: unsignaled SQ WQEs drop cross-queue FENCE flags
--

commit f52d44bbe1b3dcdecb4068d26d5596db440b5069
Author: Konstantin Taranov <kotaranov@microsoft.com>
Subject: RDMA/mana_ib: Poll RC completions using PSN and FSN progress

This commit introduces decoding for RC receive completions, armed-PSN
notifications, and MMQ completions. It retires requester and MMQ shadow
entries using sequence numbers and enforces cross-queue fence dependencies.

> diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana=
/wr.c
> index 6cc67537c6557..9fff8622aee22 100644
> --- a/drivers/infiniband/hw/mana/wr.c
> +++ b/drivers/infiniband/hw/mana/wr.c
> @@ -408,6 +408,9 @@ static int mana_ib_post_sq(struct mana_ib_qp *qp, con=
st struct ib_send_wr *wr)
>  	if (err)
>  		return err;
> =20
> +	if (wr->opcode !=3D IB_WR_RDMA_READ)
> +		shadow_wqe->wqe_size_in_bu =3D wqe_info.wqe_size_in_bu;
> +
>  	shadow_wqe->wr_id =3D wr->wr_id;
>  	shadow_wqe->send_opcode =3D convert_wr_to_wc(wr->opcode);
>  	if (!signaled)

[Severity: High]
Does the logic immediately following this diff permanently drop the
MANA_WQ_FENCE_WC flag for unsignaled WQEs?

Looking at mana_ib_post_sq():

	if (!signaled)
		shadow_wqe->flags |=3D MANA_WQ_NO_SIGNAL_WC;
	else if ((wr->send_flags & IB_SEND_FENCE) || qp->pending_mmq_fence)
		shadow_wqe->flags |=3D MANA_WQ_FENCE_WC;

If a work request is unsignaled and requires a fence, the first branch
is taken, bypassing the fence branch entirely.

This appears to break cross-queue retirement dependencies and could
potentially leak unsignaled MMQ WQEs in the shadow queue.

Should this be changed to two separate 'if' statements so that both
MANA_WQ_NO_SIGNAL_WC and MANA_WQ_FENCE_WC can be set on the same shadow WQE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D7
