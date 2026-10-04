Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C415E8B
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 15:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791129037; cv=none; b=HuSs//Xj0YOGEzb5s8Fbfblq2IhdMXeyw1Ug90O1Q+8JPOw778zHjCMvqO/vqt1KR5v9yFE+UtIPL7gDygJnFt8xQ/WFiSoCX6XQfCl22ejZcHRJ3W5RSAN2kwXi+/aoi7mRR7zNhtMqzfHV2gKrMvMM7orNKjYEnej0EhNDmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791129037; c=relaxed/simple;
	bh=f7/+QOw7uogHEG+t1OYe30cdiH/TpcjydAZFsOmknuA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lvWeYjV1w+wwX+9cxNOpVRjxAMu1xQjBqBUXCWPuDhozwlYoQaevrh6gJmegbeyhiHXP6TZelojRuOjEByg0Q73hyuqEmrKRV2Jv2DHQjIkoqSKJ8rdzAMIfzeeU/6LbQQGjFMWxFpv+o65EaWDaFJfBlrEdupybhaJpB1z94CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/C4Efyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/C4Efyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA221F000FF;
	Sun,  4 Oct 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791129036;
	bh=f7/+QOw7uogHEG+t1OYe30cdiH/TpcjydAZFsOmknuA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f/C4EfybJsAeBmSOP9CTBSbXvvBag3v7sZwaHZNpglmsh7h0WYgyRqUrbKdVeaR3h
	 JBgz5JvvGcM1QUx8zjqd9OG7ZvxBBPy5TIfeSTkiDz3XhspwWXcM255wyYq+vRN27r
	 0kgTq2kHkh3gIdQt1r9XyL14Y9NRzavqPAMjC44r/wa4UIVvGbOxy7ZkdzYPwaNz60
	 fIrE5wv9fK7P37SQo29vlZY/iAZg2iUsanh+CiKAqzOqZLE6vUsX6806RV4Y7vW80j
	 bkLFmcGDL5wQ1xne2nfMlbL2CVarV4h+ivQFSdUrUZ9dGodMuLforsALOt2Kz2Id7x
	 qvBJUzoP0+cFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: bound the ODP page index against the umem
 in rxe_check_pagefault()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004153246.2951263-1-ays511.kr@gmail.com>
References: <20261004153246.2951263-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 15:50:35 +0000
Message-Id: <20261004155035.CEA221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An ODP MR has a page array, map.pfn_list[]. Its size is computed from
> the umem start address. But rxe_check_pagefault() builds the index into
> that array from an iova that is relative to the same start, while the
> access itself was range-checked against the MR's iova (ibmr.iova).
>=20
> Those two bases do not have to match. reg_mr only requires that start
> and hca_va have the same page offset, so a user can register an MR with
> hca_va =3D start + N*PAGE. The difference then becomes an index skew of
> (hca_va - start) >> PAGE_SHIFT. Nothing compares the result with the
> size of pfn_list[], so the read goes past the end of the array.
>=20
> An unprivileged local user can reach this with a single RDMA operation
> on a self-connected rxe QP. KASAN reports a slab-out-of-bounds read. If
> the out-of-bounds qword happens to look like a writable HMM pfn, rxe
> then copies the payload into a page the user never registered.
>=20
> Reject an index that falls outside the umem and take the fault path
> instead. That path rejects the out-of-range access in
> ib_umem_odp_map_dma_and_lock(), which does check the umem range. The
> other users of pfn_list[], __rxe_odp_mr_copy() and the atomic helpers,
> run only after a successful map, so this single check covers them too.
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004153246.2951=
263-1-ays511.kr@gmail.com?part=3D1

