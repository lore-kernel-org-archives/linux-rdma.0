Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CD2463B8C
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944181; cv=none; b=O6zj3aETSbxQBxl3yqjx1GBhrYZ0uI9V8zR/JjrrH2lkxgF5qdQxg+/bEmsDRgwfTZ8/DdlkWiLfugasQlva1JzPVHqhbkLqwMg9lycZjTRS9kBV3KVjszD2Yj0N+f4dkmi11K5lLqt0S116uMv0PrZ4lMkFUcL1bvCeTlmTzS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944181; c=relaxed/simple;
	bh=mMX1fmIqh5lUHBichZlFf7fbC/HsvqPmhn4RyEGBNPI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPnuggDdSavVDT2rHhyPylW8KueMMFM5yp8ym2o9utf9HbaEQgvZetJc3J2YoAtfhF+zXXfbcvbtnWMFGqlmnfor2I4GeXqtJIOvuPBrarAMVkpC4ahFX6PLbIR5j4FP+Gt4jLFX5CK29NkVLlV67uaaCb6PcEEgF9rJ9BEo9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd2ChNoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd2ChNoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C061F00A3D;
	Wed,  9 Sep 2026 08:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788944180;
	bh=mMX1fmIqh5lUHBichZlFf7fbC/HsvqPmhn4RyEGBNPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hd2ChNoO30BNgQVaKaorvopVd9RhFyIQLrz1iXYoXSgsQdh6nASo1FG3k2pZRQHfj
	 ykF1PgPgvnAa4zY512LG5KE9fqy03AAuCpZmbQ8tQMnKDUF/RCkG2TKPpN9j3ceVqp
	 dkJULf2idbnvyiOIBFwfUrVf0QWThG6EX3wVeKV/iSMF8s7J3Q5CYwZ8RBjNm9xYDB
	 c2MARR/YuAxceEmd6tQhTl3cVu6CSATytJZdN5GwgYye/68E40j0nvekAcJE0ypvTY
	 NFk53mfipdw2q4vKdCmtVnzMzOKwsaTPukTC4rIN+xwgLlZ3+F3K1gmvyg2e7OV7JD
	 916Y341MTaVVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 7/8] RDMA/bnxt_re: Use
 bnxt_ext_stats_supported for counter count selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-7-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-7-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:56:19 +0000
Message-Id: <20260909085620.39C061F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Selecting between BNXT_RE_NUM_EXT_COUNTERS and
> BNXT_RE_NUM_STD_COUNTERS relied only on
> bnxt_qplib_is_chip_gen_p5_p7(), which doesn't account for the
> extended stats capability flag or the PF/VF restriction. Use
> bnxt_ext_stats_supported() instead, matching the check already
> used to populate the extended stats, so the counter count stays
> consistent with what gets filled in.
>=20
> Fixes: 8238c7bd8420 ("RDMA/bnxt_re: Fix the statistics for Gen P7 VF")
> Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D7

