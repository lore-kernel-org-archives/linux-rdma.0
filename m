Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48733F823D;
	Fri, 16 Oct 2026 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151626; cv=none; b=CdeyGkDJ+TPPk90UhUxv8DqawwPaiVw8MpWbG9bVPCUibMW45UKPK1PR5mw4R+wSHcT518/eB7bWrifPFKuhBw/85n4ynVioErA1Tx/HBskGDyQLqscRPrBWoyNYXxGX/rU4LDWNAV/gnTnZok5O6yQqonNqhCW34F7CF336XKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151626; c=relaxed/simple;
	bh=kVX8YtUVLB8/HsE+BJdfEPdtl0RkGaOvD+C14ViPGYA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Z9KJ/FGg7VtErm7lkWLG4YR0QfQMlRc2/ZJNAzjbJklUKPkQGl8p04HwEpAZYn1ZIGmZFgMTE9Xs5qJAPrn4ZznU+ppZDe5FAXBgMn6OnpmtxJVrMYZQ8r7OrIlhfKoGk1pTqSVzBqOFZ0cObvLwnZFMReUyV9ydxpqzC3FALe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhTZg0R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhTZg0R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD061F000C5;
	Fri, 16 Oct 2026 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792151624;
	bh=kVX8YtUVLB8/HsE+BJdfEPdtl0RkGaOvD+C14ViPGYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HhTZg0R/sRYr2DApPPN0bgbvqHzpOhV74s81ncZ1U80XXRjrxijZmr606k5uWY85W
	 qj799RP3ZtRprX48MFkBumaC5JUyqlcVa89vO5mqThBRFsjuLbUuOMcyvMdTm8doZZ
	 LeXLmYD1ZTFxwqXJxAHs6dJIZUQJJjQE1CGv4wOmUf1KwN3HtmRfMWwoNO+rCDpygz
	 fGO1FIEpf2mvRmfIB90WmiP09RgBCdmhucdzW/uToMptRTIEl5R1SUuXqGuHAzAZWX
	 Ko3iX6/O9scOtE4VrNHOGQOj5yZihtsMPqD71IKQKnUEikz5hq4VqLr5UcgMXCMAwS
	 TF4M/HxdbpSXw==
Message-ID: <sashiko-outbox-174258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 1/2] net/smc: order the CDC receive path against
 RMB publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261015-b4-disp-2a8d85ef-v5-1-6b795e8263c9@proton.me>
References: <20261015-b4-disp-2a8d85ef-v5-0-6b795e8263c9@proton.me>
 <20261015-b4-disp-2a8d85ef-v5-1-6b795e8263c9@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 11:53:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smc_conn_create() adds an SMC-R connection to the token tree before
> smc_buf_create() sets conn->rmb_desc. Tokens come from one global
> counter, so a peer in the link group can predict the next one. A CDC
> with that token, arriving in the window, makes
> smc_cdc_msg_recv_action() dereference a NULL rmb_desc in softirq.
>=20
> Set rmb_desc with a release store after the receive fields that go
> with it, and drop a CDC in smc_cdc_rx_handler() while rmb_desc is
> unset. A conforming peer learns the token only from the CLC accept or
> confirm, sent after smc_buf_create(), so nothing it sends is dropped.
> The SMC-D receive tasklet needs no check: smc_ism_set_conn() publishes
> the connection under smcd->lock, which smcd_handle_irq() also takes.
>=20
> Fixes: 69cb7dc0218b ("net/smc: add common buffer size in send and receive=
 buffer descriptors")
> Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba=
616c0920c@proton.me?part=3D1
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-b4-disp-2a=
8d85ef-v5-0-6b795e8263c9@proton.me?part=3D1

