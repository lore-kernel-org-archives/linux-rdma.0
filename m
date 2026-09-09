Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AB048BD51
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944594; cv=none; b=Fbhor9WYTsNESS31Ttchx5rv0E4UIHEn0NqoI5f7/W7NTUUn2BNSVeeFYfkZfSFOOgJIIv9k+VS5BnCSHQT/rIh7hpbAehJ0reODnWpniqPBXB+AlBsZGnbj+eo5lNubNdkcrwQX6UV7MYpsSJLG+2D+BEKyLdO2943G7GRXqIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944594; c=relaxed/simple;
	bh=xi7VvSupLZ1/gfW+jM+LfJMMXyCgpn0X6Uh0n7vwMkQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rg9ddTNld3gvDVfwHRrWB/1+8hwDUTBz46YDr+MCHdytSaV1eYFjp9WbgfVGQmCzwrP2JU/QWHg90FwnSsyInA4jVpeArEkXXQsRjQKSLCj3d4HXpmfAS7nMAvBbw5mjkE8iPN92cFr2t6fU7/GSF1fjFO5rrWLUlwTJHekGxJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIyR8SX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIyR8SX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0F01F00A3A;
	Wed,  9 Sep 2026 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788944592;
	bh=RCyNmWQVAWDFit+3ma80//EN9e/TE9c7cRuvKXZqMgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nIyR8SX0aldsKwC8ENWuCWTI/cRWJUNaNnjkuBp2cpkYvO5FvQM1MDFhHqLRuPDu3
	 ChTM0iOKSqAhayxP1zeL022oSrn0pIL1bZ7YjOjusZJQpPdiql41RTiEKBICZceCxi
	 BgxHMmU5i2GA57dH386kBZps8RCWy61OMNGnk4H4zCQjAyuxU4wi51UwA0fdi2bNE0
	 F6bD3NiPsblpNA2uS4V05/XdvDY3rhkgBDuR2N2jgE0bP62AMfI2yEqNpVZ2QsDkBP
	 Jg26Qb8jhAHfazqqt9PSDXFT/kNhB9e40tk3jiMtEwlS4aIgDak4viXW9apPWRqVT4
	 e3NkOIjlpxyew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 8/8] RDMA/bnxt_re: Check is_in_used before
 trusting RCFW completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-8-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-8-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:03:11 +0000
Message-Id: <20260909090312.3F0F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Duplicate completions for retired internal commands bypass the is_=
in_used gate, causing timeout_send atomic underflow.
--

commit a5d91fba60b82a58962973687dc528a6bc7de745
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Check is_in_used before trusting RCFW completion

This commit gates crsqe->resp memory copies and timed-out AH destruction on
is_in_used to prevent operating on stale responses. It also disarms waiters
and clears the response pointer when bailing out early on a detached device.

> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infinib=
and/hw/bnxt_re/qplib_rcfw.c
> index 9ee0d500436cb..0339e55bea886 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
[ ... ]
> @@ -682,7 +685,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qp=
lib_rcfw *rcfw,
>  		if (crsqe->is_internal_cmd && !qp_event->status)
>  			atomic_dec(&rcfw->timeout_send);

[Severity: High]
This isn't a bug introduced by this patch, but does this atomic_dec() in
bnxt_qplib_process_qp_event() need the same is_in_used check that was added
below?

If a late or duplicate firmware completion arrives for an already-retired
internal command, it will bypass the is_in_used gate here. Can this execute=
 an
erroneous atomic_dec() on a stale response and cause the timeout_send count=
er
to underflow?

> -		if (crsqe->is_waiter_alive) {
> +		if (crsqe->is_waiter_alive && crsqe->is_in_used) {
>  			if (crsqe->resp) {
>  				memcpy(crsqe->resp, qp_event, sizeof(*qp_event));
>  				/* Insert write memory barrier to ensure that

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D8
