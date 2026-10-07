Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975AF466AE6
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791390261; cv=none; b=T8iCzEDpA9fL5NpuTx8tT4acfAUPVVUonQ7U7+6IyXFHr9z5itCr+AnFfEK2ZVG9XTk8QSM+MdotkH032BiTW66IcespGvfqd/4/JqkzlNrLfm1Y2cPvkdQJZ2voEideCUXBTwzbT6ktpo7fusOLdCG0dlEOj5qEQo/lrbO0/6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791390261; c=relaxed/simple;
	bh=7F+cr7Xwh6tXPlz2JskTkNag2Wn4PJa96bTDWdnGWMM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mEXfJgGkZwoJg4fqVnl6JumLKexUtpj31jRjK7eUW3sOPK7vo+kNx+Z+qJGofxDkvPLVg83wFVR9J/BsDjsGfeGK1szi7tgXB1yBA2SnLV8W7LmjVR65A7Qk3sRXNB4BEgPsUtIrenqPZSZYyvxtmFwu/M5pUcZCk+GWFGDNu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCjtAhX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCjtAhX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043DB1F000FF;
	Wed,  7 Oct 2026 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791390260;
	bh=RD825/1iu4vLVN3XEST7iIulBNNtm7ang3vw6a7+FIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dCjtAhX+R4CUMumxkdivPsPP1bz1Eus5Q0roFFTWBj54spSLnWcOaRPZyUXeamyEZ
	 Xn0fTz3jeagGmJfLtKeVbJDSHKD+CIWZVP06IHPronDxrHopNsLLMyz/6PYPJCi0pX
	 87I9T46yEBlYfSXfyDai7r+HUzTqnp4bCvjnvVvTUFE1TUqPUlm47X7ULkEcLJa6PV
	 AImkT3cZbCvkjDCQ023OPUSrN8ots6CqoUtJ6Llp8PpLCUCrYi68hS31xoArzZliWs
	 i7UfMNE/XF8s2i8VrLkBAHIMt1r61HzYR5jcKxeIJ5xzsaVEvW0TOTOCOViguRYsbb
	 Lz0Abv/gcEaTQ==
Message-ID: <sashiko-outbox-163190@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [net-next v2 1/3] bnge: Add infrastructure support for RoCE MPC
 channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Siva Reddy Kallam" <siva.kallam@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006161256.1493672-2-siva.kallam@broadcom.com>
References: <20261006161256.1493672-1-siva.kallam@broadcom.com>
 <20261006161256.1493672-2-siva.kallam@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 16:24:19 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Saswati Das <saswati.das@broadcom.com>
>=20
> Add the initial L2 driver plumbing for RoCE MPC (PRIMATE channel)
> support:
>=20
> - Plumb BAR1 through to the RoCE auxiliary device info, alongside the
>   existing BAR0, so the RoCE driver can reach the doorbell BAR.
>=20
> This will be used by follow-on patches to issue RoCE commands over the
> MPC channels to the firmware.
>=20
> Signed-off-by: Saswati Das <saswati.das@broadcom.com>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006161256.1493=
672-1-siva.kallam@broadcom.com?part=3D1

