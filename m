Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96D52DB788
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681731; cv=none; b=ah2qCbR3qpI0gBQ+Y/FaxrmD0XD3QgPDRghtDTIJauXBAe/DZmDDSq4BivAhU4YLxFCRVCb+LfqS3DzI16Ve1RLbH84ivcqFY8fzyxFMWyDpr642YNZj72/rRCq5JoxdGkv4reXocIGEOKlGHwlPe/XTs4NEgV+HXA6D6uoCE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681731; c=relaxed/simple;
	bh=LYrcxdQ9OzNwHjnlBwklpF1jG7OPDIa0z8hv2dqk9e0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=AL/vMHQsoSH3knoK8Iv4IZN4av/il9bdLOqwhC44XWka85BniulzKQLSERPDosk16YG5OqOWhJzgUVqzYTSyqnuWDKxKIZ4mnsQGEk4FSHDnl88VJiJPTSk5w69sJ4pC3ERT6tnzC5v3UmEkFypdiazwfDk2pZs/hHYE82viduQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfNmwglB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfNmwglB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E081F00893;
	Sun, 11 Oct 2026 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791681728;
	bh=LYrcxdQ9OzNwHjnlBwklpF1jG7OPDIa0z8hv2dqk9e0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LfNmwglBVFHPopB3VJ0U8oqZDjGBsLrM5OdN6UFL1oViWq0A3PDy9gHm9FWZ9FVC6
	 qJuWDDt8G0KkfSUb9nCMB5jm6MROrd3XiLi13nJLVFPq5lET6uzmsOgB50K5k2xqCT
	 WZX0K2OJegoBF9zC9YTGY5/xQF5ygF9bVGlrCo4vrhBrTAzka7VrwYjJt7S08QcisC
	 xeOWRTZjzfXMbVkcKNaUV1ZftlatMxEeAUxgDh1qpyQ0WEq8Me/mEvOvyOpCYoWEzX
	 YdlF2MUtfdGMMpt9ZVKqashs29nuye96BgzHYbNxYrwzjJl0Fku+EJkx/1/9xR2pEX
	 gTc/CfEKfjtww==
Message-ID: <sashiko-outbox-166958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/5] RDMA/irdma: Support UMEM attribute for QP
 creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011011022.1445352-4-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-4-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 01:22:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation
> model for QP by using `UVERBS_ATTR_CREATE_QP_BUF_UMEM`
> and `ib_umem_get_attr()`.
>=20
> Add `irdma_setup_q_pbl_from_umem()` to allocate the
> backing MR and program hardware pble directly from
> the pinned umem. Proper umem and pble cleanup is
> added to `irdma_free_qp_rsrc()` upon QP destruction.
>=20
> We retain backward compatibility for legacy 2-step
> registration if the UMEM attribute is not provided.
>=20
> `irdma_alloc_iwmr()` assumed there is always a valid
> [ ... ]
> `irdma_free_iwmr` is statically scoped in `verbs.c`.
> Combining was considered, and we think it belongs
> to a future project.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011011022.1445=
352-1-dhu@x6u.co?part=3D3

