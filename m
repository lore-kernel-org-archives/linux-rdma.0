Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1A4BA1E2;
	Thu, 24 Sep 2026 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271792; cv=none; b=edw+obS2cMCWTTEGZ+KIC3hW1B5LH8W6RF0jrbdDwZTHzBe1f7TjHH40cfx2W4F+9Kj9r0gvpQhXdA807yvCScfg4n2q9E6e/iR/LsDzgRO9QmRSmc1wwsdTorDYNdP3ZcT2NKEKB9y7Un2GfKJz5ECrCbZ64ezMivSv2evClc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271792; c=relaxed/simple;
	bh=0hDOKzF7Pn8CNzUBmoi3+yd4u+taULdenEHMoBRGGpk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A0OAq/lU3SfPgmSqtkgw8kix6GDkZXg1dRpgmSYNtENbvYh/n9ERM7rBx9SIYH2ieMXh54WgytjHS/+zsfStss1SDj84E9smlPLTGr/zKCVeS/fy/AdU/c38MQ8D+mV9aFDCU5KM0g1WW+Ia0tdUktG3atM6loaEt2HtMmO+H1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2lxTXsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2lxTXsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380591F000FF;
	Thu, 24 Sep 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271790;
	bh=0hDOKzF7Pn8CNzUBmoi3+yd4u+taULdenEHMoBRGGpk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h2lxTXsKb55JlBuZtK5fHFlyl9upWznq74zl6ROMr/qdjhEyJ9S3oXJ6zN5HDFI1Q
	 pWW120zRVJtPpGtcCnIVEBv8K85DpUYYTAqh1sXcIzDNUKEZmJB1mKdF5RhhaQAQE/
	 yslFOuY7YUuxKaMmda6d35TZS7HlAQLJvXG6B88gFKd3Ju4am4gXW2vzjXEBvWPwGF
	 X+w4H3Lg33MzOIZnBFWEYMtTslDWe46A4KXBBltHMo2cJRd/8yETv32lyjT2uCSYuZ
	 w1dsWUYmppU5Jez3kMpcNmYf3jAlQfGt3Zh5zkBtqGoMVy0e2ao67t1/HnoMJdr3yx
	 1hC4BSgDQL0Yg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/4] net: mana: Introduce gdma_bus_ops for
 bus-specific operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manish Awasthi" <mawasthi@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260924173054.589291-2-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-2-mawasthi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:43:09 +0000
Message-Id: <20260924174310.380591F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Introduce per-device gdma_bus_ops for interrupt allocation, IRQ lookup,
> reset, servicing, and bus-specific capabilities. Route the shared GDMA
> code through these callbacks and provide the PCI implementation.
>=20
> Move common device bring-up and teardown into mana_gd_setup() and
> mana_gd_cleanup(), including hardware-channel initialization, device
> enumeration, interrupt-pool sizing, and servicing workqueue management.
> Record the vPort count for transport-specific queue sizing and keep shared
> IRQ context bookkeeping in the core.
>=20
> This prepares the driver for additional bus transports without duplicating
> the core or adding configuration checks throughout it.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924173054.5892=
91-1-mawasthi@linux.microsoft.com?part=3D1

