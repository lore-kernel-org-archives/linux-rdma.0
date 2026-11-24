Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506867;
	b=5XokBfVLGHaK01M+0FNTXgmfxpNR7JyjIiq1X8bHK+hFIe1pP4MaNTKtKh5s8BZFPs/m
	 LCAG6uGn8eUVs3Q21n+xAd8Qik3/N99SlB5BnuPXU0F+phh1Qdtk0doURZWlOJLR3/qG6
	 1yPBPnh24IVZlopJSeN1BHmIR5CB9HcOONaGmwvOxwynCQUXCxELVyQg7GzwY9Gjt6zoQ
	 EsZ5+3BvcXOmEbJW+XScDxZlDDsbF+jw+k5byqNIRFN2c8YJBhGR4fUt0M8YCuD2fBYeb
	 t0oZO3aWrKbQs50Hzj/yC6ECxUuw0/eVvOuz9Fek68usP0VOpnNXQNYK3ivt7ZP1EOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506867;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Au9GIpPj9Sckd61AtUzpVqJGCcmvXvngkyXD0NTFmcs=;
	b=PerQwjMYC3JGZ8626PIm/JNzYlm9bi/PlL4AyL3coFUH2wkbzcdyAkiBQie1kY4bnEeN
	 AN+NcgDZhgCw5yHLl4oS0I6j3qrUHpQL/H6gqtUVsa2JdFqzhx4adH+zZgjTjrtN1Ok+c
	 A5nvz/VaJSkcgtilYb7FLqx0xOHv6asDe6IU3T5b8qu2UXW0v2CeHnbhRwUkQUnXGFJFt
	 McUZdEUqaUDwVDrxdmbvTZT8VfEJAjzKBQd5Q/A81V6F9z+DiuJphYWy1AJpgEVQArj2p
	 VElq2BZoa1/s9UzljfwGBpFYyUEF7V9s9Msg9rJPHc+5XQ8LsEaYMbnRQFG1m2jzFNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nqt9KPrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD62A606A31E;
	Tue, 24 Nov 2026 07:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nqt9KPrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ACD1F000E0;
	Tue, 24 Nov 2026 07:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795506867;
	bh=Au9GIpPj9Sckd61AtUzpVqJGCcmvXvngkyXD0NTFmcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nqt9KPrLU/66Lh/QMgFO2j8paLD7JHZztZSDNj4KMTBvJjq21p8L2gQ8y5NgksqRl
	 wROrkghHA7vxF8/tNWq+5aGHDJh/7Biqo4x8lHxWilRQSVvzKM3YQq7Uu6uviMSB7H
	 Kbm3Fd7Z8+/AyTZJrAy4i4Xye8jOVeStpTNjt42vr/qm6NSskNl9oGa9Ny2OBqk4N6
	 Tk2IeL7E4/AvbPVQHwsWJhW9qDCd6YcQoOPrordkWWJlBplveNuwTxoTPfrmtzu6hR
	 FM31zd34mQ7ew8OXou9wMD83pjTZs91j0lvBPC/EXA4cFE9FE4OZ73gJlwPOo+TL0p
	 /vjCBaI6bNZ8Q==
Message-ID: <sashiko-outbox-230687@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: fix sock reference leak on abort_work
 cancel
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
References: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 07:54:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> smc_cdc_msg_validate() takes a reference on the socket before queueing
> conn->abort_work, and smc_conn_abort_work() drops it when it runs. When
> smc_conn_free() cancels the work while it is still pending, for example
> because a close races with a failed CDC validation, the handler never
> runs and the reference is leaked, so the SMC socket is never freed.
>=20
> Drop the reference when cancel_work_sync() reports that it cancelled a
> pending work.
>=20
> Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124073602.2341=
904-1-mjambigi@linux.ibm.com?part=3D1
