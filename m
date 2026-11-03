Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744915;
	b=H/k4hU/iasakjoxZjr9IMnlKa3V/cDHxGERb1G9EdulG2j6PWl+baztqhbXWkfMM1Z35
	 hr687eIUWYUoFuVGQ/aPX1Q1hWAynilrpK1AC0ZyK33+Sd3cf5nGdbj2bU5R1bzs7ngtK
	 iPjQxPEZZ+68/3pkKFNQ73DLxJE/qJNzgPnW/0fbtQZQBb9djs+SI7j7Fb19cC4ZT32YY
	 D0d+GO9LGs1Sg8rdoSLjtT+G89taer4XYoivMkhwimVn8y37/NgNCKZ9wkQ4V5OLkSwh0
	 fykc9v8pIBLIkhDdxkY/xGhaXSGdVY604X+7G2XyNvYM5T9FSxAOsgSA9uNTGfa7EoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744915;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B2noZl5R3/WkUYruOdyhZT5zpfsUGPQroLnXsiSIkQQ=;
	b=nYmpn0ATHBmgI1XrjvNh768r3gQoaMeBHILCrafDGWn+zXFfjdwIipRa6eqHQgjW9cWT
	 RKvoHv66o2GWjN7wvct5Yq34H/mMvxoTL6oYZmArFsUb4KJxZCxQAmr8On5vLCStQsr8W
	 Pma1zfk7E8relAQhHQ5SaoDnmrKwuJwgWW+WYMdveL1dkYUilHKWwtqxEFjBZXRJvPYxD
	 XeaQ/uHbscLuh4htwWm80XufqxLvzGel1llDpfxwNMPKsaNhEClh6tSrE0CDI8cN56BKJ
	 tRVZrimqwcOHvl80WAKVCQlknKybVLPT92MjYsqMZ2iYwrHgYIpBFJgTISioKFp3Ebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XtSMfhTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC1606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XtSMfhTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDF21F00919;
	Tue,  3 Nov 2026 22:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793744913;
	bh=B2noZl5R3/WkUYruOdyhZT5zpfsUGPQroLnXsiSIkQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XtSMfhTZOgh/8DC6cUZ7dXGfy2F5yu0tj+xOKUyKANANvfgs1wJHasKsBbcdRH8Kr
	 VvbIVKC0uPIQyU84+uT6V7WjpaA3MhT2O4Exv5v/5JQPR5RQT+EiXhr0KCKkhgkhux
	 uCxx9Sokgpk7uV4D4lxm+MHFudTrL738KRh5/td90UyUkxtPY980lR/yeLH9Ru05Qi
	 9IZnNKe0EvWTZrA6jPsga+LmTbEDjJ5siRpbpaTwcMIPr8DwwHgmcLQEVQrqAyBIx+
	 V7JvtusvWm0UgDnte+FLs7vSayZSETmM7bX5FweOS7Kc8X25Fll7ffHbIHkwXUHRVu
	 zzIkwlFcDYPQA==
Message-ID: <sashiko-outbox-196112@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102-b4-ionic-cmd-timeout-v1-2-2f75c2d0a0c7@amd.com>
References: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
 <20261102-b4-ionic-cmd-timeout-v1-2-2f75c2d0a0c7@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:28:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
>=20
> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout. The RDMA admin queue watchdog still uses 2 seconds,
> and when it fires it resets the RDMA LIF and every later verb fails
> with -ENODEV. Use the ionic command timeout, 5 seconds, instead. The
> AH create/destroy busy-wait keeps its fixed 2 second bound.
>=20
> Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
> Reviewed-by: Brett Creeley <brett.creeley@amd.com>
> Acked-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-b4-ionic-c=
md-timeout-v1-0-2f75c2d0a0c7@amd.com?part=3D2

