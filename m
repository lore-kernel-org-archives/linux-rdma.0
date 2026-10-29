Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283859;
	b=L5gse+CyPvdmfyIDdTOhHB6F7mtHDtBWWJjUJspC61w3RBdG5z7HXb8oagMRkqEeA9vy
	 UUrzpnzoowPjSubeXSEzqNhCCx2E2kzzfoI3kxLZSbtkbHZVCRBBd27Zhg/vO0q4Sjjxi
	 d8MnsP3kMXc08dzAOgNw8Ff5KgbplsimS/FX92gRiUMtO83WNEAfLDkj2+G7eA5vW9PIO
	 rVZfowXHCOhopRPwg04/pZCZ+PeWa8/FtdOqZpVdUkkqhWYSupEYdoJd7c765J+16eWUr
	 xXflkp9hMdd8gQS5v3gEsURPlsqGQ92StM9RTmuklBmi9oAo6BS/5Y1EZFyZsAk3nTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283859;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l9qRqxr86GWtFRTOYB5ZBVokpk0vh0AL35ikQqQGHtc=;
	b=VwQkcGOGXZoxYaPOLzPM2SR8bqfR4hR+PsNZsAe1vTPEXUVWH6KzcxcAH0+8/Zu+4Ro+
	 CccymKtR459cuIiBUbApZriHb8VMHm7BgF/nKBuE3b61ufWJmQ0mMvqfFZulOXVoMIIru
	 xaHMgVDNn/STitr54aODG1qyD4DtBL1pd7Qf6j1E981/VUkWP3uz1Q8dK4YBCQuyghvLv
	 4AjdvqVfe/ydsKGTt+qvFBvqw8VJGzyrIQHrxhNm/UZBgcuJZTl5/xbYUdISz3Aadlwqs
	 lGrZ3FzpCCvwXaeHxI0L6Oi9GmpPPhnIHS34cd8BpVYcsaAwZO/sZhV/GMrFFBOMgew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYNQqwJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5744606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYNQqwJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E0B1F01828;
	Thu, 29 Oct 2026 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793283858;
	bh=l9qRqxr86GWtFRTOYB5ZBVokpk0vh0AL35ikQqQGHtc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bYNQqwJ7UiVeW5KXkSsLVw4q+70QNBaA18gsrqbxLbsPTpl1/UfQTc9rS6+Y+lL9P
	 XcedhM1OTeBph9ya3Fkm5Du80rJeBeinjekArqGLdeqh/R/osMVbPtGTB89tZEB5o9
	 EEVKFl+BJwwXZ3NSbKPlcG4jguFVAK8Bo0ocjZePcYlkH8ZyzPVsouYtbXiVYqOFhi
	 DcofTjKgpsDiCBXsAG9Q5BI8hKv1AtnVU9GH8YejvpTqK7fOpk6xVN9MP1NApzCPnb
	 ILuB+M1lWXgfs1+Da+XioLdFUwpelwWePF7HP+k+XJnUvt0JciPqsM7LtJyJan+Pap
	 rXTpXB9udI4hw==
Message-ID: <sashiko-outbox-189508@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND rdma-next] RDMA/mlx4: Fix stale umem and MTT
 state after rereg_mr failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029141634.1557240-1-jmoroni@google.com>
References: <20261029141634.1557240-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 14:24:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> During rereg_mr, the umem is released in various failure cases
> but mmr->umem was left pointing to a freed umem, so it could end
> up getting double-freed when the MR is finally deregistered, or
> cause a UAF in ib_umem_check_rereg() if another rereg_mr attempt
> is made.
>=20
> Fix this by setting mmr->umem to NULL after ib_umem_release().
>=20
> Additionally, when mlx4_mr_rereg_mem_write() fails, mtt.order is
> left set but with an invalid offset, so during dereg,
> mlx4_mtt_cleanup() ends up freeing an MTT range that was never
> allocated. Fix this by resetting mtt.order to -1 in that path.
>=20
> Fixes: 9376932d0c26 ("IB/mlx4_ib: Add support for user MR re-registration=
")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029141634.1557=
240-1-jmoroni@google.com?part=3D1

