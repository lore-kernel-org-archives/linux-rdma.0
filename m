Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCA71A6820
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 05:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792215188; cv=none; b=f5HIWBByhb3ogff+ncUjyg8RIqUTzyMDxwujvHtn+YiqNtKVsapUtasPhCkFBMv9jKHWPXg4ROVttdIyJ9NHKb+Ogl7j9tQVWAf6oQyagqC4iYyfLmdArTD1uq++Ab6ccv1U0v0dcBA66e1wd8xf4hUPtKl4+pF/RyaxG1hUWNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792215188; c=relaxed/simple;
	bh=2oE/FdJIfgtbBFq+TVJP5yf/L1g5AXZi5ge98Xma5DA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=uLrqjUfbqCenopjcoOcKwcg3N7Chwk6omG0w4q3vIAkrFJEg+PLnV/xfiuGa85OoOq2ZE4606ldZuR63HfJ3R8yHKrFF+fNcLtXAI28xJWTc86hAXSEpCmBt5Z5xPI+BXDxZYQIew+dseA7XVHHDf584mOoAZ5VtBpzkVacrJIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOX6rwcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOX6rwcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595A81F000C4;
	Sat, 17 Oct 2026 05:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792215186;
	bh=7D9B7momIOcVNvJnodsHFVzSFPfw8MVUhDHEmqRYTQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cOX6rwcD0dvAF507VSEW14tcJ+hTwCpRUJxBU4KMv+w9BQcwJvJtd7dtRP94nE3de
	 W+IFR1TdeHGJj8xDaqoIt/eCM5+NTClGrV3jMbwIyKS+f/7mKyrDfiIltF606gyPBS
	 raZRflHxNFBb5LzwdqyZ3UZavq77DURYrQYgxtXbc8QgHwLhG8ztkhQwKPKEgt7hO3
	 OPFU5g8fRNPMXM3mppkyltLHNJE1ZcTOK8CVL+Bt/TZUzRfrcs4ueZyvXNAADoTYZ9
	 aK7VGFePQ+ZybiemhO37ES00hxCx+52C0j7p1q596sEimExXbpxuCqe4rSWJbnLaCL
	 xXvVmHPSrDzxg==
Message-ID: <sashiko-outbox-175308@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Bound in-flight CQP ops across deferred
 completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sunny Tiwari" <sunnytiwari@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017052856.3570063-1-sunnytiwari@google.com>
References: <20261017052856.3570063-1-sunnytiwari@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 05:33:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> On IRDMA_GEN_3+ devices, CQP operations can complete in two stages:
> Stage-1 on the CCQ acknowledges receipt and moves an entry from
> cqp->ooo_avail to cqp->ooo_pnd, while Stage-2 signals final completion
> via an AEQ event or a subsequent CCQ CQE.
>=20
> In irdma_sc_ccq_get_cqe_info(), Stage-1 processing advances
> cqp->sq_ring.tail so the SQ descriptor slot can be reused once consumed
> by hardware, whereas cqp->completed_ops is only incremented on Stage-2.
> Because irdma_cqp_ring_full() only checks cqp->sq_ring, a burst of
> backlogged commands in dev->cqp_cmd_head allows irdma_process_bh() to
> submit more concurrent in-flight CQP commands than the maximum supported
> limit (cqp->sq_size - 1) while earlier commands await Stage-2. This
> causes CQP completions to be lost and synchronous waiters to time out
> with -ETIMEDOUT (-110).
>=20
> Fix this by:
>   - Updating irdma_cqp_ring_full() to bound total in-flight CQP
>     operations (cqp->requested_ops - cqp->completed_ops) to
>     (cqp->sq_size - 1).
>   - Calling irdma_process_bh() at the end of irdma_process_ae_def_cmpl()
>     so backlogged commands are drained after Stage-2 AEQ completions
>     increment cqp->completed_ops and free in-flight capacity.
>=20
> Fixes: c7db0abe5f2b ("RDMA/irdma: Add GEN3 CQP support with deferred comp=
letions")
> Assisted-by: Gemini
> Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017052856.3570=
063-1-sunnytiwari@google.com?part=3D1

