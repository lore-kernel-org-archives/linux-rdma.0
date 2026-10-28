Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168738;
	b=JjAjLPsezSd2GsfCfOHb2p+raNeosuJ9FeViUZmvpm1BDk5Z/e8GNufki4pDs8a8rjL8
	 +0t0KeY8UXM8yO0O8zH5MUkNCTS3Rc2uM4x/rQ/snDQwenMzTXfZOQ5uNiPLeZznhVXV7
	 dJyoA3WiCiCA73L7qUt3wToGulxL3XwmIPhesumTryQgRYvHSdyRgK1rjsub0aaCmEVSS
	 UnVqeZx9chDof21DBYV7DsG3TzaQyzGDStB6Lf6gdpM0eSmsq5sSM8vPscpldYmeE68jR
	 tJzvhVkMcy0fAnXVxGSbAkRw/HqfYYvp1PMzWVb36x918fTb5JSGTdGwknP61YYpAPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168738;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zUU45Ooyvf6n0Cng36IWxptAxDlJruAGXWdRO7jRzWQ=;
	b=gyM37WRJFfdhgEEUh2P/ncUJ8R0NRspYH5WW0+aRKsY2mughZ6jC8RZOJO/marcl1BDU
	 +SjbJDd0ucEHuKbQB/7vCKpIKcjPEs+yg6I6vzyh1w0sCX5bGrDB9BSpLrSAghILzrj2P
	 /EywqxiQBWZCoLpdwV0TBrd2GX0ucXq7g93/kXytxqaZsXqDVQOHPWMZAEwWCsUzlQD1t
	 lFST/knvSDDDfRWUcshnjAdgXhPJrYQaKZnUhKl0zoVJDx1jEqi+dD+gCxF5JR3NruVpH
	 PZSET4ZatZsbQcB4iweCygTHNkujRxquNl+G5QGF/HDw5xOgss27TNlYXdG9vloQQDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AfB9xvhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07585606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AfB9xvhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1CF1F01825;
	Wed, 28 Oct 2026 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168737;
	bh=zUU45Ooyvf6n0Cng36IWxptAxDlJruAGXWdRO7jRzWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AfB9xvhLYX4pY1qCvkBrT9Zc7ZY024VcrojVsht2RX210f0jpVAeG+WbI1R0H/k3R
	 Fs7FkAdBMKy1zU+TwRT85I/QFAKt6Nfi+Mg/O7PbO/hkmo7nkUKmiFUCbzbV/7L7mG
	 FXwsH+yBNTq390T17Rscj6H9feuyJYjL6iMhZAPKYPVt3+avSYCDAF1XDS6jBTQYSe
	 R0nX0I8DPTSQDUsd/OTeA18vTP9iCNcoHScutz5ZeTRlIw2qN6TAmII22yxu8VPA1Q
	 V17OFsd8o8/DZVdHgdGpYJNBbhK4HLczJ41Z5HzPxcq6dGYLLSKKuaFNfhwr0SktWL
	 OAzSbpGtjnZ6g==
Message-ID: <sashiko-outbox-187559@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 5/7] RDMA/bnxt_re: Reset cqe pointer each poll_cq
 iteration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-6-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-6-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:25:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In bnxt_re_poll_cq(), cqe advances for every polled CQE, but budget is
> decremented only for completions reported to the caller. Skipped CQEs
> (looped-back QP1 receive, shadow-QP completions, unknown opcode) leave
> cqe ahead of where budget implies, so the next poll can write past the
> end of cq->cql[].
>=20
> cql[] is only scratch space, so reset cqe to the start of the array on
> each iteration of the outer loop.
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D5

