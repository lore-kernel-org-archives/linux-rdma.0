Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5883B14C7
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791096841; cv=none; b=AYkoFIf2wkdwrL7yR0IczQa8hCAyVj4nUi76TvcbpyDkyQcp1XOShj/0QeFCSFoEnPvaLSmJ2isN/DLgbcoJ1rN2BS8TyO3QwCG/Gq7TLSXq+gCkQBQSheAMlCZB1QhCRq9YA8Qiah5gFkkXHu0VWrm12K879bCKQyTQWSiLOWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791096841; c=relaxed/simple;
	bh=h5uaN9M7gkb3V3O7srp9R/iHZ5ccQDOBC4/S15xh2+U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HXZ8zwHj8XKb2NtuM7ldEInYwiJQBM0oFRXLXVDygqa4gc/mfLRcUmqWPiNaH0p0xi0k/0toG/pcCPwJ29Q31H8vTCSZwO/zJ7W+r1n1ZjT0kU6xpeVsOFcqO5/AB5QnyWbX1Wt8sh8RS7ct3viujDlxHQgaPn95jYO5TSZNVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9F6IxH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9F6IxH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975921F000FF;
	Sun,  4 Oct 2026 06:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791096839;
	bh=QpPbNPGON81ldYCBMc5Py6rVSMK5CmvTZEi7Eg9USAY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n9F6IxH6MkyBn9EGw1hRmYE9Tn9w+zbyy1QD/fHMtEDZ2FgNp9gSZp9HLOG5c4xPX
	 rnv2szXg6VU+CpJeuyBjUfR+B/lepDV2BGP2xmzYvuCM6mVX0NC+U7S1qBreynhwXV
	 ayYpth3XMpaiVcMFLKUebRi3CpfljLuHg/pOthLX6NZNC7ndeOilBGfo91Y/thTYkG
	 XOBnvMCHSEBq44fawnB8AgCUTJwokoXfkjXTlvydIDNetF9TTLd/enGc3aEeTwFQHF
	 +8gmgXGXch3UFpGeG2wwUa+WcojoV/Khtp/024HWM9OjGQTfyUkENjB5QJuTbThuf7
	 eu5AoR/2QrAKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: Validate inline data range in user WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004064445.1488753-1-yaojiale02@163.com>
References: <20261004064445.1488753-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 06:53:59 +0000
Message-Id: <20261004065359.975921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> For a user QP, the send queue is an mmap'd ring which userspace writes
> directly.  rxe_post_send() only schedules the send task for such a QP,
> so userspace can also change WQE fields while rxe_requester() processes
> the WQE.
>=20
> Commit 126c757e4cd46f866ddc283143b58eb4d9bf52cd ("RDMA/rxe:
> Validate num_sge/cur_sge before indexing wqe->dma.sge[]") added bounds
> checks for two members of the userspace-controlled dma structure, but
> left sge_offset unchecked.  For an inline WQE, finish_packet() uses that
> value directly as an index into inline_data[] and copies dma.resid bytes
> from the resulting pointer into the packet payload.
>=20
> A local user with access to uverbs can therefore put an out-of-range
> sge_offset in the mmap'd SQ ring.  This can disclose kernel memory in the
> outgoing packet or cause a vmalloc out-of-bounds access.
> [ ... ]
>    process_scheduled_works+0x7c0/0xf10
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcod=
e.ai/
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004064445.1488=
753-1-yaojiale02@163.com?part=3D1

