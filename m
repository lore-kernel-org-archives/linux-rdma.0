Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A038F25C
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790137232; cv=none; b=uewlGPj7UTBD9F64mq4qZI2K0SmYNgqpYGgSoWwTsi4C8GgpgVCfYQQDURLHv2zvFzfyTyyNuKIHoNEEtDsZHK47/Uz30tqtgCnpAjszOuwm3qqZ3MwRPTpqqIQd1EDCE5TiRyNQ1bw1JMvChtH+D0xaV98IR+RsxJ7VWpNZYz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790137232; c=relaxed/simple;
	bh=mtWqHuOgBdS8XivhOM4qW+PlzEE14AxYe0f8JhZJHVM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oMC0W1NPO932OII7mDopxyj3CV55h6GsuuzBDxe/FdYgJAK8bqFMJH8ifLy2t0SQbBXrO9uU1POgOdO0t85HChRzKcH8NSDo8joHsFAxme7J1dxxJxYBLkMRUV2L4ezlAcCkDn6lodWDb4dd8X2N+zAaEywPWx7iJUxO5f6eyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJBexxv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJBexxv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC811F000FF;
	Wed, 23 Sep 2026 04:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790137231;
	bh=QKy/Fsc0qZ5C8l17T3aGVXBje/VtcD6MrybDkvMHCJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WJBexxv0G3eVpKl/me3WS8IMj9AJzM/eu9yvWLzybj8sRZaSy+dkvPjB/zZs64muX
	 UK57RDCnryzJmRJwUGfLtvYDy6D5gs8+5P/3juaNAGnwBNcRr+N71/EMadzJP5SQAx
	 PA/EkDyMuhBs1XzqupI/nMjQN6HzNdx3yae5bfuCUCO4SYnblJFr3WdCcDquWjSDBn
	 9MopoSSza6aJbn4V9QVEgo5MKTN3l4DmKmlZ4pFCos1s83u5JhYA6bFSQyUWxTyfck
	 x8sZiHEyU9dLNvjFEimRTRzqugvoZ9X+oy9bqdWpGTZuJlcPARW2quzmb4EqAW8uP0
	 l0hSw1IAU99lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Quanye Yang" <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
References: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 04:20:30 +0000
Message-Id: <20260923042031.1BC811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Quanye Yang <quanyeyang@proton.me>
>=20
> queue_depth is taken from the server's CM private_data and later
> used as a session invariant.  A peer can send 0, which the client
> stores and then trips WARN_ON() in create_con_cq_qp() when the
> next connection is set up.
>=20
> Reject a zero queue_depth on ESTABLISHED, same as a bad
> magic or version, and fail the handshake with -ECONNRESET.
>=20
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=3D8+=
-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922-rtrs-fix-w=
arning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me?part=3D1

