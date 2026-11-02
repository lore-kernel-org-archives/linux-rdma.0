Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637321;
	b=rY5/fbxm5QsfdqDwOgqC0B5kjV1XPVRZjxJUX0wq5ETzqbnNipjxcyIBzWh7I1iceEyN
	 CJCAhQ9vIwQObrKayjeqUArl1FP6Mx8mUMduOijRXwxYYLSS12ZJvc5eYzLwpJ5ScWRVR
	 oal7ftQomdL/Mh1BGXdimPkpXX+v7cKajTbL3THQyqbRo6LiwjXQiVCW2xVifa0pO6miS
	 ZoZ3KABHSFC8q8nwdgZfYYL+iCRZZ/R/mt4Gm6gzUvliOCJhGT1Cz2qQu1MqzpD8Q8zHO
	 z3lC/djzT5hb/K2jp5zYDQRlIAjtJa+oOjVgmwnRUb8GVpTt46OKouehtgnFu91K7fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637321;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=peF2DdtN+XqynNZmPw/Bly24Hr+F632eDLiFhxXJJiE=;
	b=DSKBUkzluj50u6YZ0esKaab6dc2JMBixcag2IJov6DT8Ol8AKJ6xhlpvt9xAZ/wwmOdp
	 O7KPThazprvNIcc5Jxk+v3o94+HqFwsTJ7I8O258TP7DNNReE1Qcr0J8Jp5NDT5a4CPU3
	 jvrKgmFTbIP3YYkrYEdRvPmDiHWXrpgTv97hAZVGpXDmIMOoAOpwlP54tYUnyigcGtrxL
	 zHuQ6m24rNr7d6Wvk6MeRZunLhDUpEtqSp5V77nyA7Wi8RLhvTRaH6r+gNVWD+gksGbL3
	 B1mudt5KEgqATFm6hgdKof+BVy4oZWiJJx74Kg+hgI0r+zGu+OJWgjG1a/mghojdRrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVvq5pmo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFC2606B0F0
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVvq5pmo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C8A1F00A16;
	Mon,  2 Nov 2026 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637321;
	bh=peF2DdtN+XqynNZmPw/Bly24Hr+F632eDLiFhxXJJiE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oVvq5pmoOVu0BNLOUG7Wun9dO3YnqheD/ICMkbk68N0PriQUdtgashaL2UxDYvQ+F
	 +GHuIqhwS5L4laZs+yPhGGVdNtxXjJx88Xb6Qdeoq/YuQHvl+jU2Cv3vV6Ve7TiQoi
	 90PAjOlcuERbWYojaWJLoXFgCPmsfQzd/X2aBH0M+bRAEqqHkaby9LFPsYmggulS+x
	 XrdF+hR7e091lUOY3I7wQNDhVZm09fFJKQXQAH+PyFDt49SMHkFxypldaQQYlXdBI7
	 bkL9YQnIOfuQ1lSv1pp969AOxTD7WR1cREVYSIhIkQSihC/NRpD3U+jg7feXS/ExkG
	 kM5KG+ZpESpqA==
Message-ID: <sashiko-outbox-193757@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 3/9] net/mana: Extend GDMA encoding for new
 RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-4-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:35:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D3

