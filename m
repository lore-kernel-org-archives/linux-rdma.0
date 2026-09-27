Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A723ED3CA
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526087; cv=none; b=lUR/gc/GWe/gkaOnD1tlrjvy3JAdXeXRDF/z3cWBItnfOw0QxvBi5P/HRjONTOw4tYb3SPU+uDf4ckJUIpX/DYU8mulRC1Z+Hk5MwN0T6BAFPsfdBU34la713tALlna3iGy1ene1qK9LrsQm62rixV9+2dR2sqDefTgDkiQPPkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526087; c=relaxed/simple;
	bh=x4Or3JIM0RdPJGG4DAtkUNqzEUSJuSJC1GAeYoTk5Ws=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qpZEUw3A3JvmGrnLF29xkZLrnFZiYp1o6MBeZgzufXC9Hfo0lIWhpUIY1xtBaO1obCcn9mO/G+OV7wE4UfxsFtYD2sPrz9knEFCTa1son02dN4ub0x1G94RFDu+BwdjLUcEN4u0GVLILAzY1t79yCmLLJxhX1fILVYXoK0tiA64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeoUx2R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeoUx2R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DAE1F000FF;
	Sun, 27 Sep 2026 16:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790526085;
	bh=NUH+7bL3nuZ3Kj8ebfuVPAt3fpTs239lNOyJa3QDsos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eeoUx2R+QnmWTZeRld3YIc0mcS3zO2+bYVo7WPM4rPS4wrOSYSweUvOnNcSOJ9aiR
	 jDYrMk6uDYY1PfVb0/YzuzwVAhVh2Cr++4GTqlEu6ixiHP12amZreUDzdJUuab60CR
	 scaj9q6+EDfOmYJagz83oeRArWOdAapeCkQ81zDtYmENyX2pdvGudRoKaBXem9aXG8
	 HeVLnUmeBr531GcYS1CKK3jr9CvwVIDlWmOrvG9i6KQ+KM+32UPm4uAf2QDlI6cyde
	 eyz4gIAnET5+XmCz5Qq0zh33mGRgdCb6Se0o9N4Q+9Z2w2S0oZauLQNrPLjn5vxFXX
	 Y9tWqRU9+Vpkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/selftests: Fix the kernel config fragment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927161655.1184153-1-sashal@kernel.org>
References: <20260927161655.1184153-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 16:21:24 +0000
Message-Id: <20260927162125.75DAE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The config fragment lists bare option names with no values:
>=20
>   CONFIG_TUN
>   CONFIG_VETH
>   CONFIG_DUMMY
>   CONFIG_NET_NS
>   CONFIG_RDMA_RXE
>=20
> which is not valid Kconfig syntax. When the fragment is merged, for
> example by "make kselftest-merge" or by CI systems, the lines are
> rejected:
>=20
>   .config:5514:warning: unexpected data: CONFIG_TUN
>   .config:5515:warning: unexpected data: CONFIG_VETH
>   .config:5516:warning: unexpected data: CONFIG_DUMMY
> [ ... ]
>=20
> Fixes: e01027cab38a ("RDMA/rxe: Add testcase for net namespace rxe")
> Fixes: ecdcc8a455b7 ("RDMA/selftests: Add rxe_netns_names test")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927161655.1184=
153-1-sashal@kernel.org?part=3D1

