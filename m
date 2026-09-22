Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80254330B01
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038978; cv=none; b=Awik82L6dQatYcQQ1BPT9/5/80ytTKjCO6Q45s7J2qXC8VYBvYdPt0Ad3IvbHvu/DZ0YJ0PH4eGR8C93OQUhbN309bkAopW2WqP58HyWZFqkQgW8NVWmz9amhnMnrrZ9UxzoFF9BLVFVq5hr73G67Ik/RsL6NqIJlOJXrCeV+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038978; c=relaxed/simple;
	bh=oNlTgB664XlUkKBDfeYJNjzsDfQi4SfUrzBDAmNWtg8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kt9+qXij+9a89UdlAW8OTQ1fNwXUMLbNIbkihHR6SozgyTUs4TgfaQA7uApzKsx/9OnJRJndHPwZG7uwVZYmyIzipsMSPsVNCRuxn+kcK5sz7/jaTtJ8LGLuRi7qJWMe90C+dzrT687vm8o76+TL1n63JXbonnJ6nnNwjwSKJ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2mxDTPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2mxDTPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6E31F00898;
	Tue, 22 Sep 2026 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790038977;
	bh=oNlTgB664XlUkKBDfeYJNjzsDfQi4SfUrzBDAmNWtg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K2mxDTPU9sjcnMyM/cRNGwhrQHEq2rg1DkXONEIiMfVCO8HX5jHvjXh2sDuReeHjz
	 LT+QcUX7zdRDLNnypkhUme+bldkKLIWGBSUAb5e7L3uFVDiiptGnbdj2OI2IFQcZxV
	 KV+mIRqQ/oOCOMZnu9MxzHn8IuWqVz6db3fNw72eflcSLtpfitgyAC4Q7/8gewhuOk
	 2jmxfY0rC7MzJbWm4/MN9wIanmkxaA23eFcADySQxsvqX1Zwqm+yWRnV1hUS+6h14c
	 xKLWR19q3a2uR+JIE19wnkTa3FubWdVvraVxu3JYAKgtEG7NrlhP4gQc/2/QFMRbtZ
	 Q6yJK/TIqLDSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 4/8] RDMA/bnxt_re: Initialize wqe.flags in
 bnxt_re_post_srq_recv()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-5-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-5-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:02:56 +0000
Message-Id: <20260922010256.DB6E31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> wqe is declared once above the WR loop and never zeroed, so
> wqe.flags holds indeterminate stack contents on the first WR and the
> previous WR's stale value thereafter. This propagates straight into
> the hardware-visible srqe->flags in bnxt_qplib_post_srq_recv().
>=20
> Most values of the wqe struct is set except flags. So initialize
> flags also.
>=20
> Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters=
")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D4

