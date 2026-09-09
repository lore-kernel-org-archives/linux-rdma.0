Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF02C21F1
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943702; cv=none; b=GirYQxTfOOWW2oloLmaKG1mCO37Zr41lL9ZWuqRir0g/9880TDY3vz+3SC8nrF3xH5HUs2kfiw416ay2kbTgAA/oGcq4xXrwIYKmFaOn8KBDi8QvKtT3G1TgH/PttLksHGvvP8g6MTfD6CiV31U8R9edKw/bygXh57oXWtQSnnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943702; c=relaxed/simple;
	bh=ezylf0M9mH2M5AIifv+aDl9jbNuQpzuwFVAGBUz6nbE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=un0Aglehk6EalWabU0iol7Ap2On523m9DKdFg0G2C6MaoCzYFAQrK6wXoaTpsKiYI3ine3Wcsy0IX/GqOp9nnV5Nt1vC7l2wE+yS3FPtEAjR5gPhuwxRP1Fy6eP9YmPeXPOEfUdCaAoX9vLV6G03e/UtuumWCBDxwv8fEVE6MeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndQ7cyvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndQ7cyvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E5A1F00A3A;
	Wed,  9 Sep 2026 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943701;
	bh=ezylf0M9mH2M5AIifv+aDl9jbNuQpzuwFVAGBUz6nbE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ndQ7cyvwTp5zeI9VTI4bGV/yYC0QSdfVTXc9JiIuKhVVwtPFM6h2/LKTBWQkz6XRn
	 7HQKbJs2yFdp+tgg2RlTPqvArqL8E8orZ3l1rvo+z0GrhkxWW0wQUKyufuu47LINgv
	 QCnpdpexNdb6xPvHf4fefMrHzVdhBV3PhJU5d/vCznJdJJKtY+JmCWDDVJdnY4Gk3C
	 uQDkGw+fbVV/CnH/fjBk4toAvq7EqABaF+z3Yb6mQl/by5yGRtq8KDgwfePoyCH5ZQ
	 jYmwfnmtSTn+SgZhhu8+nfbV7esgBJv1XG5KoKbw16zhKuhI8h4Rn7qQEiWn7iwfil
	 XztgQWLBvpVkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 6/8] RDMA/bnxt_re: Fix the PD and DPI table
 size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-6-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-6-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:48:20 +0000
Message-Id: <20260909084821.50E5A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The PD and DPI bitmaps were sized as max >> 3 (bytes),
> but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
> test_and_set_bit()) operate on whole unsigned long words,
> so whenever max isn't a multiple of BITS_PER_LONG,
> the buffer under-allocates and the top word's bitops
> read/write past the end of the kmalloc()'d buffer.
> Most exposed on the DPI table, since dpit->max comes from the
> firmware-reported dev_attr->max_dpi with no alignment guarantee.
>=20
> Fix the size both allocations with BITS_TO_LONGS(max) * sizeof(unsigned l=
ong).
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D6

