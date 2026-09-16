Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00F94B8277
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584962; cv=none; b=t2V9eIZ+2gjcHi3K3BE/E7HD/zsgJ6Er05k4G9g998MPTvM1O0LBtpvjRHLPFFkzSPSXG+o+2zZe4SxW+bIjYKKLCanwv7HpJeeJubytExkpBN/rIQADRwmOSkQh2P6/XTIgqrGhA62q18AEl+M2KmqWSvx+9SUujbFNhDXCp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584962; c=relaxed/simple;
	bh=axHAZEL5w8BpAnsN1lWodFvkrzUsx37OiKtQqO+V0PA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tIgU45F1ipHnouUZFfLPHryqbvTteym0Hb9fn0kca/CTOjCWZRz3XR48MpueNbJEF0kWuwMwJh3KXGgUbF0g9H02xB/DhC/cj9d/U6lrmuH1shCjqe+At5R0ujuqNUgiB42cf9/T3LU5SiKrAo2pR2WgqM5Pojkbp2Y8KmyMjbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4sMGyps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4sMGyps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F21F0089B;
	Wed, 16 Sep 2026 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789584946;
	bh=axHAZEL5w8BpAnsN1lWodFvkrzUsx37OiKtQqO+V0PA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T4sMGypsnT1Q5qJiZWH0qnSxkBfce/nuUbrDvCbDFlGRXIYo3cDeAg92ZpcBi6or+
	 tkQkV/1MaIUy/XAfn/8iSam7xZ97n4fflfDn6Fzs7wI7PSP4G2xNP6iX4WkxDcIbdb
	 l9wIgPuCiMdpljHJ/pAjBj3eQcHIbnjDRrsb4QVd+m/aGJFhrZSxWKY8A/EUIV13nO
	 b1C/iNyyXucdNFtUWmi7Vn8tHhNyH0/JKLJ+pKz6bUxjjsSlhtg/PkzYzs5cR4InRC
	 7MELRVqDzVHQcOMI6yuW3HDGxuRT5hbK32lie73dDF3du8ZXHjg59dtKC3zhE7ltXs
	 M6+UiA5O2G76g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: Fix member use-after-free in
 process_group_error()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916184555.2093238-1-vulab@iscas.ac.cn>
References: <20260916184555.2093238-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 18:55:45 +0000
Message-Id: <20260916185545.D00F21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> If the callback on the error path returns non-zero after a concurrent
> ib_sa_free_multicast() already dropped the initial member reference,
> dropping our temporary reference completes the waiter, which then frees
> the member before ib_sa_free_multicast() dereferences it again.
>=20
> Only free the multicast member when our reference decrement was not
> the last one; otherwise the concurrent free is already in flight.
>=20
> Fixes: faec2f7b96b5 ("IB/sa: Track multicast join/leave requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916184555.2093=
238-1-vulab@iscas.ac.cn?part=3D1

