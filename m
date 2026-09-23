Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1D5530DFB
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169726; cv=none; b=n8h0YvoLicnuU3px6qauy4DAPFAveP8R8/3z+u26SWEWy3XtqLXHtAupxiYSc7F97i9SodmQ7FEVD8EWOtAJOoOfdfjCZWjo0OISG/YUIkbKt/LhouWjYkxMSM+DMdYjWkH0+bBRzR60wpZkrZUlBaMIMDak2H7UvmxvU0oiX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169726; c=relaxed/simple;
	bh=4SgMH7EJyyFm+EYOVWbhzA4IehdGioTiW2mvMhPd1/k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tcxxqGbZaIeTqZ3ETtPIBRm1DhAtb7MavPJipEMWPCh4b2IFV+sgEuXx3T3tOG7+DYhhXE2qT20RNXueQ3ikh9KX5M26/KSd5HNlsg1gBM+5Inm1CLRNA9zUxMN+rv3o/9Kc310+cKvP19TEl+KqUkJVzR3OHWTKfhY7XRotxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzN3b5nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzN3b5nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731411F0089A;
	Wed, 23 Sep 2026 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169724;
	bh=4SgMH7EJyyFm+EYOVWbhzA4IehdGioTiW2mvMhPd1/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QzN3b5nMWKE7MQhLEGvNZSGasOo0Tf3hBNuoU2OKRO1ogdYOAdZ+2DRO7wSPR+xlV
	 fxUohhQb9zTsE+l8B112OmLb6J3QT63CbcNf9glsF+wmgO8JaaZ/4cE6DWdR069hAd
	 lS5k0fVuB1+vd0THHxr7ndi9CGwMftKFN6y41zisT1ypRh3i0J2kpP8/D2izGmqa2m
	 gpE79c3SSFSj7aI8e7OgATErEd3rpi2MsQko8Ymd/fVHHRERf2J8BiWZRduwO0Jhoj
	 B47jE/jrJe4YpNtzvQ3PiW8L/xanwA4/c1hkubfR9VedOGRai9Jf9NkhlSVnPN8cpQ
	 cQdIsAKY1IDxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 3/5] RDMA/mana_ib: Revise UD receive
 posting with GDMA_WR_IB_SGL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131155.4055875-4-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
 <20260923131155.4055875-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:22:04 +0000
Message-Id: <20260923132204.731411F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decouple RQ WQE posting from the QP structure so it can be reused by
> other QP types. Batch multiple receive WQEs under a single doorbell.
>=20
> Introduce GDMA_WR_IB_SGL to pass SGEs directly to GDMA instead of copying
> them into a small stack array. Support receive WQEs with num_sge set to
> zero.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131155.4055=
875-1-kotaranov@linux.microsoft.com?part=3D3

