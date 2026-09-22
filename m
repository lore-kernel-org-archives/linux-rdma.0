Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96EF1CAAC
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039232; cv=none; b=azmI5IYkq9rvqrCpgXBQJj295i5GF3ZL0yamr3kHCxvndw1mRivpJOXHi6bhSTRRgfXLEdupis8rqeKmpYJk4PBdYN81cCqJM+6UFK/tUxj06vlV8PDiyRjsmfzTgHm+wdIhuqIG5TVaLxLiefdMjzG+llqyBPXXpz7mDxF39mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039232; c=relaxed/simple;
	bh=2SsVtdWSjOaua6Zo/Wrek2rhaR5+kaOJ5WRkSXfCLbw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LTAGMOifQb8CY4MMZ71DNrhegAFx0o/LYP//SHGBS5dMN2GQ2a54wnO6+5eXrvCrgFZs4Gv7CY9WLeC/UPhEGZs5WEeQM+SIc+FgE7xlZ2XE3Fd2zUYdezCzjqxpIwttmHnLPbjkjidlB/ds4l0SIAqmfJWVfGOhek6Agafej9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPIjFGDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPIjFGDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3C21F000FF;
	Tue, 22 Sep 2026 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039231;
	bh=Rqp5Ui7sHZRh260JwAq71LaaMcUT+aifacWAVaQM6xI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MPIjFGDLcFsRnfHGteiQQA3NCykm6IJKGiLQozIiadFr9L+h7fYhKaNVSyyIibbLA
	 WpvKGYyDs3km0ct7yVjzrE1IFDMJkCT31Ga2wJl1LOe6fYuMIqjsTMyOUvNLZxDf37
	 XwIV9aH5Gu+GeWq8I1rUa+iK3TcZvLKikwwtI8XNPsnCG2d9Nux0c8X6QF+VjoKQ/U
	 x9pULvkId6D7b+C8zr1VZgygfP2WS4ryLPHq+19ziAUuK+6UMi0anILM9CdnSZcfMI
	 Mto2I0EHgMImK1ilLxHgdjFB6qd4XPlh8o3u7wXnwr340jfyoWZvMUXHFS2C4NHFhF
	 qn+qkxjybYkug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 5/8] RDMA/bnxt_re: Validate num_sge in
 bnxt_re_post_srq_recv()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-6-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-6-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:07:10 +0000
Message-Id: <20260922010711.3E3C21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/bnxt_re: un-ratelimited error log in spinlock allows DoS
--

commit bb7479cd7b3a22e9b0e6b2862ab2b9133790528b
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()

Add a check if max sge for SRQ is exceeding the device maximum.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index c35ed6ed03516..3cccef8e2e837 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2399,6 +2399,13 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, c=
onst struct ib_recv_wr *wr,
>  		/* Transcribe each ib_recv_wr to qplib_swqe */
>  		wqe.flags =3D 0;
>  		wqe.num_sge =3D wr->num_sge;
> +		if (wr->num_sge > srq->qplib_srq.max_sge) {
> +			ibdev_err(&srq->rdev->ibdev,
> +				  "Limit exceeded for SRQ Receive SGEs");

[Severity: High]
Is it safe to use an un-ratelimited ibdev_err() here while holding the
srq->lock spinlock with interrupts disabled in bnxt_re_post_srq_recv()?

Since an unprivileged user can repeatedly invoke the RDMA uverbs API with a
wr->num_sge larger than srq->qplib_srq.max_sge, could this regression allow=
 a
local user to flood the kernel log buffer and potentially cause soft lockup=
s?

> +			rc =3D -EINVAL;
> +			*bad_wr =3D wr;
> +			break;
> +		}
>  		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
>  		wqe.wr_id =3D wr->wr_id;
>  		wqe.type =3D BNXT_QPLIB_SWQE_TYPE_RECV;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D5
