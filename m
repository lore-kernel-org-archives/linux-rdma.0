Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DE52D9EFB
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681730; cv=none; b=qi84bZhw5+ldXqpuZHZyp+a2UOfHz4sX0978h5vSF/lrumSmDfQZiYb6WZSLf91lfDgkhwYPId2Eb4ilhmAOr4OSS3OZsO1AZjUxLUwOAslfF/0EGYi3cgzj3+Sw6f7MNGaKL8+OJQN76t6p/h3Dn2RX+ZnXyOJbfSFIQtBr8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681730; c=relaxed/simple;
	bh=7dPZtwcgjxIjxjgEHZ1BB3wQhRY/8pzvCVT8Bu3Eo6w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qsFnKyhnd0c2yMEC3uSFpZVqiv2tc7T1j7XCuTzqadfA4hZJbD5I6u/hTkK7S2rTRwklB3Bv5O0gJeNK+NrBfUP57/ErAvmCgvpfnk11rBOT8gF0CMbUiy1tGRkPfekhHJ0fdIRPhF6BIagAjkjw13gZyPR+c4CGFwgyto2UPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSg5oLr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSg5oLr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D821F000FF;
	Sun, 11 Oct 2026 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791681727;
	bh=7dPZtwcgjxIjxjgEHZ1BB3wQhRY/8pzvCVT8Bu3Eo6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SSg5oLr6Z+/omhbOhGGreFPhNZnFfMW63oOMX20fyW2/VdAnGFBhhWk9XeeZUdcDc
	 NGykW5lnQJtQmiy2bTSMR+hz7sGbV4ydt0MkhN1h6BQf+jsRrWWWFLmgi7JQ9A8TDa
	 4zobDKtSBfPDx5e8KV1qHspOdCC1zQmsCqEv0gQl1uf78pEAA+AVzUk0vWS4PlBeqr
	 onpEbqlBRKcVleOLnUVWTb5+DRBwI7K3bBjMESUZPx/HHe08AhxAOjpks07HnER/90
	 Ucz2qutLekU93iMLIp6lGU4uYcC4Oz/YSRGv34a56uaumL9WWN5jBmuFCUkdgkZgpa
	 RTPTx4VmxVGoQ==
Message-ID: <sashiko-outbox-166957@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 5/5] RDMA/irdma: Support UMEM attribute for
 SRQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011011022.1445352-6-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-6-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 01:22:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation
> for SRQ by `UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via
> `ib_umem_get_attr()`.
>=20
> Set up hardware pble directly from the pinned SRQ
> umem via `irdma_setup_q_pbl_from_umem()`.
>=20
> Proper umem and pble cleanup, and error unwind are
> added into existing `irdma_srq_free_rsrc()` upon
> SRQ destruction.
>=20
> We maintain backward compatibility for the legacy
> 2-step registration if the UMEM attribute is not
> provided.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011011022.1445=
352-1-dhu@x6u.co?part=3D5

