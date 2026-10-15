Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E93033FD
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027987; cv=none; b=JiKdjxTWRd7nlEfH7WgtdBS0qfc+4MVhxf3lj7nHXYex2fI3Yk8hEzSElTGroEfAVsZa3H4j8yaPDA3JNClf1/y5XMawclni7RAADF9BWGHq0OYMEDmlSN82LyfNV5/l+DtNnTZ9jF9MR6OugDmzOnPZElugJDR8vRHqeuB+iwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027987; c=relaxed/simple;
	bh=JK1+bHiWr6pqGnBodsRDETzIX26ukKN+38LgUWsUVGw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=c1+cVmbHIxcXxlZjmDFmDxY093/OkU8bxaIg5v38RdpU7PY9+I3iRGsByFIly97ZKWrMgNcVBeuYI8KTSztmjci1ko1adq9D+9z51uBtdfgWjiMgXSuLEgdmBIUNv42VcezKBQ0zQPaXdDsi2m/Qr/vA+exXKxm59pHrAb81Uuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fB5x47Oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fB5x47Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B5E1F000C5;
	Thu, 15 Oct 2026 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792027986;
	bh=JK1+bHiWr6pqGnBodsRDETzIX26ukKN+38LgUWsUVGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fB5x47OyNBe3uW5ZQxnWClkY5+1l+KGnP7f1rfDATUYkOM95GiVj5J6Ae1zSrlCtT
	 MSrXtRgR4a/P8H7AHZTy2cJSGglMYebU02tB57XFOAFF1SfibvvWDMIdxXr36TMEKu
	 Mj/EQXe4zIFyrvQovwifEb5e7v9QsKm5Ib9BDcLJzxhO/4QuoWnbUEaUAk9Ev2Oyzo
	 Aen9tMRmvf68nQmJtk8MOcLVxwnK9gxlBp/90oAJQLExCwzYyzMMzFv8ls7+0Nz+UB
	 94OsdYltn0UO/A8gJtMDcJrSPPvuOTM6GXF1C+23xj8B/iVFrZ4DgpD8z47Tok4zsD
	 kStCZp5rlwfQg==
Message-ID: <sashiko-outbox-172098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 5/6] RDMA/irdma: Support UMEM attribute for
 CQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-6-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-6-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:33:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation model for CQ by
> `UVERBS_ATTR_CREATE_CQ_BUF_UMEM`, `IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UME=
M`
> via `ib_umem_get_attr()`.
>=20
> Set up hardware pble directly from the pinned CQ and shadow umems via
> `irdma_setup_q_pbl_from_umem()`.
>=20
> Proper umem and pble cleanup are added into existing `irdma_cq_free_rsrc(=
)`
> upon CQ destruction.
>=20
> We maintain backward compatibility for legacy 2-step registration if UMEM
> attributes are not provided.
>=20
> `irdma_resize_cq()` will have a possibility to deal with a pble/mr that
> is created via one-step logic, after this change. Therefore, a proper
> cleanup is added.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D5

